trap 'echo -ne "\033]0;$BASH_COMMAND\007"' DEBUG
function show_name(){ 
    if [[ -n "$BASH_COMMAND" ]]; 
    then 
    echo -en "\033]0;`pwd`\007"; 
    else 
    echo -en "\033]0;$BASH_COMMAND\007"; 
    fi 
}
export PROMPT_COMMAND='show_name'
