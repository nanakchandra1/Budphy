//
//  SentDraftReceiveCell.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage

class SentDraftReceiveCell: UITableViewCell {

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var greetingImage: FLAnimatedImageView!
    @IBOutlet weak var greetingName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var leadingBackView: NSLayoutConstraint!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var editStackView: UIStackView!
    @IBOutlet weak var deleteStackView: UIStackView!
    @IBOutlet weak var editOptionBackView: UIView!
    @IBOutlet weak var deleteOptionBackView: UIView!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        backView.gestureRecognizers?.removeAll()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let radius: CGFloat = 5

        self.greetingImage.roundCornerWith(radius: radius)
        self.backView.roundCornerWith(radius: radius)

        self.mainView.roundCornerWith(radius: radius)
        self.shadowView.roundCornerWith(radius: radius)

        self.shadowView.dropShadow(width: 3.7, shadow: AppColors.shadowViewColor)
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {
        self.greetingName.font = AppFonts.Comfortaa_Bold_0.withSize(16)
        self.greetingName.textColor = AppColors.blackColor
        self.contentView.backgroundColor = UIColor.clear
        self.editLabel.font = AppFonts.Comfortaa_Regular_0.withSize(12)
        self.editLabel.textColor = AppColors.whiteColor
        self.deleteLabel.font = AppFonts.Comfortaa_Regular_0.withSize(12)
        self.deleteLabel.textColor = AppColors.whiteColor
        self.editStackView.backgroundColor = AppColors.themeBlueColor
        self.deleteStackView.backgroundColor = AppColors.noDataFound
        
        self.ownerName.font = AppFonts.Comfortaa_Regular_0.withSize(12.9)
        self.ownerName.textColor = AppColors.blackColor
        self.timeLabel.font = AppFonts.Comfortaa_Regular_0.withSize(11)
        self.timeLabel.textColor = AppColors.dateTimeColor
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView(model: GreetingListModel) {
        self.greetingImage.setImage(withSDWeb: model.greeting, placeholderImage: AppImages.myprofilePlaceholder)
        self.greetingName.text = model.title
        self.ownerName.text = model.share_by

        self.timeLabel.text = self.calculateTime(shareTime: model.share_time)
    }
    
    func sentSetting() {
        self.ownerName.isHidden = true
        self.timeLabel.isHidden = false
        self.editStackView.isHidden = true
        self.deleteStackView.isHidden = false
        self.editOptionBackView.isHidden = true
        self.deleteOptionBackView.isHidden = false
    }
    
    func draftSetting() {
        self.ownerName.isHidden = true
        self.timeLabel.isHidden = false
        self.editStackView.isHidden = false
        self.deleteStackView.isHidden = false
        self.editOptionBackView.isHidden = false
        self.deleteOptionBackView.isHidden = false
    }
    
    func receiveSetting() {
        self.ownerName.isHidden = false
        self.timeLabel.isHidden = false
        self.editStackView.isHidden = true
        self.deleteStackView.isHidden = false
        self.editOptionBackView.isHidden = true
        self.deleteOptionBackView.isHidden = false
    }
    
    func calculateTime(shareTime: String) -> String {
        
        if let sTime = shareTime.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            
            //let endTime = Date().toString(dateFormat: DateFormat.shortDate.rawValue)
            
            //guard let eTime = endTime.toDate(dateFormat: DateFormat.shortDate.rawValue) else { return "0 Min" }
            
            let int = Date().timeIntervalSince(sTime)
            let days = int.days
            let hours = int.hours
            let mins = int.minutes
            
            if days > 1 {
                return "\(days) Days"
            } else if days == 1 {
                return "1 Day"
            } else {
                if hours > 1 {
                    return "\(hours) Hours"
                } else if hours == 1 {
                    return "1 Hour"
                } else {
                    if mins > 1 {
                        return "\(mins) Mins"
                    } else if mins == 1 {
                        return "1 Min"
                    } else {
                        return "0 Min"
                    }
                }
            }
        }
        return "0 Min"
    }
    
}
