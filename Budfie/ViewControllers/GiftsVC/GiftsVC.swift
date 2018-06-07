//
//  GiftsVC.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SafariServices

class GiftsVC: BaseVc {

    // MARK: Public Properties
    var vcState: VCState = .home
    var giftListing = [GiftingListModel]()
    
    enum VCState {
        case exploreMore
        case home
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var giftsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitGiftingList()
        self.initialSetup()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if vcState == .exploreMore {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- Private Extension
//========================
extension GiftsVC {
    
    private func initialSetup() {
        
        self.giftsTableView.delegate = self
        self.giftsTableView.dataSource = self
        self.giftsTableView.backgroundColor = UIColor.clear
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        if vcState == .exploreMore {
            backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        } else {
            backBtn.setImage(AppImages.selectionBudfieicon, for: .normal)
        }
    }
    
    func shareGiftingImage(imageName: UIImage) {
        
        CommonClass.imageShare(textURL: "Giting", shareImage: imageName, viewController: self)
        
        /*
        let alertController = UIAlertController(title: "Please select",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let  budfieShare = UIAlertAction(title: "Budfie Share", style: .default, handler: { _ in
            
            /*
            let scene = InviteesVC.instantiate(fromAppStoryboard: .Events)
            //            scene.state = .greeting
            self.navigationController?.pushViewController(scene, animated: true)
            */
            CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
            
        })
        alertController.addAction(budfieShare)
        
        let  normalShare = UIAlertAction(title: "Normal Share", style: .default, handler: { _ in
            
            CommonClass.imageShare(textURL: "Giting Testing", shareImage: imageName, viewController: self)
            
        })
        alertController.addAction(normalShare)
        
        let cancelAction = UIAlertAction(title: StringConstants.Cancel.localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        */
    }
    
    //MARK:- hitGiftingList method
    //============================
    func hitGiftingList() {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Gift_List.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token

        //TYPE (1=Sent,2=Received,3=Draft)
        
        WebServices.getGiftingList(parameters: params, success: { [weak self] (isSuccess,model) in

            guard let strongSelf = self else {
                return
            }
            
            strongSelf.giftListing = model
            strongSelf.giftsTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    func openLinks(link: String) {
        
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(url: URL(string: link)!)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(URL(string: link)!)
        }
    }
    
}

//MARK:- Private Extension
//========================
extension GiftsVC: FreeGiftDelegate {
    
    func getSelectedImage(imageName: UIImage) {
        shareGiftingImage(imageName: imageName)
    }

    func getSelectedImageURL(url: String) {
        let modifiedText = "Click link for special wish ....\n\(url)"
        let shareController = UIActivityViewController(activityItems: [modifiedText], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = view
        present(shareController, animated: true, completion: nil)
    }
}
