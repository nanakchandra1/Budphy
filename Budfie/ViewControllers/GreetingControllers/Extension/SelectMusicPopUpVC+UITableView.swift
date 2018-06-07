//
//  SelectMusicPopUpVC+UITableView.swift
//  Budfie
//
//  Created by yogesh singh negi on 09/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

// MARK:- Extension for tableview Delegate And DataSource
//=======================================================
extension SelectMusicPopUpVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let number = self.childCategory?.count else { return 0 }
//        return number
        return self.songNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let selectMusicCell = tableView.dequeueReusableCell(withIdentifier: "SelectMusicPopUpCell") as? SelectMusicPopUpCell else { fatalError("SelectMusicPopUpCell not found") }

        if self.selectedRow == indexPath.row {
            selectMusicCell.radioImageBtn.setImage(AppImages.icChooseMusicRadioOn, for: .normal)
        } else {
            selectMusicCell.radioImageBtn.setImage(AppImages.icChooseMusicRadioOff, for: .normal)
        }
        selectMusicCell.radioTextLabel.text = songNames[indexPath.row]
        selectMusicCell.radioImageBtn.addTarget(self,
                                                     action: #selector(selectedRowBtnTapped(_:)),
                                                     for: .touchUpInside)
        return selectMusicCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.selectedRow = indexPath.row
        self.selectedMusic = self.songs[indexPath.row]
        self.popUpTableView.reloadData()

        audioPlayer.stop()

        if let musicPathString = selectedMusic,
            let path = Bundle.main.path(forResource: musicPathString, ofType: ".mp3"),
            let musicURL = URL(string: "file://\(path)") {
            audioPlayer.play(from: musicURL)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


// MARK:- SelectMusicPopUpCell Prototype Cell Class
//=================================================
class SelectMusicPopUpCell: UITableViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var radioImageBtn: UIButton!
    @IBOutlet weak var radioTextLabel: UILabel!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.radioTextLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.radioTextLabel.textColor = AppColors.blackColor
        self.radioImageBtn.setImage(AppImages.icChooseMusicRadioOff, for: .normal)
        self.contentView.backgroundColor = UIColor.clear
        radioImageBtn.isUserInteractionEnabled = false
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            self.radioImageBtn.setImage(AppImages.icChooseMusicRadioOn, for: .normal)
//        } else {
//            self.radioImageBtn.setImage(AppImages.icChooseMusicRadioOff, for: .normal)
//        }
//    }
    
}
