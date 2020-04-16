import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let developer: String
    let name: String
    let icon: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "artworkUrl100"
        case developer = "artistName"
        case name, id
    }
}
