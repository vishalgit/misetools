#!/bin/bash

# Tmux Kata Training Script
# A progressive learning tool for mastering tmux

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Configuration
KATA_SESSION="tmux-kata"
PROGRESS_FILE="$HOME/.tmux-kata-progress"

# Initialize progress tracking
initialize_progress() {
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        echo "0" > "$PROGRESS_FILE"
    fi
}

# Get current kata number
get_current_kata() {
    cat "$PROGRESS_FILE" 2>/dev/null || echo "0"
}

# Update progress
update_progress() {
    local kata_num=$1
    echo "$kata_num" > "$PROGRESS_FILE"
}

# Reset progress
reset_progress() {
    echo "0" > "$PROGRESS_FILE"
}

# Display header
show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}              ${BOLD}TMUX KATA - Master tmux Step by Step${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# Display kata challenge
show_kata() {
    local kata_num=$1
    local title=$2
    local description=$3
    local hint=$4
    
    show_header
    echo -e "${YELLOW}Kata #$kata_num: ${BOLD}$title${NC}"
    echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
    echo
    echo -e "${CYAN}Challenge:${NC}"
    echo -e "  $description"
    echo
    echo -e "${CYAN}Hint:${NC}"
    echo -e "  $hint"
    echo
    echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}Press Enter when you've completed the task...${NC}"
}

# Verification functions for each kata
verify_kata_1() {
    # Check if a vertical split was created (2 panes)
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -eq 2 ]]
}

verify_kata_2() {
    # Check if a horizontal split was created (3 panes)
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -eq 3 ]]
}

verify_kata_3() {
    # User should have navigated and come back (hard to verify, we'll check they know the command)
    # We'll just verify we still have 3 panes and they pressed enter
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -eq 3 ]]
}

verify_kata_4() {
    # Check if a pane was closed (back to 2 panes)
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -eq 2 ]]
}

verify_kata_5() {
    # Check if a new window was created (2 windows)
    local window_count=$(tmux list-windows | wc -l)
    [[ $window_count -eq 2 ]]
}

verify_kata_6() {
    # Check if window was renamed (look for "mywindow" in window list)
    tmux list-windows | grep -q "mywindow"
}

verify_kata_7() {
    # User should be back on first window
    local current_window=$(tmux display-message -p '#I')
    [[ $current_window -eq 0 ]]
}

verify_kata_8() {
    # Window should be closed (back to 1 window)
    local window_count=$(tmux list-windows | wc -l)
    [[ $window_count -eq 1 ]]
}

verify_kata_9() {
    # Check if we're in copy mode (this is tricky, we'll assume success)
    # Actually, we can't easily verify this, so we'll trust the user
    return 0
}

verify_kata_10() {
    # Check if pane is zoomed
    local zoomed=$(tmux display-message -p '#{window_zoomed_flag}')
    [[ $zoomed -eq 1 ]]
}

verify_kata_11() {
    # Check if pane is unzoomed
    local zoomed=$(tmux display-message -p '#{window_zoomed_flag}')
    [[ $zoomed -eq 0 ]]
}

verify_kata_12() {
    # Check if layout changed (we'll just verify we have panes)
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -ge 2 ]]
}

verify_kata_13() {
    # Check if pane was resized (hard to verify exact size, we'll trust user)
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -ge 2 ]]
}

verify_kata_14() {
    # Check if we're detached (this will be tricky - we'll just check we're still in tmux)
    # Actually, if they detach, the script stops. So we'll verify they understand by checking session exists
    return 0
}

verify_kata_15() {
    # Check if a new session was created (at least 2 sessions)
    local session_count=$(tmux list-sessions 2>/dev/null | wc -l)
    [[ $session_count -ge 2 ]]
}

verify_kata_16() {
    # Check if we switched sessions (current session is the kata session)
    local current_session=$(tmux display-message -p '#S')
    [[ "$current_session" == "$KATA_SESSION" ]]
}

verify_kata_17() {
    # Check if panes were swapped (we'll verify we still have same number of panes)
    local pane_count=$(tmux list-panes | wc -l)
    [[ $pane_count -ge 2 ]]
}

verify_kata_18() {
    # Check if a pane was broken to a new window (should have more windows)
    local window_count=$(tmux list-windows | wc -l)
    [[ $window_count -ge 2 ]]
}

verify_kata_19() {
    # Check if synchronize-panes is on
    local sync_status=$(tmux show-window-options -v synchronize-panes 2>/dev/null || echo "off")
    [[ "$sync_status" == "on" ]]
}

verify_kata_20() {
    # Check if synchronize-panes is off
    local sync_status=$(tmux show-window-options -v synchronize-panes 2>/dev/null || echo "off")
    [[ "$sync_status" == "off" ]]
}

verify_kata_21() {
    # Check if window was moved (we'll just verify windows exist)
    local window_count=$(tmux list-windows | wc -l)
    [[ $window_count -ge 2 ]]
}

verify_kata_22() {
    # Check if session was renamed (look for "mysession")
    tmux list-sessions 2>/dev/null | grep -q "mysession"
}

# Success message
show_success() {
    echo
    echo -e "${GREEN}✓ Success!${NC} Well done!"
    sleep 1
}

# Failure message
show_failure() {
    local expected=$1
    echo
    echo -e "${RED}✗ Not quite right.${NC}"
    echo -e "Expected: $expected"
    echo -e "Press Enter to try again..."
    read
}

# Run a kata
run_kata() {
    local kata_num=$1
    local title=$2
    local description=$3
    local hint=$4
    local verify_func=$5
    local expected=$6
    
    while true; do
        show_kata "$kata_num" "$title" "$description" "$hint"
        read
        
        if $verify_func; then
            show_success
            return 0
        else
            show_failure "$expected"
        fi
    done
}

# Main kata sequence
run_katas() {
    local start_kata=$(get_current_kata)
    
    # Kata 1: Vertical Split
    if [[ $start_kata -le 1 ]]; then
        run_kata 1 \
            "Create a Vertical Split" \
            "Split your current pane vertically to create two side-by-side panes." \
            "Default prefix is Ctrl+b, then press %" \
            "verify_kata_1" \
            "2 panes visible"
        update_progress 2
    fi
    
    # Kata 2: Horizontal Split
    if [[ $start_kata -le 2 ]]; then
        run_kata 2 \
            "Create a Horizontal Split" \
            "Split one of your panes horizontally to create three panes total." \
            "Prefix + \"" \
            "verify_kata_2" \
            "3 panes visible"
        update_progress 3
    fi
    
    # Kata 3: Navigate Between Panes
    if [[ $start_kata -le 3 ]]; then
        run_kata 3 \
            "Navigate Between Panes" \
            "Move to a different pane and then return to demonstrate navigation." \
            "Prefix + arrow keys OR Prefix + o to cycle through panes" \
            "verify_kata_3" \
            "Same number of panes"
        update_progress 4
    fi
    
    # Kata 4: Close a Pane
    if [[ $start_kata -le 4 ]]; then
        run_kata 4 \
            "Close a Pane" \
            "Close one of your panes (leaving 2 panes)." \
            "Type 'exit' in a pane OR Prefix + x and confirm" \
            "verify_kata_4" \
            "2 panes remaining"
        update_progress 5
    fi
    
    # Kata 5: Create a New Window
    if [[ $start_kata -le 5 ]]; then
        run_kata 5 \
            "Create a New Window" \
            "Create a new window (like a new tab)." \
            "Prefix + c" \
            "verify_kata_5" \
            "2 windows in the status bar"
        update_progress 6
    fi
    
    # Kata 6: Rename a Window
    if [[ $start_kata -le 6 ]]; then
        run_kata 6 \
            "Rename Current Window" \
            "Rename your current window to 'mywindow'." \
            "Prefix + , then type the new name and press Enter" \
            "verify_kata_6" \
            "Window named 'mywindow'"
        update_progress 7
    fi
    
    # Kata 7: Switch Between Windows
    if [[ $start_kata -le 7 ]]; then
        run_kata 7 \
            "Switch to Previous Window" \
            "Switch back to window 0 (the first window)." \
            "Prefix + 0 OR Prefix + p (previous) OR Prefix + n (next)" \
            "verify_kata_7" \
            "Currently on window 0"
        update_progress 8
    fi
    
    # Kata 8: Close a Window
    if [[ $start_kata -le 8 ]]; then
        run_kata 8 \
            "Close a Window" \
            "Close the window named 'mywindow' (you may need to switch to it first)." \
            "Switch to the window (Prefix + 1) then Prefix + & and confirm" \
            "verify_kata_8" \
            "1 window remaining"
        update_progress 9
    fi
    
    # Kata 9: Copy Mode
    if [[ $start_kata -le 9 ]]; then
        run_kata 9 \
            "Enter Copy Mode" \
            "Enter copy mode to scroll and copy text." \
            "Prefix + [ (exit with q or Enter)" \
            "verify_kata_9" \
            "Entered copy mode"
        update_progress 10
    fi
    
    # Kata 10: Zoom a Pane
    if [[ $start_kata -le 10 ]]; then
        # First create a split for this kata
        if [[ $(tmux list-panes | wc -l) -eq 1 ]]; then
            tmux split-window -h
        fi
        
        run_kata 10 \
            "Zoom a Pane" \
            "Zoom the current pane to full window size." \
            "Prefix + z" \
            "verify_kata_10" \
            "Pane is zoomed"
        update_progress 11
    fi
    
    # Kata 11: Unzoom
    if [[ $start_kata -le 11 ]]; then
        run_kata 11 \
            "Unzoom the Pane" \
            "Unzoom the pane back to normal." \
            "Prefix + z again" \
            "verify_kata_11" \
            "Pane is unzoomed"
        update_progress 12
    fi
    
    # Kata 12: Change Layout
    if [[ $start_kata -le 12 ]]; then
        # Ensure we have multiple panes
        if [[ $(tmux list-panes | wc -l) -lt 2 ]]; then
            tmux split-window -h
            tmux split-window -v
        fi
        
        run_kata 12 \
            "Cycle Through Layouts" \
            "Cycle through different pane layouts." \
            "Prefix + Space (press multiple times to see different layouts)" \
            "verify_kata_12" \
            "Layout changed"
        update_progress 13
    fi
    
    # === ADVANCED KATAS ===
    
    show_header
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}        ${BOLD}${YELLOW}ADVANCED KATAS - Power User Features${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}You've mastered the basics! Now let's learn advanced features${NC}"
    echo -e "${BLUE}that will make you a tmux power user.${NC}"
    echo
    echo "Press Enter to continue..."
    read
    
    # Kata 13: Resize Panes
    if [[ $start_kata -le 13 ]]; then
        # Ensure we have multiple panes
        if [[ $(tmux list-panes | wc -l) -lt 2 ]]; then
            tmux split-window -h
        fi
        
        run_kata 13 \
            "Resize a Pane" \
            "Resize the current pane to make it larger or smaller." \
            "Prefix + Ctrl+Arrow keys (hold Ctrl and press arrow multiple times)" \
            "verify_kata_13" \
            "Pane resized"
        update_progress 14
    fi
    
    # Kata 14: Detach from Session
    if [[ $start_kata -le 14 ]]; then
        show_kata 14 \
            "Detach from Session" \
            "Detach from the current session (it keeps running in background)." \
            "Prefix + d (then reattach with: tmux attach)"
        
        echo
        echo -e "${YELLOW}Note: After detaching, reattach immediately with:${NC}"
        echo -e "  ${CYAN}tmux attach -t $KATA_SESSION${NC}"
        echo
        echo -e "${YELLOW}Press Enter when ready to try...${NC}"
        read
        
        # For this kata, we'll just mark it complete since detaching stops the script
        show_success
        update_progress 15
    fi
    
    # Kata 15: Create Named Session
    if [[ $start_kata -le 15 ]]; then
        show_kata 15 \
            "Create a Named Session" \
            "Open a NEW terminal and create a session named 'practice'." \
            "In a new terminal: tmux new -s practice (then exit that terminal)"
        
        echo
        echo -e "${YELLOW}Instructions:${NC}"
        echo "  1. Open a NEW terminal window/tab"
        echo "  2. Run: tmux new -s practice"
        echo "  3. Detach from it (Prefix + d) or close that terminal"
        echo "  4. Return here and press Enter"
        echo
        read
        
        if verify_kata_15; then
            show_success
            update_progress 16
        else
            show_failure "At least 2 sessions (check with: tmux ls)"
            update_progress 15
            return
        fi
    fi
    
    # Kata 16: Switch Between Sessions
    if [[ $start_kata -le 16 ]]; then
        # Ensure we have another session
        if [[ $(tmux list-sessions 2>/dev/null | wc -l) -lt 2 ]]; then
            tmux new-session -d -s practice
        fi
        
        run_kata 16 \
            "Switch Between Sessions" \
            "Switch to another session and then switch back to '$KATA_SESSION'." \
            "Prefix + s (select session) OR Prefix + ( and ) to cycle" \
            "verify_kata_16" \
            "Back on $KATA_SESSION session"
        update_progress 17
    fi
    
    # Kata 17: Swap Panes
    if [[ $start_kata -le 17 ]]; then
        # Ensure we have multiple panes
        if [[ $(tmux list-panes | wc -l) -lt 2 ]]; then
            tmux split-window -h
        fi
        
        run_kata 17 \
            "Swap Pane Positions" \
            "Swap the current pane with another pane." \
            "Prefix + { (swap with previous) OR Prefix + } (swap with next)" \
            "verify_kata_17" \
            "Panes swapped"
        update_progress 18
    fi
    
    # Kata 18: Break Pane to Window
    if [[ $start_kata -le 18 ]]; then
        # Ensure we have multiple panes
        if [[ $(tmux list-panes | wc -l) -lt 2 ]]; then
            tmux split-window -h
        fi
        
        run_kata 18 \
            "Break Pane to New Window" \
            "Move the current pane to its own new window." \
            "Prefix + ! (the pane becomes a new window)" \
            "verify_kata_18" \
            "New window created from pane"
        update_progress 19
    fi
    
    # Kata 19: Synchronized Panes (Enable)
    if [[ $start_kata -le 19 ]]; then
        # Ensure we have multiple panes and sync is off
        if [[ $(tmux list-panes | wc -l) -lt 2 ]]; then
            tmux split-window -h
        fi
        tmux set-window-option synchronize-panes off
        
        run_kata 19 \
            "Enable Synchronized Panes" \
            "Enable synchronize-panes to type in all panes at once." \
            "Prefix + : then type 'setw synchronize-panes on' and press Enter" \
            "verify_kata_19" \
            "Synchronized panes enabled"
        update_progress 20
    fi
    
    # Kata 20: Synchronized Panes (Disable)
    if [[ $start_kata -le 20 ]]; then
        run_kata 20 \
            "Disable Synchronized Panes" \
            "Turn off synchronized panes." \
            "Prefix + : then type 'setw synchronize-panes off' and press Enter" \
            "verify_kata_20" \
            "Synchronized panes disabled"
        update_progress 21
    fi
    
    # Kata 21: Move Window
    if [[ $start_kata -le 21 ]]; then
        # Create windows if needed
        local window_count=$(tmux list-windows | wc -l)
        if [[ $window_count -lt 2 ]]; then
            tmux new-window
            tmux new-window
        fi
        
        run_kata 21 \
            "Move Window Position" \
            "Move the current window to a different position in the window list." \
            "Prefix + . (then enter new position number, e.g., 5)" \
            "verify_kata_21" \
            "Window moved"
        update_progress 22
    fi
    
    # Kata 22: Rename Session
    if [[ $start_kata -le 22 ]]; then
        run_kata 22 \
            "Rename Current Session" \
            "Rename your current session to 'mysession'." \
            "Prefix + $ (then type the new name)" \
            "verify_kata_22" \
            "Session renamed to 'mysession'"
        update_progress 23
    fi
    
    # Completion
    show_header
    echo -e "${GREEN}${BOLD}🎉 Congratulations! You've completed ALL tmux katas!${NC}"
    # Completion
    show_header
    echo -e "${GREEN}${BOLD}🎉 Congratulations! You've completed ALL tmux katas!${NC}"
    echo
    echo -e "${CYAN}You've mastered:${NC}"
    echo
    echo -e "${BOLD}Basic Skills (Katas 1-12):${NC}"
    echo "  • Creating vertical and horizontal splits"
    echo "  • Navigating between panes"
    echo "  • Managing panes (closing, zooming)"
    echo "  • Creating and managing windows"
    echo "  • Copy mode for scrolling"
    echo "  • Changing layouts"
    echo
    echo -e "${BOLD}Advanced Skills (Katas 13-22):${NC}"
    echo "  • Resizing panes dynamically"
    echo "  • Session management (detach, create, switch, rename)"
    echo "  • Swapping and reorganizing panes"
    echo "  • Breaking panes to windows"
    echo "  • Synchronized panes for multi-pane commands"
    echo "  • Moving windows"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  • Customize your ~/.tmux.conf (see sample.tmux.conf)"
    echo "  • Learn about joining panes (Prefix + :join-pane)"
    echo "  • Explore plugins with TPM (Tmux Plugin Manager)"
    echo "  • Master command mode (Prefix + :) for advanced operations"
    echo "  • Learn scripting with tmux commands"
    echo "  • Practice until these commands become muscle memory!"
    echo
    echo -e "${BLUE}Run this script again anytime to practice!${NC}"
    echo
}

# Show menu
show_menu() {
    show_header
    local current=$(get_current_kata)
    echo -e "${CYAN}Your Progress:${NC} Kata $current of 22"
    echo
    echo "1) Start/Continue Training"
    echo "2) Reset Progress"
    echo "3) Quit"
    echo
    echo -n "Choose an option: "
}

# Main program
main() {
    # Check if running inside tmux
    if [[ -z "$TMUX" ]]; then
        echo -e "${RED}Error: This script must be run inside a tmux session.${NC}"
        echo
        echo "Start tmux first with: tmux"
        echo "Then run this script again."
        exit 1
    fi
    
    initialize_progress
    
    while true; do
        show_menu
        read choice
        
        case $choice in
            1)
                run_katas
                reset_progress
                echo
                echo "Press Enter to return to menu..."
                read
                ;;
            2)
                reset_progress
                echo -e "${GREEN}Progress reset!${NC}"
                sleep 1
                ;;
            3)
                echo "Happy tmuxing!"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Run the program
main
