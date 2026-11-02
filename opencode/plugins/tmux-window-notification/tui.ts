import { execFile } from "node:child_process";
import { Plugin } from "@opencode/plugin/tui";

const NOTIFICATION_TITLE = "OpenCode";

type AttentionStatus = "blocked" | "idle" | "error";

function run(command: string, args: string[]): Promise<string> {
  return new Promise((resolve, reject) => {
    execFile(command, args, { timeout: 5000 }, (error, stdout) => {
      if (error) reject(error);
      else resolve(stdout.trim());
    });
  });
}

async function tmux(args: string[]): Promise<string | null> {
  try {
    const result = await run("tmux", args);
    return result.length > 0 ? result : null;
  } catch {
    return null;
  }
}

export default Plugin.define({
  id: "tmux-window-notification",
  async setup(ctx) {
    // Runs in the terminal client, so TMUX_PANE is this OpenCode pane.
    const tmuxPane = process.env.TMUX_PANE || null;
    if (!tmuxPane) return;

    const tmuxWindowId = await tmux(["display-message", "-p", "-t", tmuxPane, "#{window_id}"]);
    const tmuxClientName = await tmux(["display-message", "-p", "-t", tmuxPane, "#{client_name}"]);

    // The shared server sends events for every session; only notify for
    // sessions (and their subagents) open in this TUI.
    const parents = new Map<string, string>();

    const rootOf = (sessionID: string): string => {
      let current = sessionID;
      for (let depth = 0; depth < 32; depth++) {
        const parent = parents.get(current) ?? ctx.data.session.get(current)?.parentID;
        if (!parent) return ctx.data.session.root(current);
        current = parent;
      }
      return current;
    };

    const isLocal = (sessionID: string): boolean => {
      const root = rootOf(sessionID);
      const route = ctx.ui.router.current();
      if (route.type === "session" && rootOf(route.sessionID) === root) return true;
      return ctx.ui.tabs.enabled() && ctx.ui.tabs.list().some((tab) => tab.sessionID === root);
    };

    const isTargetWindowFocused = async (): Promise<boolean> => {
      if (!tmuxWindowId) return false;
      try {
        const [frontmost, activeWindowId] = await Promise.all([
          run("osascript", [
            "-e",
            'tell application "System Events" to get name of first application process whose frontmost is true',
          ]),
          tmux(["display-message", "-p", "#{window_id}"]),
        ]);
        return /ghostty/i.test(frontmost) && activeWindowId === tmuxWindowId;
      } catch {
        return false;
      }
    };

    const notify = async (message: string): Promise<void> => {
      if (tmuxWindowId && tmuxClientName) {
        try {
          await run("terminal-notifier", [
            "-title", NOTIFICATION_TITLE,
            "-message", message,
            "-group", `opencode-${tmuxWindowId}`,
            "-execute", `/opt/homebrew/bin/tmux switch-client -c ${tmuxClientName} -t ${tmuxWindowId}; /usr/bin/open -a Ghostty`,
          ]);
          return;
        } catch {
          // Fall back when terminal-notifier is missing or notification permission is denied.
        }
      }
      try {
        await run("osascript", [
          "-e", "on run argv",
          "-e", "display notification (item 1 of argv) with title (item 2 of argv)",
          "-e", "end run",
          message,
          NOTIFICATION_TITLE,
        ]);
      } catch {
        // Ignore notification failures.
      }
    };

    const notifyAttention = async (status: AttentionStatus): Promise<void> => {
      if (await isTargetWindowFocused()) return;
      const windowLabel = await tmux(["display-message", "-p", "-t", tmuxPane, "#S:#I #{window_name}"]);
      const target = windowLabel ? ` in ${windowLabel}` : "";
      const messageByStatus = {
        blocked: `Permission needed${target}`,
        idle: `OpenCode finished${target}`,
        error: `OpenCode error${target}`,
      } satisfies Record<AttentionStatus, string>;
      await notify(messageByStatus[status]);
    };

    return ctx.data.listen(({ details: event }) => {
      switch (event.type) {
        case "session.created":
          if (event.data.parentID) parents.set(event.data.sessionID, event.data.parentID);
          return;
        case "permission.asked":
          if (isLocal(event.data.sessionID)) void notifyAttention("blocked");
          return;
        case "form.created":
          if (isLocal(event.data.form.sessionID)) void notifyAttention("blocked");
          return;
        case "session.execution.failed":
          if (isLocal(event.data.sessionID)) void notifyAttention("error");
          return;
        case "session.execution.succeeded":
          // Only the main session finishing means the turn is done.
          if (rootOf(event.data.sessionID) === event.data.sessionID && isLocal(event.data.sessionID)) {
            void notifyAttention("idle");
          }
          return;
      }
    });
  },
});
