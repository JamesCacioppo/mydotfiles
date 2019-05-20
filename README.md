# mydotfiles

# Install fzf, ripgrep, Vundle, and Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

brew install fzf

brew install ripgrep

# Run vim and execute :PlugInstall then :PluginInstall
