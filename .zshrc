export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=robbyrussell

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Directories
alias dots=$HOME/.dotfiles
alias proj=$HOME/Projects
alias psn=$HOME/Projects/Personal
alias keys=$HOME/Projects/Keys

# Shortcuts
alias t=$HOME/.tmux.sh
alias v=nvim
alias c="codium ."
alias aa=codex

# Docker
alias dcup="docker-compose up --detach --build"
alias dcdown="docker-compose down"
dclean() {
    docker stop $(docker ps -aq)
    docker rm --force $(docker ps -aq)
    docker volume rm $(docker volume ls -qf dangling=true)
}

# Git
alias gclear="git reset && git clean -fd && git checkout -- ."
alias gamend="git add . && git commit --amend --no-edit"

# Pyenv
export PYENV_ROOT=$HOME/.pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init - zsh)"

# Go
export GOPRIVATE=*
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# Dotnet
export PATH=$HOME/.dotnet/tools:$PATH
alias dnb="dotnet build --interactive -verbosity diag"
alias dnr="dotnet run --interactive -verbosity diag"

# Clang
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
cpprun() { clang++ -std=c++17 $1 -o out && ./out && rm -rf ./out; }

# Java
export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$PATH

export SDKMAN_DIR=$HOME/.sdkman
[[ -s $SDKMAN_DIR/bin/sdkman-init.sh ]] && source $SDKMAN_DIR/bin/sdkman-init.sh

# Cuda
export CUDA_HOME=/opt/cuda
export PATH=/opt/cuda/bin:$PATH

# Packages
case $(uname -s) in
Linux)
    pi() { yay -S --answerdiff None --answerclean None --noconfirm $@; }
    pu() { yay -Syu --noconfirm --answerdiff None --answerclean None; }
    ;;
Darwin)
    export PATH=/opt/homebrew/bin:$PATH

    pi() { brew install $@; }
    pd() { brew uninstall $@ && brew autoremove && brew cleanup; }
    pu() { brew update && brew upgrade --greedy --yes && brew cleanup; }
    ;;
esac
