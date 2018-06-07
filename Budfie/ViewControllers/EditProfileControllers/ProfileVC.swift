//
//  ProfileVC.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 20/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import SDWebImage

enum State {
    case exploreMore
    case homeScreen
    case otherProfile
}


// MARK:- ViewController Class
//===========================
class ProfileVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var facbookOn           = false
    var googleOn            = false
    var obUserDetails       : UserDetails?
    var profileDataModel    : ProfileDataModel!
    var gender              : GenderMF?
    var phoneNumber         : String?
    var dob                 : String?
    var selectedId          = [String]()
    var selectedCricketId   = [String]()
    var selectedFootballId  = [String]()
    var friendId            = String()
    var roomId              : String?
    var state: State        = .exploreMore
    var isBlock             : Bool = false
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileContactNumberLabel: UILabel!
    @IBOutlet weak var bottomSaperatorView: UIView!
    @IBOutlet weak var bottomSaperatorViewTop: NSLayoutConstraint!
    @IBOutlet weak var profileDobTextField: UITextField!
    @IBOutlet weak var fetchYourEventsLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var googleLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var maleFemaleBackgroundImage: UIImageView!
    @IBOutlet weak var topNavBar: UIView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var notificationUserBlockBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var facebookGoogleStackView: UIStackView!
    @IBOutlet weak var shadowViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fetchLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var facebookGoogleHeight: NSLayoutConstraint!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTextFieldTop: NSLayoutConstraint!

    @IBOutlet weak var interestsLbl: UILabel!
    @IBOutlet weak var addInterestsCollectionView: UICollectionView!
    @IBOutlet weak var interestContainerStackView: UIStackView!
    @IBOutlet weak var interestContainerStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var interestContainerStackViewBottom: NSLayoutConstraint!

    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.state == .otherProfile {
            self.hitOtherProfile()
        } else {
            self.hitProfileData()
        }
        
        self.obUserDetails = AppDelegate.shared.currentuser
        self.initialSetup()
        self.registerNibs()
        checkIfChatRoomExists()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.roundCorners()
    }

    @objc private func profileImageTapped(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView, let image = imageView.image else {
            CommonClass.showToast(msg: "Loading image...")
            return
        }
        let chatImagePreviewScene = ChatImagePreviewVC.instantiate(fromAppStoryboard: .Chat)
        chatImagePreviewScene.image = image
        chatImagePreviewScene.vcType = .profileImage
        chatImagePreviewScene.modalPresentationStyle = .overCurrentContext
        present(chatImagePreviewScene, animated: true, completion: nil)
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backButton(_ sender: UIButton) {
        
        AppDelegate.shared.configuration.menuWidth = 100.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        //        CommonClass.showToast(msg: "Under Development")
        
        if self.state == .exploreMore {
            //AppDelegate.shared.sharedTabbar?.hideTabbar()
        }
        
        let ob = SettingsVC.instantiate(fromAppStoryboard: .Settings)
        ob.state = self.state
        
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    @IBAction func notificationsBtnTapped(_ sender: UIButton) {
        if self.state == .otherProfile {
            self.blockView(sender)
        } else {
//            CommonClass.showToast(msg: "Under Development")
            let scene = NotificationsVC.instantiate(fromAppStoryboard: .Settings)
            scene.vcState = .profile
            self.navigationController?.pushViewController(scene, animated: true)
        }
    }
    
    @IBAction func faceBookButtonTap() {
        #if DEBUG
        self.facbookOn = !self.facbookOn
        self.faceBookGoogleMethod(isFaceBookSelected: true)
        #else
        CommonClass.showToast(msg: "Under Development")
        #endif
    }
    
    @IBAction func googleButtonTap() {
        self.googleOn = !self.googleOn
        self.faceBookGoogleMethod(isFaceBookSelected: false)
    }
    
    @IBAction func editButtonTap(_ sender: UIButton) {
        
        guard let userProfileData = profileDataModel else {
            CommonClass.showToast(msg: "Failed to fetch your profile")
            return
        }
        let controller = EditProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        controller.obProfileDataModel = userProfileData
        EditProfileVC.selectedId = self.selectedId
        controller.state = self.state
        controller.selectedCricketId = self.selectedCricketId
        controller.selectedFootballId = self.selectedFootballId
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
        
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "0" {
            EventsCoreDataController.deleteEvents()
        }
    }
    
}


//MARK: Extension: for Setting Up SubViews
//========================================
extension ProfileVC {
    
    //MARK:- initialSetup method
    //==========================
    private func initialSetup() {

        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor      = AppColors.themeBlueColor
        self.navigationTitle.text           = StringConstants.My_Profile.localized
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.shadowView.roundCornerWith(radius: 5)
        self.shadowView.dropShadow(width: 5, shadow: AppColors.shadowViewColor)
        
        self.profileNameTextField.placeholder   = StringConstants.Enter_Name.localized
        self.profileNameTextField.textColor     = AppColors.blackColor
        self.profileNameTextField.font          = AppFonts.Comfortaa_Bold_0.withSize(18.1)
        self.profileNameTextField.isEnabled     = false
        self.profileDobTextField.isEnabled      = false
        self.profileDobTextField.isEnabled      = true
        self.profileDobTextField.placeholder    = StringConstants.Enter_DOB.localized
        self.profileDobTextField.textColor      = AppColors.textFieldBaseLine
        self.profileDobTextField.font           = AppFonts.Comfortaa_Regular_0.withSize(12.5)
        
        self.locationTextField.placeholder      = "Location*"
        self.locationTextField.textColor        = AppColors.blackColor
        self.locationTextField.font             = AppFonts.Comfortaa_Bold_0.withSize(15.1)
        self.locationTextField.isEnabled        = false
        
        self.profileContactNumberLabel.text     = "Phone Number"
        self.profileContactNumberLabel.textColor    = AppColors.textFieldBaseLine
        self.profileContactNumberLabel.font         = AppFonts.Comfortaa_Regular_0.withSize(12.5)
        self.profileNameTextField.isEnabled         = false
        
        self.fetchYourEventsLabel.text              = StringConstants.Fetch_Your_Events_Via.localized
        self.fetchYourEventsLabel.textColor         = AppColors.themeBlueColor
        self.fetchYourEventsLabel.font              = AppFonts.Comfortaa_Bold_0.withSize(13)
        
        self.facebookLabel.text                     = StringConstants.Facebook.localized
        self.facebookLabel.textColor                = AppColors.blackColor
        self.facebookLabel.font                     = AppFonts.Comfortaa_Light_0.withSize(12.5)
        
        self.googleLabel.text                       = StringConstants.Google.localized
        self.googleLabel.textColor                  = AppColors.blackColor
        self.googleLabel.font                       = AppFonts.Comfortaa_Light_0.withSize(12.5)
        
        self.bottomSaperatorView.backgroundColor    = AppColors.textFieldBaseLine
        
        self.facebookGoogleBtn()
        
        if self.state == .otherProfile {
            self.setUpOtherProfile()
            self.navigationTitle.text = "Profile"
        }
    }
    
    func setUpOtherProfile() {
        
        self.fetchYourEventsLabel.isHidden = true
        self.facebookGoogleStackView.isHidden = true
        self.facebookLabel.isHidden = true
        self.facebookButton.isHidden = true
        self.googleLabel.isHidden = true
        self.googleButton.isHidden = true
        self.editProfileBtn.isHidden = true
        self.settingBtn.isHidden = true
        self.shadowViewHeight.constant = 240
        self.fetchLabelHeight.constant = 0
        self.facebookGoogleHeight.constant = 0
        self.notificationUserBlockBtn.setImage(AppImages.otherProfileDots, for: .normal)
        notificationUserBlockBtn.isHidden = (friendId == AppDelegate.shared.helpSupport.user_id)
    }
    
    //MARK:- setProfilePic method
    //===========================
    func setProfilePic() {
        
        if let imgUrl = URL(string: self.profileDataModel.image ) {
            
            self.maleFemaleBackgroundImage.sd_addActivityIndicator()
            self.maleFemaleBackgroundImage.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            self.maleFemaleBackgroundImage.sd_setImage(with: imgUrl, completed: { [weak self] (image, error, type, nurl) in

                guard let strongSelf = self, error == nil else {
                    return
                }

                strongSelf.maleFemaleBackgroundImage.image = image
                strongSelf.profileImage.isHidden = true

                let tapGesture = UITapGestureRecognizer(target: strongSelf, action: #selector(strongSelf.profileImageTapped))
                strongSelf.maleFemaleBackgroundImage.isUserInteractionEnabled = true
                strongSelf.maleFemaleBackgroundImage.addGestureRecognizer(tapGesture)
            })
        }
        self.profileImage.setImage(withSDWeb: self.profileDataModel.image, placeholderImage: AppImages.myprofilePlaceholder)
    }
    
    //MARK:- makeName method
    //======================
    func makeName() {
        
        var fullName = String()
        if let fName = self.profileDataModel?.first_name,
            !fName.isEmpty {
            fullName = fName
        }
        if let lName = self.profileDataModel?.last_name,
            !lName.isEmpty {
            fullName = fullName + " " + lName
        }
        if !fullName.isEmpty {
            self.profileNameTextField.text = fullName
        } else {
            self.profileNameTextField.text = ""
        }
        if let dob = self.profileDataModel?.dob, !dob.isEmpty {
            let str1 = dob.split(separator: " ")
            self.profileDobTextField.text = "\(str1[0]) \(str1[1])"
            profileDobTextField.isHidden = false
        } else {
            self.profileDobTextField.text = ""
            profileDobTextField.isHidden = true
        }
        if let location = self.profileDataModel?.location, !location.isEmpty {
            self.locationTextField.text = location
        }
    }
    
    //MARK:- facebookGoogleBtn method
    //===============================
    func facebookGoogleBtn() {
        
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.facebookEvent) == "1" {
            self.facebookButton.setImage(AppImages.icToggleOn, for: .normal)
            self.facbookOn = true
        } else {
            self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
            self.facbookOn = false
        }
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "1" {
            self.googleButton.setImage(AppImages.icToggleOn, for: .normal)
            self.googleOn = true
        } else {
            self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
            self.googleOn = false
        }
    }
    
    //MARK:- makePhone method
    //=======================
    func makePhone() {
        
        if let phone = self.profileDataModel?.phone_no, !phone.isEmpty {
            self.profileContactNumberLabel.text = "+91-" + phone
        }
    }
    
    //MARK:- faceBookGoogleMethod method
    //==================================
    func faceBookGoogleMethod(isFaceBookSelected: Bool) {
        
        let controller = EventsPopUpVC.instantiate(fromAppStoryboard: .Events)
        
        if isFaceBookSelected {
            
            if self.facbookOn {
                self.facebookButton.setImage(AppImages.icToggleOn, for: .normal)
                
                controller.socialType = SocialType.FaceBook
                controller.headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Facebook_Events_Now.localized)"
            } else {
                self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.facebookEvent)
                return
            }
        } else {
            
            if self.googleOn {
                self.googleButton.setImage(AppImages.icToggleOn, for: .normal)
                
                controller.socialType = SocialType.Google
                controller.headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Google_Events_Now.localized)"
            } else {
                self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
//                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                EventsCoreDataController.deleteEvents()
                return
            }
        }
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
    
    //MARK:- hitProfileData method
    //============================
    func hitProfileData(loader: Bool = true) {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_User_Profile.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        
//        AppNetworking.hideLoader()

        // Getting user Profile
        WebServices.getUserProfile(parameters: params, loader: loader, success: { (obProfileDataModel) in
            self.fillData(obProfileDataModel: obProfileDataModel)
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    func makeSelectedId() {

        AddInterestsVC.selectedId.removeAll()
        selectedCricketId.removeAll()
        selectedFootballId.removeAll()
        
        if let subCategory = self.profileDataModel?.subCategory {

            for temp in subCategory {
                self.selectedId.append(temp.id)
                if temp.id == "1" {
                    for t in temp.childCategory {
                        self.selectedCricketId.append(t.id)
                    }
                }
                if temp.id == "2" {
                    for t in temp.childCategory {
                        self.selectedFootballId.append(t.id)
                    }
                }
            }
        }
    }

    private func checkIfChatRoomExists() {

        guard !friendId.isEmpty else {
            return
        }
        let userId = AppDelegate.shared.currentuser.user_id

        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).observeSingleEvent(of: .value) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }

            if let roomId = snapshot.value as? String {
                strongSelf.roomId = roomId

            } else {

                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(strongSelf.friendId).child(userId).observeSingleEvent(of: .value) {  [weak self] (snapshot) in

                    guard let strongSelf = self else {
                        return
                    }

                    if let roomId = snapshot.value as? String {
                        strongSelf.roomId = roomId
                    }
                }
            }
        }
    }
    
    
    //MARK:- hitOtherProfile method
    //=============================
    func hitOtherProfile() {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Friend_Profile.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["friend_id"]     = self.friendId
        
//        AppNetworking.hideLoader()
        
        // Getting user Profile
        WebServices.getFriendsDetails(parameters: params, success: { [weak self] (code, obProfileDataModel) in

            guard let strongSelf = self else {
                return
            }

            if let profile = obProfileDataModel {
                strongSelf.fillData(obProfileDataModel: profile)
            } else if code == WSStatusCode.BLOCKED_BY_USER.rawValue {
                strongSelf.showUserBlockedAlert()
            }
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }

    private func showUserBlockedAlert() {
        let alert = UIAlertController(title: "Budfie", message: "You cannot view profile of this user!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- hitBlockUnBlock method
    //=============================
    func hitBlockUnBlock() {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Block_Unblock.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["friend_id"]     = self.friendId
        if self.isBlock {
            params["type"]      = "2"
        } else {
            params["type"]      = "1"
        }
        self.isBlock            = !self.isBlock
        
        // Getting user Profile
        WebServices.blockUnBlock(parameters: params, success: { (isBlocked) in
            if !isBlocked {
                self.isBlock = !self.isBlock
            } else if let roomId = self.roomId {
                if self.isBlock {
                    DatabaseReference.child(DatabaseNode.Root.userBlockStatus.rawValue).child(roomId).setValue(roomId)
                } else {
                    DatabaseReference.child(DatabaseNode.Root.userBlockStatus.rawValue).child(roomId).removeValue()
                }
            }
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    fileprivate func fillData(obProfileDataModel : ProfileDataModel) {
        
        self.profileDataModel = obProfileDataModel
        self.makeName()
        self.makePhone()
        self.makeSelectedId()
        self.setProfilePic()
        //        self.profileImage.setImage(withSDWeb: self.profileDataModel.image, placeholderImage: AppImages.myprofilePlaceholder)

        let interestCount = profileDataModel?.subCategory.count ?? 0
        if interestCount == 0 {
            interestsLbl.isHidden = true
            addInterestsCollectionView.isHidden = true
            interestContainerStackView.isHidden = true
            interestContainerStackViewTop.constant = 0
            interestContainerStackViewBottom.constant = 0
            bottomSaperatorViewTop.constant = 0
            locationTextFieldTop.constant = 0
            fetchLabelHeight.constant = 0
            shadowViewHeight.constant = 102
            bottomSaperatorView.isHidden = true
            locationImageView.isHidden = true
            locationTextField.isHidden = true
        } else {
            self.initialSetupCollectionview()
        }
        addInterestsCollectionView.reloadData()
    }
    
    func blockView (_ sender: UIButton) {
        
        AppDelegate.shared.configuration.menuIconSize = 15.0
        AppDelegate.shared.configuration.menuWidth = 100.0
        AppDelegate.shared.configuration.menuSeparatorInset = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: -10.0)
        
        var btnName = "Block"
        if self.isBlock {
            btnName = "Unblock"
            AppDelegate.shared.configuration.menuWidth = 110.0
        }
        FTPopOverMenu.showForSender(sender: sender,
                                    with: [btnName],
                                    menuImageArray: [AppImages.otherProfileBlock as UIImage],
                                    done: { (selectedIndex) -> () in
                                        self.hitBlockUnBlock()
                                        print(selectedIndex)
        }) {
            
        }
    }
    
}


//MARK: Extension: for Setting Up SubViews
//========================================
extension ProfileVC: EventsPopUpVCDelegate {
    
    func getResponse(isOkBtnTapped: Bool, socialType: SocialType) {
        if isOkBtnTapped {
            // Hit Service according to socialType
            print_debug(socialType)
            if socialType == SocialType.FaceBook {
//                AppUserDefaults.save(value: "1",
//                                     forKey: AppUserDefaults.Key.facebookEvent)
                FacebookController.shared.getFacebookEvents(true, fromViewController: self, completion: { (events, error) in

                    if error != nil {
                        AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.facebookEvent)
                        self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
                    }
                })
            } else {
//                AppUserDefaults.save(value: "1",
//                                     forKey: AppUserDefaults.Key.googleEvent)
                GoogleLoginController.shared.loginWithEventFetch(completion: { (events, error) in

                    if error != nil {
                        AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                        self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                    }
                })
            }
        } else {
            if socialType == SocialType.FaceBook {
                self.facbookOn = false
                AppUserDefaults.save(value: "0",
                                     forKey: AppUserDefaults.Key.facebookEvent)
                self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
            } else {
                self.googleOn = false
//                AppUserDefaults.save(value: "0",
//                                     forKey: AppUserDefaults.Key.googleEvent)
                self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                EventsCoreDataController.deleteEvents()
            }
        }
    }
    
}


extension ProfileVC: DoRefreshOnPop {
    
    func hitService() {
        self.hitProfileData(loader: false)
    }
}


//MARK: Extension: for SetProfilePicDelegate
//==========================================
extension ProfileVC: SetProfilePicDelegate {
    
    func changeProfilePic(picName: UIImage, gender: GenderMF) {
        
        if gender == .Custom {
            self.maleFemaleBackgroundImage.image = picName
            picName.uploadImageToS3(success: { (success, url) in
                print_debug(url)
                self.profileDataModel?.image = url
            }, progress: { (status) in
                print_debug(status)
            }, failure: { (error) in
                print_debug(error.localizedDescription)
            })
        } else {
            self.maleFemaleBackgroundImage.image = picName
        }
        self.profileImage.isHidden = true
        self.gender = gender
    }
}


//MARK: Extension for Registering Nibs and Setting Up SubViews
//============================================================
extension ProfileVC {
    
    private func initialSetupCollectionview() {
        self.addInterestsCollectionView.delegate = self
        self.addInterestsCollectionView.dataSource = self
    }
    
    private func registerNibs() {
        let cell = UINib(nibName: "AddInterestCell", bundle: nil)
        self.addInterestsCollectionView.register(cell, forCellWithReuseIdentifier: "AddInterestCellId")
    }
}


//MARK: Extension for UICollectionView Delegate and DataSource
//============================================================
extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return profileDataModel?.subCategory.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddInterestCellId", for: indexPath) as? AddInterestCell else { fatalError("AddInterestCell not found") }
        
        cell.populate(name: self.profileDataModel?.subCategory[indexPath.row].name ?? "", imageName: getImage(subCategoryId: self.profileDataModel?.subCategory[indexPath.row].id ?? ""))
        
        return cell
    }
    
}
//MARK: Extension for UICollectionView Layout
//===========================================
extension ProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:addInterestsCollectionView.frame.height - 30, height:addInterestsCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return spacingBetweenItems - 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return spacingTopDownItems
    }
    
}


