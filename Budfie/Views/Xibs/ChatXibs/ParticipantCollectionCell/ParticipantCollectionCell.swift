//
//  ParticipantCollectionCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage

class ParticipantCollectionCell: UICollectionViewCell {

    @IBOutlet weak var participantImageView: FLAnimatedImageView!
    @IBOutlet weak var removeBtn: UIButton!

    @IBOutlet weak var overlaySendView: UIImageView!
    @IBOutlet weak var nameInitialsLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        nameInitialsLbl.roundCornerWith(radius: 55/2)
        participantImageView.roundCornerWith(radius: 55/2)
        overlaySendView.roundCornerWith(radius: 8)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        participantImageView.image = nil
        removeBtn.removeTarget(nil, action: nil, for: .allEvents)
        overlaySendView.isHidden = true
        nameInitialsLbl.isHidden = true
        gestureRecognizers?.removeAll()
    }
}
