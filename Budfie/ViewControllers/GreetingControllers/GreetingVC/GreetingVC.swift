//
// GreetingVC.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 07/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

//MARK: GreetingVC class
//======================
class GreetingVC: BaseVc {
    
    //MARK: Properties
    //================
    var flowType: FlowType = .home
    var greetingType: GreetingType = .animation
    var vcState: VCState = .create
    
//    static var selectedMenuItemIndexPath = 0
    var eventDate  = String()
    var eventId  = String()
    let imageArray = [AppImages.icGreetingCreate,
                      AppImages.icGreetingDraft,
                      AppImages.icGreetingSend,
                      AppImages.icGreetingReceive]
    
    //MARK: @IBOutlet
    //===============
//    @IBOutlet weak var greetingCollectionView: UICollectionView!
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var curveView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.initialSetup()
//        self.registerXibs()
//        self.setCircularLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func landingPageBtnTapped(_ sender: UIButton) {
        
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
        
        //self.navigationController?.parent?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createBtnTapped(_ sender: UIButton) {
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let scene = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
        scene.eventDate = eventDate
        scene.flowType = flowType
        scene.eventId = eventId
        self.navigationController?.pushViewController(scene, animated: true)
        //        CommonClass.showToast(msg: #function)
    }
    
    @IBAction func draftBtnTapped(_ sender: UIButton) {
        self.goToVCType(vcType: .draft)
//        CommonClass.showToast(msg: #function)
    }
    
    @IBAction func sentBtnTapped(_ sender: UIButton) {
        self.goToVCType(vcType: .sent)
//        CommonClass.showToast(msg: #function)
    }
    
    @IBAction func receivedBtnTapped(_ sender: UIButton) {
        self.goToVCType(vcType: .receive)
//        CommonClass.showToast(msg: #function)
    }
    
}


//MARK:- Extension for UICollectionViewDelegate
//=============================================
//extension GreetingVC: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        GreetingVC.selectedMenuItemIndexPath = indexPath.item
////        self.greetingCollectionView.reloadData()
//
//        switch indexPath.item {
//
//        case 0:
//            AppDelegate.shared.sharedTabbar.hideTabbar()
//            let scene = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
//            self.navigationController?.pushViewController(scene, animated: true)
//            //self.buttonPresssed()
//
//        case 1: self.buttonPresssed()
//
//        case 2: self.buttonPresssed()
//
//        case 3: self.buttonPresssed()
//
//        case 4: self.buttonPresssed()
//
//        default :  print_debug("out of bounds indexPath ");  return
//
//        }
//    }
//
//}


//MARK:- Extension for Private methods
//====================================
extension GreetingVC {
    
    fileprivate func initialSetup() {
        
        self.navigationView.backgroundColor = UIColor.clear
        self.curveView.backgroundColor      = AppColors.themeBlueColor
        self.navigationTitle.text           = "Greeting"
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.appleHomeEffect()
//        self.greetingCollectionView.delegate = self
//        self.greetingCollectionView.dataSource = self
//        self.greetingCollectionView.isScrollEnabled = false
    }
    
//    fileprivate func registerXibs() {
//
//        greetingCollectionView.register(UINib(nibName: String(describing: GreetingCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GreetingCollectionViewCell.self))
//
//        greetingCollectionView.register(UINib(nibName: String(describing: Greeting2CollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Greeting2CollectionViewCell.self))
//    }
    
    func buttonPresssed() {
        CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
    }
    
    private func goToVCType(vcType: VCState) {
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let scene = SentGreetingsVC.instantiate(fromAppStoryboard: .Greeting)
        scene.greetingType = greetingType
        scene.flowType = flowType
        scene.vcState = vcType
        scene.eventDate = eventDate
        scene.eventId = eventId
        
        self.navigationController?.pushViewController(scene, animated: true)
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
    
    //sets CollectionView in circular Layout
//    fileprivate func setCircularLayout() {
//        
//        let circularLayout = DSCircularLayout()
//        circularLayout.setStartAngle(CGFloat(Double.pi/2),
//                                     endAngle: CGFloat(3 * (Double.pi/2)))
//        circularLayout.mirrorX = false
//        circularLayout.mirrorY = false
//        circularLayout.rotateItems = false
//        circularLayout.initWithCentre(CGPoint(x: 0,y :250),
//                                      radius: 160,
//                                      itemSize: CGSize(width: 130, height: 130),
//                                      andAngularSpacing: 0)
//        self.greetingCollectionView?.collectionViewLayout = circularLayout
//    }
    
}

