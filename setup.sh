safe_mv() {
    mv 1>/dev/null 2>&1 $1 $backup_dir/$1
}

echo "Setting up custom dotfiles..."

dotfile_dir=$PWD
backup_dir="$dotfile_dir/.backups/$(date +"%Y-%m-%d")$RANDOM"
user_bashrc_path=~/.bashrc

echo "Creating backup directory in $backup_dir"
mkdir -p $backup_dir

cd ~/

safe_mv .vimrc
ln -s "$dotfile_dir/vim/vimrc" .vimrc

safe_mv .tmux.conf
ln -s "$dotfile_dir/tmux/tmux.conf" .tmux.conf

safe_mv .ackrc
ln -s "$dotfile_dir/ack/ackrc" .ackrc

safe_mv .flake8
ln -s "$dotfile_dir/flake8/flake8.ini" .flake8

try_to_add_to_bashrc() {
  if [ $# -lt 3 ]; then
    echo "Error: Missing argument(s)"
  else
    new_source_path=$1
    new_source_include="source $new_source_path"
    bashrc_path=$2
    comment=$3
    if ! grep -q "$new_source_include" $bashrc_path; then
      echo "Adding $new_source_path to $bashrc_path"

      # Actually add to bashrc
      #echo "$comment" >> $bashrc_path
      #echo $new_source_include >> $bashrc_path
    else
      echo "File $new_source_path already sourced in $bashrc_path"
    fi
  fi
}

dotfile_bashrc_path="$dotfile_dir/bash/.bashrc"
comment=$'\n# From https://github.com/shawnadelic/.dotfiles'
comment="$comment"
echo $comment

try_to_add_to_bashrc $dotfile_bashrc_path $user_bashrc_path $comment

# Install Vundle
if ! cd .vim/bundle/Vundle.vim/; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall
cd ~/.vim/bundle/YouCompleteMe/
./install.sh

# Install Tmux Plugins
mkdir -p ~/.tmux/plugins && cd ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm
./tpm/scripts/install_plugins.sh
tmux source-file ~/.tmux.conf
