# Tmux Kata - Quick Reference Guide

## Starting the Training

1. Start tmux: `tmux`
2. Run the kata script: `./tmux-kata.sh`
3. Follow the on-screen instructions

## Default Tmux Prefix

The default prefix key is: **Ctrl+b**

Press Ctrl+b, release, then press the command key.

## Essential Tmux Commands

### Pane Management
| Command | Action |
|---------|--------|
| `Prefix + %` | Split pane vertically |
| `Prefix + "` | Split pane horizontally |
| `Prefix + Arrow` | Navigate between panes |
| `Prefix + o` | Cycle through panes |
| `Prefix + x` | Close current pane (confirm with y) |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + Space` | Cycle through layouts |
| `Prefix + {` | Swap pane with previous |
| `Prefix + }` | Swap pane with next |
| `Prefix + Ctrl+Arrow` | Resize pane in direction |
| `Prefix + !` | Break pane into new window |
| `Prefix + q` | Show pane numbers |

### Window Management
| Command | Action |
|---------|--------|
| `Prefix + c` | Create new window |
| `Prefix + ,` | Rename current window |
| `Prefix + n` | Next window |
| `Prefix + p` | Previous window |
| `Prefix + 0-9` | Switch to window by number |
| `Prefix + &` | Close current window (confirm with y) |
| `Prefix + w` | List windows (interactive) |
| `Prefix + .` | Move window to different position |
| `Prefix + f` | Find window by name |

### Session Management
| Command | Action |
|---------|--------|
| `tmux` | Start new session |
| `tmux new -s name` | Create named session |
| `tmux ls` | List sessions |
| `tmux attach` | Attach to last session |
| `tmux attach -t name` | Attach to named session |
| `Prefix + d` | Detach from session |
| `Prefix + $` | Rename session |
| `Prefix + s` | List and switch sessions |
| `Prefix + (` | Switch to previous session |
| `Prefix + )` | Switch to next session |

### Copy Mode
| Command | Action |
|---------|--------|
| `Prefix + [` | Enter copy mode |
| `q` or `Escape` | Exit copy mode |
| `Space` | Start selection (in copy mode) |
| `Enter` | Copy selection (in copy mode) |
| `Prefix + ]` | Paste buffer |

### Advanced Features
| Command | Action |
|---------|--------|
| `Prefix + :` | Enter command mode |
| `:setw synchronize-panes on` | Type in all panes simultaneously |
| `:setw synchronize-panes off` | Disable synchronized panes |
| `:join-pane -s :1` | Join pane from window 1 |
| `:swap-window -s 1 -t 2` | Swap windows 1 and 2 |
| `:resize-pane -D 5` | Resize pane down 5 lines |
| `:resize-pane -U 5` | Resize pane up 5 lines |
| `:resize-pane -L 5` | Resize pane left 5 columns |
| `:resize-pane -R 5` | Resize pane right 5 columns |

### Other Useful Commands
| Command | Action |
|---------|--------|
| `Prefix + ?` | List all key bindings |
| `Prefix + t` | Show clock |
| `Prefix + i` | Display pane information |
| `Prefix + m` | Toggle mouse mode |

## Tips for Learning

1. **Muscle Memory**: Repeat each kata multiple times until it becomes natural
2. **Custom Prefix**: Many users remap prefix to Ctrl+a (add to ~/.tmux.conf):
   ```
   unbind C-b
   set -g prefix C-a
   bind C-a send-prefix
   ```
3. **Mouse Support**: Enable mouse mode for easier learning (add to ~/.tmux.conf):
   ```
   set -g mouse on
   ```

## Customization

Create/edit `~/.tmux.conf` to customize tmux:

```bash
# Enable mouse support
set -g mouse on

# Start windows/panes at 1 instead of 0
set -g base-index 1
setw -g pane-base-index 1

# Enable vi mode
setw -g mode-keys vi

# Increase history limit
set -g history-limit 10000

# Easier split keys
bind | split-window -h
bind - split-window -v

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"
```

## Practice Workflow

1. Complete all katas in sequence
2. Reset and try to complete faster
3. Practice without looking at hints
4. Time yourself to build speed
5. Use tmux daily to build true muscle memory

## Going Further

- **Sessions**: Practice detaching and reattaching to sessions
- **Plugins**: Install [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm)
- **Themes**: Customize your status bar
- **Scripting**: Learn to script tmux commands
- **Integration**: Use with vim/neovim for ultimate productivity

## Common Issues

**Can't split panes**: Make sure you're pressing the prefix first, then releasing before the split command.

**Wrong characters**: If typing `%` or `"` doesn't work, ensure your terminal is sending the correct keys.

**Session lost**: Use `tmux ls` to find sessions, `tmux attach` to reconnect.

## Resources

- Official Wiki: https://github.com/tmux/tmux/wiki
- Tmux Book: "tmux 2: Productive Mouse-Free Development" by Brian Hogan
- Cheat Sheet: https://tmuxcheatsheet.com/
