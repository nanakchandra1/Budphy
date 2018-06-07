//
//  NotificationCell.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage

class NotificationCell: UITableViewCell {

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var notificationImage: FLAnimatedImageView!
    @IBOutlet weak var greetingName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var leadingBackView: NSLayoutConstraint!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteStackView: UIStackView!
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

        self.notificationImage.roundCornerWith(radius: radius)
        self.backView.roundCornerWith(radius: radius)

        self.mainView.roundCornerWith(radius: radius)
        self.shadowView.roundCornerWith(radius: radius)

        self.shadowView.dropShadow(width: 3.7, shadow: AppColors.shadowViewColor)
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {
        self.greetingName.font = AppFonts.Comfortaa_Bold_0.withSize(12)
        self.greetingName.textColor = AppColors.blackColor
        self.contentView.backgroundColor = UIColor.clear
        self.deleteLabel.font = AppFonts.Comfortaa_Regular_0.withSize(12)
        self.deleteLabel.textColor = AppColors.whiteColor
        self.deleteStackView.backgroundColor = AppColors.noDataFound
        self.timeLabel.font = AppFonts.Comfortaa_Regular_0.withSize(11)
        self.timeLabel.textColor = AppColors.dateTimeColor
    }
    
    func readNotification() {
        self.timeLabel.textColor = AppColors.menuBarColor
        self.greetingName.textColor = AppColors.menuBarColor
    }
    
    func unReadNotification() {
        self.greetingName.textColor = AppColors.blackColor
        self.timeLabel.textColor = AppColors.dateTimeColor
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView(model: NotificationListModel) {
        
        self.greetingName.text = model.event_name
        self.timeLabel.text = self.calculateTime(shareTime: model.notification_time)
        
        if model.read_status == "0" {
            unReadNotification()
        } else {
            readNotification()
        }

        let image: UIImage
        //self.notificationImage.setImage(withSDWeb: model.event_image, placeholderImage: AppImages.myprofilePlaceholder)

        switch model.notification_type {
        case 1:     // event invitation
            image = #imageLiteral(resourceName: "icNotificationPartInvite")
        case 2:     // Accept Event Invitation
            image = #imageLiteral(resourceName: "icNotificationPartOthers")
        case 3:     // Received Greeting
            image = #imageLiteral(resourceName: "icNotificationPartOthers")
        case 4:     // User Birthday
            image = #imageLiteral(resourceName: "icNotificationPartOthers")
        case 5:     // Friend's  Birthday
            image = #imageLiteral(resourceName: "icNotificationPartOthers")
        case 6:     // Event Notification
            switch model.category {
            case 1: // personal event
                image = #imageLiteral(resourceName: "icNotificationPartOthers")
            case 2: // concert event
                image = #imageLiteral(resourceName: "icNotificationPartOthers")
            case 3: //movies event
                image = #imageLiteral(resourceName: "icNotificationPartMovie")
            case 4: // cricket event
                image = #imageLiteral(resourceName: "icNotificationPartMatch")
            case 5: //football event
                image = #imageLiteral(resourceName: "icNotificationPartMatch")
            case 6: // badminton event
                image = #imageLiteral(resourceName: "icNotificationPartMatch")
            case 7: // tennis event
                image = #imageLiteral(resourceName: "icNotificationPartMatch")
            default:
                image = #imageLiteral(resourceName: "icNotificationPartOthers")
            }
        case 7:     // Event_reminder
            image = #imageLiteral(resourceName: "icNotificationPartOthers")
        case 9:     // Call
            image = #imageLiteral(resourceName: "icNotificationPartCall")
        case 10:    // Health reminder
            image = #imageLiteral(resourceName: "icNotificationPartHealth")
        case 11:    // Bill pay reminder
            image = #imageLiteral(resourceName: "icNotificationPartBillPayment")
        default:
            image = #imageLiteral(resourceName: "icNotificationPartOthers")
        }

        notificationImage.image = image
    }
    
    //MARK: Populate cell method
    //==========================
    func populateInvitationView(model: InvitationModel) {
        
        self.notificationImage.setImage(withSDWeb: model.eventImage, placeholderImage: AppImages.myprofilePlaceholder)

        if let eventDate = model.eventDate.toDate(dateFormat: DateFormat.calendarDate.rawValue),
            let eventTime = model.eventTime.toDate(dateFormat: DateFormat.fullTime.rawValue) {
            let dateString = eventDate.toString(dateFormat: "dd MMM yyy")
            let timeString = eventTime.toString(dateFormat: DateFormat.timein12Hour.rawValue)
            self.timeLabel.text = "\(dateString) at \(timeString)"
        }
        unReadNotification()
    }
    
    func calculateTime(shareTime: String) -> String {
        
        if let sTime = shareTime.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            
            let endTime = Date().toString(dateFormat: DateFormat.shortDate.rawValue)
            
            guard let eTime = endTime.toDate(dateFormat: DateFormat.shortDate.rawValue) else { return "0 Min" }
            
            let int = eTime.timeIntervalSince(sTime)
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
