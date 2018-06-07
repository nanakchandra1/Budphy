//
//  NewsDetailedVC+UICollectionView.swift
//  Budfie
//
//  Created by yogesh singh negi on 21/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for DataSource and Delegate
//============================================
extension NewsDetailedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.obNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsDetailsCell", for: indexPath) as? NewsDetailsCell else {
            fatalError("NewsDetailsCell not found")
        }
        cell.detailedNewsTextView.text = self.obNewsList[indexPath.row].description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension NewsDetailedVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(scrollToSelectedNews), with: nil, afterDelay: 0.02)
    }
    
    @objc private func scrollToSelectedNews() {
        if let pNumber = pageNumber {
            pageNumber = nil
            if pNumber > 0 {
                self.showNewsCollectionView.setContentOffset(CGPoint(x: CGFloat(pNumber) * self.showNewsCollectionView.frame.width, y: 0), animated: false)
            } else {
                self.setHeadlineBackgroundColor(contentOffSet: CGFloat(pNumber) * screenWidth)
            }
        }
    }
}

extension NewsDetailedVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > self.showNewsCollectionView.frame.width / 2 {
            self.previousBtn.alpha = 1
        } else {
            self.previousBtn.alpha = 0
        }
        if scrollView.contentOffset.x < (self.showNewsCollectionView.frame.width * 8) + self.showNewsCollectionView.frame.width / 2 {
            self.nextBtn.alpha = 1
        } else {
            self.nextBtn.alpha = 0
        }
//        if ((showNewsCollectionView.frame.width * CGFloat(pageNumber)) + showNewsCollectionView.frame.width / 2) == scrollView.contentOffset.x {
//
//        }
        self.setHeadlineBackgroundColor(contentOffSet: scrollView.contentOffset.x)
    }
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension NewsDetailedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK:- NewsDetailsCell Class
//============================
class NewsDetailsCell : UICollectionViewCell {
    
    //MARK:- @IBOutlet
    //================
    @IBOutlet weak var detailedNewsTextView: UITextView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.clear
        self.detailedNewsTextView.backgroundColor = UIColor.clear
        self.detailedNewsTextView.font = AppFonts.AvenirNext_Regular.withSize(17)
        self.detailedNewsTextView.textColor = AppColors.blackColor
        self.detailedNewsTextView.isEditable = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
}
