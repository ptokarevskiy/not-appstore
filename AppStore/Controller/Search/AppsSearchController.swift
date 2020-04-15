import UIKit

class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "cellId"
    fileprivate var appResults = [Application]()
    fileprivate let searchController =  UISearchController(searchResultsController: nil)
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search terms"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        //UICollectionViewCell.self - register class itself insted of instance
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 80, bottom: 0, right: 50))
        
        setupSearchBar()
        //        fetchItunesApps()
    }
    
    fileprivate func fetchItunesApps() {
        Service.shared.fetchApps(searchTerm: "Instagram") { (results, error)  in
            if let error = error {
                print("Failed to fetch apps:", error)
                return
            }
            self.appResults = results?.results ?? []
            // By default URLSessions do execute their data tasks on a background thread. Because of this, we are required to get back on the main thread by using DispatchQueue.main.async
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    
    //TODO: - Migrate to new UISearchResultsUpdating protocol
/* https://www.hackingwithswift.com/example-code/uikit/how-to-use-uisearchcontroller-to-let-users-enter-search-words */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        //throttling search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            //actually fires network request
            Service.shared.fetchApps(searchTerm: searchText) { (result, error) in
                self.appResults = result?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        //Apple recommends use "item" for collectionViews and "row" for tableViews
        cell.appResult = appResults[indexPath.item]
        return cell
    }
}


import SwiftUI
struct SearchPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return AppsSearchController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
}
