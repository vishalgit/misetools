# Quick Start Guide

## What You're About to Learn

This kata system will teach you 12 essential tmux operations through interactive practice. Each kata presents a challenge, you perform the action, and the system verifies you did it correctly.

## 30-Second Setup

```bash
# 1. Start tmux
tmux

# 2. Run the kata script
./tmux-kata.sh

# 3. Follow the on-screen prompts
# 4. Practice until it's muscle memory!
```

## What Each Kata Teaches

### Beginner Katas (1-4): Pane Basics
- **Kata 1**: Split panes vertically (side-by-side)
- **Kata 2**: Split panes horizontally (stacked)
- **Kata 3**: Navigate between panes
- **Kata 4**: Close a pane

### Intermediate Katas (5-8): Window Management
- **Kata 5**: Create new windows (like tabs)
- **Kata 6**: Rename windows for organization
- **Kata 7**: Switch between windows
- **Kata 8**: Close windows

### Advanced Katas (9-12): Pro Features
- **Kata 9**: Copy mode for scrolling/copying
- **Kata 10**: Zoom to focus on one pane
- **Kata 11**: Unzoom back to multi-pane
- **Kata 12**: Cycle through different layouts

### Power User Katas (13-22): Advanced Operations
- **Kata 13**: Resize panes dynamically
- **Kata 14**: Detach from session (background operation)
- **Kata 15**: Create named sessions
- **Kata 16**: Switch between multiple sessions
- **Kata 17**: Swap pane positions
- **Kata 18**: Break pane into new window
- **Kata 19**: Enable synchronized panes
- **Kata 20**: Disable synchronized panes
- **Kata 21**: Move windows to reorder
- **Kata 22**: Rename sessions

## Example Session

Here's what a typical training session looks like:

```
╔════════════════════════════════════════════════════════════╗
║              TMUX KATA - Master tmux Step by Step          ║
╚════════════════════════════════════════════════════════════╝

Kata #1: Create a Vertical Split
────────────────────────────────────────────────────────────

Challenge:
  Split your current pane vertically to create two side-by-side panes.

Hint:
  Default prefix is Ctrl+b, then press %

────────────────────────────────────────────────────────────
Press Enter when you've completed the task...
```

You perform the action (Ctrl+b then %), press Enter, and get immediate feedback:

```
✓ Success! Well done!
```

Then automatically moves to Kata #2!

## Visual Guide

### Before Your First Split:
```
┌─────────────────────────────┐
│                             │
│                             │
│      Single Pane            │
│                             │
│                             │
└─────────────────────────────┘
```

### After Kata 1 (Vertical Split):
```
┌──────────────┬──────────────┐
│              │              │
│    Pane 1    │    Pane 2    │
│              │              │
│              │              │
└──────────────┴──────────────┘
```

### After Kata 2 (Horizontal Split):
```
┌──────────────┬──────────────┐
│              │              │
│    Pane 1    │    Pane 2    │
│              │              │
├──────────────┴──────────────┤
│         Pane 3               │
└──────────────────────────────┘
```

## Common Mistakes (and How to Fix Them)

### Mistake 1: Forgetting the Prefix
❌ Just pressing `%` → Nothing happens
✅ Press `Ctrl+b`, release, THEN press `%`

### Mistake 2: Holding Keys Too Long
❌ Holding `Ctrl+b` while pressing `%` → May repeat
✅ Press and release `Ctrl+b`, then press `%`

### Mistake 3: Wrong Key
❌ Pressing `Ctrl+b` then `5` instead of `%`
✅ Remember: `%` is Shift+5 on US keyboards

### Mistake 4: Doing Actions Too Fast
❌ Pressing keys before tmux is ready
✅ Wait for tmux to process each command

## Practice Tips

### For Absolute Beginners
1. Complete all 12 katas once to see the basics
2. Read the full reference guide
3. Complete all katas again without looking at hints
4. Practice daily for a week

### For Quick Learners
1. Complete all katas in one sitting
2. Reset and try to complete in under 5 minutes
3. Use tmux for real work the same day
4. Customize your ~/.tmux.conf

### For Mastery
1. Complete katas with your eyes closed (seriously!)
2. Teach someone else what you learned
3. Create your own katas for advanced features
4. Use tmux for everything for a month

## After Completing the Katas

### Immediate Next Steps
1. ✅ Create your `~/.tmux.conf` configuration file
2. ✅ Set up a better key binding (many prefer Ctrl+a)
3. ✅ Enable mouse mode for easier learning
4. ✅ Use tmux in your daily workflow

### Configuration Example
Create `~/.tmux.conf`:
```bash
# Better prefix key
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Mouse support
set -g mouse on

# Easier splits
bind | split-window -h
bind - split-window -v

# Start numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Reload config
bind r source-file ~/.tmux.conf \; display "Reloaded!"
```

### Practice Projects
Try these real-world scenarios:

**1. Development Environment**
```
┌─────────────────┬──────────────┐
│                 │              │
│   Code Editor   │   Terminal   │
│                 │              │
├─────────────────┼──────────────┤
│                 │              │
│   Server Logs   │   Git/Tests  │
│                 │              │
└─────────────────┴──────────────┘
```

**2. System Monitoring**
```
┌─────────────────┬──────────────┐
│                 │              │
│    htop         │    df -h     │
│                 │              │
├─────────────────┼──────────────┤
│                 │              │
│  tail -f log    │   netstat    │
│                 │              │
└─────────────────┴──────────────┘
```

## Keyboard Layout Reference

### Default US Keyboard
The keys you'll use most:
- `Ctrl+b` - Prefix key
- `%` - Vertical split (Shift+5)
- `"` - Horizontal split (Shift+')
- `,` - Rename
- `&` - Kill window (Shift+7)

### International Keyboards
If you have trouble with `%` or `"`, you can remap in ~/.tmux.conf:
```bash
bind | split-window -h  # Vertical split
bind - split-window -v  # Horizontal split
```

## Troubleshooting

**Q: The script says I failed but I did it correctly**
A: Make sure you performed the EXACT action requested. For example, Kata 1 needs exactly 2 panes.

**Q: I can't get out of a mode**
A: Press `q` or `Escape` to exit most modes, or `Ctrl+c` as last resort.

**Q: My terminal looks weird**
A: Your terminal might not support colors. This doesn't affect functionality.

**Q: Can I use a different prefix key?**
A: Yes! Customize your ~/.tmux.conf after learning the defaults.

## Success Indicators

You'll know you've mastered tmux when:
- [ ] You can complete all katas without hints in under 5 minutes
- [ ] You use tmux automatically when SSHing to servers
- [ ] You stop using terminal tabs and use tmux windows instead
- [ ] You can navigate panes without thinking
- [ ] You use sessions to organize different projects
- [ ] You leverage synchronized panes for multi-server management
- [ ] You teach a colleague how to use tmux
- [ ] You dream in panes (just kidding... sort of)

## Resources at Your Fingertips

- **Full Reference**: `TMUX-REFERENCE.md` - All commands in one place
- **Detailed Docs**: `README.md` - How the system works
- **This Guide**: Keep it open while practicing

## Ready to Start?

```bash
# Start your journey:
tmux
./tmux-kata.sh

# Or use the installer for a permanent setup:
./install.sh
```

Remember: **Practice makes permanent**. Do it right from the start!

---

Good luck, and may your terminal be ever split! 🚀
