//
//  ChatListCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 25/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    enum CellType {
        case chatList
        case addParticipant
    }

    var type: CellType = .chatList {
        didSet {

            guard oldValue != type else {
                return
            }

            switch type {
            case .chatList:
                checkboxImageView.isHidden = true

            case .addParticipant:
                lastMsgTimeLbl.isHidden = true
                lastMsgContainerStackView.isHidden = true
                checkboxImageView.isHidden = false
                senderImageView.layer.borderWidth = 0
                chatColorViewWidth.constant = 0
                chatColorView.isHidden = true
            }
        }
    }

    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var lastMsgLbl: UILabel!
    @IBOutlet weak var lastMsgTimeLbl: UILabel!

    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var lastMsgStatusImageView: UIImageView!

    @IBOutlet weak var chatColorView: UIView!
    @IBOutlet weak var chatColorViewWidth: NSLayoutConstraint!

    @IBOutlet weak var lastMsgContainerStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()

        checkboxImageView.isHidden = true
        senderImageView.layer.cornerRadius = 55/2
        senderImageView.layer.borderWidth = 3/2
        lastMsgStatusImageView.tintColor = AppColors.themeBlueColor
        chatColorView.backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        senderNameLbl.text = nil
        lastMsgLbl.text = nil
        lastMsgTimeLbl.text = nil

        senderImageView.image = nil
        checkboxImageView.image = nil
        lastMsgStatusImageView.image = nil

        lastMsgStatusImageView.isHidden = false

        chatColorView.backgroundColor = .clear
        senderImageView.layer.borderColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)

        guard type == .addParticipant else {
            return
        }
        checkboxImageView.image = (selected ? #imageLiteral(resourceName: "popupCheck"):#imageLiteral(resourceName: "popupUncheck"))
    }

    func populate(with chat: Inbox) {

        let profilePlaceholder: UIImage
        switch chat.avatar {
        case 1:
            profilePlaceholder = #imageLiteral(resourceName: "profileMale")
        case 2:
            profilePlaceholder = #imageLiteral(resourceName: "profileFemale")
        default:
            profilePlaceholder = #imageLiteral(resourceName: "myprofilePlaceholder")
        }
        senderImageView.sd_cancelCurrentImageLoad()
        senderImageView.setImage(with: chat.pic, placeholderImage: profilePlaceholder)

        if let lastMessage = chat.lastMessage {
            let isSentMessage: Bool

            if lastMessage.senderId != AppDelegate.shared.currentuser.user_id {
                lastMsgStatusImageView.isHidden = true
                isSentMessage = false

            } else {
                switch lastMessage.status {
                case .sent:
                    lastMsgStatusImageView.image = #imageLiteral(resourceName: "icChatTickSent")
                case .delivered:
                    lastMsgStatusImageView.image = #imageLiteral(resourceName: "icChatTickSent").withRenderingMode(.alwaysTemplate)
                case .read:
                    lastMsgStatusImageView.image = #imageLiteral(resourceName: "icChatTickDelivered").withRenderingMode(.alwaysTemplate)
                }
                isSentMessage = true
            }

            let color: UIColor

            switch chat.type {
            case .group, .none:
                color = AppColors.groupMessageColor

            case .single:
                color = isSentMessage ? AppColors.sentMessageColor : AppColors.receivedMessageColor
            }

            chatColorView.backgroundColor = color
            senderNameLbl.textColor = color
            senderImageView.layer.borderColor = color.cgColor

            let calendar = Calendar.current
            let currentDate = Date()
            let messageDate = Date(timeIntervalSince1970: lastMessage.timeStamp/1000)
            let currentDateStart = calendar.startOfDay(for: currentDate)

            let msgTime: String
            let components = calendar.dateComponents([.day], from: messageDate, to: currentDateStart)

            if lastMessage.timeStamp == 0 {
                msgTime = ""
            } else if let days = components.day,
                days > 1 {
                msgTime = messageDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)

            } else if messageDate < currentDateStart {
                msgTime = StringConstants.K_YESTERDAY.localized

            } else {
                msgTime = messageDate.toString(dateFormat: DateFormat.timein12Hour.rawValue)
            }

            lastMsgTimeLbl.text = msgTime
            lastMsgLbl.text = lastMessage.message

        } else {
            lastMsgStatusImageView.image = #imageLiteral(resourceName: "icChatTickSent")
        }

        senderNameLbl.text = chat.name
    }

    func populate(with friend: PhoneContact) {
        senderNameLbl.text = friend.name
        senderImageView.setImage(withSDWeb: friend.image, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
    }
}
