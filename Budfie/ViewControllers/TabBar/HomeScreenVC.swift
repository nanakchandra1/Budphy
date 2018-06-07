//
//  HomeScreenVC.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK: HomeScreenVC class
//========================
class HomeScreenVC: BaseVc {

    var transition = PopAnimator()
    var selectedButton : UIButton!
    
    //MARK: @IBOutlet
    //===============
//    @IBOutlet weak var statusBar        : UIView!
//    @IBOutlet weak var navBar           : CurvedNavigationView!
//    @IBOutlet weak var navTitle         : UILabel!
    @IBOutlet weak var centerView       : PolygonalView!
    @IBOutlet weak var chatView         : PolygonalView!
    @IBOutlet weak var eventsView       : PolygonalView!
    @IBOutlet weak var greetingView     : PolygonalView!
    @IBOutlet weak var shoppingView     : PolygonalView!
    @IBOutlet weak var timeoutView      : PolygonalView!
    @IBOutlet weak var holidayPlanning  : PolygonalView!
    @IBOutlet weak var holidayLabel     : UILabel!
    @IBOutlet weak var chatLabel        : UILabel!
    @IBOutlet weak var eventLabel       : UILabel!
    @IBOutlet weak var greetingLabel    : UILabel!
    @IBOutlet weak var shoppingLabel    : UILabel!
    @IBOutlet weak var timeOutLabel     : UILabel!
    @IBOutlet weak var backImage        : UIImageView!
    @IBOutlet weak var versionLbl       : UILabel!
    @IBOutlet weak var versionContainerView: UIView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLbl.text = AppDelegate.shared.buildVersionNumber
        
        //        self.chatView.border(width: 4, borderColor: AppColors.whiteColor)
        self.initialSetUp()
        contactStoreDidChange()

        NotificationCenter.default.addObserver(
            self, selector: #selector(contactStoreDidChange), name: .CNContactStoreDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.centerView.borderColor = AppColors.homegray
        self.centerView.borderWidth = 3
//        self.centerView.dropShadow(width: 5, shadow: AppColors.homegray)
        self.setBorder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .CNContactStoreDidChange, object: nil)
    }

    @objc func contactStoreDidChange() {
        DispatchQueue.main.async {
            AppDelegate.shared.initialiseDataOfFriendsWithServiceHit()
        }
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func chatBtnTapped(_ sender: UIButton) {
        //        self.selectedButton = sender
        self.jumpToTabBarWithSelectedPage(tabBarState: .Chat)
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func eventsBtnTapped(_ sender: UIButton) {
        //        self.selectedButton = sender
        self.jumpToTabBarWithSelectedPage(tabBarState: .Event)
    }
    
    @IBAction func greetingBtnTapped(_ sender: UIButton) {
        //        self.selectedButton = sender
        self.jumpToTabBarWithSelectedPage(tabBarState: .Greeting)
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func shoppingBtnTapped(_ sender: UIButton) {

        let giftingScene = GiftsVC.instantiate(fromAppStoryboard: .Events)
        giftingScene.vcState = .home
        self.navigationController?.pushViewController(giftingScene, animated: true)
    }
    
    @IBAction func timeOutBtnTapped(_ sender: UIButton) {
        //        self.selectedButton = sender
        self.jumpToTabBarWithSelectedPage(tabBarState: .TimeOut)
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func holidayPlannerBtnTapped(_ sender: UIButton) {
        //        self.selectedButton = sender
        let holidayPlannerScene = HolidayPlannerVC.instantiate(fromAppStoryboard: .HolidayPlanner)
        holidayPlannerScene.vcType = .holidayPlan
        //        self.presentWithAnimation(obj: holidayPlannerScene)
        self.navigationController?.pushViewController(holidayPlannerScene, animated: true)
        //self.jumpToTabBarWithSelectedPage(tabBarState: .Menu)
        //CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func cernterBtnTapped(_ sender: UIButton) {
        //        self.selectedButton = sender
        // AppDelegate.shared.sharedTabbar.hideTabbar()
        let obMyProfileVC = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        obMyProfileVC.state = .homeScreen
        //        self.presentWithAnimation(obj: obMyProfileVC)
        self.navigationController?.pushViewController(obMyProfileVC, animated: true)
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    //    @IBAction func logOutBtnTapped(_ sender: UIButton) {
    //
    //        CommonClass.showToast(msg: "Logged Out Successfully!!!")
    //        ContactsController.shared.deleteContacts()
    //        AppUserDefaults.removeAllValues()
    //        let obLogInVC = LogInVC.instantiate(fromAppStoryboard: .Login)
    //        self.navigationController?.pushViewController(obLogInVC, animated: true)
    //    }
    
}

//MARK: Extension for InitialSetup and private methods
//====================================================
extension HomeScreenVC {
    
    func initialSetUp() {
       
//        self.statusBar.backgroundColor = AppColors.themeBlueColor
//        self.navBar.backgroundColor = UIColor.clear
//        self.navTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
//        self.navTitle.textColor = AppColors.whiteColor
        
        let fontSize: CGFloat = 18
        
        self.holidayLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
        self.holidayLabel.textColor = AppColors.blackColor
        self.holidayLabel.text = StringConstants.K_Holiday_Planner.localized
        
        self.greetingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
        self.greetingLabel.textColor = AppColors.blackColor
        self.greetingLabel.text = StringConstants.K_Greetings.localized
        
        self.timeOutLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
        self.timeOutLabel.textColor = AppColors.blackColor
        self.timeOutLabel.text = StringConstants.K_Time_Out.localized
        
        self.eventLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
        self.eventLabel.textColor = AppColors.blackColor
        self.eventLabel.text = StringConstants.K_Planner.localized
        
        self.chatLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
        self.chatLabel.textColor = AppColors.blackColor
        self.chatLabel.text = StringConstants.K_Chats.localized
        
        self.shoppingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
        self.shoppingLabel.textColor = AppColors.blackColor
        self.shoppingLabel.text = "Gifting"
        
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "1" {
            GoogleLoginController.shared.loginWithEventFetch(completion: { (events, error) in

                if error != nil {
                    AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                    //self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                }
            })
        }
        self.setBackground()
        self.appleHomeEffect()
    }
    
    func setBackground() {
        
        self.timeoutView.backgroundColor = AppColors.homeTimeOut
        self.holidayPlanning.backgroundColor = AppColors.homeHoliday
        self.chatView.backgroundColor = AppColors.homeChat
        self.eventsView.backgroundColor = AppColors.homeEvents
        self.greetingView.backgroundColor = AppColors.homeGreeting
        self.shoppingView.backgroundColor = AppColors.homeShopping
        self.centerView.backgroundColor = AppColors.eventSaperator
    }
    
    func setBorder() {
        
        let borderWidth: CGFloat = 6.0
        
        self.chatView.borderWidth           = borderWidth
        self.eventsView.borderWidth         = borderWidth
        self.timeoutView.borderWidth        = borderWidth
        self.greetingView.borderWidth       = borderWidth
        self.holidayPlanning.borderWidth    = borderWidth
        self.shoppingView.borderWidth       = borderWidth
        
//        self.centerView.dropShadow(width: 5, shadow: AppColors.homegray)
        
        self.chatView.borderColor = AppColors.homegray
        self.eventsView.borderColor = AppColors.homegray
        self.greetingView.borderColor = AppColors.homegray
        self.timeoutView.borderColor = AppColors.homegray
        self.holidayPlanning.borderColor = AppColors.homegray
        self.shoppingView.borderColor = AppColors.homegray
        
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
    
    func jumpToTabBarWithSelectedPage(tabBarState : TabBarState) {
        
        let tabVc = TabBarVC.instantiate(fromAppStoryboard: .Events)
        tabVc.tabBarState = tabBarState
//        AppDelegate.shared.sharedTabbar = tabVc
        //        self.presentWithAnimation(obj: tabVc)
        self.navigationController?.pushViewController(tabVc, animated: true)
    }
    
    func presentWithAnimation(obj : BaseVc) {
        let nvc = AvoidingMultiPushNavigationController(rootViewController: obj)
        nvc.isNavigationBarHidden = true
        nvc.transitioningDelegate = self
        self.present(nvc, animated: true, completion: nil)
        //    self.navigationController?.pushViewController(obj, animated: true)
    }
    
}


extension HomeScreenVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.originFrame =
            selectedButton!.superview!.convert(selectedButton!.frame, to: nil)
        
        transition.presenting = true
        //        selectedButton!.isHidden = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}
