#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/scripts/build.sh

FUNCTION_LIST=("build" "quit")
OPTION=$(__getParamsByOptions $FUNCTION_LIST);

case "$OPTION" in
    build)
        echo "#############################################"
        echo "## $OPTION"
        echo "#############################################"
        __runBuild
        exit
        ;;
    quit )
        __printMessage "Exiting...."
        exit
        ;;
    ? )  
        __handleError 125 "Invalid Option"
        ;;
esac