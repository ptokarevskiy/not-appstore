import UIKit

class AppRowCell: UICollectionViewCell {
    let imageView = UIImageView(cornerRadius: 12)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        //        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        getButton.backgroundColor = .systemGray6
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 16
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                nameLabel,
                companyLabel], spacing: 4),
            getButton
        ])
        stackView.spacing = 16
        
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
struct AppRowCellPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().previewLayout(.fixed(width: 300, height: 50))
    }
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            return AppRowCell()
        }
        func updateUIView(_ uiView: UIView, context: Context) {
            
        }
    }
}
