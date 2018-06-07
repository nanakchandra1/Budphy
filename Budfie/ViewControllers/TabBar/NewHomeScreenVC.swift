//
//  NewHomeScreenVC.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

//MARK: NewHomeScreenVC class
//========================
class NewHomeScreenVC: BaseVc {

    var transition = PopAnimator()
    var selectedButton : UIButton!
    var shouldAnimatedOnAppearance = true

    //MARK: @IBOutlet
    //===============

    @IBOutlet weak var buddyImageView       : UIImageView!
    @IBOutlet weak var changeBuddyBtn       : UIButton!

    @IBOutlet weak var backImage            : UIImageView!
    @IBOutlet weak var versionLbl           : UILabel!
    @IBOutlet weak var versionContainerView : UIView!
    @IBOutlet weak var budfieLogoStackView  : UIStackView!

    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

        versionLbl.text = AppDelegate.shared.buildVersionNumber

        self.initialSetUp()
        contactStoreDidChange()

        NotificationCenter.default.addObserver(
            self, selector: #selector(contactStoreDidChange), name: .CNContactStoreDidChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .default

        if shouldAnimatedOnAppearance {
            animatedBuddyImageView()
        }
        shouldAnimatedOnAppearance = false
        AppDelegate.shared.registerUserNotifications()
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

    deinit {
        NotificationCenter.default.removeObserver(self, name: .CNContactStoreDidChange, object: nil)
    }

    @objc func contactStoreDidChange() {
        DispatchQueue.main.async {
            AppDelegate.shared.initialiseDataOfFriendsWithServiceHit()
        }
    }

    fileprivate func animatedBuddyImageView() {
        UIView.animate(withDuration: 0.8) {
            self.buddyImageView.transform = .identity
        }
    }

    //MARK: @IBAction
    //===============
    @IBAction func changeBuddyBtnTapped(_ sender: UIButton) {
        let chooseBuddyScene = ChooseBuddyVC.instantiate(fromAppStoryboard: .Login)
        chooseBuddyScene.delegate = self
        navigationController?.pushViewController(chooseBuddyScene, animated: true)
    }

    @IBAction func fortuneCookieBtnTapped(_ sender: UIButton) {
        let fortuneCookieScene = FortuneCookieVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(fortuneCookieScene, animated: true)
    }

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
        goToProfile()
    }
}

extension NewHomeScreenVC: BuddyDelegate {

    func didChangeBuddy(to buddy: ChooseBuddyVC.Buddy) {
        AppUserDefaults.save(value: buddy.rawValue, forKey: .selectedBuddy)
        changeBuddyPic(for: buddy)
        buddyImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        shouldAnimatedOnAppearance = true
    }

    fileprivate func changeBuddyPic(for buddy: ChooseBuddyVC.Buddy) {

        let buddyImage   : UIImage
        let buddyBtnImage: UIImage

        switch buddy {
        case .assistant:
            buddyImage    = #imageLiteral(resourceName: "icLandingPageGirl")
            buddyBtnImage = #imageLiteral(resourceName: "icGirlSmall")
        case .superhero:
            buddyImage    = #imageLiteral(resourceName: "icLandingPageHero")
            buddyBtnImage = #imageLiteral(resourceName: "icSuperheroSmall")
        case .pet:
            buddyImage    = #imageLiteral(resourceName: "icLandingPageDog")
            buddyBtnImage = #imageLiteral(resourceName: "icAnimalSmall")
        }

        buddyImageView.image = buddyImage
        changeBuddyBtn.setImage(buddyBtnImage, for: .normal)
    }
}

//MARK: Extension for InitialSetup and private methods
//====================================================
extension NewHomeScreenVC {

    func initialSetUp() {
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "1" {
            GoogleLoginController.shared.loginWithEventFetch(completion: { (events, error) in

                if error != nil {
                    AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                    //self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                }
            })
        }
        self.appleHomeEffect()

        let buddyValue = AppUserDefaults.value(forKey: .selectedBuddy, fallBackValue: "assistant").stringValue
        if let buddy = ChooseBuddyVC.Buddy(rawValue: buddyValue) {
            changeBuddyPic(for: buddy)
        }

        let logoTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        budfieLogoStackView.addGestureRecognizer(logoTapGesture)
        buddyImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }

    @objc private func logoTapped(_ gesture: UITapGestureRecognizer) {
        goToProfile()
    }

    fileprivate func goToProfile() {
        let myProfileScene = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        myProfileScene.state = .homeScreen
        navigationController?.pushViewController(myProfileScene, animated: true)
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

    func getEventTypes() {

        let params: JSONDictionary = ["method": StringConstants.K_Event_Type.localized,
                                      "access_token": AppDelegate.shared.currentuser.access_token]

        // Get Event Type
        //===============
        WebServices.getEventType(parameters: params, loader: false, success: { (obEventTypeModel) in

            guard let realm = try? Realm() else {
                return
            }

            let eventTypes = realm.objects(RealmEventType.self)
            try? realm.write {
                realm.delete(eventTypes)
            }

            for temp in obEventTypeModel {
                let value = ["id": temp.id, "name": temp.eventType]
                try? realm.write {
                    realm.create(RealmEventType.self, value: value)
                }
            }

        }, failure: { _ in })
    }
}

extension NewHomeScreenVC: UIViewControllerTransitioningDelegate {

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

