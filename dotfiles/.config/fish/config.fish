# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Substitute rm by trash (moved to trash as opposed to removed)
if test -x /usr/bin/trash
    alias rm='trash'
end

# Disable mouse acceleration
set m 0 0

# Disable the greet
function fish_greeting
end

# Various ENV variables
export FLATC_BUILD_ENABLED=1
export DOCKER_BUILDKIT=1

# ENV variables used by gdb for rust debugging
export PATH="$HOME/.cargo/bin:$PATH"
if test -x ~/.cargo/bin/rustc
    set -x RUSTC_SYSROOT (rustc --print sysroot)
    set -x RUST_SRC_PATH $RUSTC_SYSROOT/lib/rustlib/src/rust/src/
    set -x RUST_GDB_PYTHON_MODULE_PATH $RUSTC_SYSROOT/lib/rustlib/etc/
end
export PATH="$PATH:$HOME/.local/share/yabridge"
