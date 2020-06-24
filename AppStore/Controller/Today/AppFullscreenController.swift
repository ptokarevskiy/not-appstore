import UIKit

class AppFullscreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dismissHandler: (() ->())?
    var todayItem: TodayItem?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        return button
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        let statusBarHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let translationY = -90 - statusBarHeight
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        })
    }
    
    let tableView = UITableView(frame: .zero,style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        setupCloseButton()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        let statusBar = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        tableView.contentInset = .init(top: 0, left: 0, bottom: statusBar.height, right: 0)
        
        setupFloatingControls()
    }
    
    let floatingContainerView = UIView()
    
    @objc fileprivate func handleTap(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .init(translationX: 0, y: -90)
        })
    }
    
    fileprivate func setupFloatingControls() {
        
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.clipsToBounds = true
        //alternative
//        floatingContainerView.layer.masksToBounds
        
        view.addSubview(floatingContainerView)
        //view.safeAreaLayoutGuide.bottomAnchor might not work with CGAffineTransform.trasntationX on tabBar
//        let bottomPadding = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 16
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 90))
        
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //add subviews
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        
        let imageView = UIImageView(cornerRadius: 16)
        imageView.constrainHeight(constant: 68)
        imageView.constrainWidth(constant: 68)
        imageView.image = todayItem?.image
        imageView.contentMode = .scaleAspectFill
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [UILabel(text: todayItem?.category ?? "", font: .boldSystemFont(ofSize: 18)),
                                                 UILabel(text: todayItem?.title ?? "", font: .systemFont(ofSize: 16))
            ], spacing: 4),
            getButton
        ], customSpacing: 16)
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            // hack
            //           let cell = UITableViewCell()
            //           let todayCell = TodayCell()
            //           cell.addSubview(todayCell)
            //           todayCell.centerInSuperview(size: .init(width: 250, height: 250))
            let headerCell = AppFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellHeight
        }
        return UITableView.automaticDimension
    }
    
    
}
