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
| latest   | yes          | Latest tagged release (e.g. 0.12.1)             |

# Custom modifications

These builds of pixelfed contain changes to suit the author's personal needs. You can find them in the [patches](./patches/) directory. Currently the patches are:

## Fix www-data permissions

patch: [0001-Change-www-data-to-be-uid-gid-1000.patch](./patches/0001-Change-www-data-to-be-uid-gid-1000.patch)

This changes the user id and group id of the www-data user to be 1000. www-data will still be the owner of all the files from before, it's just that instead of user id 33 (or 34 or something similar), it will be 1000.
This helps for two reasons: First, is that the user id is now always deterministic. So, if you have multiple docker images, you can be consistent on the user id #.

Secondly, the UID of 1000 is picked because that is the default user id of the first user on a computer. This means that outside of docker, if you bind mount any files & try to edit them, your user should have the same ID as www-data inside the container. This will prevent the need to `chown -R www-data:www-data .` in the future.

Note: If you have other docker images, you need to run something similar to make sure you're using UID 1000 for www-data. E.g for alpine linux it would be something similar to:

```Dockerfile
FROM nginx:mainline-alpine
RUN deluser www-data; delgroup www-data; adduser -D -H -u 1000 -s /bin/sh www-data
RUN sed -i -e 's/user\s\+nginx;/user www-data;/' /etc/nginx/nginx.conf
```

## Fix Multiline environment variable handling

patch: [0002-fix-multiline-source.patch](./patches/0002-fix-multiline-source.patch)
The docker container can't handle multiline variables. Fixing this here until it's merged [upstream](https://github.com/pixelfed/pixelfed/pull/5099)

## Fix ENTRYPOINT_SKIP_SCRIPTS

patch: [0003-fix-entrypoint-skip-scripts.patch](./patches/0003-fix-entrypoint-skip-scripts.patch)

The environment variable doesn't actually work. Fixing this until it's merged [upstream](https://github.com/pixelfed/pixelfed/pull/5097)

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
