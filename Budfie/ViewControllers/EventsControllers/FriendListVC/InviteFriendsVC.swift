//
//  InviteFriendsVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 13/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

class InviteFriendsVC: BaseVc {
    
    var ripple                  : MTRipple?
    var pulsator                = Pulsator()
    var obTopFriendListModel    : TopFriendListModel!
//    weak var delegate           : EventDelegate?
    var eventDate               : Date?
    var vcType                  : PState = .inviteFriends
//    var friendDic               = JSONDictionary()
    var selectedIds              = [String]()
    
    enum PState {
        case inviteFriends
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var backBtnName: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backAnimated: UIView!
    @IBOutlet weak var inviteMoreFriendsBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var centerImageBtn: UIButton!
    @IBOutlet weak var imageBtn1: UIButton!
    @IBOutlet weak var imageBtn2: UIButton!
    @IBOutlet weak var imageBtn3: UIButton!
    @IBOutlet weak var imageBtn4: UIButton!
    @IBOutlet weak var imageBtn5: UIButton!
    @IBOutlet weak var imageBtn6: UIButton!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var otherImage1: UIImageView!
    @IBOutlet weak var otherImage2: UIImageView!
    @IBOutlet weak var otherImage3: UIImageView!
    @IBOutlet weak var otherImage4: UIImageView!
    @IBOutlet weak var otherImage5: UIImageView!
    @IBOutlet weak var otherImage6: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtnName.isHidden = true
        self.setUpInitialViews()
        self.setBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.roundedView()
        self.pulsator.position = centerImage.layer.position
    }
    
    @IBAction func selectFriendBtnTapped(_ sender: UIButton) {
        self.selectedFriendBtn(sender)
        
        if self.selectedIds.count == 0 {
            self.skipBtn.setTitle(StringConstants.Skip.localized, for: .normal)
        } else {
            self.skipBtn.setTitle(StringConstants.Invite.localized, for: .normal)
        }
    }
    
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        
        if self.selectedIds.count > 0 {
            self.hitInviteFriend()
            
        } else {

            if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
                let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
                controller.state = .invite
                controller.delegate = self
                self.addChildViewController(controller)
                self.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
                //                controller.modalPresentationStyle = .overCurrentContext
                //                self.present(controller, animated: false, completion: nil)
            } else {
                self.pushHomeScreen()
            }
        }
    }
    
    @IBAction func inviteBtnTapped(_ sender: UIButton) {
        
        let obInviteesVC = InviteesVC.instantiate(fromAppStoryboard: .Events)
        obInviteesVC.eventId = self.obTopFriendListModel.eventId
        obInviteesVC.eventDate = eventDate
        obInviteesVC.selectedId = self.selectedIds
        obInviteesVC.friendID = self.makeFriendId()
        self.navigationController?.pushViewController(obInviteesVC, animated: true)
    }
    
}


//MARK:- InviteFriendsVC Delegate Extension
//=========================================
extension InviteFriendsVC: PushToHomeScreenDelegate {
    
    func pushHomeScreen() {
        
        guard let nav = self.navigationController else { return }
        
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        if nav.popToClass(type: TabBarVC.self) {
            if let eventD = self.eventDate?.toString(dateFormat: DateFormat.dOBServerFormat.rawValue) {
                NotificationCenter.default.post(name: Notification.Name.EventAdded,
                                                object: nil,
                                                userInfo: ["eventDate":eventD as String])
                //self.delegate?.eventAdded(date: eventD)
            }
        }
    }
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension InviteFriendsVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitialViews() {
        
        //        self.navigationController?.isNavigationBarHidden = true
        self.navigationView.backgroundColor = UIColor.clear
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.text           = StringConstants.Invite_Friends.localized
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backAnimated.backgroundColor   = UIColor.clear
        self.backBtnName.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.headingLabel.text              = "Hi \(AppDelegate.shared.currentuser.first_name) \(AppDelegate.shared.currentuser.last_name),\n\(StringConstants.Lets_Get_Your_Friends_Into_The_Fun.localized)"
        self.headingLabel.textColor         = AppColors.blackColor
        self.headingLabel.font              = AppFonts.Comfortaa_Bold_0.withSize(13)
        
        self.inviteMoreFriendsBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.inviteMoreFriendsBtn.titleLabel?.font      = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        self.inviteMoreFriendsBtn.roundCommonButtonPositive(title: StringConstants.INVITE_OTHER_FRIENDS.localized)
        
        self.skipBtn.setTitleColor(AppColors.themeBlueColor, for: .normal)
        self.skipBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.skipBtn.setTitle(StringConstants.Skip.localized, for: .normal)
        
        self.setImages()
    }
    
    func setImages() {
        
        self.centerImage.setImage(withSDWeb: AppDelegate.shared.currentuser.image, placeholderImage: AppImages.icMorePlaceholder)
        
        self.otherImage1.image = nil
        self.otherImage2.image = nil
        self.otherImage3.image = nil
        self.otherImage4.image = nil
        self.otherImage5.image = nil
        self.otherImage6.image = nil

        var unusedChatColors: [String] = []

        var randomColor: UIColor {
            if unusedChatColors.isEmpty {
                unusedChatColors = FirebaseHelper.chatColors
            }
            let randomIndex = Int(arc4random_uniform(UInt32(unusedChatColors.count)))
            let color = unusedChatColors[randomIndex]
            unusedChatColors.remove(at: randomIndex)
            return UIColor(hexString: color)
        }
        
        for index in 0..<self.obTopFriendListModel.friendListModel.count {

            let name  = self.obTopFriendListModel.friendListModel[index].fullName
            let image = self.obTopFriendListModel.friendListModel[index].image

            switch index {
            case 0:
                if image.isEmpty {
                    imageBtn1.setTitle(name.initials, for: .normal)
                    imageBtn1.backgroundColor = randomColor
                } else {
                    self.otherImage1.setImage(withSDWeb: image,
                                              placeholderImage: AppImages.myprofilePlaceholder)
                }
            case 1:
                if image.isEmpty {
                    imageBtn2.setTitle(name.initials, for: .normal)
                    imageBtn2.backgroundColor = randomColor
                } else {
                    self.otherImage2.setImage(withSDWeb: image,
                                              placeholderImage: AppImages.myprofilePlaceholder)
                }
            case 2:
                if image.isEmpty {
                    imageBtn3.setTitle(name.initials, for: .normal)
                    imageBtn3.backgroundColor = randomColor
                } else {
                    self.otherImage3.setImage(withSDWeb: image,
                                              placeholderImage: AppImages.myprofilePlaceholder)
                }
            case 3:
                if image.isEmpty {
                    imageBtn4.setTitle(name.initials, for: .normal)
                    imageBtn4.backgroundColor = randomColor
                } else {
                    self.otherImage4.setImage(withSDWeb: image,
                                              placeholderImage: AppImages.myprofilePlaceholder)
                }
            case 4:
                if image.isEmpty {
                    imageBtn5.setTitle(name.initials, for: .normal)
                    imageBtn5.backgroundColor = randomColor
                } else {
                    self.otherImage5.setImage(withSDWeb: image,
                                              placeholderImage: AppImages.myprofilePlaceholder)
                }
            default:
                break
            }
        }
        
        if self.obTopFriendListModel.friendListModel.count == 0 {
            delayWithSeconds(5, completion: {
                CommonClass.showToast(msg: "Sorry!!! No Friend Found")
            })
        }
    }
    
    func startAnimated() {
        
        self.centerImage.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)

        self.otherImage1.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        self.otherImage2.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        self.otherImage3.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        self.otherImage4.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        self.otherImage5.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        self.otherImage6.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: [.curveEaseIn], animations: {
            
            self.centerImage.transform = .identity
        }) { (state) in
            self.startimageAnimated()
        }
    }
    
    func startimageAnimated(){
        
        UIView.animate(withDuration: 0.5, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [.curveEaseIn], animations: {
            
            self.otherImage1.transform = .identity
        }) { (state) in
            UIView.animate(withDuration: 0.5, delay: 1.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [.curveEaseIn], animations: {
                
                self.otherImage2.transform = .identity
            }) { (state) in
                UIView.animate(withDuration: 0.5, delay: 1.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [.curveEaseIn], animations: {
                    
                    self.otherImage3.transform = .identity
                }) { (state) in
                    UIView.animate(withDuration: 0.5, delay: 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [.curveEaseIn], animations: {
                        
                        self.otherImage4.transform = .identity
                    }) { (state) in
                        UIView.animate(withDuration: 0.5, delay: 1.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [.curveEaseIn], animations: {
                            
                            self.otherImage5.transform = .identity
                        }) { (state) in
                            UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [.curveEaseIn], animations: {
                                
                                self.otherImage6.transform = .identity
                            }) { (state) in
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func startAnimation() {
        
        self.centerImage.layer.superlayer?.insertSublayer(pulsator, below: centerImage.layer)
        pulsator.start()
        pulsator.radius = 320
        pulsator.backgroundColor = AppColors.themeLightBlueColor.withAlphaComponent(1).cgColor
        pulsator.radius = 250
        //        pulsator.numPulse = Int(8)
        pulsator.animationDuration = 7
        pulsator.numPulse = 15
        self.startimageAnimated()
    }
    
    func roundedView() {
        
//        self.otherImage6.roundCorners()
        self.centerImage.layer.cornerRadius = self.centerImage.frame.width / 2 //roundCorners()
        self.otherImage1.layer.cornerRadius = self.otherImage1.frame.width / 2
        self.otherImage2.layer.cornerRadius = self.otherImage2.frame.width / 2
        self.otherImage3.layer.cornerRadius = self.otherImage3.frame.width / 2
        self.otherImage4.layer.cornerRadius = self.otherImage4.frame.width / 2
        self.otherImage5.layer.cornerRadius = self.otherImage5.frame.width / 2
        self.otherImage6.layer.cornerRadius = self.otherImage6.frame.width / 2

        centerImageBtn.layer.cornerRadius = self.centerImage.frame.width / 2
        imageBtn1.layer.cornerRadius = self.otherImage1.frame.width / 2
        imageBtn2.layer.cornerRadius = self.otherImage2.frame.width / 2
        imageBtn3.layer.cornerRadius = self.otherImage3.frame.width / 2
        imageBtn4.layer.cornerRadius = self.otherImage4.frame.width / 2
        imageBtn5.layer.cornerRadius = self.otherImage5.frame.width / 2
        imageBtn6.layer.cornerRadius = self.otherImage6.frame.width / 2
        
        self.centerImage.clipsToBounds = true
        self.otherImage1.clipsToBounds = true
        self.otherImage2.clipsToBounds = true
        self.otherImage3.clipsToBounds = true
        self.otherImage4.clipsToBounds = true
        self.otherImage5.clipsToBounds = true
    }
    
    func setBorder() {
        
        let borderWidth: CGFloat = 2.0

        /*
         self.otherImage1.border(width: borderWidth, borderColor: UIColor.clear)
         self.otherImage2.border(width: borderWidth, borderColor: UIColor.clear)
         self.otherImage3.border(width: borderWidth, borderColor: UIColor.clear)
         self.otherImage4.border(width: borderWidth, borderColor: UIColor.clear)
         self.otherImage5.border(width: borderWidth, borderColor: UIColor.clear)
         */

        self.imageBtn1.border(width: borderWidth, borderColor: UIColor.clear)
        self.imageBtn2.border(width: borderWidth, borderColor: UIColor.clear)
        self.imageBtn3.border(width: borderWidth, borderColor: UIColor.clear)
        self.imageBtn4.border(width: borderWidth, borderColor: UIColor.clear)
        self.imageBtn5.border(width: borderWidth, borderColor: UIColor.clear)
    }
    
    func selectedFriendBtn(_ sender: UIButton) {
        
        switch sender {
        case self.imageBtn1:
            self.setImageBorder(self.imageBtn1, selectedId: self.obTopFriendListModel.friendListModel[0].friendId)

        case self.imageBtn2:
            self.setImageBorder(self.imageBtn2, selectedId: self.obTopFriendListModel.friendListModel[1].friendId)
            
        case self.imageBtn3:
            self.setImageBorder(self.imageBtn3, selectedId: self.obTopFriendListModel.friendListModel[2].friendId)
            
        case self.imageBtn4:
            self.setImageBorder(self.imageBtn4, selectedId: self.obTopFriendListModel.friendListModel[3].friendId)

        case self.imageBtn5:
            self.setImageBorder(self.imageBtn5, selectedId: self.obTopFriendListModel.friendListModel[4].friendId)
            
        default:
            break
        }
    }
    
    func setImageBorder(_ sender: UIButton, selectedId: String) {
        
        if self.selectedIds.contains(selectedId) {
            
            sender.border(width: 2,
                          borderColor: UIColor.clear)
            
            if let index = self.selectedIds.index(of: selectedId) {
                self.selectedIds.remove(at: index)
            }
            
        } else {
            sender.border(width: 2, borderColor: AppColors.themeBlueColor)
            self.selectedIds.append(selectedId)
        }
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]       = StringConstants.K_Invite_Friends.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token
        params["event_id"]     = self.obTopFriendListModel.eventId
        params["friends"]      = ""
        
        let frndID = self.makeFriendId()
        params["friends"] = CommonClass.convertToJson(jsonDic: frndID)
        return params
    }
    
    func makeFriendId() -> [JSONDictionary] {
        
        var friendDic = [JSONDictionary]()
        
        for temp in self.selectedIds {
            var friend = JSONDictionary()
            friend["friend_id"] = temp
            friendDic.append(friend)
        }
        return friendDic
    }
    
    //MARK:- hitInviteFriend method
    //=============================
    func hitInviteFriend() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Invite Friend
        //==============
        WebServices.inviteFriends(parameters: params, success: { (success) in
            
            if success {
                
                let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
                controller.delegate = self
                controller.pageState = .greetingEvent
                controller.modalPresentationStyle = .overCurrentContext
                self.present(controller, animated: false, completion: nil)
            }

        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        }
    }
    
}


//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension InviteFriendsVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        
        CommonClass.showToast(msg: "Friends has been invited successfully")
        
        if isOkBtn {
            
            let ob = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
            if let date = self.eventDate?.toString(dateFormat: DateFormat.dOBServerFormat.rawValue) {
                ob.eventDate = date
                ob.eventId = obTopFriendListModel.eventId
                ob.flowType = .events
                //AppDelegate.shared.sharedTabbar?.hideTabbar()
            }
            self.navigationController?.pushViewController(ob, animated: true)
        } else {
            
            if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
                let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
                controller.state = .invite
                controller.delegate = self
                self.addChildViewController(controller)
                self.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
                //                controller.modalPresentationStyle = .overCurrentContext
                //                self.present(controller, animated: false, completion: nil)
            } else {
                self.pushHomeScreen()
            }
        }
    }
    
}
/*
 if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
 let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
 controller.state = .invite
 controller.delegate = self
 //                controller.modalPresentationStyle = .overCurrentContext
 //                self.present(controller, animated: false, completion: nil)
 self.addChildViewController(controller)
 self.view.addSubview(controller.view)
 controller.didMove(toParentViewController: self)
 } else {
 self.pushHomeScreen()
 }
 */
