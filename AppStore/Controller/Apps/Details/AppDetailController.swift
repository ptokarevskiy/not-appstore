import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let reuseIdentifier = "cellId"
    fileprivate let previewCellId = "previewCellId"
    var app: Application?
    
    var appId: String! {
        didSet {
            let urlString = "http://itunes.apple.com/lookup?id=\(appId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, error) in
                let app = result?.results.first
                self.app = app
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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppDetailCell
            cell.app = app
            return cell
            } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.horizontalController.app = self.app
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
        //calculate size for cell
        let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        dummyCell.app = app
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
        } else {
            return .init(width: view.frame.width, height: 500)
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
