# Ash

A forum with subcommunities, reddit-like.

Built using Phoenix LiveView.

## What's implemented:

Voting in comments/posts

Registering and logging in for User Accounts through `mix phx.gen auth`

User post history/timeline.

Infinite scrolling in any timelines (frontpage, communities and user page).

Karma calculation for posts and comments through the vote component.

## What is missing:

An actual interface for subscribing to communities

A frontpage that is composed of the communities you've subscribed to.

A custom ordering logic based on karma and post age for the frontpage and /c/all communities.

Making comments to a post and replying to comments (this shouldn't be hard, we only need to add the HTML for it).

Add User "total" karma to their user page.

Caching for posts/comments karma.

MORE TEST COVERAGE!!!