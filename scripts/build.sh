#!/bin/bash

################################################################################
## Variables ###################################################################
################################################################################
DEBUG_MODE=false
DOCKER_USER="wtfauonabt"
PUSH_TO_DOCKERHUB=false
PATH_TO_DOCKERFILE=""
IMAGE_NAME=""
IMAGE_TAG=""
STAPLED_FOLDER=""

################################################################################
## Help Messages ###############################################################
################################################################################
function __dockerBuildHelp() {
    __printDockerBuildDescription
    echo "Options:"
    echo "-d | --debug  Debug Mode                                  DEFAULT: $DEBUG_MODE"
    echo "-p | --push   Push to dockerhub                           DEFAULT: $PUSH_TO_DOCKERHUB"
    echo "-u | --user   Docker Username, sets the user account.     DEFAULT: $DOCKER_USER"
    echo 
    echo "Example:"
    echo "./build.sh -u=testing_username ./test test latest "
    echo
}

function __printDockerBuildDescription () {
    echo
    echo "Docker build"
    echo 
    echo "Syntax: ./build.sh [-h|d|p|u] [PATH TO DOCKERFILE] [IMAGE_NAME] [IMAGE_TAG]"
    echo
    echo "==========================================================================="
}


################################################################################
## Variable Modifiers ##########################################################
################################################################################
function __readBuildInput() {
    __printDockerBuildDescription
    __printMessage "Please provide information to the following:"
    read -p 'Path to DockerFile [PATH_TO_DOCKERFILE] (e.g. ./test): ' PATH_TO_DOCKERFILE
    read -p 'Docker User [DOCKER_USER] (default: wtfauonabt): ' DOCKER_USER
    read -p 'Image Name [IMAGE_NAME] (e.g. test): ' IMAGE_NAME
    read -p 'Image Tag [IMAGE_TAG] (e.g. latest): ' IMAGE_TAG
    read -p 'Push to Registry [PUSH_TO_DOCKERHUB] (y/n): ' INPUT_PUSH
    if [ "$INPUT_PUSH" = "y" ];then
        PUSH_TO_DOCKERHUB=true
    fi
}

function __validateArgv() {
    local ERROR_CODE=0
    if [ "$#" -ne 3 ]; then
        if ! declare -f __readInput > /dev/null; then
            __readInput
            break
        fi
        echo 125
        return
    fi
}
function __setArgv() {
    local ERROR_CODE=__validateArgv $@
    if $ERROR_CODE;then
      __handleError $ERROR_CODE "Invalid number of arguments"  
    fi
    PATH_TO_DOCKERFILE=$1
    IMAGE_NAME=$2
    IMAGE_TAG=$3
}

## Options handler - exits error code
function __dockerBuildOptionsHandler(){
    local ERROR_CODE=0
    while getopts hdpu:-: OPT; do
        if [ "$OPT" = "-" ]; then   # long option: reformulate OPT and OPTARG
            OPT="${OPTARG%%=*}"       # extract long option name
            OPTARG="${OPTARG#$OPT}"   # extract long option argument (may be empty)
            OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
        fi
        case "$OPT" in
            p | push )
                PUSH_TO_DOCKERHUB=true
                ;;
            u | user )
                DOCKER_USER="$OPTARG" ; 
                ;;
            d | debug )
                echo "Debug Mode is ON!!!!"
                DEBUG_MODE=true
                ;;
            h | help ) # display Help
                __dockerBuildHelp
                ERROR_CODE=1;
                ;;
            ??* )          
                __invalidOption --$OPT
                __dockerBuildHelp
                ERROR_CODE=125
                ;; # bad long option
            ? )  
                __invalidOption --$OPT
                __dockerBuildHelp
                ERROR_CODE=125
                ;;  # bad short option (error reported via getopts)
        esac
    done
    __handleError $ERROR_CODE "Options Error!!!"
}

################################################################################
## Actions #####################################################################
################################################################################
function __dockerUpload() {
    if [ "$DEBUG_MODE" = true ]; then
        __printDebugMessage "docker push $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG"
    fi
    if [ "$PUSH_TO_DOCKERHUB" = true ]; then
        docker push $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG
        __handleError $? "Upload Error!!!"
    fi
}

function __dockerBuildx() {
    if [ "$DEBUG_MODE" = true ]; then
        __printDebugMessage "docker buildx build -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG --platform linux/arm/v7,linux/arm64/v8,linux/amd64 ."
    fi
    docker buildx build \
        -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG \
        --platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
        .
    __handleError $? "Build Error!!!"


}

function __dockerBuild() {
    if [ "$DEBUG_MODE" = true ]; then
        __printDebugMessage "docker build -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG ."
    fi
    docker build \
        -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG \
        .
    __handleError $? "Build Error!!!"
}

################################################################################
## Runner ######################################################################
################################################################################
function __runBuild() {
    __printMessage "Initiating Docker build script..."

    # ## Setup options and argv
    # __dockerBuildOptionsHandler $@
    # ## Remove options
    # shift $((OPTIND-1))
    # __setArgv $@

    __readBuildInput

    ## Move to directory
    cd $PATH_TO_DOCKERFILE
    __printDebugMessage "$(pwd)"

    ## Perform Build
    __dockerBuild
    
    ## Perform Upload to Docker Hub
    __dockerUpload

    ## Move back to original directory
    cd -
    __printDebugMessage "$(pwd)"

    __printMessage "Docker build script completed"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/helper/print_handler.sh
source $SCRIPT_DIR/helper/error_handler.sh
source $SCRIPT_DIR/helper/params_handler.sh

