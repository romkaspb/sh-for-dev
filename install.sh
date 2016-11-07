#!/bin/bash

echo "First, update repos and install git"
sudo apt-get update
sudo apt-get install git

echo "Enter your git username:"
read GIT_NAME
echo "Enter your git email:"
read GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
