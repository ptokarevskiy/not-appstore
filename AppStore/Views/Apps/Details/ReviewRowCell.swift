import UIKit

class ReviewRowCell: UICollectionViewCell {
    let reviewsController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(reviewsController.view)
        reviewsController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
struct ReviewRowCellPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().previewLayout(.fixed(width: 300, height: 200))
    }
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) ->  UIView {
            return ReviewRowCell()
        }
        func updateUIView(_ uiView:  UIView, context: Context) {
            
        }
    }
}
