# Shell Dotfiles for WSL Ubuntu

Complete shell configuration for AI development with Python, FastAPI, Docker, and PostgreSQL on WSL Ubuntu.

## 📁 Repository Structure

```
dotfiles/
├── README.md              # This file
├── setup.sh              # Automated installation script
├── shell_common          # Shared configuration for bash/zsh
├── zshrc                 # Zsh configuration
├── bashrc                # Bash configuration
├── env.example           # Environment variables template
└── .gitignore           # Git ignore file
```

## 🚀 Quick Start

### One-Command Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Run the setup script
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

### Manual Installation

```bash
# Copy files
cp shell_common ~/.shell_common
cp zshrc ~/.zshrc
cp bashrc ~/.bashrc
cp env.example ~/.env

# Edit .env with your API keys
nano ~/.env

# Reload shell
exec zsh
```

## ✨ Features

### Shared Configuration
- ✅ Works with both **bash** and **zsh**
- ✅ Consistent aliases and functions across shells
- ✅ Environment variables loaded from `~/.env`
- ✅ Automatic backup of existing configurations

### Development Tools
- 🐍 Python development with `uv` package manager
- 🐳 Docker and Docker Compose shortcuts
- 🗄️ PostgreSQL service management
- 🔧 Git aliases and helpers
- 📝 VS Code integration

### Aliases Included

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -alF` | List all files with details |
| `projects` | `cd ~/projects` | Go to projects directory |
| `gs` | `git status` | Git status |
| `ga` | `git add` | Git add |
| `gc` | `git commit -m` | Git commit with message |
| `gp` | `git push` | Git push |
| `py` | `python3` | Python 3 |
| `venv` | `python3 -m venv .venv` | Create virtual environment |
| `activate` | `source .venv/bin/activate` | Activate venv |
| `dps` | `docker ps` | Docker processes |
| `dcup` | `docker compose up -d` | Docker compose up |
| `dcdown` | `docker compose down` | Docker compose down |

### Functions Included

| Function | Description |
|----------|-------------|
| `mkcd dirname` | Create directory and cd into it |
| `start_services` | Start Docker and PostgreSQL |
| `stop_services` | Stop Docker and PostgreSQL |
| `status_services` | Check service status |
| `lsp` | List all projects in ~/projects |
| `p projectname` | Quick navigate to project |
| `extract file` | Extract any archive type |
| `ff filename` | Find files by name |
| `search "text"` | Search text in files |

## 📋 Requirements

- **WSL 2** with Ubuntu 22.04 LTS
- **Zsh** (with Oh My Zsh + Powerlevel10k)
- **Git**
- **Python 3.11+**
- **Docker** (optional)
- **PostgreSQL** (optional)

## 🔧 Configuration

### Environment Variables

Edit `~/.env` to add your API keys:

```bash
GEMINI_API_KEY=your_gemini_key
OPENAI_API_KEY=your_openai_key
ANTHROPIC_API_KEY=your_anthropic_key
LANGCHAIN_API_KEY=your_langchain_key
LANGCHAIN_TRACING_V2=true
```

**Security:** The `.env` file is automatically set to `chmod 600` (only you can read/write).

### Custom Aliases

Add your custom aliases to `~/.shell_common`:

```bash
# Add at the end of ~/.shell_common
alias myalias='my command'
```

### Zsh-Specific Configuration

Add zsh-specific settings to `~/.zshrc` (after the shared config is sourced).

## 📦 Installation Details

The `setup.sh` script will:

1. ✅ Backup existing configuration files with timestamps
2. ✅ Install all configuration files
3. ✅ Create `~/.env` template
4. ✅ Set proper file permissions
5. ✅ Verify installation
6. ✅ Create `~/projects` directory
7. ✅ Optionally install VS Code settings

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull
./setup.sh
```

The setup script will backup your current configs before updating.

## 🔙 Rollback

If something goes wrong, your backups are saved in:
```
~/.dotfiles_backup_YYYYMMDD_HHMMSS/
```

To rollback:
```bash
# Find your backup directory
ls -la ~ | grep dotfiles_backup

# Restore files
cp ~/.dotfiles_backup_*/zshrc ~/.zshrc
cp ~/.dotfiles_backup_*/bashrc ~/.bashrc
cp ~/.dotfiles_backup_*/shell_common ~/.shell_common

# Reload shell
exec zsh
```

## 🧪 Testing

After installation, test with:

```bash
# Test aliases
ll
projects
gs

# Test functions
mkcd test-folder
start_services
status_services

# Test environment variables
echo $OPENAI_API_KEY
```

## 🤝 Contributing

Feel free to fork and customize for your needs!

## 📝 Notes

- Configuration is optimized for AI/ML development
- Uses `uv` for Python package management
- Docker and PostgreSQL auto-start is optional (disabled by default)
- Works seamlessly with VS Code Remote - WSL

## 🆘 Troubleshooting

### Zsh not loading configuration
```bash
exec zsh
source ~/.zshrc
```

### API keys not loading
```bash
# Check .env file exists and has correct permissions
ls -la ~/.env
chmod 600 ~/.env

# Reload shell
exec zsh
```

### Services not starting
```bash
# Manually start services
sudo service docker start
sudo service postgresql start
```

## 📄 License

MIT License - Feel free to use and modify!

## 🔗 Links

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [uv Package Manager](https://github.com/astral-sh/uv)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

---

**Made with ❤️ for AI Development on WSL**
