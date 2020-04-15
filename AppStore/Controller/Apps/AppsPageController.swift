import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let reuseIdentifier = "id"
    fileprivate let headerIdentifier = "headerId"
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .label
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //1
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
        activityIndicator.startAnimating()
        fetchData()
    }
    
    var groups = [AppGroup]()
    var socialApps = [SocialApp]()
    
    fileprivate func fetchData() {
        
        //sync data fetches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            dispatchGroup.leave()
            if let group = appGroup {
                self.groups.append(group)
            }
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            dispatchGroup.leave()
            if let group = appGroup {
                self.groups.append(group)
            }
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json") { (appGroup, error) in
            dispatchGroup.leave()
            if let group = appGroup {
                self.groups.append(group)
            }
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { (apps, error) in
            dispatchGroup.leave()
            if let error = error {
                print("Error fetching social apps:", error)
                return
            }
            guard let apps = apps else { return }
            self.socialApps = apps
        }
        
        //completion
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    //3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppsGroupCell
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        //Every time appgroup set you need to reloadData
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.didSelectHandler = { [weak self] feedResult in
            let controller = AppDetailController()
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}



import SwiftUI
struct AppsPagePreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().edgesIgnoringSafeArea(.bottom)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UICollectionViewController {
            return AppsPageController()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
