import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Application]
}

struct Application: Decodable {
    let name: String
    let id: Int
    let category: String
    //If data may not exits use "var" + optional
    var averageUserRating: Float?
    let icon: String
    var screenshotUrls: [String]?
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case category = "primaryGenreName"
        case icon = "artworkUrl100"
        case id = "trackId"
        case screenshotUrls, averageUserRating, formattedPrice, description, releaseNotes
    }
}
