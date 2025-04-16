# Dotfiles Management

<!--toc:start-->

- [Dotfiles Management](#dotfiles-management)
  - [What's Inside](#whats-inside)
  - [Setup on a New Machine](#setup-on-a-new-machine)
    - [1. Back up Existing Dotfiles](#1-back-up-existing-dotfiles)
    - [2. Clone the Repository](#2-clone-the-repository)
    - [3. Add the Git Function Override to Your Shell Configuration](#3-add-the-git-function-override-to-your-shell-configuration)
    - [4. Checkout Your Dotfiles](#4-checkout-your-dotfiles)
    - [6. Configure Git to Hide Untracked Files](#6-configure-git-to-hide-untracked-files)
  - [Usage](#usage)
  - [Benefits](#benefits)
  <!--toc:end-->

This repository contains my personal dotfiles, managed using a bare Git repository approach as described in [this article ](https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles/).

## What's Inside

Configuration files for:

- Neovim
- Zsh
- Tmux
- And more...

## Setup on a New Machine

Follow these steps to set up these dotfiles on a new system:

### 1. Back up Existing Dotfiles

```bash
mkdir -p ~/.dotfiles-backup
cp ~/.zshrc ~/.tmux.conf ~/.config/nvim ~/.dotfiles-backup 2>/dev/null
```

### 2. Clone the Repository

Clone as a bare repository:

```bash
git clone --bare git@github.com:dancoconetu/dotfiles.git $HOME/.dotfiles
```

### 3. Add the Git Function Override to Your Shell Configuration

Instead of using an alias, add this function to your `.zshrc` (or `.bashrc`) file:

```bash
git() {
  if [[ "$PWD" == "$HOME" || "$PWD" == "$HOME/.config"* ]]; then
    command git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
  else
    command git "$@"
  fi
}
```

This function automatically uses your dotfiles repository when you're in your home directory or `.config` subdirectories, and behaves normally elsewhere.

### 4. Checkout Your Dotfiles

```bash
dotfiles checkout
```

If you see an error about overwriting existing files, move conflicting files to a backup:

```bash
mkdir -p ~/.config-backup
dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}
dotfiles checkout
```

### 6. Configure Git to Hide Untracked Files

```bash
dotfiles config --local status.showUntrackedFiles no
```

## Usage

Once set up, you can manage your dotfiles using regular `git` commands when you're in your home directory or .config directory:

```bash
# When in $HOME or $HOME/.config/* directories:
# Add a file
git add .zshrc

# Commit changes
git commit -m "Update zshrc configuration"

# Push to remote repository
git push

# Pull updates
git pull
```

When working in other directories, the `git` command works normally with your regular repositories.

## Benefits

- No symlink management needed
- Files stay in their proper locations
- Simple configuration and management
- Easy to set up on new machines
