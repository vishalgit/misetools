# Tmux Kata Training System

A progressive, interactive learning tool for mastering tmux through kata-style practice.

## Overview

This training system presents tmux challenges one at a time, validates your actions, and tracks your progress. It's designed to build muscle memory through repetitive practice, similar to martial arts katas.

## Features

- ✅ **Progressive Learning**: 22 katas from basics to advanced
- ✅ **Automatic Validation**: Verifies you've completed each task correctly
- ✅ **Progress Tracking**: Resume where you left off
- ✅ **Visual Feedback**: Color-coded success/failure messages
- ✅ **Hints**: Each kata includes the exact command to use
- ✅ **Repeatable**: Reset and practice until it's muscle memory
- ✅ **Advanced Features**: Session management, pane manipulation, power-user commands

## Installation

1. Save the script to your system:
   ```bash
   curl -o ~/tmux-kata.sh [URL]
   chmod +x ~/tmux-kata.sh
   ```

2. Or if you have the files locally:
   ```bash
   chmod +x tmux-kata.sh
   ```

## Usage

1. **Start tmux** (required):
   ```bash
   tmux
   ```

2. **Run the kata trainer**:
   ```bash
   ./tmux-kata.sh
   ```

3. **Follow the on-screen instructions**:
   - Read each challenge
   - Perform the tmux action
   - Press Enter to verify
   - Progress to the next kata on success

4. **Practice until mastery**:
   - Reset progress and complete all katas faster
   - Try without looking at hints
   - Use daily until commands become automatic

## Kata Curriculum

The training covers these essential tmux skills:

### Beginner Level (Katas 1-4): Pane Basics
1. **Vertical Split** - Create side-by-side panes
2. **Horizontal Split** - Create stacked panes
3. **Pane Navigation** - Move between panes
4. **Close Pane** - Remove unwanted panes

### Intermediate Level (Katas 5-8): Window Management
5. **New Window** - Create windows (like tabs)
6. **Rename Window** - Organize your workspace
7. **Switch Windows** - Navigate between windows
8. **Close Window** - Clean up windows

### Advanced Level (Katas 9-12): Pro Features
9. **Copy Mode** - Scroll and copy text
10. **Zoom Pane** - Focus on one pane
11. **Unzoom** - Return to multi-pane view
12. **Layouts** - Reorganize pane arrangements

### Power User Level (Katas 13-22): Advanced Operations
13. **Resize Panes** - Dynamically adjust pane sizes
14. **Detach Session** - Leave session running in background
15. **Create Named Session** - Organize multiple projects
16. **Switch Sessions** - Navigate between different sessions
17. **Swap Panes** - Rearrange pane positions
18. **Break Pane to Window** - Move pane to its own window
19. **Enable Synchronized Panes** - Type in multiple panes at once
20. **Disable Synchronized Panes** - Return to normal operation
21. **Move Window** - Reorder windows in the list
22. **Rename Session** - Label your sessions

## How It Works

### Architecture

The script uses these key components:

1. **Progress Tracking**
   - Stores current kata number in `~/.tmux-kata-progress`
   - Allows resuming from where you left off
   - Can be reset to start over

2. **State Verification**
   - Each kata has a verification function
   - Uses `tmux list-panes`, `tmux list-windows`, etc.
   - Checks actual tmux state, not just keystrokes

3. **Validation Functions**
   ```bash
   verify_kata_1() {
       # Check if a vertical split was created (2 panes)
       local pane_count=$(tmux list-panes | wc -l)
       [[ $pane_count -eq 2 ]]
   }
   ```

4. **Interactive Loop**
   - Present challenge
   - Wait for user action
   - Validate result
   - Provide feedback
   - Progress or retry

### Technical Details

**Requirements:**
- Bash 4.0+
- Tmux 2.0+ (tested with 3.x)
- Running inside a tmux session

**Files Created:**
- `~/.tmux-kata-progress` - Progress tracking file

**Tmux Commands Used:**
- `tmux list-panes` - Count and inspect panes
- `tmux list-windows` - Count and inspect windows
- `tmux display-message` - Get session info
- Various others for state inspection

## Customization

### Adding New Katas

To add a new kata:

1. **Create a verification function**:
```bash
verify_kata_13() {
    # Your verification logic here
    # Return 0 for success, non-zero for failure
    local some_state=$(tmux some-command)
    [[ condition_met ]]
}
```

2. **Add to the kata sequence**:
```bash
if [[ $start_kata -le 13 ]]; then
    run_kata 13 \
        "Kata Title" \
        "Description of what to do" \
        "Hint: Prefix + key" \
        "verify_kata_13" \
        "Expected outcome description"
    update_progress 14
fi
```

3. **Update the total kata count** in the completion message

### Modifying Difficulty

- **Easier**: Add more detailed hints, show example commands
- **Harder**: Remove hints, add time limits, require specific sequences
- **Advanced**: Add multi-step katas, require specific pane arrangements

### Changing Appearance

Modify the color codes at the top of the script:
```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
# etc.
```

## Tips for Effective Learning

1. **Daily Practice**: Run through all katas daily for a week
2. **Speed Runs**: Time yourself and try to improve
3. **No Hints**: Cover the hints and try from memory
4. **Real Usage**: Apply what you learn in actual work
5. **Customize**: Once comfortable, customize your tmux.conf

## Common Issues

**"Error: This script must be run inside a tmux session"**
- Solution: Run `tmux` first, then run the script

**Verification fails but I did it correctly**
- Some katas are hard to verify (like copy mode)
- Make sure you completed the exact task described
- Check if you have the right number of panes/windows

**Progress not saving**
- Check write permissions for `~/.tmux-kata-progress`
- Make sure the script can write to your home directory

**Weird characters or colors**
- Your terminal might not support ANSI colors
- Try a modern terminal (iTerm2, Alacritty, GNOME Terminal)

## Advanced Usage

### Integration with Other Tools

Create an alias in your `.bashrc` or `.zshrc`:
```bash
alias tk='tmux new -s kata \; run-shell ~/tmux-kata.sh'
```

### Automated Testing

Run all katas programmatically:
```bash
# This would require modification to support non-interactive mode
# Left as an exercise for the user
```

### Training Sessions

Create a training session with multiple panes:
```bash
tmux new-session -s training \; \
  split-window -h \; \
  split-window -v \; \
  send-keys '~/tmux-kata.sh' C-m
```

## Philosophy

This tool is inspired by:
- **Kata practice** from martial arts - repetition builds muscle memory
- **Interactive learning** - doing is better than reading
- **Immediate feedback** - know right away if you got it right
- **Progressive difficulty** - build skills incrementally

## Contributing

Ideas for improvements:
- [ ] Add session management katas
- [ ] Include window swapping and moving
- [ ] Add pane resizing challenges
- [ ] Include synchronized panes
- [ ] Add configuration file katas
- [ ] Support custom keybindings
- [ ] Add difficulty levels
- [ ] Include timing/scoring system
- [ ] Add multiplayer/competitive mode

## Resources

- [Official Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [TMUX-REFERENCE.md](./TMUX-REFERENCE.md) - Quick reference guide
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

## License

Free to use, modify, and distribute. Learn and share!

## Acknowledgments

Built for developers who want to master tmux through deliberate practice.

---

**Happy tmuxing! 🚀**

Practice makes permanent. Make it perfect.
