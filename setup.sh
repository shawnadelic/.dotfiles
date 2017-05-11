safe_mv() {
    mv 1>/dev/null 2>&1 $1 $backup_dir/$1
}

echo "Setting up custom dotfiles..."

dotfile_dir=$PWD
backup_dir="$dotfile_dir/.backups/$(date +"%Y-%m-%d")$RANDOM"

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

# Only add to bashrc once
if ! grep -q $dotfile_dir/bash/.bashrc ~/.bashrc; then
    echo ". $dotfile_dir/bash/.bashrc" >> ~/.bashrc
fi

# Install Vundle
if ! cd .vim/bundle/Vundle.vim/; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall
cd ~/.vim/bundle/YouCompleteMe/
./install.sh
