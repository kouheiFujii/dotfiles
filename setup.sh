#!/bin/sh

DOTFILES=$HOME/dotfiles

# symbolic link list
declare -a FILES_TO_SYMLINK=(
    '.zshrc'
    '.pryrc'
    '.bundle/config'
)

create_symlinks() {
  local file="$1"
  local symlinc_path="$HOME/$file"
  local dotfile_path="$DOTFILES/$file"

  if [[ -e "$symlinc_path" ]]; then
    if [[ -h "$symlinc_path" ]]; then
      rm "$symlinc_path"
      echo "Removed existing symlink at $symlinc_path"
    else
      mv "$symlinc_path" "$symlinc_path.backup"
      echo "Moved $symlinc_path to $symlinc_path.backup"
    fi
  fi

  ln -s "$dotfile_path" "$symlinc_path"
  echo "Created symlink $symlinc_path -> $dotfile_path"
}

for file in "${FILES_TO_SYMLINK[@]}"; do
  create_symlinks "$file"
done

echo "Done. Reload your terminal."
