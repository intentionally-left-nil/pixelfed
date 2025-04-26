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
| 0.12.5                   | no           | 0.12.5 release                                                 |
| 0.12.5-fix-post-stats    | no           | 0.12.5 release, with the 0021 fix post stats patch             |
| 0.12.5-fix-s3-federation | no           | 0.12.5 release, with the 0021 stats and 0030-32 fix federation patches |
| latest                   | yes          | Latest tagged release (e.g. 0.12.1)                            |

# Custom modifications

These builds of pixelfed contain changes to suit the author's personal needs. You can find them in the [patches](./patches/) directory. Currently the patches are:

## Handle fully-qualified domain names

patch: [0020-Correctly-handle-fully-qualified-domains.patch](./patches/0020-Correctly-handle-fully-qualified-domains.patch)

Hopefully this gets [upstreamed](https://github.com/pixelfed/pixelfed/pull/4617) soon. When referencing a username, if you use the full @username.domain.com, then clicking the generate links lead to a 404. This patch fixes pixelfed to properly return the username

## Fix server post stats

patch: [0021-Fix-post-stats.patch](./patches/0021-Fix-post-stats.patch)
The stats on the homepage are incorrect, because it includes posts from remote servers. This patch fixes the query to only include local posts.
[Upstream PR](https://github.com/pixelfed/pixelfed/pull/5902)

## Fix S3/Cloud Storage Federation

patches: [0030](./patches/0030-Revert-Update-NewStatusPipeline-improve-fallback.patch), [0031](./patches/0031-Revert-Update-NewStatusPipeline-replaces-5706.patch), and [0032](./patches/0032-Ensure-the-cloud-url-is-used-when-publishing-a-statu.patch)

When using S3 or other cloud storage providers, posts could be federated before media uploads completed, causing broken federation with incorrect media URLs. The first two patches revert an incorrect attempt to fix this issue, while the third patch provides the correct solution by ensuring media uploads complete before federation occurs.

# I don't want these patches/ I want to do it myself

It's really easy to manage the images yourself

1. [Fork](https://github.com/intentionally-left-nil/pixelfed/fork) the repository
1. In your own repo, add/change/remove any of the patches you want
1. Change the [pixelfed_ref.txt](./pixelfed_ref.txt) file correspond to the appropriate pixelfed commit you want. This could be a github branch (e.g. `dev`, or a tag `v0.11.8`, or a SHA `70e8203`)
1. Push your changes to github, and it will automatically build images tagged under :alpha

# Creating a new tagged release

Run `./publish_release.sh v0.11.8`
