//
//  VideosOrGifsVC+UICollectionView.swift
//  Budfie
//
//  Created by yogesh singh negi on 21/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for DataSource and Delegate
//============================================
extension VideosOrGifsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.commonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as? ThumbnailCell else {
            fatalError("ThumbnailCell not found")
        }
        let model = self.commonList[indexPath.row]
        var urlString = String()
        
        if model.type == "1" {
            urlString = model.thumbnail
            cell.playIcon.isHidden = false
        } else {
            urlString = model.url
            cell.playIcon.isHidden = true
        }

        if model.url.contains("https://www.youtube.com/watch?v="),
            let url = URL(string: model.url),
            let videoId = url.queryItems["v"] {

            let imageUrl = "https://img.youtube.com/vi/\(videoId)/0.jpg"
            cell.thumbnailImageView.setImage(withSDWeb: imageUrl, placeholderImage: AppImages.myprofilePlaceholder)

        } else {
            cell.thumbnailImageView.setImage(withSDWeb: urlString, placeholderImage: AppImages.myprofilePlaceholder)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.commonList[indexPath.row].type == "1" {
            self.videosMoodSelected(indexPath: indexPath)
        } else {
            self.gifsMoodSelected(indexPath: indexPath)
        }
        
        /*
        if self.state == .cli {
            self.moviesMoodSelected(indexPath: indexPath)
        } else if self.state == .videos {
            self.videosMoodSelected(indexPath: indexPath)
        } else {
            self.gifsMoodSelected(indexPath: indexPath)
        }
 */
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HCollectionReusableView", for: indexPath)
            
            reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            reusableview.backgroundColor = UIColor.clear//(0 , 0, self.view.frame.width, 40)
            //do other header related calls or settups
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
    }
 */
    
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension VideosOrGifsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidth = (screenWidth - 31) / 2
        
        return CGSize(width: heightWidth, height: heightWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // ofSize should be the same size of the headerView's label size:
        return CGSize(width: collectionView.frame.size.width, height: 40)
        
    }
 */
    
}

//MARK:- ThumbnailCell Class
//===========================
class ThumbnailCell : UICollectionViewCell {
    
    //MARK:- @IBOutlet
    //================
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnailImageView.image = AppImages.ic53VideosOpt1V1PlayVideo
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentView.roundCornerWith(radius: 5)
    }
    
}
