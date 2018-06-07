//
//  SentImageVideoMessageCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage
import SwiftyJSON

class SentImageVideoMessageCell: UITableViewCell {

    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!

    @IBOutlet weak var msgImageView: FLAnimatedImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var msgTimeLbl: UILabel!

    @IBOutlet weak var msgDetailContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        senderImageView.roundCornerWith(radius: 35)
        senderImageView.border(width: 1.5, borderColor: .white)

        msgDetailContainerView.addShadow(ofColor: .gray, radius: 2, offset: CGSize(width: 0, height: 2), opacity: 1)
        msgDetailContainerView.layer.cornerRadius = 44.5/2
        msgImageView.layer.cornerRadius = 5
        msgDetailContainerView.layer.masksToBounds = false
        msgDetailContainerView.backgroundColor = AppColors.sentMessageColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        senderNameLbl.text = nil
        senderImageView.image = nil
        msgImageView.image = nil
        msgTimeLbl.text = nil
        //msgDetailContainerView.backgroundColor = .white
    }

    func populate(with message: ChatMessage) {

        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(message.senderId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongSelf = self,
                let value = snapshot.value else {
                    return
            }

            let json = JSON(value)
            let member = ChatMember(with: json)

            strongSelf.senderNameLbl.text = nil //"\(member.firstName) \(member.lastName)"
            strongSelf.senderImageView.setImage(withSDWeb: member.profilePic, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
        }

        switch message.type {
        case .video:
            videoImageView.isHidden = false
            msgImageView.setImage(withSDWeb: message.mediaUrl, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))

        case .image, .sticker, .emoji:
            videoImageView.isHidden = true

            switch message.type {
            case .image:
                 msgImageView.setImage(withSDWeb: message.mediaUrl, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
            case .sticker, .emoji:
                if let image = UIImage(named: message.mediaUrl) {
                    msgImageView.image = image
                } else if let asset = NSDataAsset(name: message.mediaUrl) {
                    msgImageView.image = UIImage.sd_animatedGIF(with: asset.data)
                }
            default:
                fatalError("not possible")
            }
        default:
            break
        }

        /*
         let messageColor = message.color
         if !messageColor.isEmpty {
         msgDetailContainerView.backgroundColor = UIColor(hexString: message.color)
         }
         */

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
