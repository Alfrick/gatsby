#!/bin/bash
SRC_PATH=$1
CUSTOM_COMMAND="${2:-yarn test}"
GATSBY_PATH="${CIRCLE_WORKING_DIRECTORY:-../../}"

# cypress docker does not support sudo and does not need it, but the default node executor does
command -v gatsby-dev || command -v sudo && sudo npm install -g gatsby-dev-cli || npm install -g gatsby-dev-cli &&

echo "ls -al ./packages/gatsby-admin/node_modules/.bin"
ls -al ./packages/gatsby-admin/node_modules/.bin 

echo "ls -al ./packages/gatsby/node_modules/.bin"
ls -al ./packages/gatsby/node_modules/.bin 

echo "ls -al ./node_modules/.bin"
ls -al ./node_modules/.bin 

# setting up child integration test link to gatsby packages
cd "$SRC_PATH" &&
gatsby-dev --set-path-to-repo "$GATSBY_PATH" &&
gatsby-dev --scan-once && # copies _all_ files in gatsby/packages
([[ -f ./node_modules/.bin/gatsby ]] && chmod +x ./node_modules/.bin/gatsby || return 0) && # this is sometimes necessary to ensure executable
sh -c "$CUSTOM_COMMAND" &&
echo "e2e test run succeeded"
