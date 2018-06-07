//
//  GiftsVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension GiftsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3//self.modelGreetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FreeGiftTableCell") as? FreeGiftTableCell else {
                fatalError("FreeGiftTableCell not found")
            }
            
            cell.giftListing = self.giftListing
            cell.freeGiftCollection.reloadData()
            cell.delegate = self
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GiftBuyCell") as? GiftBuyCell else {
                fatalError("GiftBuyCell not found")
            }
            
            if indexPath.row == 1 {
                
                cell.giftImage.image = #imageLiteral(resourceName: "icGiftingRecommends")
                cell.giftTypeLable.text = "BUDFIE RECOMMENDS CUSTOMISABLE GIFTS"
                
            } else {
                
                cell.giftImage.image = #imageLiteral(resourceName: "icGiftingFlowers")
                cell.giftTypeLable.text = "FLOWERS AND CAKES"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.openLinks(link: "http://www.excitinglives.com/personalisedgiftsindia.php")
        } else {
            self.openLinks(link: "http://www.excitinglives.com/experience/index.php?main_page=index&cPath=11")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}


//MARK:- GiftBuyCell Prototype Class
//==================================
class GiftBuyCell: UITableViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftTypeLable: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {

        giftImage.layer.cornerRadius = 8
        buyBtn.layer.cornerRadius = buyBtn.frame.height / 2
        buyBtn.backgroundColor = AppColors.themeBlueColor
        giftImage.clipsToBounds = true
        giftImage.addShadow(ofColor: AppColors.blackColor, radius: 3.0, offset: CGSize.init(width: 0, height: 2.0), opacity: 0.3)

        buyBtn.isUserInteractionEnabled = false
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView() {
        
    }
    
}


