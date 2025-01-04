# Ash

A forum with subcommunities, reddit-like.

Built using Phoenix LiveView.

## What's implemented:

Voting in comments/posts.

Registering and logging in for User Accounts through `mix phx.gen auth`.

User post history/timeline.

Infinite scrolling in any timelines (frontpage, communities and user page).

Karma calculation for posts and comments through the vote context.

Comments viewable in the post page.

Replies to Comments viewable in the post page.

Making comments to a post and replying to comments.

Live comments through PubSub.

An interface for subscribing to communities.

Making posts in a community (with images)!

A Rust NIF through [rustler](https://github.com/rusterlium/rustler), making every uploaded image black and white.

Images stored in S3 buckets (minio used for local dev).

## What is missing:


A frontpage that is composed of the communities you've subscribed to.

A custom ordering logic based on karma and post age for the frontpage and /c/all communities.

Add User "total" karma to their user page.

Caching for posts/comments karma.

Test coverage.