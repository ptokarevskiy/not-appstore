import UIKit

class MainView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

import SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return MainView()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
