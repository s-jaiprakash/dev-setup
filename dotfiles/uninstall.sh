#!/bin/bash
# Uninstall Script for Dotfiles
# This script removes the installed dotfiles and restores backups

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_header "Dotfiles Uninstall Script"
echo ""

print_warning "This will remove the dotfiles configuration and attempt to restore backups."
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    print_info "Uninstall cancelled"
    exit 0
fi

echo ""

# ============================================
# Find Latest Backup
# ============================================

print_header "Step 1: Finding Backups"
echo ""

BACKUP_DIRS=($(ls -dt ~/.dotfiles_backup_* 2>/dev/null))

if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
    print_warning "No backup directories found"
    restore_backups=false
else
    print_success "Found ${#BACKUP_DIRS[@]} backup(s)"
    LATEST_BACKUP="${BACKUP_DIRS[0]}"
    print_info "Latest backup: $LATEST_BACKUP"
    echo ""
    
    read -p "Restore from this backup? (y/n): " restore_choice
    if [[ "$restore_choice" == "y" ]]; then
        restore_backups=true
    else
        restore_backups=false
    fi
fi

echo ""

# ============================================
# Remove Installed Files
# ============================================

print_header "Step 2: Removing Installed Files"
echo ""

remove_file() {
    local file=$1
    if [ -f "$HOME/$file" ]; then
        rm "$HOME/$file"
        print_success "Removed ~/$file"
    else
        print_info "~/$file doesn't exist"
    fi
}

remove_file ".shell_common"
remove_file ".zshrc"
remove_file ".bashrc"

# Ask about .env
if [ -f "$HOME/.env" ]; then
    print_warning "Found ~/.env file"
    read -p "Remove ~/.env (contains your API keys)? (y/n): " remove_env
    if [[ "$remove_env" == "y" ]]; then
        rm "$HOME/.env"
        print_success "Removed ~/.env"
    else
        print_info "Kept ~/.env"
    fi
fi

echo ""

# ============================================
# Restore Backups
# ============================================

if [ "$restore_backups" = true ]; then
    print_header "Step 3: Restoring Backups"
    echo ""
    
    restore_file() {
        local file=$1
        if [ -f "$LATEST_BACKUP/$file" ]; then
            cp "$LATEST_BACKUP/$file" "$HOME/$file"
            print_success "Restored ~/$file"
        else
            print_info "No backup found for ~/$file"
        fi
    }
    
    restore_file ".zshrc"
    restore_file ".bashrc"
    restore_file ".shell_common"
    restore_file ".env"
else
    print_header "Step 3: Backup Restoration Skipped"
    echo ""
    print_info "No backups will be restored"
fi

echo ""

# ============================================
# Summary
# ============================================

print_header "Uninstall Complete"
echo ""

print_success "Dotfiles have been removed"

if [ "$restore_backups" = true ]; then
    print_success "Backups have been restored from: $LATEST_BACKUP"
fi

echo ""
echo -e "${BLUE}📝 Next Steps:${NC}"
echo "  1. Reload your shell:"
echo "     ${YELLOW}exec zsh${NC}"
echo ""
echo "  2. If you want to keep backup files:"
echo "     ${YELLOW}ls -la ~/.dotfiles_backup_*${NC}"
echo ""
echo "  3. To remove all backups:"
echo "     ${YELLOW}rm -rf ~/.dotfiles_backup_*${NC}"
echo ""

read -p "Reload shell now? (y/n): " reload_shell

if [[ "$reload_shell" == "y" ]]; then
    exec zsh
fi
