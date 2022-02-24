#!/bin/bash

COMMAND=$1

BLUE=`tput setaf 4`
CYAN=`tput setaf 6`
NC=`tput sgr0`

if [[ $# -eq 0 ]] ; then
    # Display Help
    echo
    echo "${BLUE}[FZN]${NC} Shortcut library to automate small repetitive tasks."
    echo
    echo "Syntax: ${BLUE}fzn ${CYAN}<command> <options>${NC}"
    echo
    echo "where <command> is one of:"
    echo "  ${CYAN}create${NC}      Creates a new branch, requires a branch name and optionaly a source branch."
    echo "  ${CYAN}refresh${NC}     Merges the latest version of develop branch into the current one."
    echo "  ${CYAN}bounce${NC}      Updates the main branch (develop by default) and checkouts the provided branch."
    echo "  ${CYAN}pull${NC}        Stash any changes, fetch > pulls and restore stashed changes."
    echo
    exit 1
fi

case "$COMMAND" in
    "refresh") 
        SOURCE=${2:-develop}
        BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

        echo "${BLUE}[FZN]${NC} Updating ${CYAN}${SOURCE}${NC} and merging it into current branch: ${BLUE}${BRANCH}${NC}."

        git stash
        git fetch
        git checkout $SOURCE
        git pull
        git checkout $BRANCH
        git pull
        git merge $SOURCE
        git stash pop
    ;;
    "create")
        BRANCH=$2
        SOURCE=${3:-develop}

        if [[ $# -eq 0 ]]
        then
            echo "${BLUE}[FZN]${NC} Please provide a branch name"
            exit 1
        else
            echo "${BLUE}[FZN]${NC} Updating ${CYAN}${SOURCE}${NC} to create a new branch ${BLUE}${BRANCH}${NC} from it."
        fi

        git fetch
        git checkout $SOURCE
        git pull
        git checkout -b $BRANCH
    ;;
    "pull")
        echo "${BLUE}[FZN]${NC} Stash > Fetch > Pull > Stash pop."

        git stash
        git fetch
        git pull
        git stash pop
    ;;
    "bounce")
        BRANCH=$2
        SOURCE=${3:-develop}

        if [[ $# -eq 0 ]]
        then
            echo "${BLUE}[FZN]${NC} Please provide a branch name to checkout."
            exit 1
        else
            echo "${BLUE}[FZN]${NC} Bouncing to branch ${CYAN}${BRANCH}${NC}."
        fi

        git fetch
        git checkout $SOURCE
        git pull
        git checkout $BRANCH
        git pull
        git stash pop
    ;;
    *) echo "${BLUE}[FZN]${NC} Command ${CYAN}$COMMAND${NC} not found"
esac
