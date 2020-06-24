import UIKit
import SDWebImage

class SearchResultCell: UICollectionViewCell {
    
    var appResult: Application! {
        didSet {
            nameLabel.text = appResult.name
            categoryLabel.text = appResult.category
            ratingsLabel.text = "Rating: \(String(format: "%.1f", appResult.averageUserRating ?? 0))"
            
            let url = URL(string: appResult.icon)
            appIconImageView.sd_setImage(with: url)
            
            screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![0]))
            if appResult.screenshotUrls!.count > 1 {
                screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![1]))
            }
            if appResult.screenshotUrls!.count > 2 {
                screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![2]))
            }
        }
    }
    
    let appIconImageView: UIImageView = {
        let view = UIImageView()
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "APP NAME"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos & Video"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "9.26M"
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }()
    
    //lazy var for access for instance variables and functions
    lazy var screenshot1ImageView = self.createScreenshotImageView()
    lazy var screenshot2ImageView = self.createScreenshotImageView()
    lazy var screenshot3ImageView = self.createScreenshotImageView()
    
    func createScreenshotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //cmd + control + e --> rename
        let infoTopStackView = UIStackView(arrangedSubviews: [
            appIconImageView,
            VerticalStackView(arrangedSubviews: [
                nameLabel,
                categoryLabel,
                ratingsLabel]),
            getButton
        ])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        let screenshotsStackView = UIStackView(arrangedSubviews: [
            screenshot1ImageView,
            screenshot2ImageView,
            screenshot3ImageView
        ])
        screenshotsStackView.spacing = 12
        //Default distribution = .fill 
        screenshotsStackView.distribution = .fillEqually
        
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            infoTopStackView,
            screenshotsStackView
        ], spacing: 16)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import SwiftUI
struct SearchResultCellPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView()
    }
    
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) -> UICollectionViewCell {
            return SearchResultCell()
        }
        func updateUIView(_ uiView: UICollectionViewCell, context: Context) {
            
        }
    }
}
