import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category.uppercased()
            titleLabel.text = todayItem.title
            backgroundColor = todayItem.backgroundColor
            
            multipleAppController.apps = todayItem.apps
            multipleAppController.collectionView.reloadData()
        }
    }
    
    let categoryLabel = UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "What we're \nplaying now", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    let multipleAppController = TodayMultipleAppsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            multipleAppController.view], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import SwiftUI
struct TodayMultipleAppCellPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().edgesIgnoringSafeArea(.bottom)
    }
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) ->  UIView {
            return TodayMultipleAppCell()
        }
        func updateUIView(_ uiView:  UIView, context: Context) {
            
        }
    }
}
