import UIKit
import SDWebImage

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    let footerId = "footer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        fetchData()
    }
    
    var results = [Application]()
    
    fileprivate let searchTerm = "Darkside"
    
    fileprivate func fetchData() {
         let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=0&limit=20"
        Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, error) in
            print(searchResult?.results ?? [])
            
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var isPaginating = false
    var isDonePaginating = false
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        let track = self.results[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: track.icon))
        cell.trackLabel.text = track.name
        cell.subtitileLabel.text = "\(track.artistName ?? "") • \(track.collectionName ?? "")"

            //Init pagination
        if indexPath.item == results.count - 1 && !isPaginating{
            print("fetch more data")
            isPaginating = true
            
            let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
                 Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, error) in
                     print(searchResult?.results ?? [])
                     
                    if searchResult?.results.count == 0 {
                        self.isDonePaginating = true
                    }
                    sleep(1)
                    
                     self.results += searchResult?.results ?? []
                     DispatchQueue.main.async {
                         self.collectionView.reloadData()
                     }
                    self.isPaginating = false
                 }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
}


import SwiftUI
struct MusicControllerPreview: PreviewProvider {
    static var previews: some View {
        return ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return MusicController()
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
