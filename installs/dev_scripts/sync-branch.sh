#!/usr/bin/env bash

function showHelp(){
cat << EOF
usage: sync-branch.sh [-b|--branch <branch/release>][--help]

This script will sync all of the docker compose repos to the same release or branch
This script assumes the remote name of origin

Required:
  [-b|--branch]
    The branch you wish to sync all repos to
    this should be something like release/5.20.0

Optional:
  [-f|--force]
    Skips the yes no prompt

  [-i|--ignore] Can be used multiple times
    ignore list of folder names
    example: sync-release.sh -b release/5.20.0 -i service-ui -i service-pbx
    this example will skip broadworks and PBX repos

  [-n|--noalt]
      if the remote branch name does not exist, this will not
       default and keep the current branch

  [-d|--default <branch> (Default:develop)]
      if the remote branch does not exist we default to the specified branch

  [-provision]
      Provision chef, web and api_web after

Report bugs to:
up home page:
EOF
    exit 0
}

ignoreList=()

# read the options
TEMP=`getopt -o d:fni:b: --long help,default:,force,noalt,ignore:,branch:,provision -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -d|--default)
            case "$2" in
                "") shift 2 ;;
                *) DEFAULT=$2 ; shift 2 ;;
            esac ;;
        -f|--force) FORCE=true ; shift ;;
        --provision) PROVISION=true ; shift ;;
        --help) showHelp ; shift ;;
        -n|--noalt) DEFAULT=false ; shift ;;
        -i|--ignore)
            case "$2" in
                "") shift 2 ;;
                *) ignoreList+=($2) ; shift 2 ;;
            esac ;;
        -b|--branch)
            case "$2" in
                "") shift 2 ;;
                *) branch=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Vars

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

prompt_bold="$(tput bold)"
prompt_reset="$(tput sgr0)"
prompt_green="$prompt_bold$(tput setaf 76)" # BOLD GREEN
prompt_yellow="$prompt_bold$(tput setaf 202)" # BOLD YELLOW
prompt_red="$prompt_bold$(tput setaf 9)" # BOLD RED
prompt_blue="$prompt_bold$(tput setaf 27)" # BOLD RED

## declare an array variable
declare -a folderList=('service-pbx' 'service-ui' 'service-auth' 'broadworks-provisioning-agent' 'service-allocation' 'chef-repo' 'voiceaxis')

# Functions

function postMessage(){
    echo "$prompt_bold sync | $1 $prompt_reset"
}

function postTable(){
    color=$1
    PROC_NAME=$2
    Status=$3
    line='                              '
    printf "$prompt_bold%s %s [$color%s$prompt_reset$prompt_bold]$prompt_reset\n" $PROC_NAME "${line:${#PROC_NAME}}" $Status
}


function get_git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ $ref != "" ]]; then
      echo $ref
  else
      echo "no_branch"
  fi
}

function checkout_release_branch() {
  remoteName='origin'
  targetBranch=$1
  remoteRelease="$remoteName/$targetBranch"
  if git branch -r | grep --quiet $remoteRelease; then
      postMessage "${prompt_green}Checking out $remoteRelease as $targetBranch"
      git checkout $remoteRelease -B $targetBranch
  else
      if [[ $DEFAULT != false ]]; then
          remoteDefault="$remoteName/$DEFAULT"
          postMessage "${prompt_yellow}Remote Release not found."
          postMessage "Checking out $remoteDefault as $DEFAULT"
          git checkout $remoteDefault -B $DEFAULT
      else
          postMessage "${prompt_green}Pulling Latest"
          git pull
      fi
  fi
}

function processFolder(){
    folder=$1
    newFolder=$DIR/../$folder

    if [ ! -d "$newFolder" ]; then
        checkoutRepo $folder
    fi

    normalDir="`cd "${newFolder}";pwd`"
    postMessage "Changing folders to $normalDir"
    cd $normalDir

    currentBranch=$(get_git_branch)

    if [[ $currentBranch == $branch ]]; then
        postMessage "${prompt_green}Pulling $branch"
        git pull
    else
        postMessage "Fetching from Origin"
        git fetch origin
        checkout_release_branch $branch
    fi
    cd $DIR
}

function checkoutRepo(){
    repo=$1
    if [ -z "$GERRIT_USERNAME" ]; then
      postMessage "${prompt_red}Warning! We could not find the Gerrit folder/repo: $repo"
      postMessage "We will now attempt to clone the missing repo"
      postMessage "Please enter your Gerrit username: "
      read user
    else
      user=$GERRIT_USERNAME
    fi
    folder=$DIR/../
    cd $folder
    git clone ssh://$user@gerrit.coredial.com:29418/$repo && scp -p -P 29418 $user@gerrit.coredial.com:hooks/commit-msg $repo/.git/hooks/
    cd $DIR
}

function getFolderState(){
    folder=$1
    newFolder=$DIR/../$folder
    if [[ -d $newFolder ]]; then
        normalDir="`cd "${newFolder}";pwd`"
        cd $normalDir

        currentBranch=$(get_git_branch)
        if [[ $currentBranch ==  $branch ]]; then
            color=$prompt_green
        elif [[ $currentBranch == 'develop' ]]; then
            color=$prompt_yellow
        else
            color=$prompt_red
        fi
        postTable $color $folder $currentBranch

        cd $DIR
    else
        postTable $prompt_red $folder 'MISSING'
    fi
}


function currentState(){
    echo ""
    echo "${prompt_bold}Current State:${prompt_reset}"
    for i in "${folderList[@]}"
    do
        getFolderState $i
    done
}

# Program Start:

if [[ -z "$branch" ]]; then
    echo "--branch required"
    exit 1
fi

if [[ -z $DEFAULT ]]; then
    DEFAULT='develop'
fi

currentState

if [[ "$ignoreList" ]]; then
echo ""
echo "${prompt_bold}Ignore List:${prompt_reset}"
for i in "${ignoreList[@]}"
do
    echo "${i}"
done
fi

echo ""
if [[ -z $FORCE ]]; then
    if [[ $DEFAULT == false ]]; then
        echo "This script will reset all of your current branches $branch. If $branch is not available, we will pull the latest from the checked out branch"
    else
        echo "This script will reset all of your current branches to $DEFAULT or $branch"
    fi
    read -p "Do you wish to run this script?" yn
    case $yn in
        [Yy]* ) ;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
fi

for i in "${folderList[@]}"
do
    if [[ ! "$ignoreList" ]]; then
        echo ""
        processFolder $i
    else
        if [[ ${ignoreList[*]} =~ $i ]]; then
            postMessage "${prompt_blue}Skipping $i"
        else
            echo ""
            processFolder $i
        fi
    fi
done

currentState

if [[ $PROVISION == true ]]; then
    echo "Provisioning Services"
    vag up --provision chef_server web api_web
    echo "fixing api web access for local container access"
    . fix-api-web.sh
fi