import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Application]
}

struct Application: Decodable {
    let name: String
    let category: String
    //If data may not exits use "var" + optional
    var averageUserRating: Float?
    let icon: String
    let screenshotUrls: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case category = "primaryGenreName"
        case icon = "artworkUrl100"
        case screenshotUrls, averageUserRating
    }
}
