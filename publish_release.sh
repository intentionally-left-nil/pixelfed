#! /bin/bash

set -u

if [ "$#" -lt 1 ]; then
    echo "Missing version number e.g. 0.11.8"
fi

version="$1"

if ! [ "${version:0:1}" = "v" ]; then
  version="v${version}"
fi

if [ "$#" -ge 2 ]; then
  full_name="${version}-$2"
else
  full_name="$version"
fi

echo "Cleaning up old branches and tags"
git branch -D "$full_name" || true
git tag -d "$full_name" || true
git push origin ":refs/tags/$full_name" || exit 1

echo "Checking out new branch and tagging"
git checkout -b "$full_name" || exit 1
echo "$version" > pixelfed_ref.txt || exit 1
git add pixelfed_ref.txt || exit 1
git commit -m "$full_name" || exit 1
git tag "$full_name" || exit 1
git push origin "refs/tags/$full_name" || exit 1
git checkout main || exit 1
