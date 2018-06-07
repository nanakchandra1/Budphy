//
//  ShowEventCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 14/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- ShowEventCell class
//==========================
class ShowEventCell: BaseCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var leftCurveView    : UIView!
    @IBOutlet weak var curveBackView    : UIView!
    @IBOutlet weak var eventName        : UILabel!
    @IBOutlet weak var eventTime        : UILabel!
    @IBOutlet weak var editEventBtn     : UIButton!
    @IBOutlet weak var eventTypeImage   : UIImageView!
    @IBOutlet weak var moviesConcertImage: UIImageView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.curveBackView.layer.cornerRadius = 5
        self.curveBackView.layer.masksToBounds = false
        self.curveBackView.roundCornersFromOneSide([.topRight,.bottomRight],
                                                   radius: self.curveBackView.frame.width)
        self.leftCurveView.roundCornersFromOneSide([.topLeft,.bottomLeft], radius: 5)
        //self.contentView.dropShadow(width: 2, shadow: AppColors.popUpBackground)
        self.contentView.addShadow(ofColor: AppColors.popUpBackground, radius: 2, offset: CGSize(width: 0, height: 2), opacity: 0.5)
        self.moviesConcertImage.roundCornerWith(radius: 5)
    }
    
}


//MARK:- Extension for private methods
//====================================
extension ShowEventCell {
    
    private func setupSubView() {
        
        self.eventName.textColor    = AppColors.blackColor
        self.eventName.font         = AppFonts.Comfortaa_Bold_0.withSize(12)
        self.eventTime.textColor    = AppColors.themeBlueColor
        self.eventTime.font         = AppFonts.Comfortaa_Bold_0.withSize(11)
        self.moviesConcertImage.isHidden = true
        self.leftCurveView.isHidden = true
//        self.editEventBtn.isUserInteractionEnabled = false
        self.eventName.numberOfLines = 2
    }
    
    func populateWithModel(event: EventModel) {
        
        self.moviesConcertImage.isHidden = true
        self.eventTypeImage.isHidden = false
        self.editEventBtn.isHidden = false
        self.editEventBtn.isUserInteractionEnabled = true
        
        self.eventTypeImage.image = getEventListImage(typeId: event.eventType)
        
        if event.eventCategory == "4" {
            self.editEventBtn.setImage(AppImages.icEventsEdit, for: .normal)
        } else if event.eventCategory == "1" || event.eventCategory == "2" || event.eventCategory == "3" {
            if event.isFavourite == "0" {
                self.editEventBtn.setImage(AppImages.icUnselectHeart, for: .normal)
            } else {
                self.editEventBtn.setImage(AppImages.icSelectHeart, for: .normal)
            }
        } else {
            self.editEventBtn.isHidden = true
        }
        
        if !event.eventName.isEmpty {
            self.eventName.text = event.eventName
        } else {
            self.eventName.text = "NA"
        }
        
        self.eventTime.text = event.eventStartTime
        //self.eventTypeImage.image = eventTypeImage
        //self.editEventBtn.setImage(eventFrom, for: .normal)
    }
    
    func populateWithMoviesConcert(event: EventModel) {
        
        self.moviesConcertImage.isHidden = false
        self.eventTypeImage.isHidden = true
        self.eventName.numberOfLines = 2
        
        if !event.eventName.isEmpty {
            self.eventName.text = event.eventName
        } else {
            self.eventName.text = "NA"
        }
        self.eventTime.text = event.eventStartTime
        self.moviesConcertImage.setImage(withSDWeb: event.eventImage,
                                         placeholderImage: AppImages.myprofilePlaceholder)
        if event.isFavourite == "0" {
            self.editEventBtn.setImage(AppImages.icUnselectHeart, for: .normal)
        } else {
            self.editEventBtn.setImage(AppImages.icSelectHeart, for: .normal)
        }
    }
    
    //    func populateConcertModel(event: ConcertModel) {
    //
    //        self.moviesConcertImage.isHidden = false
    //        self.eventTypeImage.isHidden = true
    //        self.eventName.numberOfLines = 1
    //
    //        if let name = event.concertName as? String, !name.isEmpty {
    //            self.eventName.text = name
    //        } else {
    //            self.eventName.text = "NA"
    //        }
    //
    //        self.moviesConcertImage.setImage(withSDWeb: event.concertImage, placeholderImage: AppImages.icEventsbudfiePlaceholder)
    //
    //        self.editEventBtn.setImage(AppImages.icUnselectHeart, for: .normal)
    //        let str = event.concertStartTime.toDate(dateFormat: DateFormat.fullTime.rawValue)
    //        let strDate = str?.toString(dateFormat: DateFormat.shortTime.rawValue)
    //        self.eventTime.text = strDate//event.concertStartTime
    //        //self.eventTypeImage.image = eventTypeImage
    //        //self.editEventBtn.setImage(eventFrom, for: .normal)
    //    }
    
}
