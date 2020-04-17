import Foundation

class Service {
    
    //Singleton
    static let shared = Service()
    
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let urlEncodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(urlEncodedSearchTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    //helper func
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    //let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=en&cc=us"
    
    func fetchGenericJSONData<T:Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completion(objects, nil)
            } catch let jsonError {
                completion(nil, jsonError)
                print("Failed to decode",jsonError)
            }
        }.resume()
    }
}
