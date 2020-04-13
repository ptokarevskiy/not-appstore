import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Application]
}

struct Application: Decodable {
    let trackName: String
    let primaryGenreName: String
    //If data may not exits use "var" + optional
    var averageUserRating: Float?
}
