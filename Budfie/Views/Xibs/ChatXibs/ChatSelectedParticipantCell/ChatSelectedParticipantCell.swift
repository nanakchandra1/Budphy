//
//  ChatSelectedParticipantCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 26/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class ChatSelectedParticipantCell: UITableViewCell {

    @IBOutlet weak var participantListCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let nibName = ParticipantCollectionCell.defaultReuseIdentifier
        let nib = UINib(nibName: nibName, bundle: nil)
        participantListCollectionView.register(nib, forCellWithReuseIdentifier: nibName)
    }

    func setCollectionViewScrollDirection(_ direction: UICollectionViewScrollDirection) {
        if let layout = participantListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            direction != layout.scrollDirection {
            layout.scrollDirection = direction
        }
    }
}
