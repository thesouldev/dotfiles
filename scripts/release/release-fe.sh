#!/bin/bash

set -e

RELEASE_TYPE=$1

valid_types=("patch" "minor" "major")
if [[ ! " ${valid_types[@]} " =~ " ${RELEASE_TYPE} " ]]; then
    echo "Error: Invalid release type. Must be one of: ${valid_types[*]}"
    exit 1
fi

# Get current version from package.json
CURRENT_VERSION=$(node -p "require('./package.json').version")

# Update version using npm
npm version $RELEASE_TYPE --no-git-tag-version

# Get new version from package.json
NEW_VERSION=$(node -p "require('./package.json').version")

# Commit changes
git add package.json package-lock.json
git commit --no-gpg-sign -m "Bump version from v${CURRENT_VERSION} to v${NEW_VERSION}"
git tag "v${NEW_VERSION}"

# Ask for confirmation before pushing
echo ""
echo "Ready to push changes to remote repository:"
echo "  - Branch: master"
echo "  - Tag: v${NEW_VERSION}"
echo ""
read -p "Do you want to proceed with the push? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin master
    git push origin "v${NEW_VERSION}"
    echo ""
    echo "Successfully created and pushed tag v${NEW_VERSION}"
else
    echo "Push cancelled. Changes are committed locally but not pushed."
    echo "Tag v${NEW_VERSION} created locally."
    echo "You can push manually later with:"
    echo "  git push origin master"
    echo "  git push origin v${NEW_VERSION}"
fi
