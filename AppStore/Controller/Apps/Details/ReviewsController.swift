import UIKit

class ReviewsController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellID"
    var reviews: Reviews? {
          didSet {
            collectionView.reloadData()
          }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.feed.entry.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewCell
        let entry = self.reviews?.feed.entry[indexPath.item]
        cell.authorLabel.text = entry?.author.name.label
        cell.titleLabel.text = entry?.title.label
        cell.bodyLabel.text = entry?.content.label
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

import SwiftUI
struct ReviewsControllerPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().previewLayout(.fixed(width: 400, height: 280))
    }
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) ->  UIViewController {
            return ReviewsController()
        }
        func updateUIViewController(_ uiViewController:  UIViewController, context: Context) {
            
        }
    }
}
