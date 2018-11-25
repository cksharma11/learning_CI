#! /bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"

if [ -z "$1" ]; then
  echo -e "${RED}Error : Git Clone URL Missing!"
  exit 1
fi

GIT_CLONE_URL=$1;
REPO_NAME=$(echo "$GIT_CLONE_URL" | cut -d"/" -f5 | cut -d"." -f1)
PROJECTS_DIR=".ci_repositories"
CI_INTERVAL=5

if [ ! -d "$PROJECTS_DIR" ]; then
  mkdir $PROJECTS_DIR
fi

cd $PROJECTS_DIR
git clone $GIT_CLONE_URL
cd $REPO_NAME

while true; do
  clear
  mocha --reporter min > ./.mocha_data
  echo -e "${GREEN}-------------------------"
  echo "Mocha is running in every 5 seconds"
  echo -e "${GREEN}Total Passing Tests : "
  cat ./.mocha_data | grep pass
  echo -e "${RED}Total failing Tests : "
  cat ./.mocha_data | grep fail
  echo -e "${GREEN}-------------------------"
  sleep $CI_INTERVAL
  git pull > /dev/null
done
