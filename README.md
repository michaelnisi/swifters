# Swifters

The Swifters iOS app lets you browse [Swift](https://swift.org/) users on [GitHub](https://github.com). Its purpose is to explore [GraphQL](https://graphql.org) with [Apollo](https://www.apollographql.com). It uses [GitHub’s GraphQL API](https://developer.github.com/v4/).

![Screenshot 1](./docs/1.jpg) ![Screenshot 2](./docs/2.jpg)

Swifters progressively populates an in-memory cache, while users scroll a list of Swift developers on GitHub, loading ten at a time. Tapping a developer in the list shows details.

## Considerations

Creating adaptive UIs collection views and table views can be used to structure apps. This requires rich data sources providing these views with data. Correctly built, with diffing and `performBatchUpdates(_:completion:)`, flexible app structures emerge.

### Related

- [A Tour of UICollectionView](https://developer.apple.com/videos/play/wwdc2018/225/)
- [DeepDiff](https://github.com/onmyway133/DeepDiff)
- [SE-0240](https://github.com/apple/swift-evolution/blob/master/proposals/0240-ordered-collection-diffing.md)
- [SectionedDataSource](https://github.com/michaelnisi/podest/blob/master/Podest/collections/SectionedDataSource.swift)

## Objectives

- Explore GraphQL building a modern application with Apollo and [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview). 
- Compare the imperative and procedural REST approach to the declarative GraphQL.
- Try pagination using [UICollectionViewDataSourcePrefetching](https://developer.apple.com/documentation/uikit/uicollectionviewdatasourceprefetching).

## Dependencies

- 🕸 [Apollo](https://github.com/apollographql/apollo-ios), Caching GraphQL client for iOS
- 🖼 [Nuke](https://github.com/kean/Nuke), Image loading and caching
- 🔗 [Ola](https://github.com/michaelnisi/ola), Check reachability of host

#### Apollo

Apollo requires [Node.js](https://nodejs.org) 8.x or newer. And it’s using [npx](https://blog.npmjs.org/post/162869356040/introducing-npx-an-npm-package-runner), which is neat. It lets you execute commands locally, or from a central cache, installing any packages needed.

```
npx apollo schema:download --endpoint=https://api.github.com/graphql --header="Authorization: <token>"
```

💡 *You need an [OAuth token](https://developer.github.com/v4/guides/forming-calls/#authenticating-with-graphql) for accessing this API.*

And with that, I’ve just downloaded the 45K LOC schema file of the GitHub GraphQL API v4. 😮

#### Diffing

Every iOS developer has implemented a diffing algorithm for updating collection views or table views, one way or another. Looking around, I found [DeepDiff](https://github.com/onmyway133/DeepDiff) and extracted the diffing into a single 386 LOC [file](./Swifters/ds/diff.swift).

I’m excited about the recent [Ordered Collection Diffing](https://github.com/apple/swift-evolution/blob/master/proposals/0240-ordered-collection-diffing.md) proposal, describing additions to the Swift standard library that provide an interchange format for diffs as well as diffing/patching functionality for appropriate collection types.

## Evaluating GraphQL/Apollo

Reading the Apollo documentation, my main concern with Apollo’s approach is the tight coupling between view controllers and the remote API, merging access and storage. On the other hand, [repositories](https://www.martinfowler.com/eaaCatalog/repository.html) have the same surface and its purpose is removing the serialization layer, which can be a millstone around the neck of developers, rendering them hesitant to change. Propagating an adjustment from the server onto the screen is often laborious and often requires coordination between different teams.

But the service logic leaks into your view controllers. Is that modern? Maybe. The `schema.json` is a contract. I have to read up on GraphQL API versioning.

Apollo does not only remove serialization, but also builds a local graph. I decided to go all in for this little experiment and query from my collection view data sources, which accompanies nicely my other dogma for this demo: collection views only.

## Conclusion

Three days later, I’m impressed. After passing the intial ramp, aquiring a rudimentary understanding of GraphQL and setting up Apollo, it has been a downhill ride—thrilling and fast. Building an app by modeling queries like clay is incredibly effective. Development can get pretty spontaneous that way. For large apps, of course, this may also become a problem, despite all being statically typed, which is pretty amazing by the way.

A week later, do I still believe in REST? I haven’t experienced implementing a GraphQL server—[graphql-erlang](https://github.com/shopgun/graphql-erlang) looks fantastic—but from the client perspective and what I’ve seen so far, I would recommend GraphQL. All parts fell into place quite naturally. Intuitive decisions were mostly right. My reading matter for the next couple of weeks is set. 📚

### Open Questions

- Offline first? How would we persist the graph cache?
- How does memory management of the graph work?
- Why is `GraphQLFragment` not `Hashable`?

## Installation

Setting up development, dependency repos are getting cloned to `../`. Consider wrapping the project in its own directory if this would collide with existing directories.

```
./tools/setup
```

Add `Swifters.xcodeproj` and the dependency `.xcodeproj` files—Apollo, Nuke, and Ola—to an Xcode Workspace.

[Apollo CLI](https://github.com/apollographql/apollo-tooling) is required, to install it locally, which is sufficient thanks to npx, do:

```
npm i apollo@1.9.x
```

Or just `npm i`, I’ve added a vanilla `package.json`. I should move this into the setup script.

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
