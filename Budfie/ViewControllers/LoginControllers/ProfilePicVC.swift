//
//  ProfilePicVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- Left Right Top Bottom Spacing For Items of Collection View
//=================================================================
enum LRTBSpacing: CGFloat {
    case LeftRight = 30.0
    case TopBottom = 0.0
}

//MARK:- Set Profile Pic Delegate
//===============================
protocol SetProfilePicDelegate : class{
    func changeProfilePic(picName: UIImage, gender: GenderMF)
}

//MARK:- ProfilePicVC Class
//=========================
class ProfilePicVC: BaseVc {
    
    //MARK:- Properties
    //=================
    let displayItems: [String] = [StringConstants.Male.localized,
                                  StringConstants.Female.localized,
                                  StringConstants.Camera.localized,
                                  StringConstants.Gallery.localized]
    weak var delegate: SetProfilePicDelegate?
    var selectedIndex = -1
    var profilePic : UIImage?
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : UIView!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var backBtnName      : UIButton!
    @IBOutlet weak var chooseLabel      : UILabel!
    @IBOutlet weak var customizeProfileCollectionView: UICollectionView!
    @IBOutlet weak var submitButton     : UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        self.registerNibs()
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        if self.selectedIndex == 0 {
            self.delegate?.changeProfilePic(picName: AppImages.ic_myprofile_male, gender: .Male)
        } else if self.selectedIndex == 1 {
            self.delegate?.changeProfilePic(picName: AppImages.ic_myprofile_female, gender: .Female)
        } else {
            if let profilePic = self.profilePic {
                self.delegate?.changeProfilePic(picName: profilePic, gender: .Custom)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension ProfilePicVC {
    
    private func initialSetup(){
        
        // set header view..
        self.navigationView.backgroundColor = AppColors.themeBlueColor
        self.navigationView.curvView()// For curve shape view..
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.Profile_Pic.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtnName.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.chooseLabel.text = StringConstants.Choose.localized
        self.chooseLabel.textColor = AppColors.blackColor
        self.chooseLabel.font = AppFonts.Comfortaa_Bold_0.withSize(16)
        
        self.submitButton.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitButton.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        self.submitButton.roundCommonButton(title: StringConstants.SUBMIT.localized)
        
        self.customizeProfileCollectionView.delegate = self
        self.customizeProfileCollectionView.dataSource = self
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "CommonImageCell", bundle: nil)
        self.customizeProfileCollectionView.register(cell, forCellWithReuseIdentifier: "CommonImageCellId")
    }
    
}


//MARK: Extension: for Opening Camera or Gallery
//==============================================
extension ProfilePicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePic = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
        if let profilePic = self.profilePic{
            self.delegate?.changeProfilePic(picName: profilePic, gender: .Custom)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.selectedIndex = -1
        self.customizeProfileCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}
