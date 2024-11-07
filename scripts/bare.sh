#!/bin/bash
folder=$1
repo=$2
branch=${3:main}
mkdir $folder
cd $folder
git clone --bare $repo .bare
cd .bare 
git worktree add ../main $branch
cd ../main
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
