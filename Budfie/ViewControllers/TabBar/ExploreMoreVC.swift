//
//  ExploreMoreVC.swift
//  beziarPath
//
//  Created by yogesh singh negi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class ExploreMoreVC: BaseVc {
    
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var openPhotoBtn: UIButton!
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var settingsBackView: PolygonalView!
    @IBOutlet weak var notificationsBackView: PolygonalView!
    @IBOutlet weak var shoppingBackView: UIView!
    @IBOutlet weak var holidayPlannerBackView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var shoppingLabel: UILabel!
    @IBOutlet weak var holidayPlannerLabel: UILabel!
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var notificationsImageView: UIImageView!
    @IBOutlet weak var shoppingImageView: UIImageView!
    @IBOutlet weak var holidayPlannerImageView: UIImageView!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var notificationsBtn: UIButton!
    @IBOutlet weak var shoppingBtn: UIButton!
    @IBOutlet weak var holidayPlannerBtn: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.photoNameLabel.text = "\(AppDelegate.shared.currentuser.first_name) \(AppDelegate.shared.currentuser.last_name)"
        self.photoImageView.setImage(withSDWeb: AppDelegate.shared.currentuser.image, placeholderImage: AppImages.icMorePlaceholder)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.setProfilePhotoViews()
        self.setCornerRadius()
        self.setBorder()
    }
    
    @IBAction func landingPageBtnTapped(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.parent?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func photoBtnTapped(_ sender: UIButton) {
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let obMyProfileVC = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        obMyProfileVC.state = .exploreMore
        self.navigationController?.pushViewController(obMyProfileVC, animated: true)
    }
    
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        //        CommonClass.showToast(msg: "Under Development")
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let ob = SettingsVC.instantiate(fromAppStoryboard: .Settings)
        ob.state = .exploreMore
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    @IBAction func notificationsBtnTapped(_ sender: UIButton) {
        
        let scene = NotificationsVC.instantiate(fromAppStoryboard: .Settings)
        scene.vcState = .exploreMore
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
    @IBAction func shoppingBtnTapped(_ sender: UIButton) {
//        CommonClass.showToast(msg: "Under Development")
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let giftingScene = GiftsVC.instantiate(fromAppStoryboard: .Events)
        giftingScene.vcState = .exploreMore
        self.navigationController?.pushViewController(giftingScene, animated: true)
    }
    
    @IBAction func holidayBtnTapped(_ sender: UIButton) {
//        CommonClass.showToast(msg: "Under Development")
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let holidayPlannerScene = HolidayPlannerVC.instantiate(fromAppStoryboard: .HolidayPlanner)
        holidayPlannerScene.vcType = .exploreMore
        self.navigationController?.pushViewController(holidayPlannerScene, animated: true)
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension ExploreMoreVC {
    
    private func initialSetup() {
        
        // set header view..
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navigationView.backgroundColor = UIColor.clear
        self.navigationTitle.text           = "Explore More"
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        self.homeBtn.setImage(AppImages.eventsHomeLogo, for: .normal)
        
        self.openPhotoBtn.backgroundColor   = AppColors.themeBlueColor
        self.openPhotoBtn.setImage(AppImages.icEdit, for: .normal)
    
        self.photoNameLabel.textColor = AppColors.blackColor
        self.photoNameLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15,
                                                                      iphone6: 17,
                                                                      iphone6p: 18)
        self.settingsBackView.isHidden = true
        self.notificationsBackView.isHidden = true
        self.settingLabel.isHidden = true
        self.notificationsLabel.isHidden = true
        self.settingsBtn.isHidden = true
        self.notificationsBtn.isHidden = true
        self.settingImageView.isHidden = true
        self.notificationsImageView.isHidden = true
        self.setLabels()
        self.setImages()
        self.rotateViews()
        self.setBackViews()
        self.appleHomeEffect()
    }
    
    func setLabels() {
        self.settingLabel.text          = StringConstants.K_Settings.localized
        self.notificationsLabel.text    = StringConstants.K_Notifications.localized
        self.shoppingLabel.text         = "Gifting"
        self.holidayPlannerLabel.text   = StringConstants.K_Holiday_Planner.localized
        
        self.settingLabel.textColor         = AppColors.blackColor
        self.notificationsLabel.textColor   = AppColors.blackColor
        self.shoppingLabel.textColor        = AppColors.blackColor
        self.holidayPlannerLabel.textColor  = AppColors.blackColor
        
        self.settingLabel.font          = AppFonts.Comfortaa_Bold_0.withSize(14,
                                                                             iphone6: 17,
                                                                             iphone6p: 18)
        self.notificationsLabel.font    = AppFonts.Comfortaa_Bold_0.withSize(14,
                                                                             iphone6: 17,
                                                                             iphone6p: 18)
        self.shoppingLabel.font         = AppFonts.Comfortaa_Bold_0.withSize(14,
                                                                             iphone6: 17,
                                                                             iphone6p: 18)
        self.holidayPlannerLabel.font   = AppFonts.Comfortaa_Bold_0.withSize(14,
                                                                             iphone6: 17,
                                                                             iphone6p: 18)
    }
    
    func setImages() {
        self.settingImageView.image         = AppImages.icSettings
        self.notificationsImageView.image   = AppImages.icNotification
        self.shoppingImageView.image        = AppImages.icShopping
        self.holidayPlannerImageView.image  = AppImages.icHp
    }
    
    func setProfilePhotoViews() {
        self.photoImageView.roundCorners()
        self.openPhotoBtn.layer.cornerRadius = self.openPhotoBtn.frame.width / 2
       
        self.openPhotoBtn.border(width: 2, borderColor: AppColors.whiteColor)
    }
    
    func setBackViews() {
        self.settingsBackView.backgroundColor       = AppColors.settingsColor
        self.holidayPlannerBackView.backgroundColor = AppColors.homeHoliday
        self.notificationsBackView.backgroundColor  = AppColors.notificationsColor
        self.shoppingBackView.backgroundColor       = AppColors.homeShopping
    }
    
    func rotateViews() {
        let angel = CGFloat.pi/2
        self.settingsBackView.transform         = CGAffineTransform(rotationAngle: angel)
        self.holidayPlannerBackView.transform   = CGAffineTransform(rotationAngle: angel)
        self.notificationsBackView.transform    = CGAffineTransform(rotationAngle: angel)
        self.shoppingBackView.transform         = CGAffineTransform(rotationAngle: angel)
    }
    
    func setBorder() {
        let border: CGFloat = 3
        self.settingsBackView.borderWidth               = border
        self.holidayPlannerBackView.layer.borderWidth   = border
        self.shoppingBackView.layer.borderWidth         = border
        self.notificationsBackView.borderWidth          = border

        self.holidayPlannerBackView.layer.borderColor   = AppColors.homegray.cgColor
        self.shoppingBackView.layer.borderColor         = AppColors.homegray.cgColor

        self.holidayPlannerBackView.layer.cornerRadius  = self.holidayPlannerBackView.width/2
        self.shoppingBackView.layer.cornerRadius        = self.shoppingBackView.width/2
    }
    
    func setCornerRadius() {
        var cornerRadius: CGFloat = 0.0
        if screenWidth < 322 {
            cornerRadius = 30.0
        } else {
            cornerRadius = 35.0
        }
        self.settingsBackView.layer.cornerRadius           = cornerRadius
        self.holidayPlannerBackView.layer.cornerRadius     = cornerRadius
        self.shoppingBackView.layer.cornerRadius           = cornerRadius
        self.notificationsBackView.layer.cornerRadius      = cornerRadius
    }
    
    private func appleHomeEffect() {
        
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        
        self.backImage.addMotionEffect(motionEffectGroup)
    }
    
}

