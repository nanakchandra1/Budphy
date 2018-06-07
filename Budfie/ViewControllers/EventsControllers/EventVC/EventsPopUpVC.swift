//
//  EventsPopUpVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

enum SocialType : String {
    case FaceBook
    case Google
    case Budfie
}

protocol EventsPopUpVCDelegate : class {
    func getResponse(isOkBtnTapped: Bool, socialType: SocialType)
}

class EventsPopUpVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Phone_Events_Now.localized)"
    weak var delegate: EventsPopUpVCDelegate?
    var socialType: SocialType?
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInitailViews()
        self.registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.popUpView.transform = CGAffineTransform(translationX: 0,
                                                     y: -screenHeight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.popUpView.transform = .identity
        }
    }
    
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        
        self.delegateWithAnimation(isOkBtnTapped: true)
    }
    
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
        self.delegateWithAnimation(isOkBtnTapped: false)
    }
    
}



//MARK: Extension : for Regisering Nibs and Setting Up SubViews
//=============================================================
extension EventsPopUpVC {
    
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitailViews() {
        
        self.view.backgroundColor = UIColor.clear
        self.backGroundView.backgroundColor = AppColors.popUpBackground
        self.popUpView.backgroundColor = AppColors.whiteColor
        self.popUpImageView.image = AppImages.eventspopupCalender
        
        self.headingLabel.textColor = AppColors.blackColor
        self.headingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(16)
        self.headingLabel.text = self.headerText
        self.headingLabel.textAlignment = .center
        
        self.okBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.okBtn.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.okBtn.roundCommonButtonPositive(title: StringConstants.YES.localized)
        
        self.cancelBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.cancelBtn.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.cancelBtn.roundCommonButton(title: StringConstants.NOT_NOW.localized)
        
    }
    
    
    //MARK:- Nib Register method
    //==========================
    fileprivate func registerNibs() {
        
    }
    
    //MARK:- delegateWithAnimation method
    //===================================
    func delegateWithAnimation(isOkBtnTapped: Bool) {
        
        self.delegate?.getResponse(isOkBtnTapped: isOkBtnTapped, socialType: self.socialType ?? SocialType.Budfie)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        
                        self.popUpView.transform = CGAffineTransform(translationX: 0,
                                                                     y: -screenHeight)
        },
                       completion: { (doneWith) in
                        self.hidePopUp()
        })
    }
    
    
}
