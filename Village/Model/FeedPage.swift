struct FeedPage: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Feed]
}

struct UserFeedPage: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [UserFeed]
}
