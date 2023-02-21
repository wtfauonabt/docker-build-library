#!/bin/bash

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
