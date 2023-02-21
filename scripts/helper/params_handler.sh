#!/bin/bash


################################################################################
## Get Input ###################################################################
################################################################################
function __getParamsByOptions() {
    if [ "$#" -ne 1 ]; then
        FUNCTION_LIST=$@
    fi
    FUNCTION_LIST_LENGTH=${#FUNCTION_LIST[@]}
    if [ ${#FUNCTION_LIST_LENGTH[@]} -eq 0 ];  then
        echo $FUNCTION_LIST_LENGTH
        __handleError 1 "Unable to get FUNCTION_LIST"
    fi
    PS3="Please enter your choice (1-$FUNCTION_LIST_LENGTH): "
    select OPT in "${FUNCTION_LIST[@]}"
    do        
        echo $OPT
        break
    done
}


function __runCommand() {
    # Check if the function exists (bash specific)
    if declare -f "__$1" > /dev/null; then
        # call arguments verbatim
        "__$@"
        exit
    fi
    __handleError 1 "__$1 is not a known function name" >&2
}