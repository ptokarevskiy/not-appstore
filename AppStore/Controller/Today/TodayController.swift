import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
//    fileprivate let cellId = "cellId"
//    fileprivate let multipleAppCellId = "multipleAppCell"
    
    var appFullscreenController: AppFullscreenController!
    
//    let items = [TodayItem.init(category: "The daily list", title: "Test-Drive These CarPlay Apps", image: UIImage(named: "garden")!, description: "", backgroundColor: .secondarySystemBackground, cellType: .multiple),
//                 TodayItem.init(category: "Life Hack", title: "Utilizing your time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .secondarySystemBackground, cellType: .single),
//                 TodayItem.init(category: "Holidays", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838892817, green: 0.9626765847, blue: 0.7271130681, alpha: 1), cellType: .single)]
    
    var items = [TodayItem]()
    var activityIndicatorView: UIActivityIndicatorView = {
       let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.color = .label
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
//        if let cell = cell as? TodayCell {
//            cell.todayItem = items[indexPath.item]
//        } else if let cell = cell as? TodayMultipleAppCell {
//            cell.todayItem = items[indexPath.item]
//        }
        
        return cell
//        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleAppCellId, for: indexPath) as! TodayMultipleAppCell
//            cell.todayItem = items[indexPath.item]
//            return cell
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
//        cell.todayItem = items[indexPath.item]
//        return cell
    }
    
    fileprivate func fetchData() {
        //dispatchGroup
        let dispatchGroup = DispatchGroup()
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            
            topGrossingGroup = appGroup
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem.init(category: "Daily list", title: topGrossingGroup?.feed.title ?? "", image: UIImage(named: "garden")!, description: "", backgroundColor: .secondarySystemBackground, labelColor: .label, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem.init(category: "Daily list", title: gamesGroup?.feed.title ?? "", image: UIImage(named: "garden")!, description: "", backgroundColor: .secondarySystemBackground, labelColor: .label, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
                TodayItem.init(category: "Holidays", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838892817, green: 0.9626765847, blue: 0.7271130681, alpha: 1), labelColor: .black, cellType: .single, apps: []),
                TodayItem.init(category: "Life Hack", title: "Utilizing your time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white, labelColor: .black, cellType: .single, apps: [])
            ]
            
            self.collectionView.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    static let cellHeight: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if items[indexPath.item].cellType == .multiple {
//            let fullController = TodayMultipleAppsController(mode: .fullscreen)
//            fullController.apps = self.items[indexPath.item].apps
//            present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
//            return
//        }
        if items[indexPath.item].cellType == .multiple {
          let appFullscreenController = TodayMultipleAppsController(mode: .fullscreen)
          let fullscreenNavigationController = BackEnabledNavigationController(rootViewController: appFullscreenController)
          appFullscreenController.apps = items[indexPath.item].apps
          fullscreenNavigationController.modalPresentationStyle = .fullScreen
          navigationController?.present(fullscreenNavigationController, animated: true)
            return
        }
        
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.item]
        appFullscreenController.dismissHandler = {
            self.handleRemoveFullscreenView()
        }
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)

        self.appFullscreenController = appFullscreenController
        self.collectionView.isUserInteractionEnabled = false

//        redView.frame = .init(x: 0, y: 0, width: 100, height: 200)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //absolute corners of cell
        guard let startingframe = cell.superview?.convert(cell.frame, to: nil) else { return }

        self.startingFrame = startingframe
        //Autolayout constraint animations
        //4 anchors
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingframe.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingframe.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingframe.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingframe.height)

        [topConstraint, leadingConstraint, heightConstraint, widthConstraint].forEach {$0?.isActive = true }
        self.view.layoutIfNeeded()

        fullscreenView.layer.cornerRadius = 16
        self.tabBarController?.setTabBar(hidden: true, animated: false)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            //starts animation
            self.view.layoutIfNeeded()

            //doesnt work anymore
//            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
           
            //index path: section 0, cell 0
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }

            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()

        }, completion: nil )
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveFullscreenView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
//            self.appFullscreenController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
            self.tabBarController?.setTabBar(hidden: false)
        })
    }
}

import SwiftUI
struct TodayControllerPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) ->  UIViewController {
//            return TodayController()
            return BaseTabBarController()
        }
        func updateUIViewController(_ uiViewController:  UIViewController, context: Context) {
            
        }
    }
}
