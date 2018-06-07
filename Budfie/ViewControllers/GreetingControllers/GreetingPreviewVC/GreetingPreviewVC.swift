//
//  GreetingPreviewVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 09/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage
import FreeStreamer
import SDWebImage

class GreetingPreviewVC: BaseVc {

    var greeting            : Greeting!
    var vcState             : VCState = .draft
    var flowType            : FlowType = .home
    var modelGreetingDetail = [GreetingDetailsModel]()
    var modelGreetingList   : GreetingListModel?

    lazy var audioPlayer = FSAudioStream()
    
    @IBOutlet weak var greetingTitleLabel   : UILabel!
    @IBOutlet weak var greetingImageView    : FLAnimatedImageView!
    @IBOutlet weak var shareBtn             : UIButton!
    @IBOutlet weak var sharedFriendsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.vcState == .sent || self.vcState == .receive || self.flowType == .viewEvent) && self.flowType != .events {
            self.hitGreetingDetails(greetingId: "")
        }
        self.initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        greetingImageView.roundCornerWith(radius: 5)
        greetingImageView.dropShadow(width: 5, shadow: AppColors.calenderShadow)
        greetingImageView.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        audioPlayer.stop()

        if let musicURLString = self.modelGreetingList?.music,
            let path = Bundle.main.path(forResource: musicURLString, ofType: ".mp3"),
            let musicURL = URL(string: "file://\(path)") {
            audioPlayer.play(from: musicURL)

        } else if greeting != nil,
            let musicURLString = greeting.musicUrl,
            let path = Bundle.main.path(forResource: musicURLString, ofType: ".mp3"),
            let musicURL = URL(string: "file://\(path)") {

            audioPlayer.play(from: musicURL)
        }
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        audioPlayer.stop()
        
        switch vcState {
        case .sent, .receive, .draft:
            self.navigationController?.popViewController(animated: true)
            
        case .create:
            popToController(TabBarVC.self, animated: true)
            
        case .none:
            switch flowType {
            case .home:
                break
                
            case .events, .viewEvent:
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        audioPlayer.stop()

        if let urlString = self.modelGreetingList?.greeting {

            if urlString.hasSuffix(".gif") {
                CommonClass.showBudfieShare(text: urlString, image: nil, on: self, shareDelegate: self)

            } else if let url = URL(string: urlString) {

                AppNetworking.showLoader()
                SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions.useNSURLCache, progress: nil) { (image, _, error, _) in
                    AppNetworking.hideLoader()

                    if let e = error {
                        CommonClass.showToast(msg: e.localizedDescription)
                    } else if let unwrappedImage = image {
                        CommonClass.showBudfieShare(text: "", image: unwrappedImage, on: self, shareDelegate: self)
                    }
                }
            }

        } else if let urlString = self.greeting.faceInHoleImageUrl,
            let url = URL(string: urlString) {

            AppNetworking.showLoader()
            SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions.useNSURLCache, progress: nil) { (image, _, error, _) in
                AppNetworking.hideLoader()

                if let e = error {
                    CommonClass.showToast(msg: e.localizedDescription)
                } else if let unwrappedImage = image {
                    CommonClass.showBudfieShare(text: "", image: unwrappedImage, on: self, shareDelegate: self)
                }
            }
        }

        /*
        let alertController = UIAlertController(title: "Please select",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let  budfieShare = UIAlertAction(title: "Budfie Share", style: .default, handler: { _ in
            
            var greetingId = String()
            //var isDraft = true

            if let id = self.modelGreetingList?.greeting_id/*, self.vcState != .draft*/ {
                greetingId = id
                //isDraft = false
            } else if let id = self.greeting.id { //&& self.vcState == .create {
                greetingId = id
            }
            /*
            else {
                greetingId = self.greeting.id!
                isDraft = self.greeting.isDraft
            }
            */
            let scene = InviteesVC.instantiate(fromAppStoryboard: .Events)
            scene.state = .greeting
            scene.eventId = greetingId
            scene.isDraft = (self.vcState == .draft)
            self.navigationController?.pushViewController(scene, animated: true)
        })
        alertController.addAction(budfieShare)
        
        let  normalShare = UIAlertAction(title: "Normal Share", style: .default, handler: { _ in
            
            if let url = self.modelGreetingList?.greeting {
                
                let image = UIImageView()
                image.setImage(withSDWeb: url, placeholderImage: AppImages.myprofilePlaceholder)
                
                if let shareImage = image.image {
                    
                    CommonClass.imageShare(textURL: url,
                                           shareImage: shareImage,
                                           viewController: self)
                    //                CommonClass.externalShare(textURL: url, viewController: self)
                }
            } else if let url = self.greeting.faceInHoleImageUrl {
                CommonClass.externalShare(textURL: url, viewController: self)
            }
        })
        alertController.addAction(normalShare)
        
        let cancelAction = UIAlertAction(title: StringConstants.Cancel.localized,
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController,
                animated: true,
                completion: nil)
        */
    }
    
}

extension GreetingPreviewVC: BudfieShareDelegate {

    func shareWithBudfie() {
        var greetingId = String()
        //var isDraft = true

        if let id = self.modelGreetingList?.greeting_id/*, self.vcState != .draft*/ {
            greetingId = id
            //isDraft = false
        } else if let id = self.greeting.id { //&& self.vcState == .create {
            greetingId = id
        }
        /*
         else {
         greetingId = self.greeting.id!
         isDraft = self.greeting.isDraft
         }
         */
        let scene = InviteesVC.instantiate(fromAppStoryboard: .Events)
        scene.state = .greeting
        scene.eventId = greetingId
        scene.isDraft = (vcState == .draft || vcState == .create)
        self.navigationController?.pushViewController(scene, animated: true)
    }
}

extension GreetingPreviewVC {
    
    private func initialSetup() {

        setGreetingInfo()

        /*
        if let imgString = imgURl {
            SDWebImageManager.shared().imageCache?.removeImage(forKey: imgString, withCompletion: {
                if imgString == "https://s3.amazonaws.com/appinventiv-development/iOS/1519545754.gif" {
                    self.greetingImageView.setImage(withSDWeb: "https://colinbendell.cloudinary.com/image/upload/c_crop,f_auto,g_auto,h_350,w_400/v1512090971/Wizard-Clap-by-Markus-Magnusson.gif",
                                                    placeholderImage: AppImages.myprofilePlaceholder)

                } else {
                    self.greetingImageView.setImage(withSDWeb: imgString,
                                                    placeholderImage: AppImages.myprofilePlaceholder)
                }
            })
        }
        */

        //"https://colinbendell.cloudinary.com/image/upload/c_crop,f_auto,g_auto,h_350,w_400/v1512090971/Wizard-Clap-by-Markus-Magnusson.gif"
        
        self.sharedFriendsTableView.delegate = self
        self.sharedFriendsTableView.dataSource = self
        
        self.shareBtn.titleLabel?.font          = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.shareBtn.titleLabel?.textColor     = AppColors.themeBlueColor
        self.shareBtn.roundCommonButtonPositive(title: "Share")

        if self.flowType == .events {
            self.shareBtn.isHidden = true
        } else {
            self.shareBtn.isHidden = false
        }
    }

    private func setGreetingInfo() {
        var imgURl : String?
        var greetingTitle : String?

        if self.vcState == .sent || self.vcState == .receive || self.vcState == .draft || self.flowType == .events || self.flowType == .viewEvent {
            greetingTitle = self.modelGreetingList?.title
            imgURl = self.modelGreetingList?.greeting
        } else {
            greetingTitle = greeting.greetingTitle
            imgURl = greeting.faceInHoleImageUrl
        }

        if let title = greetingTitle {
            greetingTitleLabel.text = title
        }

        /*
         greetingImageView.border(width: 1, borderColor: AppColors.addEventBaseLine)

         if let imgString = imgURl,
         let url = URL(string: imgString) {
         greetingImageView.sd_setImage(with: url)
         }
         */

        if let imgString = imgURl {
            greetingImageView.setImage(withSDWeb: imgString,
                                       placeholderImage: AppImages.myprofilePlaceholder)
        }
    }
        
    //MARK:- hitGreetingDetails method
    //================================
    func hitGreetingDetails(greetingId: String = "", page: String = "", loader: Bool = true) {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Greeting_Details.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["page"]          = "1"
        
        if self.vcState == .sent {
            params["type"]          = "1"
        } else if self.vcState == .receive {
            params["share_id"]      = self.modelGreetingList?.share_id
            params["type"]          = "2"
        } else if self.flowType == .events || self.flowType == .viewEvent {
            
            if let shareId = self.modelGreetingList?.share_id,
                shareId == AppDelegate.shared.currentuser.user_id {
                params["type"]          = "1"
            } else {
                params["type"]          = "2"
            }
        }
        
        if let id = self.modelGreetingList?.greeting_id/*, self.vcState != .draft*/ {
            params["greeting_id"]   = id//greetingId
        }
        
        //TYPE (1=Sent,2=Received)
        
        WebServices.getGreetingDetails(parameters: params, loader: loader, success: { (model) in
//            self.settingEmptyDataSet(isLoading: false)
            self.modelGreetingDetail = model
            self.setGreetingInfo()
//            self.modelGreetingDetail
            
            self.sharedFriendsTableView.reloadData()
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    /*
    func settingEmptyDataSet(isLoading: Bool = true) {
        
        var placeholder = ""
        if isLoading {
            placeholder = "Loading..."
        } else {
            placeholder = "No Shared User"
        }
        
        let myAttribute = [ NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                            NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: placeholder, attributes: myAttribute)
        
        self.sharedFriendsTableView.emptyDataSetView { view in
            view.titleLabelString(myAttrString)
                //                .detailLabelString(NSAttributedString.init(string: "No Data"))
                //                .image(AppImages.icNodata)
                //                .imageAnimation(imageAnimation)
                //                .buttonTitle(buttonTitle, for: .normal)
                //                .buttonTitle(buttonTitle, for: .highlighted)
                //                .buttonBackgroundImage(buttonBackgroundImage, for: .normal)
                //                .buttonBackgroundImage(buttonBackgroundImage, for: .highlighted)
                //                .dataSetBackgroundColor(backgroundColor)
                //                .verticalOffset(verticalOffset)
                //                .verticalSpace(spaceHeight)
                //                .shouldDisplay(true, view: tableView)
                //                .shouldFadeIn(true)
                //                .isTouchAllowed(true)
                //                .isScrollAllowed(true)
                .isImageViewAnimateAllowed(true)
                .didTapDataButton {
                    // Do something
                }
                .didTapContentView {
                    // Do something
            }
        }
    }
 */
        
}

/*
//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension GreetingPreviewVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
}
 */
