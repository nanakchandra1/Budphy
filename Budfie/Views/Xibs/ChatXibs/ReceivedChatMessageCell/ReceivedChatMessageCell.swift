//
//  ReceivedChatMessageCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReceivedChatMessageCell: UITableViewCell {

    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!

    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var msgTimeLbl: UILabel!

    @IBOutlet weak var msgDetailContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        msgLbl.numberOfLines = 0
        reset()

        senderImageView.roundCornerWith(radius: 35)
        senderImageView.border(width: 1.5, borderColor: .white)

        msgDetailContainerView.addShadow(ofColor: .gray, radius: 2, offset: CGSize(width: 0, height: 2), opacity: 1)
        msgDetailContainerView.layer.cornerRadius = 44.5/2
        msgDetailContainerView.layer.masksToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    private func reset() {
        senderNameLbl.text = nil
        senderImageView.image = nil
        msgLbl.text = nil
        msgTimeLbl.text = nil
        msgDetailContainerView.backgroundColor = .white
    }

    func populate(with message: ChatMessage, chatType: ChatType) {

        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(message.senderId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }

            let json = JSON(value)
            let member = ChatMember(with: json)

            if chatType != .single {
                strongSelf.senderNameLbl.text = "\(member.firstName) \(member.lastName)"
            }
            strongSelf.senderImageView.setImage(withSDWeb: member.profilePic, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
        }

        msgLbl.text = message.message

        if chatType != .single {
            let messageColor = message.color
            if !messageColor.isEmpty {
                msgDetailContainerView.backgroundColor = UIColor(hexString: message.color)
            }
        } else {
            msgDetailContainerView.backgroundColor = AppColors.receivedMessageColor
        }

        let calendar = Calendar.current
        let currentDate = Date()
        let messageDate = Date(timeIntervalSince1970: message.timeStamp/1000)
        let currentDateStart = calendar.startOfDay(for: currentDate)

        let msgTime: String
        let components = calendar.dateComponents([.day], from: messageDate, to: currentDateStart)

        if let days = components.day,
            days > 1 {
            msgTime = messageDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)

        } else if messageDate < currentDateStart {
            msgTime = StringConstants.K_YESTERDAY.localized

        } else {
            msgTime = messageDate.toString(dateFormat: DateFormat.timein12Hour.rawValue)
        }

        msgTimeLbl.text = msgTime
    }
    
}
