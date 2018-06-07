//
//  TypeOfGreetingVC.swift
//  Budfie
//
//  Created by appinventiv on 01/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift
import UIKit

class TypeOfGreetingVC: BaseVc {
    
    //MARK: Properties
    //================
    var flowType    : FlowType = .home
    var greetingType: GreetingType = .animation
    var vcState     : VCState = .create
    var eventDate   = String()
    var eventId     = String()

    /*
    private var draftGreetingCount = 0 {
        didSet {
            updateGreetingCount()
        }
    }
    private var sentGreetingCount = 0 {
        didSet {
            updateGreetingCount()
        }
    }
    */
    private var receivedGreetingCount = 0 {
        didSet {
            updateGreetingCount()
        }
    }

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var moreOptionMenuBtn: UIButton!
    @IBOutlet weak var animatedBackView: PolygonalView!
    @IBOutlet weak var faceInAHoleBackView: PolygonalView!
    @IBOutlet weak var popUpBackView: PolygonalView!
    @IBOutlet weak var classicOrFunnyBackView: PolygonalView!
    @IBOutlet weak var animatedLabel: UILabel!
    @IBOutlet weak var faceInAHoleLabel: UILabel!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var classicOrFunnyLabel: UILabel!
    @IBOutlet weak var animatedImageView: UIImageView!
    @IBOutlet weak var faceInAHoleImageView: UIImageView!
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var classicOrFunnyImageView: UIImageView!
    @IBOutlet weak var centerYforFaceView: NSLayoutConstraint!
    @IBOutlet weak var widthOfGreetingViews: NSLayoutConstraint!
    @IBOutlet weak var backImage: UIImageView!

    @IBOutlet weak var greetingCountContainerView: UIView!
    @IBOutlet weak var greetingCountLbl: UILabel!

    //    @IBOutlet weak var animatedBtn: UIButton!
    //    @IBOutlet weak var faceInAHoleBtn: UIButton!
    //    @IBOutlet weak var popUpBtn: UIButton!
    //    @IBOutlet weak var classicOrFunnyBtn: UIButton!

    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        /*
        if let realm = try? Realm() {
            draftGreetingCount = realm.objects(Greeting.self).filter({ greeting in
                if let id = greeting.id {
                    return (greeting.isDraft && !id.isEmpty)
                }
                return greeting.isDraft
            }).count
        }
        */
        getGreetingCount()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setCornerRadius()
        //        self.setBorder()
    }

    private func updateGreetingCount() {
        let totalCount = (/*draftGreetingCount + sentGreetingCount + */receivedGreetingCount)
        greetingCountContainerView.isHidden = (totalCount == 0)
        if totalCount < 10 {
            greetingCountLbl.text = "\(totalCount)"
        } else {
            greetingCountLbl.text = "9+"
        }
    }

    private func getGreetingCount() {
        WebServices.getGreetingCount(success: { [weak self] (sentGreetingCount, receivedGreetingCount) in
            guard let strongSelf = self else {
                return
            }
            //strongSelf.sentGreetingCount = sentGreetingCount
            strongSelf.receivedGreetingCount = receivedGreetingCount

        }, failure: { error in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if self.flowType == .home {
            
            if let _ = self.navigationController?.popToClass(type: NewHomeScreenVC.self) {}
            
        } else if self.flowType == .events {

            if eventDate.isEmpty {
                NotificationCenter.default.post(name: Notification.Name.DidEditGreeting, object: nil)
                return
            }
            
            guard let date = eventDate.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) else {
                return
            }
            
            let userInfo: [AnyHashable : Any] = ["eventDate": date]
            NotificationCenter.default.post(name: NSNotification.Name.DidChooseDate,
                                            object: nil,
                                            userInfo: userInfo)
            
        }
    }
    
    @IBAction func moreOptionsBtnTapped(_ sender: UIButton) {

        if receivedGreetingCount > 0 {
            AppDelegate.shared.configuration.menuWidth = 110.0
        } else {
            AppDelegate.shared.configuration.menuWidth = 100.0
        }
        
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Drafts","Sent","Received"],
                                    menuCountArray: [/*draftGreetingCount, sentGreetingCount,*/0, 0, receivedGreetingCount],
                                    done: { (selectedIndex) -> () in
                                        self.jumpToSelectedItem(index: selectedIndex)
        }) {
        }
    }
    
    @IBAction func animatedBtnTapped(_ sender: UIButton) {
        moveToAnimationsVC(with: .animation)
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func faceInAHoleBtnTapped(_ sender: UIButton) {
        moveToAnimationsVC(with: .faceInHole)
    }
    
    @IBAction func popUpBtnTapped(_ sender: UIButton) {
        moveToAnimationsVC(with: .popUp3D)
    }
    
    @IBAction func classicOrFunnyBtnTapped(_ sender: UIButton) {
        moveToAnimationsVC(with: .classicFunny)
    }
}

//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension TypeOfGreetingVC {
    
    private func initialSetup() {

        self.greetingCountContainerView.isHidden = true
        self.greetingCountContainerView.round()
        self.greetingCountContainerView.backgroundColor = AppColors.calendarEventPink

        // set header view..
        self.statusBar.backgroundColor      = AppColors.themeBlueColor
        self.navigationView.backgroundColor = UIColor.clear
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        self.navigationTitle.text           = "Wish Genie"
        
        if self.flowType == .home {
            self.homeBtn.setImage(AppImages.eventsHomeLogo, for: .normal)
        } else if self.flowType == .events {
            self.homeBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        }

        /*
        if screenWidth < 322 {
            self.centerYforFaceView.constant = 10
            self.widthOfGreetingViews.constant = -5
        } else if screenWidth < 376 {
            self.widthOfGreetingViews.constant = -3
        }
        */
        
        self.appleHomeEffect()
        self.setLabels()
        self.setImages()
        self.rotateViews()
        self.setBackViews()
    }
    
    func setLabels() {
        
        self.animatedLabel.textColor     = AppColors.blackColor
        self.faceInAHoleLabel.textColor  = AppColors.blackColor
        self.popUpLabel.textColor        = AppColors.blackColor
        self.classicOrFunnyLabel.textColor = AppColors.blackColor
        
        self.animatedLabel.font = AppFonts.AvenirNext_Medium.withSize(13,
                                                                      iphone6: 14,
                                                                      iphone6p: 16)
        self.faceInAHoleLabel.font = AppFonts.AvenirNext_Medium.withSize(13,
                                                                         iphone6: 14,
                                                                         iphone6p: 16)
        self.popUpLabel.font = AppFonts.AvenirNext_Medium.withSize(13,
                                                                   iphone6: 14,
                                                                   iphone6p: 16)
        self.classicOrFunnyLabel.font = AppFonts.AvenirNext_Medium.withSize(13,
                                                                            iphone6: 14,
                                                                            iphone6p: 16)
    }
    
    func setImages() {
        self.animatedImageView.image     = AppImages.icGreetingAnimated
        self.faceInAHoleImageView.image  = AppImages.icGreetingFacehole
        self.popUpImageView.image        = AppImages.icGreetingPopup
        self.classicOrFunnyImageView.image = AppImages.icGreetingClassicFunny
    }
    
    func setBackViews() {
        self.animatedBackView.backgroundColor       = AppColors.animatedColor
        self.classicOrFunnyBackView.backgroundColor = AppColors.classicOrFunnyColor
        self.faceInAHoleBackView.backgroundColor    = AppColors.faceInHoleColor
        self.popUpBackView.backgroundColor          = AppColors.popUp3DColor
    }
    
    func rotateViews() {
        let angle = CGFloat.pi/2
        self.animatedBackView.transform       = CGAffineTransform(rotationAngle: angle)
        self.classicOrFunnyBackView.transform = CGAffineTransform(rotationAngle: angle)
        self.faceInAHoleBackView.transform    = CGAffineTransform(rotationAngle: angle)
        self.popUpBackView.transform          = CGAffineTransform(rotationAngle: angle)
    }
    
    func setBorder() {
        let border: CGFloat = 20.0
        self.animatedBackView.borderWidth       = border
        self.classicOrFunnyBackView.borderWidth = border
        self.popUpBackView.borderWidth          = border
        self.faceInAHoleBackView.borderWidth    = border
    }
    
    func setCornerRadius() {
        var cornerRadius: CGFloat = 0.0
        if screenWidth < 322 {
            cornerRadius = 30.0
        } else {
            cornerRadius = 35.0
        }
        self.animatedBackView.layer.cornerRadius       = cornerRadius
        self.classicOrFunnyBackView.layer.cornerRadius = cornerRadius
        self.popUpBackView.layer.cornerRadius          = cornerRadius
        self.faceInAHoleBackView.layer.cornerRadius    = cornerRadius
    }
    
    private func moveToAnimationsVC(with type: GreetingType) {
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let greetingsMenuVCScene = GreetingsMenuVC.instantiate(fromAppStoryboard: .Greeting)
        greetingsMenuVCScene.greetingType = type
        greetingsMenuVCScene.flowType = self.flowType
        greetingsMenuVCScene.eventDate = eventDate
        greetingsMenuVCScene.eventId = eventId
        navigationController?.pushViewController(greetingsMenuVCScene, animated: true)
    }
    
    private func jumpToSelectedItem(index: Int) {
        
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let sentGreetingsVCScene = SentGreetingsVC.instantiate(fromAppStoryboard: .Greeting)
        
        switch index {
        case 0:
            sentGreetingsVCScene.vcState = .draft
        case 1:
            sentGreetingsVCScene.vcState = .sent
        default:
            sentGreetingsVCScene.vcState = .receive
            sentGreetingsVCScene.delegate = self
        }
        sentGreetingsVCScene.flowType = self.flowType
        sentGreetingsVCScene.eventId = self.eventId
        navigationController?.pushViewController(sentGreetingsVCScene, animated: true)
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

extension TypeOfGreetingVC: ResetGreetingCountDelegate {

    func resetGreetingCount() {
        receivedGreetingCount = 0
    }
}
