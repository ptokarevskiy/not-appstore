import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var apps = [FeedResult]()
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDissmiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDissmiss() {
        dismiss(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = self.apps[indexPath.item].id
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == .fullscreen {
            setupCloseButton()
            collectionView.backgroundColor = .systemBackground
            navigationController?.isNavigationBarHidden = true
        } else {
            collectionView.backgroundColor = .clear
            collectionView.isScrollEnabled = false
        }
        
        
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        
        
        //never execute fetch code in view
//        Service.shared.fetchGames { (appGroup, error) in
//
//            self.results = appGroup?.feed.results ?? []
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
    }
    
    override var prefersStatusBarHidden: Bool { return true }

    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return .init(top: 24, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullscreen {
            return apps.count
        }
        
        return min(4, apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        cell.app = apps[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 68
        if mode == .fullscreen {
            return .init(width: view.frame.width - 48, height: height)
        }
//        let height: CGFloat = (view.frame.height - 3 * spacing) / 4
        return .init(width: view.frame.width, height: height)
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //default 10
        return spacing
    }
    
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId = results[indexPath.item].id
//        let appDetailsController = AppDetailController(appId: appId)
//        navigationController?.pushViewController(appDetailsController, animated: true)
//    }
}


import SwiftUI
struct MultipleAppsControllerPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView()
    }
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) ->  UIViewController {
            return TodayMultipleAppsController(mode: .fullscreen)
        }
        func updateUIViewController(_ uiViewController:  UIViewController, context: Context) {
            
        }
    }
}
