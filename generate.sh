#!/bin/bash

touch ./repos.json ./orgs.json ./ALL_README_URLS.md ./ALL_READMES.md ./BADGES.md

REPOS=`cat ./repos.json`
# REPOS=[ $REPOS ] || REPOS=`curl https://api.github.com/users/brysgo/repos > ./repos.json && cat ./repos.json`

REPO_NAMES=`echo $REPOS | jq -r '.[] | select(.private != true) | .full_name'`

ORGS=`cat ./orgs.json`
# ORGS=[ $ORGS ] || ORGS=`curl https://api.github.com/users/brysgo/orgs > ./orgs.json && cat ./orgs.json`
ORG_REPOS_URL=`echo $ORGS | jq '.[] | .repos_url'`

ORG_REPOS=`cat ./org_repos.json`
# ORG_REPOS=[ $ORG_REPOS ] || `echo $ORG_REPOS_URL | xargs -n 1 curl  > ./org_repos.json && cat ./org_repos.json`

REPO_NAMES="$REPO_NAMES $(echo $ORG_REPOS | jq -r '.[] | select(.private != true) | .full_name')"

README_URLS=`echo $REPO_NAMES | xargs -I {} -n 1 echo "https://raw.githubusercontent.com/{}/master/README.md"`
echo "$README_URLS" > ./ALL_README_URLS.md

ALL_READMES=`cat ./ALL_READMES.md`
# ALL_READMES=[ $ALL_READMES ] || ALL_READMES=`echo $README_URLS | xargs -n 1 curl`
echo "$ALL_READMES" > "./ALL_READMES.md"

BADGES=`cat ./ALL_READMES.md | grep '\!\['`
echo $BADGES > BADGES.md
