#!/bin/bash
# based on deploy.sh from https://jasonthai.me/blog/2019/07/22/how-to-deploy-a-github-page-using-circleci-20-custom-jekyll-gems/

# set default values (correspond to main) if not set
# see https://stackoverflow.com/a/28085062/9335596 for syntax
: "${GH_PAGES_USER:="canteen-mgmt"}"
: "${GH_PAGES_REPO:="$GH_PAGES_USER.github.io"}"
: "${GH_PAGES_REPO_URL:="git@github.com:$GH_PAGES_USER/$GH_PAGES_REPO.git"}"
: "${SOURCE_REPO:="AAU-ASE-GroupC-WS2021/canteenMgmtFrontend"}"

# generate commit message (copy commit title, link to original commit (+optional pr) in commit message body)
COMMIT_TITLE="$(git log -1 --pretty=%s)"
COMMIT_HASH="$(git log -1 --pretty=%H)"

if [ -n "$SOURCE_REPO" ]
then
  COMMIT_MESSAGE="built in CircleCI from $SOURCE_REPO@$COMMIT_HASH"
  if [ -n "$CIRCLE_PR_NUMBER" ]
  then
    COMMIT_MESSAGE="$COMMIT_MESSAGE (see $SOURCE_REPO#$CIRCLE_PR_NUMBER)"
  fi
fi

# clone and empty repo
mkdir deploy_repo && cd "$_" && \
  git clone $GH_PAGES_REPO_URL . && \
  find . -maxdepth 1 -mindepth 1 ! -name '.git*' -exec rm -rf {} \; && \
  cp -r ../build/web/* .

git config user.name "${GH_PAGES_NAME:-CircleCI}"
git config user.email "${GH_PAGES_EMAIL:-ci@circleci.com}"

git add -fA
git commit --allow-empty -m "$COMMIT_TITLE" -m "$COMMIT_MESSAGE"
git push -f origin "${GH_PAGES_BRANCH:-main}"
