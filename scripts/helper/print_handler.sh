#!/bin/bash

################################################################################
## Print Messages ##############################################################
################################################################################

function __printMessage() {
    echo
    echo "==========================================================================="
    echo
    echo $1
    echo
    echo "==========================================================================="
    echo
}

function __printDebugMessage() {
    if [ "$DEBUG_MODE" = true ]; then
        echo
        echo "DEBUG: $@"
        echo
    fi
}

function __printErrorMessage() {
    __dockerBuildHelp
    
    echo
    echo "ERROR: $@"
    echo

    __printMessage "Docker build script exit with ERROR"
}

