//
//  AddEventHeaderView.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- AddEventHeaderView class
//===============================
class AddEventHeaderView: UITableViewHeaderFooterView {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var eventsImage          : UIImageView!
    @IBOutlet weak var backgroundHeaderView : UIView!
    @IBOutlet weak var cameraImageBtn       : UIButton!
    @IBOutlet weak var addPhotoLabel        : UILabel!
    @IBOutlet weak var centerMovieBtn: UIButton!
    @IBOutlet weak var overlayView: UIView!

    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var liveLblContainerView: UIView!

    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpInitialViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.superview?.endEditing(true)
    }
    
}


//MARK:- Extension for private methods
//====================================
extension AddEventHeaderView {
    
    private func setUpInitialViews() {

        liveLblContainerView.backgroundColor = AppColors.calendarEventPink
        liveLblContainerView.roundCornerWith(radius: 2)

        self.cameraImageBtn.setImage(AppImages.profileCameraWhite, for: .normal)
        self.backgroundHeaderView.backgroundColor   = AppColors.whiteColor
        //self.headerLabel.text                       = StringConstants.Add_Event.localized
        self.addPhotoLabel.text                     = StringConstants.Add_Photo.localized
        //self.headerLabel.textColor                  = AppColors.whiteColor
        self.addPhotoLabel.textColor                = AppColors.whiteColor
        //self.headerLabel.font                       = AppFonts.AvenirNext_Medium.withSize(20)
        self.addPhotoLabel.font                     = AppFonts.Comfortaa_Light_0.withSize(13)
        //self.sideCameraBtn.isHidden                 = true
        //self.submitImageBtn.isHidden                = true
        //self.submitImageBtn.backgroundColor         = AppColors.themeBlueColor
        //self.eventsImage.backgroundColor            = AppColors.themeBlueColor
        self.centerMovieBtn.isHidden                = true
    }
    
    func setEditEvent() {
        //self.roundSubmitBtnHeightConstraint.constant = 60
        self.cameraImageBtn.isHidden                = true
        //self.submitImageBtn.isHidden                = true
        self.addPhotoLabel.isHidden                 = true
        //self.sideCameraBtn.setImage(AppImages.profileCameraWhite, for: .normal)
        //self.sideCameraBtn.isHidden                 = false
        //self.headerLabel.text = StringConstants.K_Edit_Event.localized
    }
    
    func setViewEvent() {
        //self.roundSubmitBtnHeightConstraint.constant = 60
        self.cameraImageBtn.isHidden                = true
        //self.submitImageBtn.isHidden                = false
        self.addPhotoLabel.isHidden                 = true
        //self.sideCameraBtn.setImage(AppImages.icEdit, for: .normal)
        //self.sideCameraBtn.isHidden                 = false
        //self.headerLabel.text = StringConstants.K_Edit_Event.localized
    }
    
    func setForEditProfile() {
        self.cameraImageBtn.isHidden = true
        //self.sideCameraBtn.isHidden = true
        self.addPhotoLabel.isHidden = true
        //self.submitImageBtn.isHidden = true
        //self.headerLabel.isHidden = true
        self.overlayView.isHidden = true
        //self.backBtn.isHidden = true
        //self.submitImageBtn.setImage(AppImages.profileCameraWhite, for: .normal)
        //self.headerLabel.text = StringConstants.K_Edit_Profile.localized
    }
    
    func setForMoviesOrConcert() {
        self.cameraImageBtn.isHidden    = true
        //self.sideCameraBtn.isHidden     = false
        self.addPhotoLabel.isHidden     = true
        //self.submitImageBtn.isHidden    = false
        self.centerMovieBtn.isHidden    = false
        self.centerMovieBtn.setImage(AppImages.icPlay, for: .normal)
        //self.sideCameraBtn.setImage(AppImages.icUnselectFav, for: .normal)
        //self.submitImageBtn.setImage(AppImages.icShare, for: .normal)
    }

    func setForSports() {
        setForMoviesOrConcert()
        self.centerMovieBtn.isHidden = true
    }
    
}
