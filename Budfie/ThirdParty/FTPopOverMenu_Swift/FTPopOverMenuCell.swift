//
//  FTPopOverMenuCell.swift
//  FTPopOverMenu_Swift
//
//  Created by Abdullah Selek on 28/07/2017.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

class FTPopOverMenuCell: UITableViewCell {

    fileprivate lazy var configuration : FTConfiguration = {
        return FTConfiguration.shared
    }()

    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        //self.contentView.addSubview(imageView)
        return imageView
    }()

    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        //self.contentView.addSubview(label)
        //label.setContentHuggingPriority(.defaultLow, for: .vertical)
        //label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    fileprivate lazy var countLabel : UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = AppColors.calendarEventPink
        label.textColor = UIColor.white
        label.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        label.clipsToBounds = true
        label.roundCornerWith(radius: 8)
        //self.contentView.addSubview(label)
        return label
    }()

    func setupCellWith(menuName: String, menuImage: AnyObject?, menuCount: Int?) {
        self.backgroundColor = UIColor.clear

        let containerStackView = UIStackView(arrangedSubviews: [iconImageView, nameLabel, countLabel])
        containerStackView.isUserInteractionEnabled = false
        contentView.addSubview(containerStackView)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        containerStackView.alignment = .center
        containerStackView.axis = .horizontal
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = 5

        countLabel.widthAnchor.constraint(equalToConstant: 16).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true

        containerStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        // Configure cell text
        nameLabel.font = configuration.textFont
        nameLabel.textColor = configuration.textColor
        nameLabel.textAlignment = configuration.textAlignment
        countLabel.textAlignment = configuration.textAlignment

        nameLabel.text = menuName
        //nameLabel.frame = CGRect(x: FT.DefaultCellMargin, y: 0, width: configuration.menuWidth - FT.DefaultCellMargin*2, height: configuration.menuRowHeight)
        
        // Configure cell icon if available
        var iconImage: AnyObject? = nil
        if let menuImage = menuImage {
            if menuImage is String {
                iconImage = UIImage(named: menuImage as! String)
            } else {
                if menuImage is UIImage {
                    iconImage = menuImage
                }
            }
            if iconImage != nil {
                if  configuration.ignoreImageOriginalColor {
                    iconImage = iconImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                }
                iconImageView.tintColor = configuration.textColor
                iconImageView.image = iconImage as? UIImage

                //iconImageView.frame =  CGRect(x: FT.DefaultCellMargin, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)

                //nameLabel.frame = CGRect(x: FT.DefaultCellMargin*2 + configuration.menuIconSize, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: (configuration.menuWidth - configuration.menuIconSize - FT.DefaultCellMargin*3), height: configuration.menuIconSize)
            }
        } else {
            iconImageView.isHidden = true
        }

        if let count = menuCount, count != 0 {
            countLabel.text = count.toString
        } else {
            countLabel.isHidden = true
        }
    }
}
