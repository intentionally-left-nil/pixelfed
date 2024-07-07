# Pixelfed docker images

This repository contains builds of [pixelfed](https://github.com/pixelfed/pixelfed) using the provided [Dockerfiles](https://github.com/pixelfed/pixelfed/tree/dev/contrib/docker) from that repository

The following variants are available:

- ghcr.io/intentionally-left-nil/pixelfed-fpm

For each docker image, the following tags are available:

| Tag Name | Auto-updates | Description                                     |
| -------- | ------------ | ----------------------------------------------- |
| alpha    | yes          | Build of the pixelfed dev branch, updated daily |
| 0.11.8   | no           | 0.11.8 release                                  |
| 0.11.9   | no           | 0.11.9 release                                  |
| 0.11.11  | no           | 0.11.11 release                                 |
| 0.11.12  | no           | 0.11.12 release                                 |
| 0.12.1   | no           | 0.12.1 release                                  |
| 0.12.3   | no           | 0.12.3 release                                  |
| latest   | yes          | Latest tagged release (e.g. 0.12.1)             |

# Custom modifications

These builds of pixelfed contain changes to suit the author's personal needs. You can find them in the [patches](./patches/) directory. Currently the patches are:

## Fix composer dependencies
patch: [0001-fix-composer-dependencies.patch](./patches/0001-fix-composer-dependencies.patch)
Upstream PR here: https://github.com/pixelfed/pixelfed/pull/5211

This fixes how composer.install runs

## Remove composer.lock
patch: [0002-remove-composer-lock.patch](./patches/0002-remove-composer-lock.patch)
Building the 0.12.3 version breaks because some depednency isn't updated properly. This fixes the issue
by ignoring the composer.lock file and just using composer.json (which uses the most updated version allowed by composer.json instead of the .lock)

## Handle fully-qualified domain names

patch: [0020-Correctly-handle-fully-qualified-domains.patch](./patches/0020-Correctly-handle-fully-qualified-domains.patch)

Hopefully this gets [upstreamed](https://github.com/pixelfed/pixelfed/pull/4617) soon. When referencing a username, if you use the full @username.domain.com, then clicking the generate links lead to a 404. This patch fixes pixelfed to properly return the username

# I don't want these patches/ I want to do it myself

It's really easy to manage the images yourself

1. [Fork](https://github.com/intentionally-left-nil/pixelfed/fork) the repository
1. In your own repo, add/change/remove any of the patches you want
1. Change the [pixelfed_ref.txt](./pixelfed_ref.txt) file correspond to the appropriate pixelfed commit you want. This could be a github branch (e.g. `dev`, or a tag `v0.11.8`, or a SHA `70e8203`)
1. Push your changes to github, and it will automatically build images tagged under :alpha

# Creating a new tagged release

Run `./publish_release.sh v0.11.8`
