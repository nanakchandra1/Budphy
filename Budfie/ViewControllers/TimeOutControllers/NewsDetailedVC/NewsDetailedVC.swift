//
//  NewsDetailedVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 21/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class NewsDetailedVC: BaseVc {
    
    //MARK: Properties
    //================
    var obNewsList = [NewsListModel]()
    var pageNumber: Int? = 0
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navBar: CurvedNavigationView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navBackBtn: UIButton!
    @IBOutlet weak var showNewsCollectionView: UICollectionView!
    @IBOutlet weak var newsHeaderBackView: ReverseCurvedView!
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var seperatorView: UIImageView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetUp()
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func backBtnTapped(_ sender: UIButton) {
        //        AppDelegate.shared.sharedTabbar.showTabbar()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func previousBtnTapped(_ sender: UIButton) {
        self.moveToPage(sender)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        self.moveToPage(sender)
    }
    
}

//MARK:- Extension for Private methods
//====================================
extension NewsDetailedVC {
    
    fileprivate func initialSetUp() {
        
        self.showNewsCollectionView.delegate = self
        self.showNewsCollectionView.dataSource = self
        self.showNewsCollectionView.backgroundColor = UIColor.clear
        self.showNewsCollectionView.roundCornerWith(radius: 3)
        
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navBar.backgroundColor = UIColor.clear
        self.navTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.navTitle.textColor = AppColors.whiteColor
        self.navTitle.text = StringConstants.K_Trending_Now.localized
        
        self.newsHeaderBackView.backgroundColor = UIColor.clear
        self.previousBtn.alpha = 0
        
        self.newsHeadlineLabel.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.newsHeadlineLabel.textColor = AppColors.blackColor

        let arrowIcon = #imageLiteral(resourceName: "phonenumberBackicon").withRenderingMode(.alwaysTemplate)
        previousBtn.setImage(arrowIcon, for: .normal)
        nextBtn.setImage(arrowIcon, for: .normal)

        nextBtn.transform = CGAffineTransform(rotationAngle: 180.toRadians)
    }
    
    fileprivate func moveToPage(_ sender: UIButton) {
        
        guard let indexPath = self.showNewsCollectionView.indexPathsForVisibleItems.first else { return }
        
        var page = indexPath.item
        
        if sender == self.previousBtn {
            page -= 1
        } else {
            page += 1
        }
        self.showNewsCollectionView.setContentOffset(CGPoint(x: CGFloat(page) * self.showNewsCollectionView.frame.width, y: 0), animated: true)
    }
    
    func setHeadlineBackgroundColor(contentOffSet: CGFloat) {
        
        let index = Int(contentOffSet/self.showNewsCollectionView.frame.width)
        
        if let backColor = NewsColors(rawValue: index + 1) {
            self.newsHeadlineLabel.text = self.obNewsList[index].title
            self.newsHeaderBackView.backFillColor = backColor.lightColor
            self.showNewsCollectionView.backgroundColor = backColor.darkColor
        }
    }
    
}
