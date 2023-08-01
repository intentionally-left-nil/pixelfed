#! /bin/bash

set -u

if [ "$#" -ne 1 ]; then
    echo "Missing version number e.g. 0.11.8"
fi

version="$1"

if ! [ "${version:0:1}" = "v" ]; then
  version="v${version}"
fi

git checkout -b "$version" || exit 1
echo "$version" > pixelfed_ref.txt || exit 1
git add pixelfed_ref.txt || exit 1
git commit -m "$version" || exit 1
git tag "$version" || exit 1
git push origin "refs/tags/$version" || exit 1
