#!/bin/bash
folder=$1
repo=$2
mkdir $folder
cd $folder
git clone --bare $repo .bare
cd .bare 
git worktree add ../main main
cd ../main
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
