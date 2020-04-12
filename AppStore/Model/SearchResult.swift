import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Application]
}

struct Application: Decodable {
    let trackName: String
    let primaryGenreName: String
}
