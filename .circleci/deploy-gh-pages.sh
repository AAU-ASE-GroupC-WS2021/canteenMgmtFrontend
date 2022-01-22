#!/bin/bash
# based on deploy.sh from https://jasonthai.me/blog/2019/07/22/how-to-deploy-a-github-page-using-circleci-20-custom-jekyll-gems/

ORG_NAME=AAU-ASE-GroupC-WS2021
REPO_NAME=$ORG_NAME.github.io

# commit message (copy commit title, link to original commit (+optional pr) in commit message body)
COMMIT_TITLE="$(git log -1 --pretty=%s $CIRCLE_SHA1)"
COMMIT_MESSAGE="built in CircleCI from $ORG_NAME/$REPO_NAME@$CIRCLE_SHA1"
if [ -n "$CIRCLE_PR_NUMBER" ]
then
  COMMIT_MESSAGE="$COMMIT_MESSAGE (see $ORG_NAME/$REPO_NAME#$CIRCLE_PR_NUMBER)"
fi

# clone and empty repo, copy build over
git clone git@github.com:$ORG_NAME/$REPO_NAME.git && \
  cd $REPO_NAME && \
  rm -rf ./* && \
  cp -r ../build/web/* .

git config user.name "${GH_PAGES_NAME:-CircleCI}"
git config user.email "${GH_PAGES_EMAIL:-ci@circleci.com}"

git add -fA
git commit --allow-empty -m "$COMMIT_TITLE" -m "$COMMIT_MESSAGE"
git push -f origin "${BRANCH:-master}"
