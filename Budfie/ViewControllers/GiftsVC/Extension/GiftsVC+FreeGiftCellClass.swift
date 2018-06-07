//
//  GiftsVC+FreeGiftCellClass.swift
//  Budfie
//
//  Created by appinventiv on 05/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage

protocol FreeGiftDelegate: class {
    func getSelectedImage(imageName: UIImage)
    func getSelectedImageURL(url: String)
}

//MARK:- FreeGiftCell Prototype Class
//===================================
class FreeGiftTableCell: UITableViewCell {
    
    weak var delegate: FreeGiftDelegate?
    var giftListing = [GiftingListModel]()
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var freeGiftCollection: UICollectionView!
    @IBOutlet weak var freeBtn: UIButton!
    
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
        
        self.freeGiftCollection.delegate = self
        self.freeGiftCollection.dataSource = self
        
        self.freeBtn.layer.cornerRadius = self.freeBtn.frame.height / 2
        self.freeBtn.backgroundColor = AppColors.themeBlueColor
        self.freeBtn.isHidden = true
        self.freeBtn.isUserInteractionEnabled = false
        
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView() {
        
    }
    
}


extension FreeGiftTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if giftListing.isEmpty {
           return 0 
        }
        return giftListing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FreeGiftCell", for: indexPath) as? FreeGiftCell else { fatalError("FreeGiftCell not found") }
        
        /*
        if let giftList = GiftingFreeList(rawValue: indexPath.row + 1) {
            cell.giftImageView.image = giftList.image
            cell.giftNameLabel.text = giftList.name
        }
         */
        
        let model = giftListing[indexPath.row]
        
        cell.giftImageView.setImage(withSDWeb: model.image, placeholderImage: AppImages.myprofilePlaceholder)
        cell.giftNameLabel.text = model.title
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
        if let giftList = GiftingFreeList(rawValue: indexPath.row + 1) {
            delegate?.getSelectedImage(imageName: giftList.image)
        }
         */
        
        let uiimage = UIImageView()
        let imgUrl = giftListing[indexPath.row].image
        uiimage.setImage(withSDWeb: giftListing[indexPath.row].image, placeholderImage: AppImages.myprofilePlaceholder)

        if imgUrl.hasSuffix(".gif") {
            delegate?.getSelectedImageURL(url: giftListing[indexPath.row].image)
        } else if let image = uiimage.image {
            delegate?.getSelectedImage(imageName: image)
        }
    }
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension FreeGiftTableCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 160, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
    }
    
}


//MARK:- TrendingDestinationCell Prototype Class
//==============================================
class FreeGiftCell: UICollectionViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var labelBackView: UIView!
    @IBOutlet weak var giftImageView: FLAnimatedImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    
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

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        labelBackView.layer.cornerRadius = 2
        giftImageView.layer.cornerRadius = 8
        giftImageView.clipsToBounds = true
        labelBackView.clipsToBounds = true
        giftImageView.addShadow(ofColor: AppColors.blackColor, radius: 3.0, offset: CGSize.init(width: 0, height: 2.0), opacity: 0.3)
        labelBackView.backgroundColor = AppColors.shadowViewColor
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView() {
        
    }
}
