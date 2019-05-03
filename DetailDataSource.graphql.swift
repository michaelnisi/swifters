//  This file was automatically generated (by me) and should not be edited.

import Apollo

public final class UserNodeQuery: GraphQLQuery {
  public let operationDefinition =
    "query UserNode($id: ID!) {\n  node(id: $id) {\n    __typename\n    ...UserDetail\n  }\n}"

  public var queryDocument: String { return operationDefinition.appending(UserDetail.fragmentDefinition) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("node", arguments: ["id": GraphQLVariable("id")], type: .object(Node.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(node: Node? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
    }

    /// Fetches an object given its ID.
    public var node: Node? {
      get {
        return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "node")
      }
    }

    public struct Node: GraphQLSelectionSet {
      public static let possibleTypes = ["CodeOfConduct", "License", "MarketplaceCategory", "MarketplaceListing", "App", "Organization", "Project", "ProjectColumn", "ProjectCard", "Issue", "User", "Repository", "BranchProtectionRule", "Ref", "PullRequest", "UserContentEdit", "Label", "Reaction", "IssueComment", "PullRequestCommit", "Commit", "CommitComment", "Deployment", "DeploymentStatus", "Status", "StatusContext", "Tree", "Milestone", "ReviewRequest", "Team", "UserStatus", "OrganizationInvitation", "PullRequestReviewThread", "PullRequestReviewComment", "PullRequestReview", "CommitCommentThread", "ClosedEvent", "ReopenedEvent", "SubscribedEvent", "UnsubscribedEvent", "MergedEvent", "ReferencedEvent", "CrossReferencedEvent", "AssignedEvent", "UnassignedEvent", "LabeledEvent", "UnlabeledEvent", "MilestonedEvent", "DemilestonedEvent", "RenamedTitleEvent", "LockedEvent", "UnlockedEvent", "DeployedEvent", "DeploymentEnvironmentChangedEvent", "HeadRefDeletedEvent", "HeadRefRestoredEvent", "HeadRefForcePushedEvent", "BaseRefForcePushedEvent", "ReviewRequestedEvent", "ReviewRequestRemovedEvent", "ReviewDismissedEvent", "UserBlockedEvent", "PullRequestCommitCommentThread", "BaseRefChangedEvent", "AddedToProjectEvent", "CommentDeletedEvent", "ConvertedNoteToIssueEvent", "MentionedEvent", "MovedColumnsInProjectEvent", "PinnedEvent", "RemovedFromProjectEvent", "TransferredEvent", "UnpinnedEvent", "PushAllowance", "ReviewDismissalAllowance", "DeployKey", "Language", "Release", "ReleaseAsset", "RepositoryTopic", "Topic", "Gist", "GistComment", "PublicKey", "OrganizationIdentityProvider", "ExternalIdentity", "SecurityAdvisory", "Blob", "Bot", "RepositoryInvitation", "Tag"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(UserDetail.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeCodeOfConduct() -> Node {
        return Node(unsafeResultMap: ["__typename": "CodeOfConduct"])
      }

      public static func makeLicense() -> Node {
        return Node(unsafeResultMap: ["__typename": "License"])
      }

      public static func makeMarketplaceCategory() -> Node {
        return Node(unsafeResultMap: ["__typename": "MarketplaceCategory"])
      }

      public static func makeMarketplaceListing() -> Node {
        return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
      }

      public static func makeApp() -> Node {
        return Node(unsafeResultMap: ["__typename": "App"])
      }

      public static func makeOrganization() -> Node {
        return Node(unsafeResultMap: ["__typename": "Organization"])
      }

      public static func makeProject() -> Node {
        return Node(unsafeResultMap: ["__typename": "Project"])
      }

      public static func makeProjectColumn() -> Node {
        return Node(unsafeResultMap: ["__typename": "ProjectColumn"])
      }

      public static func makeProjectCard() -> Node {
        return Node(unsafeResultMap: ["__typename": "ProjectCard"])
      }

      public static func makeIssue() -> Node {
        return Node(unsafeResultMap: ["__typename": "Issue"])
      }

      public static func makeRepository() -> Node {
        return Node(unsafeResultMap: ["__typename": "Repository"])
      }

      public static func makeBranchProtectionRule() -> Node {
        return Node(unsafeResultMap: ["__typename": "BranchProtectionRule"])
      }

      public static func makeRef() -> Node {
        return Node(unsafeResultMap: ["__typename": "Ref"])
      }

      public static func makePullRequest() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequest"])
      }

      public static func makeUserContentEdit() -> Node {
        return Node(unsafeResultMap: ["__typename": "UserContentEdit"])
      }

      public static func makeLabel() -> Node {
        return Node(unsafeResultMap: ["__typename": "Label"])
      }

      public static func makeReaction() -> Node {
        return Node(unsafeResultMap: ["__typename": "Reaction"])
      }

      public static func makeIssueComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "IssueComment"])
      }

      public static func makePullRequestCommit() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestCommit"])
      }

      public static func makeCommit() -> Node {
        return Node(unsafeResultMap: ["__typename": "Commit"])
      }

      public static func makeCommitComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "CommitComment"])
      }

      public static func makeDeployment() -> Node {
        return Node(unsafeResultMap: ["__typename": "Deployment"])
      }

      public static func makeDeploymentStatus() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeploymentStatus"])
      }

      public static func makeStatus() -> Node {
        return Node(unsafeResultMap: ["__typename": "Status"])
      }

      public static func makeStatusContext() -> Node {
        return Node(unsafeResultMap: ["__typename": "StatusContext"])
      }

      public static func makeTree() -> Node {
        return Node(unsafeResultMap: ["__typename": "Tree"])
      }

      public static func makeMilestone() -> Node {
        return Node(unsafeResultMap: ["__typename": "Milestone"])
      }

      public static func makeReviewRequest() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequest"])
      }

      public static func makeTeam() -> Node {
        return Node(unsafeResultMap: ["__typename": "Team"])
      }

      public static func makeUserStatus() -> Node {
        return Node(unsafeResultMap: ["__typename": "UserStatus"])
      }

      public static func makeOrganizationInvitation() -> Node {
        return Node(unsafeResultMap: ["__typename": "OrganizationInvitation"])
      }

      public static func makePullRequestReviewThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReviewThread"])
      }

      public static func makePullRequestReviewComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReviewComment"])
      }

      public static func makePullRequestReview() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestReview"])
      }

      public static func makeCommitCommentThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "CommitCommentThread"])
      }

      public static func makeClosedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ClosedEvent"])
      }

      public static func makeReopenedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReopenedEvent"])
      }

      public static func makeSubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "SubscribedEvent"])
      }

      public static func makeUnsubscribedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnsubscribedEvent"])
      }

      public static func makeMergedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MergedEvent"])
      }

      public static func makeReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReferencedEvent"])
      }

      public static func makeCrossReferencedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CrossReferencedEvent"])
      }

      public static func makeAssignedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AssignedEvent"])
      }

      public static func makeUnassignedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnassignedEvent"])
      }

      public static func makeLabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LabeledEvent"])
      }

      public static func makeUnlabeledEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlabeledEvent"])
      }

      public static func makeMilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MilestonedEvent"])
      }

      public static func makeDemilestonedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DemilestonedEvent"])
      }

      public static func makeRenamedTitleEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RenamedTitleEvent"])
      }

      public static func makeLockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "LockedEvent"])
      }

      public static func makeUnlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnlockedEvent"])
      }

      public static func makeDeployedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeployedEvent"])
      }

      public static func makeDeploymentEnvironmentChangedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeploymentEnvironmentChangedEvent"])
      }

      public static func makeHeadRefDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefDeletedEvent"])
      }

      public static func makeHeadRefRestoredEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefRestoredEvent"])
      }

      public static func makeHeadRefForcePushedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "HeadRefForcePushedEvent"])
      }

      public static func makeBaseRefForcePushedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "BaseRefForcePushedEvent"])
      }

      public static func makeReviewRequestedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequestedEvent"])
      }

      public static func makeReviewRequestRemovedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewRequestRemovedEvent"])
      }

      public static func makeReviewDismissedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewDismissedEvent"])
      }

      public static func makeUserBlockedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UserBlockedEvent"])
      }

      public static func makePullRequestCommitCommentThread() -> Node {
        return Node(unsafeResultMap: ["__typename": "PullRequestCommitCommentThread"])
      }

      public static func makeBaseRefChangedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "BaseRefChangedEvent"])
      }

      public static func makeAddedToProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "AddedToProjectEvent"])
      }

      public static func makeCommentDeletedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "CommentDeletedEvent"])
      }

      public static func makeConvertedNoteToIssueEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "ConvertedNoteToIssueEvent"])
      }

      public static func makeMentionedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MentionedEvent"])
      }

      public static func makeMovedColumnsInProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "MovedColumnsInProjectEvent"])
      }

      public static func makePinnedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "PinnedEvent"])
      }

      public static func makeRemovedFromProjectEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "RemovedFromProjectEvent"])
      }

      public static func makeTransferredEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "TransferredEvent"])
      }

      public static func makeUnpinnedEvent() -> Node {
        return Node(unsafeResultMap: ["__typename": "UnpinnedEvent"])
      }

      public static func makePushAllowance() -> Node {
        return Node(unsafeResultMap: ["__typename": "PushAllowance"])
      }

      public static func makeReviewDismissalAllowance() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReviewDismissalAllowance"])
      }

      public static func makeDeployKey() -> Node {
        return Node(unsafeResultMap: ["__typename": "DeployKey"])
      }

      public static func makeLanguage() -> Node {
        return Node(unsafeResultMap: ["__typename": "Language"])
      }

      public static func makeRelease() -> Node {
        return Node(unsafeResultMap: ["__typename": "Release"])
      }

      public static func makeReleaseAsset() -> Node {
        return Node(unsafeResultMap: ["__typename": "ReleaseAsset"])
      }

      public static func makeRepositoryTopic() -> Node {
        return Node(unsafeResultMap: ["__typename": "RepositoryTopic"])
      }

      public static func makeTopic() -> Node {
        return Node(unsafeResultMap: ["__typename": "Topic"])
      }

      public static func makeGist() -> Node {
        return Node(unsafeResultMap: ["__typename": "Gist"])
      }

      public static func makeGistComment() -> Node {
        return Node(unsafeResultMap: ["__typename": "GistComment"])
      }

      public static func makePublicKey() -> Node {
        return Node(unsafeResultMap: ["__typename": "PublicKey"])
      }

      public static func makeOrganizationIdentityProvider() -> Node {
        return Node(unsafeResultMap: ["__typename": "OrganizationIdentityProvider"])
      }

      public static func makeExternalIdentity() -> Node {
        return Node(unsafeResultMap: ["__typename": "ExternalIdentity"])
      }

      public static func makeSecurityAdvisory() -> Node {
        return Node(unsafeResultMap: ["__typename": "SecurityAdvisory"])
      }

      public static func makeBlob() -> Node {
        return Node(unsafeResultMap: ["__typename": "Blob"])
      }

      public static func makeBot() -> Node {
        return Node(unsafeResultMap: ["__typename": "Bot"])
      }

      public static func makeRepositoryInvitation() -> Node {
        return Node(unsafeResultMap: ["__typename": "RepositoryInvitation"])
      }

      public static func makeTag() -> Node {
        return Node(unsafeResultMap: ["__typename": "Tag"])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userDetail: UserDetail? {
          get {
            if !UserDetail.possibleTypes.contains(resultMap["__typename"]! as! String) { return nil }
            return UserDetail(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct UserDetail: GraphQLFragment {
  public static let fragmentDefinition =
    "fragment UserDetail on User {\n  __typename\n  id\n  avatarUrl\n  createdAt\n  name\n  bio\n  email\n  url\n  followers {\n    __typename\n    totalCount\n  }\n}"

  public static let possibleTypes = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("bio", type: .scalar(String.self)),
    GraphQLField("email", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("followers", type: .nonNull(.object(Follower.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, avatarUrl: String, createdAt: String, name: String? = nil, bio: String? = nil, email: String, url: String, followers: Follower) {
    self.init(unsafeResultMap: ["__typename": "User", "id": id, "avatarUrl": avatarUrl, "createdAt": createdAt, "name": name, "bio": bio, "email": email, "url": url, "followers": followers.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  /// A URL pointing to the user's public avatar.
  public var avatarUrl: String {
    get {
      return resultMap["avatarUrl"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "avatarUrl")
    }
  }

  /// Identifies the date and time when the object was created.
  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  /// The user's public profile name.
  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  /// The user's public profile bio.
  public var bio: String? {
    get {
      return resultMap["bio"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "bio")
    }
  }

  /// The user's publicly visible profile email.
  public var email: String {
    get {
      return resultMap["email"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  /// The HTTP URL for this user
  public var url: String {
    get {
      return resultMap["url"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "url")
    }
  }

  /// A list of users the given user is followed by.
  public var followers: Follower {
    get {
      return Follower(unsafeResultMap: resultMap["followers"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "followers")
    }
  }

  public struct Follower: GraphQLSelectionSet {
    public static let possibleTypes = ["FollowerConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(totalCount: Int) {
      self.init(unsafeResultMap: ["__typename": "FollowerConnection", "totalCount": totalCount])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Identifies the total count of items in the connection.
    public var totalCount: Int {
      get {
        return resultMap["totalCount"]! as! Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "totalCount")
      }
    }
  }
}
