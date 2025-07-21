# Example function
# myfunc() {
#   local dir="$HOME/{DIR}"

#   if [ "$1" != "" ]
#   then
#     cd "$dir/$1"
#   else
#     cd "$dir"
#   fi
# }

# Lazygit - change directory on exit
# @see https://github.com/jesseduffield/lazygit#changing-directory-on-exit
lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

