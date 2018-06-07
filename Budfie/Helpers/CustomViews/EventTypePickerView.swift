//
//  EventTypePickerView.swift
//  Budfie
//
//  Created by Aakash Srivastav on 09/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class EventTypePickerView: UIView {

    var pickerlabel: UILabel!
    var pickerImage: UIImageView!

    var containerStackView: UIStackView!
    var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {

        pickerlabel = UILabel()
        pickerImage = UIImageView()
        contentView = UIView()

        containerStackView = UIStackView(arrangedSubviews: [pickerlabel, pickerImage])
        contentView.addSubview(containerStackView)
        addSubview(contentView)

        pickerlabel.font = AppFonts.AvenirNext_Medium.withSize(20)
        pickerlabel.textColor = .black
        pickerlabel.textAlignment = .left
        pickerlabel.numberOfLines = 1
        pickerlabel.lineBreakMode = .byTruncatingTail
        pickerlabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        pickerlabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        pickerImage.contentMode = .scaleAspectFill
        pickerImage.setContentHuggingPriority(.defaultHigh, for: .vertical)
        pickerImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        pickerImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        pickerImage.heightAnchor.constraint(equalToConstant: 42).isActive = true

        containerStackView.alignment = .center
        containerStackView.axis = .horizontal
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = 8

        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        pickerlabel.translatesAutoresizingMaskIntoConstraints = false
        pickerImage.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
}
