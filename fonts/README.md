# Install Nerd Fonts on WIndows

## Step 1: Download and Install a Nerd Font

### In PowerShell (Windows, not WSL)

### Download CascadiaCode Nerd Font
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip" -OutFile "$env:TEMP\CascadiaCode.zip"

### Extract
Expand-Archive -Path "$env:TEMP\CascadiaCode.zip" -DestinationPath "$env:TEMP\CascadiaCode"

### Open the folder
explorer "$env:TEMP\CascadiaCode"
Then:

Select all .ttf files
Right-click → Install for all users

### Step 2: Configure Windows Terminal

Open Windows Terminal
Press Ctrl+, (opens settings)
Go to Profiles → Ubuntu-22.04
Scroll to Appearance
Change Font face to: CaskaydiaCove Nerd Font
Change Font size to: 11 or 12
Click Save
