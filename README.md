# Dotfiles Management

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

### 3. Define the Alias

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 4. Add the Alias to Your Shell Configuration

For Bash:

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
```

For Zsh:

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.zshrc
```

### 5. Checkout Your Dotfiles

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

Once set up, you can manage your dotfiles using the `dotfiles` command just like you would use `git`:

```bash
# Add a file
dotfiles add .vimrc

# Commit changes
dotfiles commit -m "Update vim configuration"

# Push to remote repository
dotfiles push

# Pull updates
dotfiles pull
```

## Benefits

- No symlink management needed
- Files stay in their proper locations
- Simple configuration and management
- Easy to set up on new machines
