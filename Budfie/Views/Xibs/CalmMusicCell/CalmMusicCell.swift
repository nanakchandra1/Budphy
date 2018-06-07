//
//  CalmMusicCell.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class CalmMusicCell: UITableViewCell {

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var playPauseIcon: UIImageView!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
        unSelectedMusic()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unSelectedMusic()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            selectedMusic()
        } else {
            unSelectedMusic()
        }
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {
        self.contentView.backgroundColor = UIColor.clear
        playPauseIcon.image = AppImages.playCalm
    }
    
    func selectedMusic() {
        musicName.textColor = AppColors.themeBlueColor
        artistName.textColor = AppColors.themeBlueColor
        playPauseIcon.image = AppImages.pauseCalm
    }
    
    func unSelectedMusic() {
        musicName.textColor = AppColors.blackColor
        artistName.textColor = AppColors.blackColor
        playPauseIcon.image = AppImages.playCalm
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView(model: NotificationListModel) {
        
    }
}
