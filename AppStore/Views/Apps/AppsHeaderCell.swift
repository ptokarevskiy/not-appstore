import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
    
    let imageView = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        companyLabel.textColor = .link
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .separator
        titleLabel.numberOfLines = 2
        
        let stackView = VerticalStackView(arrangedSubviews: [
            companyLabel,
            titleLabel,
            imageView
        ], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import SwiftUI
struct AppsHeaderCellPreview: PreviewProvider {
    static var previews: some View {
            ContentView().previewLayout(.fixed(width: 400, height: 300))
    }
    struct ContentView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            return AppsHeaderCell()
        }
        func updateUIView(_ uiView: UIView, context: Context) {
            
        }
    }
}
