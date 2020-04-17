import UIKit

class ReviewCell: UICollectionViewCell {
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "Nickname", font: .systemFont(ofSize: 16))
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    let bodyLabel = UILabel(text: "Review body \nReview body \nReview body \n", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [UIStackView(arrangedSubviews: [
            titleLabel,
//            UIView(),
            authorLabel
        ], customSpacing: 8),
                                                             starsLabel,
                                                             bodyLabel, UIView()],
                                          spacing: 12)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorLabel.textAlignment = .right
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import SwiftUI
class ReviewCellPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().previewLayout(.fixed(width: 400, height: 300))
    }
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) ->  UIView {
            return ReviewCell()
        }
        func updateUIView(_ uiView:  UIView, context: Context) {
            
        }
    }
}
