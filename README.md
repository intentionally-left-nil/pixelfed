# Pixelfed docker images

This repository contains builds of [pixelfed](https://github.com/pixelfed/pixelfed) using the [Dockerfile](https://github.com/pixelfed/pixelfed/blob/dev/Dockerfile) from that repository

> [!IMPORTANT]
> Pixelfed replaced its old multi-target Dockerfile (the `fpm-runtime` target, `PHP_*` build args, `contrib/docker` entrypoints) with a single image based on [serversideup/php:8.4-fpm-nginx](https://serversideup.net/open-source/docker-php/). The image now contains **both nginx and php-fpm**, serves HTTP on port **8080**, stores the app in **/var/www/html**, and runs as `www-data` (no `gosu`, no root entrypoint). Accordingly, these builds are now published as `ghcr.io/intentionally-left-nil/pixelfed` — the old `ghcr.io/intentionally-left-nil/pixelfed-fpm` image is retired (its last tag is 0.12.9).

The following variants are available:

- ghcr.io/intentionally-left-nil/pixelfed

For each docker image, the following tags are available:

| Tag Name                 | Auto-updates | Description                                                    |
| ------------------------ | ------------ | -------------------------------------------------------------- |
| alpha                    | yes          | Build of the pixelfed dev branch, updated daily                |
| 0.11.8                   | no           | 0.11.8 release                                                 |
| 0.11.9                   | no           | 0.11.9 release                                                 |
| 0.11.11                  | no           | 0.11.11 release                                                |
| 0.11.12                  | no           | 0.11.12 release                                                |
| 0.12.1                   | no           | 0.12.1 release                                                 |
| 0.12.3                   | no           | 0.12.3 release                                                 |
| 0.12.3-oauth             | no           | 0.12.3 release, with the 0010 oauth patch                      |
| 0.12.4                   | no           | 0.12.4 release                                                 |
| 0.12.4-fix-notifications | no           | 0.12.4 release, with the 0021 and 22 push notification patches |
| 0.12.5                   | no           | 0.12.5 release                                                 |
| 0.12.5-fix-post-stats    | no           | 0.12.5 release, with the 0021 fix post stats patch             |
| 0.12.5-fix-s3-federation | no           | 0.12.5 release, with the 0021 stats and 0030-32 fix federation patches |
| 0.12.5-fix-id-url-check  | no           | 0.12.5 release, with 21-40 patches, including removing the domain check for ActivityStream |
| 0.12.6                   | no           | 0.12.6 release                                                 |
| 0.14.1                   | no           | 0.14.1 with the new docker pattern                                                 |
| latest                   | yes          | Latest tagged release (e.g. 0.12.6)                            |

Tags up to and including `0.12.9` were published on the retired `ghcr.io/intentionally-left-nil/pixelfed-fpm` image. Newer releases are published on `ghcr.io/intentionally-left-nil/pixelfed`.

# Custom modifications

These builds of pixelfed contain changes to suit the author's personal needs. You can find them in the [patches](./patches/) directory. Currently the patches are:

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
