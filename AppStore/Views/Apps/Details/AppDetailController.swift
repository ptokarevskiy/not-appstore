import UIKit

class AppDetailController: BaseListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .yellow
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
