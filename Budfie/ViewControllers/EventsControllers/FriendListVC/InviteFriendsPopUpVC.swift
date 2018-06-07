//
//  InviteFriendsPopUpVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

protocol GetResponseDelegate : class {
    func nowOrSkipBtnTapped(isOkBtn: Bool)
}

class InviteFriendsPopUpVC: BaseVc {
    
    //MARK:- Properties
    //=================
    weak var delegate: GetResponseDelegate?
    var pageState: PState = .inviteFriends
    
    enum PState {
        case inviteFriends
        case favUnFav
        case logout
        case greetingEvent
        case greeting
        case holidayPlanner
        case deleteEvent
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nowBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitailViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.statusBarView.backgroundColor = AppColors.popUpBackground
        self.backView.transform = CGAffineTransform(translationX: 0,
                                                    y: -screenHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            
            self.backGroundView.backgroundColor = AppColors.popUpBackground
            //                self.statusBarView.backgroundColor = AppColors.whiteColor
            self.backView.transform = .identity
            
        }
    }
    
    
    @IBAction func nowBtnTapped(_ sender: UIButton) {
        self.delegate?.nowOrSkipBtnTapped(isOkBtn: true)
        self.nowOrSkipBtnAnimation()
    }
    
    
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        self.delegate?.nowOrSkipBtnTapped(isOkBtn: false)
        self.nowOrSkipBtnAnimation()
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.nowOrSkipBtnAnimation()
    }
    
}

//MARK: Extension : for Regisering Nibs and Setting Up SubViews
//=============================================================
extension InviteFriendsPopUpVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitailViews() {
        
        self.view.backgroundColor = UIColor.clear
        self.backGroundView.backgroundColor = AppColors.popUpBackground
        self.popUpView.backgroundColor = AppColors.whiteColor
        
        self.headingLabel.textColor = AppColors.blackColor
        self.headingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(16)
        
        self.nowBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.nowBtn.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(14.7)
        
        self.skipBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.skipBtn.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.cancelBtn.isHidden = true

        self.headingLabel.textAlignment = .center
        self.setTextForPopUp()
    }
    
    //MARK:- set text for popup method
    //================================
    fileprivate func setTextForPopUp() {

        switch pageState {
        case .inviteFriends:
            self.skipBtn.roundCommonButton(title: StringConstants.NO.localized)
            self.nowBtn.roundCommonButtonPositive(title: StringConstants.YES.localized)
            self.headingLabel.text = "Would you like to invite friends?"
        case .favUnFav:
            self.skipBtn.roundCommonButtonPositive(title: StringConstants.NO.localized)
            self.nowBtn.roundCommonButton(title: StringConstants.YES.localized)
            self.headingLabel.text = "\(StringConstants.K_Are_You_Sure.localized)\n\(StringConstants.K_Favourite_Msg.localized)"
            self.headingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(18)
        case .logout:
            self.skipBtn.roundCommonButtonPositive(title: StringConstants.NO.localized)
            self.nowBtn.roundCommonButton(title: StringConstants.YES.localized)
            self.headingLabel.text = "\(StringConstants.K_Are_You_Sure.localized)\n\(StringConstants.K_Logout_Msg.localized)"
            self.headingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(18)
        case .greetingEvent:
            self.skipBtn.roundCommonButton(title: StringConstants.NO.localized)
            self.nowBtn.roundCommonButtonPositive(title: StringConstants.YES.localized)
            self.headingLabel.text = "\(StringConstants.Would_You_Like_To_Send_Special.localized)\n greeting with this event?"
        case .greeting:
            self.skipBtn.roundCommonButton(title: StringConstants.NOT_NOW.localized)
            self.nowBtn.roundCommonButtonPositive(title: StringConstants.YES.localized)
            self.headingLabel.text = "Do you want to share this\ngreeting now?"
            self.cancelBtn.isHidden = false
        case .holidayPlanner:
            self.skipBtn.roundCommonButton(title: StringConstants.NO.localized)
            self.nowBtn.roundCommonButtonPositive(title: StringConstants.YES.localized)
            self.headingLabel.text = "Do you want to show this holiday in\nPlanner?"
            self.cancelBtn.isHidden = false
        case .deleteEvent:
            self.skipBtn.roundCommonButtonPositive(title: StringConstants.NO.localized)
            self.nowBtn.roundCommonButton(title: StringConstants.YES.localized)
            self.headingLabel.text = "Are you sure you want to delete this \nEvent?"
            self.cancelBtn.isHidden = true
        }
    }
    
    func nowOrSkipBtnAnimation() {
        UIView.animate(withDuration: 0.5,
                       animations: {
//                        self.statusBarView.backgroundColor = AppColors.popUpBackground
                        self.backGroundView.backgroundColor = UIColor.clear
                        self.backView.transform = CGAffineTransform(translationX: 0,
                                                                    y: -screenHeight)
        }, completion: { (doneWith) in

            switch self.pageState {
            case .inviteFriends, .favUnFav, .logout, .greetingEvent:
                self.hidePopUp()
            case .greeting, .holidayPlanner, .deleteEvent:
                self.view.removeFromSuperview()
            }
        })
    }
    
}
