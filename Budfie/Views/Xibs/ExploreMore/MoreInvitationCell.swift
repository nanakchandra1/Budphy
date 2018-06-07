//
//  MoreInvitationCell.swift
//  Budfie
//
//  Created by appinventiv on 29/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

class MoreInvitationCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.initialForLayer()
    }
    
    func initialSetUp() {
        self.backView.backgroundColor = AppColors.whiteColor
        self.contentView.backgroundColor = UIColor.clear
        self.superview?.backgroundColor = UIColor.clear
        
        self.acceptBtn.setTitle(StringConstants.K_ACCEPT.localized, for: .normal)
        self.acceptBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        self.acceptBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(12)
        self.acceptBtn.backgroundColor = AppColors.fillGreenColor
        
        self.rejectBtn.setTitle(StringConstants.K_REJECT.localized, for: .normal)
        self.rejectBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        self.rejectBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(12)
        self.rejectBtn.backgroundColor = AppColors.fillRedColor
        
        self.eventTitle.textColor = AppColors.blackColor
        self.eventTitle.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        self.dateAndTimeLabel.textColor = AppColors.dateTimeColor
        self.dateAndTimeLabel.font = AppFonts.Comfortaa_Regular_0.withSize(11)

        ownerLabel.textColor = AppColors.dateTimeColor
        ownerLabel.font = AppFonts.Comfortaa_Regular_0.withSize(11)
    }
    
    func initialForLayer() {
        self.backView.roundCornerWith(radius: 5)
        self.backView.dropShadow(width: 5, shadow: AppColors.invitCellshadow)
        self.profilePicImage.roundCornerWith(radius: 5)
        
        self.rejectBtn.roundCornerWith(radius: 15)
        self.acceptBtn.roundCornerWith(radius: 15)
        self.rejectBtn.layer.borderColor = AppColors.borderRedColor.cgColor
        self.acceptBtn.layer.borderColor = AppColors.borderGreenColor.cgColor
    }
    
    func populate(objc: InvitationModel) {
        let typeImage = getEventDetailsImage(eventName: objc.eventType)
        self.profilePicImage.setImage(withSDWeb: objc.eventImage, placeholderImage: typeImage)
        self.eventTitle.text = objc.eventName
        ownerLabel.text = "Invited by: \(objc.invitedBy)"

        if let eventDate = objc.eventDate.toDate(dateFormat: DateFormat.calendarDate.rawValue),
            let eventTime = objc.eventTime.toDate(dateFormat: DateFormat.fullTime.rawValue) {

            let dateString = eventDate.toString(dateFormat: "dd MMM yyy")
            let timeString = eventTime.toString(dateFormat: DateFormat.timein12Hour.rawValue)
            self.dateAndTimeLabel.text = "\(dateString) at \(timeString)"

        } else {
            self.dateAndTimeLabel.text = "\(objc.eventDate) at \(objc.eventTime)"
        }
    }
}
