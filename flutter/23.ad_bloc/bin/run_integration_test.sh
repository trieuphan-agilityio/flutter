#!/usr/bin/env bash

# remember some failed commands and report on exit
error=false

show_help() {
    printf "\nusage: $0 [--help] [<path to package>]

Tool for running integration tests.
(run from root of repo)

where:
    <path to package>
        run tests for package at path only
        (otherwise runs all tests)
    --help
        print this message
"
    exit 1
}

# run integration tests
runTests () {
    local package_dir=$1
    local repo_dir=$2
    cd $package_dir;
    if [[ -f "pubspec.yaml" ]] && [[ -f "test_driver/app_test.dart" ]]; then
        echo "run integration tests"
        dart test_driver/app_test.dart || error=true
    fi
    cd - > /dev/null
}

case $1 in
    --help)
        show_help
        ;;
    *)
        repo_dir=`pwd`
        # if no parameter passed
        if [[ -z $1 ]]; then
            rm -f lcov.info
            package_dirs=(`find . -maxdepth 2 -type d`)
            for package_dir in "${package_dirs[@]}"; do
                runTests $package_dir $repo_dir
            done
        else
            if [[ -d "$1" ]]; then
                runTests $1 $repo_dir
            else
                printf "\nError: not a directory: $1"
                show_help
            fi
        fi
        ;;
esac

#Fail the build if there was an error
if [[ "$error" = true ]] ;
then
    exit -1
fi
