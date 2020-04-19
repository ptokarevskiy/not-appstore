import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var appFullscreenController: AppFullscreenController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
//        let redView = UIView()
//        redView.backgroundColor = .red
        let appFullscreenController = AppFullscreenController()
        let redView = appFullscreenController.view!
        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        redView.layer.cornerRadius = 16
        view.addSubview(redView)
        addChild(appFullscreenController)
        self.appFullscreenController = appFullscreenController
//        redView.frame = .init(x: 0, y: 0, width: 100, height: 200)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //absolute corners of cell
        guard let startingframe = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingframe
        //Autolayout constraint animations
        //4 anchors
        redView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = redView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingframe.origin.y)
        leadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingframe.origin.x)
        widthConstraint = redView.widthAnchor.constraint(equalToConstant: startingframe.width)
        heightConstraint = redView.heightAnchor.constraint(equalToConstant: startingframe.height)
        
        [topConstraint, leadingConstraint, heightConstraint, widthConstraint].forEach {$0?.isActive = true }
        self.view.layoutIfNeeded()
        
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
        }, completion: nil)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
        //        gesture.view?.removeFromSuperview()
        //access starting frame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            if let startingFrame = self.startingFrame {
                
                self.topConstraint?.constant = startingFrame.origin.y
                self.leadingConstraint?.constant = startingFrame.origin.x
                self.widthConstraint?.constant = startingFrame.width
                self.heightConstraint?.constant = startingFrame.height
                //starts animation
                self.tabBarController?.setTabBar(hidden: false, animated: false)
                self.view.layoutIfNeeded()
                
                self.appFullscreenController.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
                
            }
        }) { _ in
            gesture.view?.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
        }
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
