import type { Plugin } from "@opencode-ai/plugin";

const TMUX_STATUS_OPTION = "@opencode_status";
const NOTIFICATION_TITLE = "OpenCode";
const STATUS = {
  working: "󰚩",
  idle: "󰏤",
  blocked: "󰀦",
  error: "󰅚",
} as const;

type Status = (typeof STATUS)[keyof typeof STATUS];
type AttentionStatus = "blocked" | "idle" | "error";

export default (async ({ $ }) => {
  let currentStatus: Status | null = null;

  const getPaneFromEnv = async (): Promise<string | null> => {
    try {
      const result = await $`printenv TMUX_PANE`.text();
      const pane = result.trim();
      return pane.length > 0 ? pane : null;
    } catch {
      return null;
    }
  };

  const getWindowId = async (tmuxPane: string | null): Promise<string | null> => {
    if (!tmuxPane) return null;

    try {
      const result = await $`tmux display-message -p -t ${tmuxPane} '#{window_id}'`.text();
      const windowId = result.trim();
      return windowId.length > 0 ? windowId : null;
    } catch {
      return null;
    }
  };

  const getClientName = async (tmuxPane: string | null): Promise<string | null> => {
    if (!tmuxPane) return null;

    try {
      const result = await $`tmux display-message -p -t ${tmuxPane} '#{client_name}'`.text();
      const clientName = result.trim();
      return clientName.length > 0 ? clientName : null;
    } catch {
      return null;
    }
  };

  const getCurrentWindowId = async (): Promise<string | null> => {
    try {
      const result = await $`tmux display-message -p '#{window_id}'`.text();
      const windowId = result.trim();
      return windowId.length > 0 ? windowId : null;
    } catch {
      return null;
    }
  };

  const getWindowLabel = async (tmuxPane: string | null): Promise<string | null> => {
    if (!tmuxPane) return null;

    try {
      const result = await $`tmux display-message -p -t ${tmuxPane} '#S:#I #{window_name}'`.text();
      const label = result.trim();
      return label.length > 0 ? label : null;
    } catch {
      return null;
    }
  };

  const setStatus = async (
    tmuxWindowId: string | null,
    status: Status | null,
    force = false,
  ): Promise<void> => {
    if (!tmuxWindowId) return;
    if (!force && currentStatus === status) return;

    try {
      if (status) {
        await $`tmux set-window-option -q -t ${tmuxWindowId} ${TMUX_STATUS_OPTION} ${status}`;
      } else {
        await $`tmux set-window-option -q -u -t ${tmuxWindowId} ${TMUX_STATUS_OPTION}`;
      }
      currentStatus = status;
    } catch {
      // Ignore tmux update failures so opencode keeps running outside tmux.
    }
  };

  const isTargetWindowFocused = async (tmuxWindowId: string | null): Promise<boolean> => {
    if (!tmuxWindowId) return false;

    try {
      const [frontmost, activeWindowId] = await Promise.all([
        $`osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'`.text(),
        getCurrentWindowId(),
      ]);

      return /ghostty/i.test(frontmost.trim()) && activeWindowId === tmuxWindowId;
    } catch {
      return false;
    }
  };

  const notify = async (message: string, tmuxWindowId: string | null, tmuxClientName: string | null): Promise<void> => {
    const terminalNotifier = (await $`command -v terminal-notifier || true`.text()).trim();

    if (terminalNotifier && tmuxWindowId && tmuxClientName) {
      try {
        await $`terminal-notifier -title ${NOTIFICATION_TITLE} -message ${message} -group ${`opencode-${tmuxWindowId}`} -execute ${`/opt/homebrew/bin/tmux switch-client -c ${tmuxClientName} -t ${tmuxWindowId}; /usr/bin/open -a Ghostty`}`;
        return;
      } catch {
        // Fall back when macOS notification permission for terminal-notifier is denied.
      }
    }

    await $`osascript -e 'on run argv' -e 'display notification (item 1 of argv) with title (item 2 of argv)' -e 'end run' ${message} ${NOTIFICATION_TITLE}`;
  };

  const notifyAttention = async (status: AttentionStatus): Promise<void> => {
    if (await isTargetWindowFocused(tmuxWindowId)) return;

    const windowLabel = await getWindowLabel(tmuxPane);
    const target = windowLabel ? ` in ${windowLabel}` : "";
    const messageByStatus = {
      blocked: `Permission needed${target}`,
      idle: `OpenCode finished${target}`,
      error: `OpenCode error${target}`,
    } satisfies Record<AttentionStatus, string>;

    await notify(messageByStatus[status], tmuxWindowId, tmuxClientName);
  };

  const tmuxPane = await getPaneFromEnv();
  const tmuxWindowId = await getWindowId(tmuxPane);
  const tmuxClientName = await getClientName(tmuxPane);

  return {
    event: async ({ event }) => {
      if (event.type === "session.status") {
        const status = event.properties?.status;
        const statusType = typeof status === "object" ? status?.type : status;
        if (statusType === "busy") {
          await setStatus(tmuxWindowId, STATUS.working);
        } else if (statusType === "idle") {
          await setStatus(tmuxWindowId, STATUS.idle);
        }
        return;
      }

      if (event.type === "permission.asked" || event.type === "question.asked") {
        await setStatus(tmuxWindowId, STATUS.blocked);
        await notifyAttention("blocked");
        return;
      }

      if (event.type === "permission.replied" || event.type === "question.replied" || event.type === "question.rejected") {
        await setStatus(tmuxWindowId, STATUS.working);
        return;
      }

      if (event.type === "session.error") {
        await setStatus(tmuxWindowId, STATUS.error);
        await notifyAttention("error");
        return;
      }

      if (event.type !== "session.idle") return;

      await setStatus(tmuxWindowId, STATUS.idle);
      await notifyAttention("idle");
    },

    "permission.ask": async () => {
      await setStatus(tmuxWindowId, STATUS.blocked);
    },

    "chat.message": async () => {
      await setStatus(tmuxWindowId, STATUS.working);
    },
  };
}) satisfies Plugin;
