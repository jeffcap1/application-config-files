## Setup Hyprspace

### Install using homebrew:

```bash
brew install --cask PeachlifeAB/tap/hyprspace
```

### Run the following command to start the Hyprspace service:

```bash
hyprspace init
# uncheck sketchybar, I didn't have much success with it
```

### symlink the hyprspace config to your home directory:

```bash
ln -s ~/.config/application-config-files/hyprspace/config.toml ~/.config/hyprspace/config.toml
```
