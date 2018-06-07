//
//  ChatHeaderTableCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 16/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class ChatHeaderTableCell: UITableViewCell {

    @IBOutlet weak var headerLblContainerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        headerLblContainerView.addShadow(ofColor: .gray, radius: 2, offset: CGSize(width: 0, height: 2), opacity: 1)
        headerLblContainerView.roundCornerWith(radius: 27/2)
        headerLblContainerView.clipsToBounds = false
        headerLblContainerView.layer.masksToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        headerLbl.text = nil
        headerLblContainerView.backgroundColor = .white
    }

    func populate(with message: ChatMessage) {
        headerLbl.text = message.message
        let messageColor = message.color
        if !messageColor.isEmpty {
            headerLblContainerView.backgroundColor = UIColor(hexString: message.color)
        }
    }
    
}
