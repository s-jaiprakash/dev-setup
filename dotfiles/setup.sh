#!/bin/bash
# Dotfiles Setup Script
# Automatically installs shell configuration files
# Usage: ./setup.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# Helper Functions
# ============================================

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

# ============================================
# Pre-flight Checks
# ============================================

print_header "Dotfiles Setup Script"
echo ""

# Check if running in WSL
if ! grep -q microsoft /proc/version 2>/dev/null; then
    print_warning "This script is designed for WSL. Continuing anyway..."
    read -p "Press Enter to continue or Ctrl+C to cancel..."
fi

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_info "Script directory: $SCRIPT_DIR"
echo ""

# Check if required files exist
print_info "Checking for required files..."
REQUIRED_FILES=("shell_common" "zshrc" "bashrc")
OPTIONAL_FILES=("p10k.zsh" "env.example")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$SCRIPT_DIR/$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    print_error "Missing required files:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    print_info "Tip: Run './fix_structure.sh' to fix file naming issues"
    exit 1
fi

print_success "All required files found"

# Check optional files
for file in "${OPTIONAL_FILES[@]}"; do
    if [ -f "$SCRIPT_DIR/$file" ]; then
        print_info "Found optional file: $file"
    fi
done

echo ""

# ============================================
# Backup Existing Files
# ============================================

print_header "Step 1: Backing Up Existing Files"
echo ""

BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_info "Backup directory: $BACKUP_DIR"
echo ""

backup_file() {
    local file=$1
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        print_success "Backed up ~/$file"
    else
        print_info "~/$file doesn't exist, skipping backup"
    fi
    # Always return success to avoid set -e issues
    return 0
}

backup_file ".zshrc"
backup_file ".bashrc"
backup_file ".shell_common"
backup_file ".p10k.zsh"
backup_file ".env"

echo ""

# ============================================
# Install Configuration Files
# ============================================

print_header "Step 2: Installing Configuration Files"
echo ""

# Install shell_common
print_info "Installing ~/.shell_common..."
cp "$SCRIPT_DIR/shell_common" "$HOME/.shell_common"
chmod 644 "$HOME/.shell_common"
print_success "Installed ~/.shell_common"

# Install .zshrc
print_info "Installing ~/.zshrc..."
cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
chmod 644 "$HOME/.zshrc"
print_success "Installed ~/.zshrc"

# Install .bashrc
print_info "Installing ~/.bashrc..."
cp "$SCRIPT_DIR/bashrc" "$HOME/.bashrc"
chmod 644 "$HOME/.bashrc"
print_success "Installed ~/.bashrc"

# Install p10k configuration
if [ -f "$SCRIPT_DIR/p10k.zsh" ]; then
    print_info "Installing ~/.p10k.zsh..."
    cp "$SCRIPT_DIR/p10k.zsh" "$HOME/.p10k.zsh"
    chmod 644 "$HOME/.p10k.zsh"
    print_success "Installed ~/.p10k.zsh (Professional theme)"
else
    print_warning "p10k.zsh not found - using existing ~/.p10k.zsh if available"
fi

echo ""

# ============================================
# Setup .env File
# ============================================

print_header "Step 3: Setting Up Environment Variables"
echo ""

if [ -f "$HOME/.env" ]; then
    print_warning ".env file already exists"
    read -p "Do you want to keep it? (y/n): " keep_env
    
    if [[ "$keep_env" != "y" ]]; then
        print_info "Creating new .env file..."
        create_new_env=true
    else
        print_success "Keeping existing .env file"
        create_new_env=false
    fi
else
    create_new_env=true
fi

if [ "$create_new_env" = true ]; then
    # Check if there's an env.example file
    if [ -f "$SCRIPT_DIR/env.example" ]; then
        print_info "Using env.example as template..."
        cp "$SCRIPT_DIR/env.example" "$HOME/.env"
    else
        print_info "Creating .env template..."
        cat > "$HOME/.env" << 'ENV_EOF'
# API Keys - Replace with your actual keys
GEMINI_API_KEY=your_gemini_key_here
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
LANGCHAIN_API_KEY=your_langchain_key_here
LANGCHAIN_TRACING_V2=true
ENV_EOF
    fi
    
    chmod 600 "$HOME/.env"
    print_success "Created ~/.env template"
    print_warning "Remember to edit ~/.env with your actual API keys!"
fi

echo ""

# ============================================
# VS Code Settings (Optional)
# ============================================

print_header "Step 4: VS Code Settings (Optional)"
echo ""

# Check for various possible VS Code settings file names
VSCODE_SETTINGS_FILE=""
for filename in "vscode_settings.json" "vscode-settings.json" "settings.json"; do
    if [ -f "$SCRIPT_DIR/$filename" ] && [ -s "$SCRIPT_DIR/$filename" ]; then
        VSCODE_SETTINGS_FILE="$filename"
        break
    fi
done

if [ -n "$VSCODE_SETTINGS_FILE" ]; then
    read -p "Install VS Code settings? (y/n): " install_vscode
    
    if [[ "$install_vscode" == "y" ]]; then
        VSCODE_DIR="$HOME/.vscode-server/data/Machine"
        mkdir -p "$VSCODE_DIR"
        
        if [ -f "$VSCODE_DIR/settings.json" ]; then
            cp "$VSCODE_DIR/settings.json" "$BACKUP_DIR/vscode_settings.json"
            print_success "Backed up VS Code settings"
        fi
        
        cp "$SCRIPT_DIR/$VSCODE_SETTINGS_FILE" "$VSCODE_DIR/settings.json"
        print_success "Installed VS Code settings"
    else
        print_info "Skipping VS Code settings"
    fi
else
    print_info "No VS Code settings file found, skipping"
fi

echo ""

# ============================================
# Create Projects Directory
# ============================================

print_header "Step 5: Setting Up Projects Directory"
echo ""

if [ ! -d "$HOME/projects" ]; then
    mkdir -p "$HOME/projects"
    print_success "Created ~/projects directory"
else
    print_info "~/projects already exists"
fi

echo ""

# ============================================
# Verify Installation
# ============================================

print_header "Step 6: Verifying Installation"
echo ""

verify_file() {
    local file=$1
    local display_name=$2
    
    if [ -f "$HOME/$file" ] && [ -r "$HOME/$file" ]; then
        print_success "$display_name is installed and readable"
        return 0
    else
        print_error "$display_name verification failed"
        return 1
    fi
}

VERIFICATION_PASSED=true

verify_file ".shell_common" "~/.shell_common" || VERIFICATION_PASSED=false
verify_file ".zshrc" "~/.zshrc" || VERIFICATION_PASSED=false
verify_file ".bashrc" "~/.bashrc" || VERIFICATION_PASSED=false
verify_file ".env" "~/.env" || VERIFICATION_PASSED=false

# Optional verification
if [ -f "$HOME/.p10k.zsh" ]; then
    verify_file ".p10k.zsh" "~/.p10k.zsh (optional)" || true
fi

echo ""

# ============================================
# Check for Required Tools
# ============================================

print_header "Step 7: Checking Required Tools"
echo ""

check_command() {
    local cmd=$1
    local display_name=$2
    local required=$3
    
    if command -v "$cmd" &> /dev/null; then
        print_success "$display_name is installed"
        return 0
    else
        if [ "$required" = "true" ]; then
            print_error "$display_name is not installed (required)"
        else
            print_warning "$display_name is not installed (optional)"
        fi
        return 1
    fi
}

# Required tools
check_command "zsh" "Zsh" "true"
check_command "git" "Git" "true"

# Optional but recommended
check_command "python3" "Python 3" "false"
check_command "docker" "Docker" "false"
check_command "uv" "uv package manager" "false"

echo ""

# ============================================
# Post-Installation Tips
# ============================================

print_header "Step 8: Post-Installation Tips"
echo ""

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My Zsh is not installed"
    echo "Install it with:"
    echo "  sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    echo ""
fi

# Check if Powerlevel10k is installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_warning "Powerlevel10k theme is not installed"
    echo "Install it with:"
    echo "  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    echo ""
fi

# Check for zsh plugins
if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        print_warning "zsh-autosuggestions plugin is not installed"
        echo "Install it with:"
        echo "  git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        echo ""
    fi
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        print_warning "zsh-syntax-highlighting plugin is not installed"
        echo "Install it with:"
        echo "  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
        echo ""
    fi
fi

# ============================================
# Final Instructions
# ============================================

print_header "Installation Complete! 🎉"
echo ""

if [ "$VERIFICATION_PASSED" = true ]; then
    print_success "All files installed successfully!"
else
    print_warning "Some files failed verification. Please check the errors above."
fi

echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "  ✅ Configuration files installed"
echo "  ✅ Backups saved to: $BACKUP_DIR"
echo "  ✅ Projects directory: ~/projects"
if [ -f "$HOME/.p10k.zsh" ]; then
    echo "  ✅ Professional Powerlevel10k theme installed"
fi
echo ""

echo -e "${BLUE}📝 Next Steps:${NC}"
echo "  1. Edit ~/.env with your actual API keys:"
echo "     ${YELLOW}nano ~/.env${NC}"
echo ""
echo "  2. Reload your shell:"
echo "     ${YELLOW}exec zsh${NC}"
echo ""
echo "  3. Test the configuration:"
echo "     ${YELLOW}ll${NC}         # List files"
echo "     ${YELLOW}projects${NC}   # Go to projects directory"
echo "     ${YELLOW}gs${NC}         # Git status"
echo ""

echo -e "${BLUE}💡 Useful Commands:${NC}"
echo "  ${YELLOW}start_services${NC}   # Start Docker & PostgreSQL"
echo "  ${YELLOW}lsp${NC}              # List all projects"
echo "  ${YELLOW}mkcd dirname${NC}     # Create and cd into directory"
echo "  ${YELLOW}mkvenv${NC}           # Create Python virtual environment"
echo ""

echo -e "${BLUE}🔄 To Rollback:${NC}"
echo "  ${YELLOW}cp $BACKUP_DIR/.zshrc ~/.zshrc${NC}"
echo "  ${YELLOW}cp $BACKUP_DIR/.bashrc ~/.bashrc${NC}"
echo "  ${YELLOW}cp $BACKUP_DIR/.shell_common ~/.shell_common${NC}"
echo "  ${YELLOW}exec zsh${NC}"
echo ""

print_info "Backups saved in: $BACKUP_DIR"
echo ""

# Ask to reload shell
read -p "Do you want to reload the shell now? (y/n): " reload_shell

if [[ "$reload_shell" == "y" ]]; then
    print_success "Reloading shell..."
    exec zsh
else
    print_info "Remember to reload your shell: exec zsh"
fi
