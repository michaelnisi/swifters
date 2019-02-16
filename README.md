# Swifters

The Swifters iOS app lets you browse [Swift](https://swift.org/) users on [GitHub](https://github.com). Its purpose is to explore [GraphQL](https://graphql.org) with [Apollo iOS](https://www.apollographql.com/docs/ios/), a strongly-typed, caching GraphQL client. Swifters queries GitHub’s [GraphQL API v4](https://developer.github.com/v4/). If your new to GraphQL, you might want to read my [introduction](https://troubled.pro/2019/02/graphql.html).

The Swifters iOS app lets you browse [Swift](https://swift.org/) users on [GitHub](https://github.com). Its purpose is to explore [GraphQL](https://graphql.org) with [Apollo iOS](https://www.apollographql.com/docs/ios/), a strongly-typed, caching GraphQL client. Swifters queries GitHub’s [GraphQL API v4](https://developer.github.com/v4/).

![Screenshot 1](./docs/1.jpg) ![Screenshot 2](./docs/2.jpg)

Swifters progressively populates its [cache](https://www.apollographql.com/docs/ios/watching-queries.html), while users scroll a list of Swift developers on GitHub, loading two to three handfuls of Swifters at a time. Tapping a developer in the list shows details.

## Objectives

- Explore GraphQL building a modern application with Apollo and [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
- Compare the imperative and procedural REST approach to the declarative GraphQL
- Paginate with [UICollectionViewDataSourcePrefetching](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching)

## Dependencies

- 🕸 [Apollo](https://github.com/apollographql/apollo-ios), Caching GraphQL client for iOS
- 🖼 [Nuke](https://github.com/kean/Nuke), Image loading and caching
- 🔗 [Ola](https://github.com/michaelnisi/ola), Check reachability of host
- 🦀 [DeepDiff](https://github.com/onmyway133/DeepDiff) Amazingly incredible extraordinary lightning fast diffing

## Installation

Setting up for development, dependency repos are getting cloned to `../`. Consider wrapping the project in its own directory if these would collide with existing directories of yours.

```
$ ./tools/setup
```

Add `Swifters.xcodeproj` and the dependency `.xcodeproj` files, Apollo, Nuke, and Ola, to an Xcode Workspace.

Apollo iOS uses the Apollo command-line tool. Declared in `package.json`, we can install this dependency with npm.

```
$ npm i
```

Let’s check if the Apollo CLI is accessible with [npx](https://blog.npmjs.org/post/162869356040/introducing-npx-an-npm-package-runner), the npm package runner for executing CLI tools locally. Without npx we would have to install the apollo package globally.

```
$ npx apollo -v
›   Warning: apollo update available from 1.9.2 to 2.4.3
apollo/1.9.2 darwin-x64 node-v8.12.0
```

All right! That warning is fine.

### Accessing GitHub GraphQL API v4

A personal access token is required to communicate with [GitHub’s GraphQL server](https://developer.github.com/v4/guides/forming-calls/#authenticating-with-graphql).

Swifters needs following scopes:

```
read:user
user:email
```

To configure the app with your token, do:

```
GITHUB_TOKEN=<token> ./tools/configure
```

## Building the App

Xcode needs access to the Node toolchain. If you’re having issues with Xcode not finding Node, try:

```
ln -s $(which node) /usr/local/bin/node
```

You might have to do the same for npm and npx.

## License

[MIT License](https://github.com/michaelnisi/swifters/blob/master/LICENSE)
