//
//  TimeOutVC.swift
//  beziarPath
//
//  Created by yogesh singh negi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

//MARK: TimeOutVC class
//=====================
class TimeOutVC: BaseVc {
    
    //MARK: Property
    //==============
    let image = [AppImages.ic_bored_graphic,
                 AppImages.ic_happy_graphic,
                 AppImages.ic_fight_graphic,
                 AppImages.ic_sad_graphic]
    let headerText = [StringConstants.K_Bored.localized,
                      StringConstants.K_Happy.localized,
                      StringConstants.K_Fight.localized,
                      StringConstants.K_Sad.localized]
    let backColors = [AppColors.badDay,
                      AppColors.happy,
                      AppColors.fight,
                      AppColors.bored]
    var moodType: MoodType = .bored
    var pageNumber: Int {
        return Int(ceil(self.timeOutCollectionView.contentOffset.x / self.timeOutCollectionView.width))
    }
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var timeOutCollectionView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var happyBtn: UIButton!
    @IBOutlet weak var boredBtn: UIButton!
    @IBOutlet weak var sadBtn: UIButton!
    @IBOutlet weak var madBtn: UIButton!
    
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var boredLabel: UILabel!
    @IBOutlet weak var madLabel: UILabel!
    @IBOutlet weak var sadLabel: UILabel!
    
    @IBOutlet weak var curveSliderMainView: UIView!
    @IBOutlet weak var happyDotView: UIView!
    @IBOutlet weak var boredDotView: UIView!
    @IBOutlet weak var madDotView: UIView!
    @IBOutlet weak var sadDotView: UIView!
    
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setSliderView()
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        let ob = TimeOutPopUpVc.instantiate(fromAppStoryboard: .TimeOut)
        ob.moodType = self.moodType
        self.navigationController?.pushViewController(ob, animated: true)
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    @IBAction func moodBtnTapped(_ sender: UIButton) {
        self.selectMoodWithAnimation(sender)
    }
}

//MARK: Extension for InitialSetup and private methods
//====================================================
extension TimeOutVC {
    
    func initialSetUp() {
        
        self.timeOutCollectionView.delegate = self
        self.timeOutCollectionView.dataSource = self
        self.roundSubmitBtn()
        self.setLabels()
        self.setSliderView()
        self.setLabelColor()
        self.initialColorOfDotViews()
        self.boredDotView.backgroundColor = AppColors.blackColor
        self.boredLabel.textColor = AppColors.blackColor
        self.boredLabel.font = AppFonts.Comfortaa_Bold_0.withSize(16)
//        self.boredDotView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
    }
    
    func roundSubmitBtn() {
        
        self.submitBtn.layer.borderWidth = 2
        self.submitBtn.roundCommonButton(title: StringConstants.SUBMIT.localized)
        self.submitBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.submitBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        self.submitBtn.backgroundColor = UIColor.clear
        self.submitBtn.layer.borderColor = AppColors.whiteColor.cgColor
    }
    
    func setSliderView() {
        
        self.curveSliderMainView.backgroundColor = AppColors.whiteColor
        self.curveSliderMainView.alpha = 0.2
        self.curveSliderMainView.roundCornerWith(radius: self.curveSliderMainView.frame.height/2)
        self.happyDotView.roundCorners()
        self.sadDotView.roundCorners()
        self.madDotView.roundCorners()
        self.boredDotView.roundCorners()
//        self.inititialSizeOfSliders()
    }
    
    func setLabels() {
        
        self.happyLabel.text    = StringConstants.K_Happy.localized
        self.boredLabel.text    = StringConstants.K_Bored.localized
        self.madLabel.text      = "Mad"
        self.sadLabel.text      = StringConstants.K_Sad.localized
        
        self.happyLabel.textColor   = AppColors.FacetextColor
        self.boredLabel.textColor   = AppColors.FacetextColor
        self.madLabel.textColor     = AppColors.FacetextColor
        self.sadLabel.textColor     = AppColors.FacetextColor
        
        self.setFonts()
    }
    
    func selectMoodWithAnimation(_ sender: UIButton) {
        
//        self.setSliderWithAnimation(sender)
        let index: CGFloat
        
        switch sender {
        case self.boredBtn:
            index = 0
            self.moodType = .bored
        case self.happyBtn:
            index = 1
            self.moodType = .happy
        case self.madBtn:
            index = 2
            self.moodType = .mad
        case self.sadBtn:
            index = 3
            self.moodType = .sad
        default:
            return
        }
        self.timeOutCollectionView.setContentOffset(CGPoint(x: index * screenWidth, y: 0), animated: true)
    }
    
    func setLabelColor() {
    
        self.happyLabel.textColor = AppColors.whiteColor
        self.boredLabel.textColor = AppColors.whiteColor
        self.madLabel.textColor = AppColors.whiteColor
        self.sadLabel.textColor = AppColors.whiteColor
    }
    
    func setFonts() {
        
        self.setLabelColor()
        let fontSize: CGFloat = 16
        
        self.happyLabel.font    = AppFonts.Comfortaa_Regular_0.withSize(fontSize)
        self.boredLabel.font    = AppFonts.Comfortaa_Regular_0.withSize(fontSize)
        self.madLabel.font      = AppFonts.Comfortaa_Regular_0.withSize(fontSize)
        self.sadLabel.font      = AppFonts.Comfortaa_Regular_0.withSize(fontSize)
        
    }
    
    func setFontOnScroll(_ sender: UIButton) {
        
        self.setFonts()
        let fontSize: CGFloat = 16
        
        switch sender {
        case self.happyBtn:
            self.happyLabel.textColor = AppColors.blackColor
            self.happyLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
            
        case self.boredBtn:
            self.boredLabel.textColor = AppColors.blackColor
            self.boredLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
            
        case self.madBtn:
            self.madLabel.textColor = AppColors.blackColor
            self.madLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
            
        case self.sadBtn:
            self.sadLabel.textColor = AppColors.blackColor
            self.sadLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
            
        default:
            return
        }
    }
    
    func initialColorOfDotViews() {
        
        self.happyDotView.backgroundColor = AppColors.whiteColor
        self.boredDotView.backgroundColor = AppColors.whiteColor
        self.madDotView.backgroundColor = AppColors.whiteColor
        self.sadDotView.backgroundColor = AppColors.whiteColor
        
    }
    
    func inititialSizeOfSliders() {
        
        self.initialColorOfDotViews()
        
//        self.happyDotView.transform = .identity
//        self.boredDotView.transform = .identity
//        self.madDotView.transform   = .identity
//        self.sadDotView.transform   = .identity
    }
    
    func setSliderSizeOnScroll(_ sender: UIButton) {
        
        self.inititialSizeOfSliders()
//        let scaleMultiplier: CGFloat = 1.6
        
        switch sender {
        case self.happyBtn:
            self.happyDotView.backgroundColor = AppColors.blackColor
//            self.happyDotView.transform = CGAffineTransform(scaleX: scaleMultiplier, y: scaleMultiplier)
            
        case self.boredBtn:
            self.boredDotView.backgroundColor = AppColors.blackColor
//            self.boredDotView.transform = CGAffineTransform(scaleX: scaleMultiplier, y: scaleMultiplier)
            
        case self.madBtn:
            self.madDotView.backgroundColor = AppColors.blackColor
//            self.madDotView.transform   = CGAffineTransform(scaleX: scaleMultiplier, y: scaleMultiplier)
            
        case self.sadBtn:
            self.sadDotView.backgroundColor = AppColors.blackColor
//            self.sadDotView.transform   = CGAffineTransform(scaleX: scaleMultiplier, y: scaleMultiplier)
            
        default:
            return
        }
    }
    
    func setSliderWithAnimation(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: [.curveLinear],
                       animations: {
                        
                        self.setFontOnScroll(sender)
                        self.setSliderSizeOnScroll(sender)
                        
        }, completion: nil)
        
    }
    
}


//MARK: Extension for ScrollView delegate And PanGesture
//======================================================
extension TimeOutVC {
    
    //ScrollView delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setmoodTypeType(contentOffSet: scrollView.contentOffset.x)
    }
    
    fileprivate func setmoodTypeType(contentOffSet: CGFloat) {
        
//        if ((timeOutCollectionView.frame.width * CGFloat(pageNumber - 1)) + timeOutCollectionView.frame.width / 2) >= contentOffSet {
        
            let index = Int(contentOffSet/screenWidth)
            
            self.setFonts()
            self.initialColorOfDotViews()
            
            let fontSize: CGFloat = 16
            
            switch index {
                
            case 0:
                self.moodType = .bored
                self.boredLabel.textColor = AppColors.blackColor
                self.boredLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
                self.boredDotView.backgroundColor = AppColors.blackColor
                
            case 1:
                self.moodType = .happy
                self.happyLabel.textColor = AppColors.blackColor
                self.happyLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
                self.happyDotView.backgroundColor = AppColors.blackColor
                
            case 2:
                self.moodType = .mad
                self.madLabel.textColor = AppColors.blackColor
                self.madLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
                self.madDotView.backgroundColor = AppColors.blackColor
                
            case 3:
                self.moodType = .sad
                self.sadLabel.textColor = AppColors.blackColor
                self.sadLabel.font = AppFonts.Comfortaa_Bold_0.withSize(fontSize)
                self.sadDotView.backgroundColor = AppColors.blackColor
                
            default:
                return
            }
            
//        }
    }
    
}

