import Foundation

class Service {
    
    //Singleton
    static let shared = Service()
    
    func fetchApps(searchTerm: String, completion: @escaping ([Application], Error?) -> ()) {
        let urlEncodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(urlEncodedSearchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        //fetch data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch apps:", error)
                completion([], error)
                return
            }
            
            //success
            guard let data = data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonError {
                print("Failed to decode error:", jsonError)
                completion([], jsonError)
            }
            
        }.resume()
    }
    
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        let gamesWeLoveUrlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json"
        fetchAppGroup(urlSrting: gamesWeLoveUrlString, completion: completion)
    }
    
    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
        let topGrossingUrlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        fetchAppGroup(urlSrting: topGrossingUrlString, completion: completion)
    }
    
    //helper func
    func fetchAppGroup(urlSrting: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        guard let url = URL(string: urlSrting) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                completion(appGroup, nil)
            } catch let jsonError {
                completion(nil, jsonError)
                print("Failed to decode",jsonError)
            }
        }.resume()
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> ()) {
        guard let url = URL(string: "https://api.letsbuildthatapp.com/appstore/social") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let objects = try JSONDecoder().decode([SocialApp].self, from: data)
                completion(objects, nil)
            } catch let jsonError {
                completion(nil, jsonError)
                print("Failed to decode",jsonError)
            }
        }.resume()
    }
}
