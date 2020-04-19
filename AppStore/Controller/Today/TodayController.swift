import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var appFullscreenController: AppFullscreenController!
    
    let items = [TodayItem.init(category: "Life Hack", title: "Utilizing your time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .tertiarySystemBackground),
                 TodayItem.init(category: "Holidays", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838892817, green: 0.9626765847, blue: 0.7271130681, alpha: 1))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        cell.todayItem = items[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: 450)
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

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            //starts animation
            self.view.layoutIfNeeded()

            //doesnt work anymore
//            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.tabBarController?.setTabBar(hidden: true)

            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }

            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()

        }, completion: nil)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveFullscreenView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.appFullscreenController.tableView.contentOffset = .zero
            
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
        return ContainerView().edgesIgnoringSafeArea(.bottom)
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
