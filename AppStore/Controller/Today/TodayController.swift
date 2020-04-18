import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var appFullscreenController: UIViewController!
    
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
        redView.frame = startingframe
        // why i don't use a transition delegate?
        
        // we're using frames for animation
        // frames aren't reliable enough for animations
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            redView.frame = self.view.frame
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        }, completion: nil)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
        //        gesture.view?.removeFromSuperview()
        //access starting frame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            if let startingFrame = self.startingFrame {
                gesture.view?.frame = startingFrame
                
                self.tabBarController?.tabBar.transform = .identity
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
