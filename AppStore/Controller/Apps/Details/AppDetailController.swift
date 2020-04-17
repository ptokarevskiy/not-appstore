import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let reuseIdentifier = "cellId"
    fileprivate let previewCellId = "previewCellId"
    fileprivate let reviewsCellId = "reviewCellId"
    var app: Application?
    var reviews: Reviews?
    
    var appId: String! {
        didSet {
            print(appId!)
            let urlString = "http://itunes.apple.com/lookup?id=\(appId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, error) in
                let app = result?.results.first
                self.app = app
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=en&cc=us"
            print(reviewsUrl)
            Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews: Reviews?, error) in
                if let error = error {
                    print("Failed to decode reviews:", error)
                }
//                reviews?.feed.entry.forEach { print($0.title, $0.content, $0.author.name.label) }
                self.reviews = reviews
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewsCellId)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppDetailCell
            cell.app = app
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.horizontalController.app = self.app
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewsCellId, for: indexPath) as! ReviewRowCell
            cell.reviewsController.reviews = self.reviews
            return cell
        default: fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            //calculate size for cell
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.app = app
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            
            return .init(width: view.frame.width, height: estimatedSize.height)
        case 1:
            return .init(width: view.frame.width, height: 500)
        default:
            return .init(width: view.frame.width, height: 280)
        }
    }
}




import SwiftUI
struct AppDetailControllerPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView()
    }
    struct ContainerView: UIViewControllerRepresentable{
        func makeUIViewController(context: Context) -> UIViewController {
            return AppDetailController()
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
