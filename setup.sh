safe_mv() {
    mv 1>/dev/null 2>&1 $1 $backup_dir/$1
}

echo "Setting up custom dotfiles..."

dotfile_dir=$PWD
backup_dir="$dotfile_dir/.backups"

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
ln -s "$dotfile_dir/flake/flake8" .flake8

# TODO: Do bash stuff better

echo ". $dotfile_dir/bash/aliases" >> ~/.bashrc

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
