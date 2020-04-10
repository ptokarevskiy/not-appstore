import UIKit

class BaseTabBarController: UITabBarController {
    
    //3 - AppSearchController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: UIViewController(), title: "Today", imageName: "today"),
            createNavController(viewController: UIViewController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search")
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0.9)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        return navigationController
    }
    

}


import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return BaseTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
