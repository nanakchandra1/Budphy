//
//  SentVoiceMessageCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit
import SwiftyJSON

class SentVoiceMessageCell: UITableViewCell {

    private let playImage = #imageLiteral(resourceName: "icMusicPlay").withRenderingMode(.alwaysTemplate)
    private let pauseImage = #imageLiteral(resourceName: "icMusicPause").withRenderingMode(.alwaysTemplate)

    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!

    @IBOutlet weak var audioPlayPauseBtn: UIButton!
    @IBOutlet weak var audioTimeLbl: UILabel!
    @IBOutlet weak var msgTimeLbl: UILabel!

    @IBOutlet weak var audioLengthIndicatorView: UIView!
    @IBOutlet weak var playedAudioLengthIndicatorViewWidth: NSLayoutConstraint!
    @IBOutlet weak var audioThumbHandleView: UIView!

    @IBOutlet weak var msgDetailContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        senderImageView.roundCornerWith(radius: 35)
        senderImageView.border(width: 1.5, borderColor: .white)

        msgDetailContainerView.addShadow(ofColor: .gray, radius: 2, offset: CGSize(width: 0, height: 2), opacity: 1)
        msgDetailContainerView.layer.cornerRadius = 44.5/2
        msgDetailContainerView.layer.masksToBounds = false

        audioThumbHandleView.roundCornerWith(radius: 6)
        msgDetailContainerView.backgroundColor = AppColors.sentMessageColor

        audioPlayPauseBtn.tintColor = .black
        audioPlayPauseBtn.setImage(playImage, for: .normal)
        playedAudioLengthIndicatorViewWidth.constant = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        senderNameLbl.text = nil
        senderImageView.image = nil
        audioTimeLbl.text = nil
        msgTimeLbl.text = nil
        //msgDetailContainerView.backgroundColor = .white

        playedAudioLengthIndicatorViewWidth.constant = 0
        audioPlayPauseBtn.setImage(playImage, for: .normal)

        audioThumbHandleView.gestureRecognizers?.removeAll()
    }

    func populate(with message: ChatMessage, playedMessageId: String?, progress: Float, isPlaying: Bool) {

        if message.messageId == playedMessageId {
            updateAudioPlayer(progress, isPlaying)
        }

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

    func updateAudioPlayer(_ progress: Float, _ isPlaying: Bool) {
        playedAudioLengthIndicatorViewWidth.constant = max(0, min(133, (133 * CGFloat(progress))))
        let btnImage = isPlaying ? pauseImage:playImage
        audioPlayPauseBtn.setImage(btnImage, for: .normal)
    }
}
