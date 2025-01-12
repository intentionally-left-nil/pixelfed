# Pixelfed docker images

This repository contains builds of [pixelfed](https://github.com/pixelfed/pixelfed) using the provided [Dockerfiles](https://github.com/pixelfed/pixelfed/tree/dev/contrib/docker) from that repository

The following variants are available:

- ghcr.io/intentionally-left-nil/pixelfed-fpm

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
| latest                   | yes          | Latest tagged release (e.g. 0.12.1)                            |

# Custom modifications

These builds of pixelfed contain changes to suit the author's personal needs. You can find them in the [patches](./patches/) directory. Currently the patches are:s

## Handle fully-qualified domain names

patch: [0020-Correctly-handle-fully-qualified-domains.patch](./patches/0020-Correctly-handle-fully-qualified-domains.patch)

Hopefully this gets [upstreamed](https://github.com/pixelfed/pixelfed/pull/4617) soon. When referencing a username, if you use the full @username.domain.com, then clicking the generate links lead to a 404. This patch fixes pixelfed to properly return the username

## Fix push notification registration

patch: [0021-fix-notifications](./patches/0021-fix-notifications.patch)
The code to determine whether a user has turned on push notifications has either a timing condition, or a race condition. Either way, the logic is overly-complicated, and uses redis to cache the information, instead of just pulling it from postgres. The patch removes the redis cache and just directly reads from the database. [Upstream PR](https://github.com/pixelfed/pixelfed/pull/5456)

## Add push notifications for mentions

patch: [0022-add-mentions-push-notification](./patches/0022-add-mentions-push-notification.patch)

Push notifications currently aren't sent out when users are mentioned, either in a post or a comment (only in a DM). This is fixed in this patch by hooking up the already-existing infrastructure [Upstream PR](https://github.com/pixelfed/pixelfed/pull/5458)

# I don't want these patches/ I want to do it myself

It's really easy to manage the images yourself

1. [Fork](https://github.com/intentionally-left-nil/pixelfed/fork) the repository
1. In your own repo, add/change/remove any of the patches you want
1. Change the [pixelfed_ref.txt](./pixelfed_ref.txt) file correspond to the appropriate pixelfed commit you want. This could be a github branch (e.g. `dev`, or a tag `v0.11.8`, or a SHA `70e8203`)
1. Push your changes to github, and it will automatically build images tagged under :alpha

# Creating a new tagged release

Run `./publish_release.sh v0.11.8`
