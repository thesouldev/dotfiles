#!/bin/bash

set -e

RELEASE_TYPE=$1

valid_types=("patch" "minor" "major")
if [[ ! " ${valid_types[@]} " =~ " ${RELEASE_TYPE} " ]]; then
    echo "Error: Invalid release type. Must be one of: ${valid_types[*]}"
    exit 1
fi

CURRENT_VERSION=$(uv version | awk '{print $2}')

uv version --bump $RELEASE_TYPE
NEW_VERSION=$(uv version | awk '{print $2}')

echo ""
echo "Version bump: v${CURRENT_VERSION} -> v${NEW_VERSION}"
echo ""
read -p "Commit, tag, and push to master? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add pyproject.toml uv.lock
    git commit --no-gpg-sign -m "Bump version from v${CURRENT_VERSION} to v${NEW_VERSION}"
    git tag -d "v${NEW_VERSION}" 2>/dev/null || true
    git push origin ":refs/tags/v${NEW_VERSION}" 2>/dev/null || true
    git tag "v${NEW_VERSION}"
    git push origin master
    git push origin "v${NEW_VERSION}"
    echo ""
    echo "Successfully created and pushed tag v${NEW_VERSION}"
else
    git checkout pyproject.toml uv.lock
    echo "Aborted. No changes were made."
fi