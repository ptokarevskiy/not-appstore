import UIKit

class PreviewScreenshotsController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var app: Application? {
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    class ScreenshotCell: UICollectionViewCell {
        let imageView = UIImageView(cornerRadius: 12)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            imageView.backgroundColor = .systemGray3
            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
            
            addSubview(imageView)
            imageView.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        let screenshotUrl = self.app?.screenshotUrls[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: screenshotUrl ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 250, height: view.frame.height)
    }
}

import SwiftUI
struct ScreenshotsControllerPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().previewLayout(.fixed(width: 350, height: 500))
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) ->  UIViewController {
            return PreviewScreenshotsController()
        }
        func updateUIViewController(_ uiViewController:  UIViewController, context: Context) {
            
        }
    }
}
