import UIKit

class TrackCell: UICollectionViewCell {
    let imageView = UIImageView(cornerRadius: 16)
    let trackLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    let subtitileLabel = UILabel(text: "Subtitille", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.constrainWidth(constant: 80)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [trackLabel, subtitileLabel], spacing: 4)], customSpacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
struct TrackCellPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().previewLayout(.fixed(width: 400, height: 100))
    }
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) ->  UIView {
            TrackCell()
        }
        func updateUIView(_ uiView:  UIView, context: Context) {
            
        }
    }
}
