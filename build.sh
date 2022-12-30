#!/bin/sh

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
## Print Messages ##############################################################
################################################################################
function __dockerBuildHelp() {
    echo
    echo "Docker build"
    echo 
    echo "Syntax: ./build.sh [-h|u|n] [PATH TO DOCKERFILE] [IMAGE_NAME] [IMAGE_TAG]"
    echo
    echo "Options:"
    echo "-d | --debug  Debug Mode                                  DEFAULT: $DEBUG_MODE"
    echo "-p | --push   Push to dockerhub                           DEFAULT: $PUSH_TO_DOCKERHUB"
    echo "-u | --user   Docker Username, sets the user account.     DEFAULT: $DOCKER_USER"
    echo 
    echo "Example:"
    echo "./build.sh -u=testing_username ./test test latest "
    echo
}

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
    echo
    echo "ERROR: $@"
    echo

    __printMessage "Docker build script exit with ERROR"
}

################################################################################
## Conditional Validations #####################################################
################################################################################
function __validateArgv() {
    local ERROR_CODE=0
    if [ "$#" -ne 3 ]; then
        __handleError 125 "Invalid number of arguments"
    fi
}

################################################################################
## Handle Errors ###############################################################
################################################################################
##
##  $1; Error Code
##  $2: Error Message
##
function __handleError () {
    local ERROR_CODE=$1
    if [ "$ERROR_CODE" -gt "0" ]; 
    then
        __printErrorMessage $2
        exit $ERROR_CODE
    fi
}

################################################################################
## Variable Modifiers ##########################################################
################################################################################
function __setArgv() {
    __validateArgv $@

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

function __dockerBuild() {
    if [ "$DEBUG_MODE" = true ]; then
        __printDebugMessage "docker build -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG ."
    fi
    docker build -t $DOCKER_USER/$IMAGE_NAME:$IMAGE_TAG .
    __handleError $? "Build Error!!!"
}

################################################################################
## Runner ######################################################################
################################################################################
function __main() {
    __printMessage "Initiating Docker build script..."

    ## Setup options and argv
    __dockerBuildOptionsHandler $@
    ## Remove options
    shift $((OPTIND-1))
    __setArgv $@

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

__main $@
