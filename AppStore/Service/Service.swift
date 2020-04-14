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
}
