//
//  ProfilePicVC.swift
//  Budfie
//
//  Created by appinventiv on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

enum LRTBSpacing: CGFloat {
    case LeftRight = 30.0
    case TopBottom = 0.0
}

protocol SetProfilePicDelegate {
    func changeProfilePic(picName: UIImage, gender: GenderMF)
}
//enum ItemsInDisplay: String {
//    case Male       = "Male"
//    case Female     = "Female"
//    case Camera     = "Camera"
//    case Gallery    = "Gallery"
//    case Cricket    = "Cricket"
//    case Football   = "Football"
//    case Badminton  = "Badminton"
//    case Formula_1  = "Formula_1"
//    case Racing     = "Racing"
//    case Tennis     = "Tennis"
//    case Bollywood  = "Bollywood"
//    case Hollywood  = "Hollywood"
//    case Tollywood  = "Tollywood"
//    case Series     = "Series"
//}

//MARK:- ProfilePicVC Class
//=========================
class ProfilePicVC: BaseVc {
    
    //MARK:- Properties
    //=================
    let displayItems: [String] = [StringConstants.Male.localized,
                                  StringConstants.Female.localized,
                                  StringConstants.Camera.localized,
                                  StringConstants.Gallery.localized]
    var delegate: SetProfilePicDelegate?
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var backBtnName: UIButton!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var customizeProfileCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    
    
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
        
        let obAddInterestsVC = AddInterestsVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(obAddInterestsVC, animated: true)
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
        self.navigationTitle.text = StringConstants.My_Profile.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(16)
        
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





//MARK: Extension: for UICollection Delegate and DataSource
//=========================================================
extension ProfilePicVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCellId", for: indexPath) as? CommonImageCell else { fatalError("CommonImageCell not found") }
        
        cell.populate(name: displayItems[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            self.delegate?.changeProfilePic(picName: AppImages.ic_myprofile_male, gender: .Male)
        } else if indexPath.row == 1 {
            self.delegate?.changeProfilePic(picName: AppImages.ic_myprofile_female, gender: .Female)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



//MARK: Extension: for UICollection Layout
//========================================
extension ProfilePicVC: UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        return CGSize(width: 120, height: 150)
    //    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.customizeProfileCollectionView.frame.width - LRTBSpacing.LeftRight.rawValue * 3) / 2
        let height = (self.customizeProfileCollectionView.frame.height - LRTBSpacing.TopBottom.rawValue * 3) / 2
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: LRTBSpacing.TopBottom.rawValue,
                            left: LRTBSpacing.LeftRight.rawValue,
                            bottom: LRTBSpacing.TopBottom.rawValue,
                            right: LRTBSpacing.LeftRight.rawValue)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



//MARK: Extension: for Opening Camera or Gallery
//==============================================
extension ProfilePicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {


}

