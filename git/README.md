## Description

These are my default settings to be used on any computer running git to make the experience better.

### Setup

1. Symlink the directory to `~/.config/git`
2. Run `git config --global include.path ~/.config/git/gitconfig_shared`
3. Run `git config --global --edit` and make sure the include is the first line

### Verify

```sh
git config --global --list --show-origin
git config --global --list --show-origin --show-scope
```
