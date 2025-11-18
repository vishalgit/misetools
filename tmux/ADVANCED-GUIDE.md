# Advanced Tmux Katas - Power User Guide

## Overview

The advanced katas (13-22) build upon the foundational skills and teach you power-user techniques that will transform your tmux workflow. These features separate casual users from tmux masters.

## Why Advanced Katas Matter

### Session Management (Katas 14-16, 22)
**The Problem**: Losing work when SSH disconnects, or juggling multiple projects in separate terminal windows.

**The Solution**: Sessions let you organize work into persistent environments that survive disconnections and can be switched between instantly.

**Real-World Use Cases**:
- Remote server work (detach before closing laptop, reattach later)
- Separate sessions for different clients/projects
- Long-running processes that need to survive terminal closure
- Pairing sessions (multiple users attach to same session)

### Pane Manipulation (Katas 13, 17-18)
**The Problem**: Fixed pane layouts that don't adapt to your current task.

**The Solution**: Dynamic pane resizing, swapping, and breaking gives you complete control over your workspace layout.

**Real-World Use Cases**:
- Resize panes to show more of your logs or code
- Rearrange panes to match your mental model
- Promote an important pane to its own window
- Quickly reorganize when switching tasks

### Synchronized Panes (Katas 19-20)
**The Problem**: Running the same command on multiple servers requires tedious repetition.

**The Solution**: Synchronized panes let you type in multiple panes simultaneously.

**Real-World Use Cases**:
- Deploy to multiple servers at once
- Update configuration across a cluster
- Monitor multiple log files in parallel
- Test behavior across different environments

### Window Organization (Kata 21)
**The Problem**: Windows get out of order as you work, making navigation confusing.

**The Solution**: Move windows to logical positions in your window list.

**Real-World Use Cases**:
- Keep related windows grouped together
- Maintain a consistent window order (e.g., editor always at 1, tests at 2)
- Reorganize as project priorities change

---

## Detailed Kata Guide

### Kata 13: Resize Panes
**Command**: `Prefix + Ctrl+Arrow`

**What It Does**: Dynamically adjusts pane sizes without recreating your layout.

**Pro Tips**:
- Hold Ctrl and press arrows multiple times for fine control
- Use this when you need to see more of one pane temporarily
- Combine with zoom (Prefix + z) for even more flexibility
- Add custom bindings in .tmux.conf for larger resize increments

**Common Patterns**:
```bash
# In .tmux.conf - easier resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
```

### Kata 14: Detach from Session
**Command**: `Prefix + d`

**What It Does**: Disconnects from tmux but keeps everything running in the background.

**Pro Tips**:
- Everything continues running (servers, builds, downloads)
- Reattach with: `tmux attach -t session-name`
- Use before closing your laptop with SSH connections
- Detach before switching to a different session
- Sessions persist until explicitly killed or server reboots

**Workflow Example**:
```bash
# Start a long-running process
tmux new -s deploy
./deploy-to-production.sh

# Detach (Prefix + d) - deploy continues
# Close laptop, go to meeting

# Later, reattach to check progress
tmux attach -t deploy
```

### Kata 15: Create Named Session
**Command**: `tmux new -s name`

**What It Does**: Creates a session with a descriptive name instead of just a number.

**Pro Tips**:
- Name sessions after projects: `client-website`, `api-development`
- Use short, memorable names
- List all sessions: `tmux ls`
- Name reflects purpose, making switching easier

**Organization Strategy**:
```bash
tmux new -s dotfiles    # Personal configuration work
tmux new -s work-proj   # Main project
tmux new -s monitoring  # System monitoring session
tmux new -s learning    # For tutorials and experiments
```

### Kata 16: Switch Between Sessions
**Command**: `Prefix + s` (interactive) or `Prefix + (` / `)`

**What It Does**: Navigate between multiple active sessions.

**Pro Tips**:
- `Prefix + s` shows a tree view of all sessions with windows
- `Prefix + (` and `)` cycle through sessions
- Use different sessions for different contexts (work/personal)
- All sessions run simultaneously

**Workflow Example**:
```
Session 1 "api-dev":
  Window 0: code editor
  Window 1: API server
  Window 2: database logs

Session 2 "frontend":
  Window 0: code editor
  Window 1: webpack dev server
  Window 2: browser tests

Switch between them instantly with Prefix + s
```

### Kata 17: Swap Panes
**Command**: `Prefix + {` or `Prefix + }`

**What It Does**: Exchanges positions of two panes.

**Pro Tips**:
- `{` swaps with previous pane (counterclockwise)
- `}` swaps with next pane (clockwise)
- Useful when you split in the wrong order
- Rearrange without recreating your layout

**Use Case**:
```
Before:         After (Prefix + }):
┌────┬────┐     ┌────┬────┐
│ 1  │ 2  │     │ 2  │ 1  │
├────┴────┤  →  ├────┴────┤
│    3    │     │    3    │
└─────────┘     └─────────┘
```

### Kata 18: Break Pane to Window
**Command**: `Prefix + !`

**What It Does**: Converts current pane into a new window.

**Pro Tips**:
- Use when a pane needs more space long-term
- Opposite of `:join-pane` (not covered in katas)
- Original layout remains with one fewer pane
- New window appears at the end of window list

**Scenario**:
```
You're debugging in a small pane but need full screen.
Prefix + ! → That pane becomes a new window
Work there, then Prefix + & to close when done
```

### Kata 19-20: Synchronized Panes
**Commands**: 
- Enable: `Prefix + :` then `setw synchronize-panes on`
- Disable: `Prefix + :` then `setw synchronize-panes off`

**What It Does**: Broadcasts your keystrokes to all panes in the window.

**Pro Tips**:
- Toggle indicator usually appears in status bar
- Only affects panes in current window
- Be careful - affects ALL panes, including inactive ones
- Create a binding in .tmux.conf for quick toggle

**Custom Binding**:
```bash
# In .tmux.conf
bind S setw synchronize-panes
```

**Real-World Scenario**:
```bash
# Split into 4 panes, SSH to different servers
# Top-left:    ssh user@web1
# Top-right:   ssh user@web2
# Bottom-left: ssh user@web3
# Bottom-right:ssh user@web4

# Enable sync: Prefix + :, then setw synchronize-panes on
# Now type once, executes on all servers:
sudo systemctl restart nginx
# All four servers restart nginx simultaneously

# Disable sync when done
```

### Kata 21: Move Window
**Command**: `Prefix + .`

**What It Does**: Assigns a new number to the current window.

**Pro Tips**:
- Helps maintain logical window order
- Especially useful after closing windows (gaps in numbering)
- Some people keep specific tasks at specific numbers
- Can also use `:swap-window` for more control

**Organization Example**:
```
Preferred layout:
  0: Main editor
  1: Tests
  2: Server
  3: Database
  4: Documentation

If you accidentally create them out of order,
use Prefix + . to reorganize
```

### Kata 22: Rename Session
**Command**: `Prefix + $`

**What It Does**: Changes the name of your current session.

**Pro Tips**:
- Use when session purpose changes
- Keep names short but descriptive
- Helps when you have many sessions
- Visible in `tmux ls` and status bar

**Naming Conventions**:
```bash
# Good names:
api-dev, frontend, deploy, monitoring

# Avoid:
really-long-descriptive-name-that-is-hard-to-type
tmp123
session1
```

---

## Advanced Workflows Combining Multiple Katas

### Workflow 1: Multi-Server Management
```bash
# Create session for server management
tmux new -s servers

# Create 4 panes
Prefix + % (vertical split)
Prefix + " (horizontal split both)

# SSH to different servers
Prefix + 0 (first pane)  → ssh prod-server-1
Prefix + 1 (second pane) → ssh prod-server-2
Prefix + 2 (third pane)  → ssh prod-server-3
Prefix + 3 (fourth pane) → ssh prod-server-4

# Enable synchronized panes
Prefix + :
setw synchronize-panes on

# Run commands across all servers
sudo apt update
sudo apt upgrade -y

# Disable sync
Prefix + :
setw synchronize-panes off

# Detach and let updates run
Prefix + d

# Reattach later
tmux attach -t servers
```

### Workflow 2: Project Context Switching
```bash
# Morning: Start work on Project A
tmux new -s project-a
# Set up panes for editor, server, tests

# Urgent request for Project B
Prefix + d (detach from project-a)
tmux new -s project-b
# Set up panes for different project

# Switch back and forth as needed
tmux attach -t project-a
tmux attach -t project-b

# Or use Prefix + s for visual switcher
```

### Workflow 3: Adaptive Layout Management
```bash
# Start with standard layout
Split into 3 panes

# Need to focus on logs?
Prefix + z (zoom log pane)
# Work with logs
Prefix + z (unzoom)

# Need logs bigger but not full screen?
Prefix + Ctrl+Down (resize pane larger)

# Need to compare two files side-by-side?
Prefix + ! (break pane to window)
Prefix + % (split vertically)
# Now you have dedicated comparison window

# Done? Switch back
Prefix + & (close comparison window)
```

### Workflow 4: Persistent Development Environment
```bash
# Friday evening - setup development session
tmux new -s dev

Window 0: Code editor
Window 1: Running application
Window 2: Database logs
Window 3: Git status

# Go home for weekend
Prefix + d

# Monday morning - everything exactly as you left it
tmux attach -t dev

# System crash/reboot happened?
# Sessions are lost, but you can:
# 1. Save tmux layout in a script
# 2. Use tmux-resurrect plugin
# 3. Create a shell script to recreate your setup
```

---

## Advanced Tips & Tricks

### Custom Keybindings for Advanced Features
Add these to your `~/.tmux.conf`:

```bash
# Quick session switching
bind -n M-1 switch-client -t project-a
bind -n M-2 switch-client -t project-b
bind -n M-3 switch-client -t monitoring

# Toggle synchronized panes
bind S setw synchronize-panes

# Easier pane breaking and joining
bind ! break-pane
bind @ command-prompt -p "Join pane from:" "join-pane -s '%%'"

# Smart pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Session management
bind C-s choose-session
bind C-n command-prompt -p "New session:" "new-session -s '%%'"
bind C-r command-prompt -p "Rename session:" "rename-session '%%'"
```

### Session Management Scripts
```bash
#!/bin/bash
# ~/bin/start-dev-session.sh

SESSION="dev-project"

# Create session
tmux new-session -d -s $SESSION

# Window 0: Editor
tmux rename-window -t $SESSION:0 'editor'
tmux send-keys -t $SESSION:0 'cd ~/projects/myapp && vim' C-m

# Window 1: Server
tmux new-window -t $SESSION:1 -n 'server'
tmux send-keys -t $SESSION:1 'cd ~/projects/myapp && npm run dev' C-m

# Window 2: Tests
tmux new-window -t $SESSION:2 -n 'tests'
tmux send-keys -t $SESSION:2 'cd ~/projects/myapp && npm test -- --watch' C-m

# Attach
tmux attach -t $SESSION
```

### Synchronized Panes Use Cases
1. **Cluster management**: Update configuration across nodes
2. **Parallel testing**: Run tests in multiple environments
3. **Log monitoring**: Watch logs from multiple services
4. **SSH key distribution**: Update authorized_keys on multiple servers
5. **Batch operations**: Any command that needs to run on multiple targets

### Session Organization Strategies
1. **By Project**: One session per project/client
2. **By Role**: Dev, ops, personal
3. **By Context**: Frontend, backend, devops, learning
4. **By Priority**: Current sprint, backlog, maintenance

---

## Common Pitfalls & Solutions

### Pitfall 1: Too Many Sessions
**Problem**: Created too many sessions, hard to find the right one.
**Solution**: 
- Name sessions descriptively
- Kill unused sessions: `tmux kill-session -t name`
- List sessions regularly: `tmux ls`
- Use `Prefix + s` tree view

### Pitfall 2: Forgetting Synchronized Panes Is On
**Problem**: Typed passwords/commands in all panes accidentally.
**Solution**:
- Add indicator to status bar in .tmux.conf
- Always toggle off after use
- Create visual reminder in prompt

### Pitfall 3: Complex Layouts Lost on Detach
**Problem**: Spent time creating perfect layout, it's lost after reattach... wait, no it's not!
**Solution**: Tmux preserves layouts! But if server reboots:
- Use tmux-resurrect plugin
- Script your layout creation
- Keep layout simple and reproducible

### Pitfall 4: Resized Panes Look Weird
**Problem**: Resized panes don't align nicely.
**Solution**:
- Use layout cycle (Prefix + Space) to reset
- Resize in small increments
- Consider using even-horizontal or even-vertical layouts

---

## Muscle Memory Exercises

### Exercise 1: Session Juggling
```
1. Create 3 named sessions
2. Create 2 windows in each
3. Practice switching between sessions
4. Detach and reattach to each
5. Rename all sessions
6. Clean up (kill all sessions)

Goal: Do this in under 2 minutes
```

### Exercise 2: Pane Choreography
```
1. Split into 4 panes
2. Resize each to different sizes
3. Swap panes to rearrange
4. Break one to a window
5. Return and reorganize remaining panes
6. Cycle through layouts

Goal: Smooth, confident movements
```

### Exercise 3: Synchronized Deploy
```
1. Split into 3 panes
2. SSH to 3 different servers (or localhost 3 times)
3. Enable synchronized panes
4. Run: echo "test" > test.txt
5. Disable synchronized panes
6. Verify each pane independently
7. Remove file in each

Goal: No mistakes, proper toggling
```

---

## Integration with Development Workflow

### Full-Stack Developer Setup
```
Session "frontend":
  Window 0: Code editor (vim/vscode)
  Window 1: React dev server
  Window 2: Browser automation tests

Session "backend":
  Window 0: API code
  Window 1: API server
  Window 2: Database logs

Session "deploy":
  Window 0: CI/CD monitoring
  Window 1: Staging environment
  Window 2: Production environment (view-only)
```

### DevOps Engineer Setup
```
Session "monitoring":
  Window 0: htop (4 panes, different servers)
  Window 1: Log aggregation
  Window 2: Metrics dashboard

Session "deploy":
  Window 0: Deployment scripts
  Window 1: Synchronized panes for fleet updates
  Window 2: Rollback procedures

Session "incidents":
  (Created on-demand when issues arise)
```

---

## Next Level: Beyond the Katas

After mastering these advanced katas, explore:

1. **Tmux Plugin Manager (TPM)**: Plugin ecosystem
2. **Tmux Resurrect**: Save/restore sessions across reboots
3. **Tmux Continuum**: Automatic session saving
4. **Tmux Yank**: Better copy/paste integration
5. **Custom Scripting**: Automate tmux with shell scripts
6. **Integration**: Vim-tmux-navigator, fzf-tmux, etc.

---

## Conclusion

These advanced katas transform tmux from a terminal multiplexer into a complete workspace orchestration tool. The difference between basic and advanced tmux usage is like the difference between using a bicycle and knowing how to do tricks on it—both get you from A to B, but mastery opens up entirely new possibilities.

**Practice these katas until they become instinctive, then build your own workflows around them.**

---

**Remember**: The goal isn't just to memorize commands—it's to internalize them so deeply that tmux becomes an extension of your thought process. When you can switch contexts, manipulate layouts, and manage sessions without conscious thought, you've achieved tmux mastery.

Keep practicing! 🚀
