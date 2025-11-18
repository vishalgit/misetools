# Tmux Kata Training System - Complete Package

Welcome to the Tmux Kata Training System! This package contains everything you need to master tmux through interactive practice.

## 📦 What's Included

### Core Files
1. **tmux-kata.sh** (12 KB)
   - The main training script
   - 12 progressive katas from beginner to advanced
   - Automatic validation and progress tracking
   - Interactive feedback system

2. **install.sh** (3.2 KB)
   - One-command installation script
   - Sets up directory structure
   - Optionally adds shell alias
   - Checks dependencies

### Documentation
3. **QUICKSTART.md** (8.2 KB)
   - Fastest way to get started
   - Visual guides and examples
   - Common mistakes and fixes
   - Practice tips for all skill levels

4. **README.md** (6.6 KB)
   - Complete system documentation
   - Architecture explanation
   - How to add custom katas
   - Troubleshooting guide

5. **TMUX-REFERENCE.md** (3.6 KB)
   - Quick reference for all tmux commands
   - Organized by category
   - Keyboard shortcuts table
   - Copy mode guide

6. **sample.tmux.conf** (9.4 KB)
   - Starter configuration file
   - Better key bindings
   - Beautiful status bar
   - Commented for easy customization

## 🚀 Getting Started (Choose Your Path)

### Path 1: Quick Start (5 minutes)
```bash
# 1. Download all files to a directory
# 2. Make scripts executable
chmod +x tmux-kata.sh install.sh

# 3. Start tmux
tmux

# 4. Run the kata trainer
./tmux-kata.sh
```

### Path 2: Full Installation (10 minutes)
```bash
# 1. Download all files to a directory
# 2. Make installer executable
chmod +x install.sh

# 3. Run installer
./install.sh

# 4. Follow the prompts
# 5. Use the created alias: tmux-kata
```

### Path 3: Manual Setup (15 minutes)
```bash
# 1. Read QUICKSTART.md
# 2. Read README.md for deep understanding
# 3. Copy sample.tmux.conf to ~/.tmux.conf
# 4. Customize configuration
# 5. Run tmux-kata.sh for training
```

## 📚 Learning Roadmap

### Day 1: Foundation
- [ ] Read QUICKSTART.md (10 min)
- [ ] Complete Katas 1-4 (Pane basics) (15 min)
- [ ] Practice Katas 1-4 without hints (10 min)
- [ ] Use tmux for actual work (ongoing)

### Day 2: Windows
- [ ] Complete Katas 5-8 (Window management) (15 min)
- [ ] Review TMUX-REFERENCE.md (10 min)
- [ ] Practice Katas 1-8 continuously (10 min)

### Day 3: Advanced Features
- [ ] Complete Katas 9-12 (Advanced features) (15 min)
- [ ] Read README.md architecture section (10 min)
- [ ] Complete all 12 basic katas in under 5 minutes (challenge)

### Day 4: Power User Skills
- [ ] Complete Katas 13-18 (Session & pane management) (20 min)
- [ ] Practice session workflows (10 min)
- [ ] Complete Katas 19-22 (Synchronized panes & organization) (15 min)

### Day 5: Customization
- [ ] Copy sample.tmux.conf to ~/.tmux.conf
- [ ] Customize key bindings
- [ ] Set up status bar theme
- [ ] Test all customizations
- [ ] Complete all 22 katas continuously (challenge)

### Week 2+: Mastery
- [ ] Use tmux daily for all terminal work
- [ ] Complete all katas without thinking
- [ ] Create your own workflow layouts
- [ ] Teach someone else tmux

## 🎯 What You'll Learn

### Beginner Skills (Katas 1-4)
- Creating vertical splits (side-by-side panes)
- Creating horizontal splits (stacked panes)
- Navigating between panes
- Closing panes

### Intermediate Skills (Katas 5-8)
- Creating windows (like tabs)
- Renaming windows for organization
- Switching between windows
- Closing windows

### Advanced Skills (Katas 9-12)
- Copy mode for scrolling and copying text
- Zooming panes for focus
- Unzooming back to layout
- Cycling through automatic layouts

### Power User Skills (Katas 13-22)
- Resizing panes dynamically
- Detaching and reattaching sessions
- Creating and managing named sessions
- Switching between multiple sessions
- Swapping and rearranging panes
- Breaking panes into new windows
- Synchronized panes for multi-pane commands
- Moving windows to reorder them
- Renaming sessions for better organization

## 🔧 System Requirements

- **Operating System**: Ubuntu 18.04+, Debian 10+, or any Linux with tmux
- **Tmux Version**: 2.0 or higher (3.x recommended)
- **Bash**: 4.0 or higher
- **Terminal**: Any terminal emulator with ANSI color support

Check your versions:
```bash
tmux -V        # Check tmux version
bash --version # Check bash version
```

## 📖 File Usage Guide

### For Learning
1. **Start here**: QUICKSTART.md
2. **Then**: tmux-kata.sh (the interactive trainer)
3. **Reference**: TMUX-REFERENCE.md (keep open while practicing)
4. **Deep dive**: README.md (when you want to understand how it works)

### For Customization
1. **Base config**: sample.tmux.conf
2. **Modification guide**: Comments in sample.tmux.conf
3. **Advanced features**: README.md "Customization" section

### For Installation
1. **Quick setup**: install.sh
2. **Manual setup**: Instructions in README.md

## 🎓 How the Kata System Works

### The Learning Loop
```
┌─────────────────────────────────────────┐
│  1. Display Challenge                   │
│     "Split your pane vertically"        │
└───────────────┬─────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│  2. You Perform Action                  │
│     Press: Ctrl+b then %                │
└───────────────┬─────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│  3. Press Enter to Verify               │
└───────────────┬─────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│  4. System Validates                    │
│     Checks: pane_count == 2             │
└───────────────┬─────────────────────────┘
                │
        ┌───────┴────────┐
        ▼                ▼
   ✓ Success        ✗ Failure
        │                │
        │         (Try Again)
        │                │
        └────────┬───────┘
                 ▼
        Next Kata / Complete
```

### Progress Tracking
- Progress saved in `~/.tmux-kata-progress`
- Resume from where you left off
- Reset anytime to practice from beginning

### Validation Methods
- Counts panes: `tmux list-panes | wc -l`
- Counts windows: `tmux list-windows | wc -l`
- Checks zoom state: `tmux display-message -p '#{window_zoomed_flag}'`
- Verifies names: `tmux list-windows | grep "name"`

## 💡 Pro Tips

### Learning Effectively
1. **Repeat Daily**: Practice for 10 minutes every day for a week
2. **No Peeking**: Try without hints once you've done each kata once
3. **Real Use**: Use tmux for actual work immediately after training
4. **Speed Runs**: Time yourself and try to beat your record
5. **Teach Others**: Best way to cement knowledge

### Customization Ideas
1. **Better Prefix**: Change Ctrl+b to Ctrl+a (closer on keyboard)
2. **Mouse Mode**: Enable for easier pane clicking (training wheels)
3. **Vim Bindings**: Use hjkl for navigation if you're a vim user
4. **Status Bar**: Customize to show what you need
5. **Plugins**: Explore TPM (Tmux Plugin Manager) after basics

### Common Workflows

**Development Setup**:
```
Window 1: Code editor + terminal
Window 2: Test runner
Window 3: Server logs
Window 4: Documentation
```

**System Administration**:
```
Window 1: Main work
Window 2: Monitoring (htop, df)
Window 3: Logs (tail -f)
Window 4: SSH sessions
```

## 🐛 Troubleshooting

### "Command not found: tmux"
```bash
# Ubuntu/Debian
sudo apt install tmux

# Fedora
sudo dnf install tmux

# Arch
sudo pacman -S tmux

# macOS
brew install tmux
```

### "Must run inside tmux"
```bash
# Start tmux first
tmux

# Then run the script
./tmux-kata.sh
```

### "Permission denied"
```bash
# Make scripts executable
chmod +x tmux-kata.sh install.sh
```

### Weird colors or formatting
- Your terminal might not support ANSI colors
- Try a modern terminal: iTerm2, Alacritty, GNOME Terminal, Terminator
- Functionality works regardless of colors

## 🌟 Success Metrics

You've mastered tmux when you can:
- [ ] Complete all 22 katas in under 5 minutes
- [ ] Navigate without thinking about commands
- [ ] Use tmux for 100% of terminal work
- [ ] Create custom layouts for different tasks
- [ ] Manage multiple sessions effortlessly
- [ ] Use synchronized panes when needed
- [ ] Teach someone else the basics
- [ ] Never lose work due to disconnected SSH

## 🔗 Additional Resources

### Official Documentation
- Tmux Manual: `man tmux`
- Tmux Wiki: https://github.com/tmux/tmux/wiki
- Tmux GitHub: https://github.com/tmux/tmux

### Community Resources
- r/tmux on Reddit
- Tmux Cheat Sheet: https://tmuxcheatsheet.com/
- Awesome Tmux: https://github.com/rothgar/awesome-tmux

### Books
- "tmux 2: Productive Mouse-Free Development" by Brian Hogan
- "The Tao of tmux" by Tony Narlock (free online)

## 🎉 What's Next?

After completing the katas:

1. **Customize**: Copy sample.tmux.conf to ~/.tmux.conf and personalize
2. **Daily Use**: Make tmux your default terminal environment
3. **Advanced Features**: Learn about sessions, buffers, hooks
4. **Plugins**: Explore TPM and popular plugins
5. **Workflow**: Develop your own layouts and shortcuts
6. **Teach**: Share your knowledge with others

## 📝 Quick Reference Card

```
┌─────────────────────────────────────────────────┐
│             TMUX ESSENTIAL COMMANDS             │
├─────────────────────────────────────────────────┤
│ Prefix: Ctrl+b (default)                        │
├─────────────────────────────────────────────────┤
│ PANES                                           │
│  %     Split vertically                         │
│  "     Split horizontally                       │
│  o     Next pane                                │
│  arrows Navigate panes                          │
│  x     Close pane                               │
│  z     Zoom/unzoom                              │
├─────────────────────────────────────────────────┤
│ WINDOWS                                         │
│  c     New window                               │
│  ,     Rename window                            │
│  n     Next window                              │
│  p     Previous window                          │
│  0-9   Window by number                         │
│  &     Close window                             │
├─────────────────────────────────────────────────┤
│ SESSIONS                                        │
│  d     Detach from session                      │
│  $     Rename session                           │
│  s     List sessions                            │
├─────────────────────────────────────────────────┤
│ OTHER                                           │
│  [     Copy mode (scroll)                       │
│  ?     List all bindings                        │
│  :     Command prompt                           │
└─────────────────────────────────────────────────┘
```

## 📄 License

Free to use, modify, and distribute. No restrictions.
The goal is learning - share freely!

## 🙏 Acknowledgments

Created for developers who want to master tmux through deliberate practice.
Inspired by the kata method from martial arts.

---

**Ready to become a tmux master?**

```bash
./install.sh  # For permanent setup
# or
./tmux-kata.sh  # For immediate practice
```

**Practice makes permanent. Make it perfect!** 🚀
