//
//  AnimationsVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 25/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import IQKeyboardManagerSwift
import RealmSwift
import SDWebImage

enum GreetingType: Int {
    case animation = 1
    case faceInHole
    case popUp3D
    case classicFunny
    case normalImage
}

enum VCState {
    case draft
    case create
    case sent
    case receive
    case none
}

enum FlowType {
    case home
    case events
    case viewEvent
}

class AnimationsVC: BaseVc {

    // MARK: Enum

    // MARK: Public Properties
    var flowType: FlowType = .home
    var greetingType: GreetingType = .animation
    var vcState: VCState = .create
    var eventId = String()
    var eventDate = String()

    lazy var greeting = Greeting()
    var date = String()
    var greetingId = String()
    var selectedImage = String()
    var snappedImage: UIImage?

    // MARK: Private Properties
    fileprivate var selectedMusic: String?
    fileprivate var musicIndex: Int?
    fileprivate var colorSlider: ColorSlider!
    fileprivate var stickerLabel: JLStickerLabelView?
    fileprivate var hasViewAppearedOnce = false
//    fileprivate var images: [String] = []

    // MARK: IBOutlets
    @IBOutlet weak var stickerView: JLStickerImageView!

//    @IBOutlet weak var animationsCollectionContainerView: UIView!
//    @IBOutlet weak var animationsCollectionView: UICollectionView!

    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var togglingSliderView: UIView!

    @IBOutlet weak var greetingTitleTextField: UITextField!
    @IBOutlet weak var greetingDescriptionTextView: IQTextView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var addFaceBtn: UIButton!
    @IBOutlet weak var addMusicBtn: UIButton!

    @IBOutlet weak var togglingSliderViewLeading: NSLayoutConstraint!
    @IBOutlet weak var greetingDetailContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var greetingTitleTextFieldTrailing: NSLayoutConstraint!

    // MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if snappedImage != nil {
            greetingType = .normalImage
        }

        /*
        let amazonBucketUrl = "https://s3.amazonaws.com/appinventiv-development/budfie/test/"

        let funnyImages = [
            "\(amazonBucketUrl)1_undernewmanagement.png",
            "\(amazonBucketUrl)2_gameover.png",
            "\(amazonBucketUrl)3_meow.png",
            "\(amazonBucketUrl)4_sorry.png",
            "\(amazonBucketUrl)5_happybirthday.png",
            "\(amazonBucketUrl)6_sorry+for+being+such+as+ass.png",
            "\(amazonBucketUrl)7_you+are+hot.png",
            "\(amazonBucketUrl)8_soul+mates.png",
            "\(amazonBucketUrl)9_baby+shower.png",
            "\(amazonBucketUrl)10_happybirthday+2.png",
            "\(amazonBucketUrl)11_Party+time.png",
            "\(amazonBucketUrl)12_happy+Anniversary.png",
            "\(amazonBucketUrl)13_friday.png",
            "\(amazonBucketUrl)14_party+time2.png"
        ]

        let faceHoleImages = [
            "\(amazonBucketUrl)4.5.1_jamsebond.png",
            "\(amazonBucketUrl)4.5.2_monkey.png",
            "\(amazonBucketUrl)4.5.3_bikinigirl.png",
            "\(amazonBucketUrl)4.5.4_car.png",
            "\(amazonBucketUrl)4.5.5_santa.girls.png",
            "\(amazonBucketUrl)4.5.6_wonderwomen.png",
            "\(amazonBucketUrl)4.5.7_body-man.png",
            "\(amazonBucketUrl)4.5.8_bahubali.png",
            "\(amazonBucketUrl)4.5.9_superhero.png"
        ]

        let popUp3DImages = [
            "\(amazonBucketUrl)5.1_fan.png",
            "\(amazonBucketUrl)5.2_myheart.png",
            "\(amazonBucketUrl)5.3_flyheart.png",
            "\(amazonBucketUrl)5.4_Thanks+a+Million+.png",
            "\(amazonBucketUrl)5.5_missyou.png",
            "\(amazonBucketUrl)5.6_getwellsoon.png",
            "\(amazonBucketUrl)5.7_happy+birthday.png",
            "\(amazonBucketUrl)5.8_keep+smiling.png",
            "\(amazonBucketUrl)5.9_sending+love.png",
            "\(amazonBucketUrl)5.10_sending+love.png",
            "\(amazonBucketUrl)5.11_getwell+soon.png",
            "\(amazonBucketUrl)5.12_Birthday.png",
            "\(amazonBucketUrl)5.13_Thankyou.png"
        ]

        switch type {
        case .animation:
            images = []
        case .faceInHole:
            images = faceHoleImages
        case .popUp3D:
            images = popUp3DImages
        case .classicFunny:
            images = funnyImages
        }
*/
        switch self.greetingType {
        case .animation:
            self.navTitle.text = "Animations"
        case .faceInHole, .normalImage:
            self.navTitle.text = "Face In a Hole"
        case .popUp3D:
            self.navTitle.text = "Classic"
        case .classicFunny:
            self.navTitle.text = "Fun"
        }
        
        colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.addTarget(self, action: #selector(colorSliderDidChange), for: .valueChanged)
        sliderContainerView.addSubview(colorSlider)
        colorSlider.alpha = 0

        togglingSliderViewLeading.constant = (screenWidth - 50)
//        animationsCollectionContainerView.addQualityShadow(ofColor: .black)

//        animationsCollectionView.dataSource = self
//        animationsCollectionView.delegate = self

//        animationsCollectionView.allowsSelection = true
//        animationsCollectionView.allowsMultipleSelection = false

        let borderWidth: CGFloat = 1
        let borderColor = AppColors.themeBlueColor

        togglingSliderView.border(width: borderWidth, borderColor: borderColor)
        greetingTitleTextField.border(width: borderWidth, borderColor: borderColor)
        greetingDescriptionTextView.border(width: borderWidth, borderColor: borderColor)

        greetingTitleTextField.delegate = self
        greetingDescriptionTextView.delegate = self

        greetingTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        stickerView.fontName = AppFonts.Comfortaa_Regular_0.rawValue

        let addFaceBtnTypes: [GreetingType] = [.faceInHole, .normalImage]
        addFaceBtn.isHidden = !addFaceBtnTypes.contains(greetingType)

        /*
        let toggleSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleSwiped))
        toggleSwipeGesture.direction = .right
        toggleSwipeGesture.cancelsTouchesInView = false
        togglingSliderView.addGestureRecognizer(toggleSwipeGesture)
        */
            
        if vcState == .draft {

            if let imgData = greeting.faceInHoleImageData {
                let img = UIImage(data: imgData)
                if greetingType == .normalImage {
                    snappedImage = img
                }
                stickerView.image = img
            }

            greetingTitleTextField.text = greeting.greetingTitle
            greetingDescriptionTextView.text = greeting.greetingDescription
            //textViewDidChange(greetingDescriptionTextView)

        } else {
            
            if let realm = try? Realm() {
                try? realm.write {
                    
                    greeting.id = ""
                    greeting.faceHoleImageUrl = self.selectedImage
                    greeting.musicUrl = "https://s3.amazonaws.com/appinventiv-development/melodyloops-preview-happy-trip-1m0s+(1).mp3"
                    
                    realm.add(greeting)
                }
            }
            
            if let imgStr = greeting.faceHoleImageUrl,
                let url = URL(string: imgStr) {
                let options: SDWebImageOptions
                if url.isFileURL {
                    options = .refreshCached
                } else {
                    options = SDWebImageOptions()
                }
                self.stickerView.sd_addActivityIndicator()
                self.stickerView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
                stickerView.sd_setImage(with: url, placeholderImage: AppImages.myprofilePlaceholder, options: options)
            }
        }

        if greetingType == .animation {
            greetingDetailContainerViewBottom.constant = (140 - 56)
            greetingTitleTextFieldTrailing.constant = 10
            togglingSliderView.isHidden = true
            addMusicBtn.isHidden = true
        }

        if greetingType == .normalImage,
            let image = snappedImage {
            stickerView.image = image
            //addFaceBtn.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasViewAppearedOnce, vcState == .draft {

            if vcState == .draft,
                let r = greeting.greetingColor?.red,
                let g = greeting.greetingColor?.green,
                let b = greeting.greetingColor?.blue {

                let color = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
                colorSlider.color = color

            } else {
                colorSlider.color = UIColor.black
            }

            textViewDidChange(greetingDescriptionTextView)

            if let stickerLabel = stickerLabel {

                stickerLabel.labelTextView.center = CGPoint(x: CGFloat(greeting.descriptionViewX), y: CGFloat(greeting.descriptionViewY))

                stickerLabel.transform = CGAffineTransform(rotationAngle: CGFloat(greeting.descriptionViewRotation))
                if let scaleRect = greeting.descriptionViewBounds {
                    stickerLabel.adjust(with: scaleRect.rect)
                    stickerLabel.labelTextView.origin = CGPoint(x: 19, y: 19)
                }
                stickerLabel.layoutIfNeeded()
            }
        }
        hasViewAppearedOnce = true

        /*
        if animationsCollectionView.indexPathsForSelectedItems?.isEmpty == true {
            let initialIndexPath = IndexPath(item: 0, section: 0)
            animationsCollectionView.selectItem(at: initialIndexPath, animated: false, scrollPosition: .right)
            collectionView(animationsCollectionView, didSelectItemAt: initialIndexPath)
        }
        */
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !hasViewAppearedOnce else {
            return
        }

        colorSlider.frame = sliderContainerView.bounds
        colorSlider.frame.size.height = 15
        colorSlider.center.y = sliderContainerView.center.y

        let cornerRadius = greetingTitleTextField.height/2

        togglingSliderView.layer.cornerRadius = cornerRadius
        greetingTitleTextField.layer.cornerRadius = cornerRadius
        greetingDescriptionTextView.layer.cornerRadius = cornerRadius

        greetingDescriptionTextView.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5)

        let radius = addMusicBtn.height/2
        addFaceBtn.roundCornerWith(radius: radius)
        addMusicBtn.roundCornerWith(radius: radius)
    }

    // MARK: Private Methods
    @objc private func toggleSwiped(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            print_debug("Swiped right")
        case .left:
            print_debug("Swiped left")
        default:
            break
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {

    }

    @objc private func colorSliderDidChange(_ sender: ColorSlider) {

        let newColor = sender.color

        // Did this because when attributed text is set in textfield
        // even when user types or we set normal text to it. So
        // when changing text color when textfield is not in focus
        // does nothing until typing again begins. Now when we set
        // its text back to it again, the attributed text gets
        // refreshed and changed color is now visible.

        /*
        let greetingsTitle = greetingTitleTextField.text
        greetingTitleTextField.textColor = newColor
        greetingTitleTextField.text = greetingsTitle

        greetingDescriptionTextView.textColor = newColor
        */

        stickerView.textColor = newColor

        if let stickerLabel = stickerLabel {
            stickerLabel.labelTextView.foregroundColor = newColor
        }
    }

    private func animatedColorSlider(to position: CGFloat, hiding colorSlider: Bool) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.togglingSliderViewLeading.constant = position
            self.colorSlider.alpha = (colorSlider ? 0 : 1)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: IBActions
    @IBAction func openSliderBtnTapped(_ sender: UIButton) {

        let finalSliderPosition: CGFloat = 10
        guard togglingSliderViewLeading.constant != finalSliderPosition else {
            return
        }

        animatedColorSlider(to: finalSliderPosition, hiding: false)
    }

    @IBAction func closeSliderBtnTapped(_ sender: UIButton) {

        let finalSliderPosition = (screenWidth - 50)
        guard togglingSliderViewLeading.constant != finalSliderPosition else {
            return
        }
        animatedColorSlider(to: finalSliderPosition, hiding: true)
    }
    
    @IBAction func addMusicBtnTapped(_ sender: UIButton) {
        
        let selectMusicPopUpScene = SelectMusicPopUpVC.instantiate(fromAppStoryboard: .Greeting)
        selectMusicPopUpScene.modalPresentationStyle = .overCurrentContext
        selectMusicPopUpScene.delegate = self
        selectMusicPopUpScene.selectedRow = musicIndex ?? -1
        selectMusicPopUpScene.selectedMusic = selectedMusic
        present(selectMusicPopUpScene, animated: false, completion: nil)
    }
    
    @IBAction func addFaceBtnTapped(_ sender: UIButton) {
        AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image, allowsEditing: false)
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func doneBtnTapped(_ sender: UIButton) {

        guard let greetingTitle = greetingTitleTextField.text, !greetingTitle.isEmpty else {
            CommonClass.showToast(msg: "Please add title to this greeting")
            return
        }

        stickerLabel?.hideEditingHandlers()
        view.endEditing(true)
        AppNetworking.showLoader()

        if greetingType == .animation {

            if let url = URL(string: selectedImage) {
                if url.isFileURL {
                    uploadGIF(url)
                } else {
                    self.getGreetingId(for: selectedImage)
                }
            }

        } else {

            let snapShotImage: UIImage

            if greetingType == .normalImage,
                let image = snappedImage {
                snapShotImage = image
            } else if #available(iOS 10.0, *) {
                snapShotImage = stickerView.asImage(frame: stickerView.bounds)
            } else {
                snapShotImage = stickerView.asImageIniOS9(frame: stickerView.bounds)
            }

            uploadGreetingImage(snapShotImage)
        }
    }

    private func uploadGIF(_ url: URL) {

        url.uploadToS3(success: { [weak self] (success, greetingImageUrl) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.getGreetingId(for: greetingImageUrl)

            }, progress: { (status) in

        }, failure: { (error) in

            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    private func uploadGreetingImage(_ image: UIImage) {

        let imageName = "\(Int(Date().timeIntervalSince1970)).png"
        //let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)/\(imageName)"

        image.uploadImageToS3(imageurl: imageName, success: { [weak self] (success, greetingImageUrl) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.getGreetingId(for: greetingImageUrl)

            }, progress: { (status) in

        }, failure: { (error) in

            AppNetworking.hideLoader()
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    private func getGreetingId(for greetingImageUrl: String) {

        let typeValue: Int
        if greetingType == .normalImage {
            typeValue = 2
        } else {
            typeValue = greetingType.rawValue
        }

        var parameters: JSONDictionary = ["access_token": AppDelegate.shared.currentuser.access_token,
                                          "method": "create_greeting",
                                          "type": typeValue,
                                          "title": greetingTitleTextField.text!,
                                          "url": greetingImageUrl]

        if let music = selectedMusic {
            parameters["music"] = music
        }
        if let color = greeting.greetingColor {
            parameters["color"] = color.hex
        }

        WebServices.createGreeting(parameters: parameters, success: { [weak self] greetingId in

            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.eventId.isEmpty {
                AppNetworking.hideLoader()

                strongSelf.greetingId = greetingId
                strongSelf.saveGreeting(with: greetingId, greetingImage: greetingImageUrl)
                
                let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
                controller.delegate = self
                controller.pageState = .greeting
                strongSelf.addChildViewController(controller)
                strongSelf.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
                //controller.present(controller, animated: false, completion: nil)
                
            } else {
                strongSelf.addGreetingToEvent(greetingId: greetingId, greetingImg: greetingImageUrl)
                
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.delete(strongSelf.greeting)
                    }
                }
            }
            
            }, failure: { error in

                AppNetworking.hideLoader()
                CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK:- hitAddGreeting method
    //==============================
    private func addGreetingToEvent(greetingId: String, greetingImg: String) {
        
        let params: JSONDictionary = ["method": "edit",
                                      "access_token": AppDelegate.shared.currentuser.access_token,
                                      "greeting_id": greetingId,
                                      "event_id": eventId]
        
        // Add Greeting
        //================
        WebServices.editEvent(parameters: params, loader: false, success: { [weak self] (isSuccess) in
            
            AppNetworking.hideLoader()
            
            guard let strongSelf = self else {
                return
            }
            
             if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
             let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
             controller.state = .invite
             controller.delegate = strongSelf
             strongSelf.addChildViewController(controller)
             strongSelf.view.addSubview(controller.view)
             controller.didMove(toParentViewController: self)
             //                controller.modalPresentationStyle = .overCurrentContext
             //                self.present(controller, animated: false, completion: nil)
             } else {
                strongSelf.pushHomeScreen()
             }
            
            if isSuccess {
                
                if strongSelf.eventDate.isEmpty {
                    let userInfo: [AnyHashable : Any] = ["greeting_id": greetingId,
                                                         "greeting_image": greetingImg]
                    NotificationCenter.default.post(name: Notification.Name.DidEditGreeting,
                                                    object: nil,
                                                    userInfo: userInfo)
                    return
                }
                
                guard let date = strongSelf.eventDate.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) else {
                    return
                }
                
                let userInfo: [AnyHashable : Any] = ["eventDate": date]
                NotificationCenter.default.post(name: NSNotification.Name.DidChooseDate,
                                                object: nil,
                                                userInfo: userInfo)
            }
            }, failure: { (err) in
                AppNetworking.hideLoader()
                CommonClass.showToast(msg: err.localizedDescription)
        })
    }

    private func saveGreeting(with id: String, greetingImage url: String) {
        guard let realm = try? Realm() else {
            return
        }

        do {
            try realm.write {

                realm.add(greeting)

                let color = GreetingColor()
                let newCiColor = CIColor(color: colorSlider.color)
                color.red = Double(newCiColor.red)
                color.blue = Double(newCiColor.blue)
                color.green = Double(newCiColor.green)

                greeting.greetingTitle = greetingTitleTextField.text
                greeting.greetingDescription = greetingDescriptionTextView.text

                greeting.id = id
                greeting.greetingType = greetingType.rawValue
                greeting.faceInHoleImageUrl = url

                let currentDate = Date()
                greeting.dateString = currentDate.toString(dateFormat: DateFormat.shortDate.rawValue)

                greeting.greetingColor = color
                greeting.musicUrl = selectedMusic
                greeting.isDraft = true

                if let stickerLabel = stickerLabel {
                    greeting.descriptionViewX = Double(stickerLabel.center.x)
                    greeting.descriptionViewY = Double(stickerLabel.center.y)

                    let greetingRect = GreetingRect()
                    greetingRect.x = Double(stickerLabel.bounds.minX)
                    greetingRect.y = Double(stickerLabel.bounds.minY)
                    greetingRect.width = Double(stickerLabel.bounds.width)
                    greetingRect.height = Double(stickerLabel.bounds.height)
                    greeting.descriptionViewBounds = greetingRect

                    let rotation = atan2(stickerLabel.transform.b, stickerLabel.transform.a)
                    greeting.descriptionViewRotation = Double(rotation)
                }

                if let img = stickerView.image {
                    greeting.faceInHoleImageData = UIImageJPEGRepresentation(img, 1)
                }
            }
        } catch {
            print_debug(error.localizedDescription)
        }
    }

}


// MARK: Music Delegate Methods
extension AnimationsVC: MusicDelegate {

    func didSelectMusic(_ music: String, index: Int) {
        selectedMusic = music
        musicIndex = index
        
    }
}


//MARK:- AnimationsVC Delegate Extension
//======================================
extension AnimationsVC: PushToHomeScreenDelegate {
    
    func pushHomeScreen() {
        
        guard let nav = self.navigationController else { return }
        
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        if nav.popToClass(type: TabBarVC.self) {
            if !self.eventDate.isEmpty {
                NotificationCenter.default.post(name: Notification.Name.EventAdded,
                                                object: nil,
                                                userInfo: ["eventDate": self.eventDate as String])
                //self.delegate?.eventAdded(date: eventD)
            }
        }
    }
}


//MARK: Extension for Opening Camera or Gallery
//=============================================
extension AnimationsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            if greetingType == .faceInHole {
                let faceInHoleScene = FaceInHoleVC.instantiate(fromAppStoryboard: .Greeting)
                faceInHoleScene.delegate = self
                faceInHoleScene.vcState = .create
                faceInHoleScene.imageViewHeight = stickerView.height
                faceInHoleScene.greeting = greeting
                faceInHoleScene.faceImage = pickedImage

                picker.dismiss(animated: true) {
                    self.present(faceInHoleScene, animated: true, completion: nil)
                }

            } else {
                snappedImage = pickedImage
                stickerView.image = pickedImage
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

// MARK: Face in a Hole Delegate Methods
extension AnimationsVC: FaceInHoleDelegate {

    func didFinishPuttingFaceInHole(image: UIImage?) {
        stickerView.image = image
    }
}

//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension AnimationsVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            
            let greetingPreviewScene = GreetingPreviewVC.instantiate(fromAppStoryboard: .Greeting)
            greetingPreviewScene.greeting = self.greeting
            greetingPreviewScene.vcState = self.vcState
            self.navigationController?.pushViewController(greetingPreviewScene, animated: true)
            
            /*
            let alertController = UIAlertController(title: "Please select",
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
            
            let  budfieShare = UIAlertAction(title: "Budfie Share", style: .default, handler: { _ in
                
               
                
            })
            alertController.addAction(budfieShare)
            
            let  normalShare = UIAlertAction(title: "Normal Share", style: .default, handler: { _ in
                
                CommonClass.externalShare(textURL: "url", viewController: self)
                
            })
            alertController.addAction(normalShare)
            
            let cancelAction = UIAlertAction(title: StringConstants.Cancel.localized, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
 */
            
        } else {
            
            //AppDelegate.shared.sharedTabbar?.showTabbar()
            
            let typeOfGreetingVCScene = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
            self.navigationController?.pushViewController(typeOfGreetingVCScene, animated: true)
            //            if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
            //                let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
            //                controller.state = .invite
            //                controller.delegate = self
            //                self.addChildViewController(controller)
            //                self.view.addSubview(controller.view)
            //                controller.didMove(toParentViewController: self)
            //            } else {
            //                self.pushHomeScreen()
            //            }
        }
    }
    
}

/*
 let greetingPreviewScene = GreetingPreviewVC.instantiate(fromAppStoryboard: .Greeting)
 greetingPreviewScene.greeting = greeting
 greetingPreviewScene.vcState = .draft
 navigationController?.pushViewController(greetingPreviewScene, animated: true)
 */

////MARK:- AddEventsVC Delegate Extension
////=====================================
//extension AnimationsVC: PushToHomeScreenDelegate {
//
//    func pushHomeScreen() {
//
//        guard let nav = self.navigationController else { return }
//
//        AppDelegate.shared.sharedTabbar.showTabbar()
//        if nav.popToClass(type: EventVC.self) {
//            self.delegate?.eventAdded(date: Date().toString(dateFormat: DateFormat.dOBServerFormat.rawValue))
//            nav.popToRootViewController(animated: true)
//        }
//    }
//}
/*
// MARK: CollectionView DataSource Methods
extension AnimationsVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimationCollectionCell", for: indexPath) as? AnimationCollectionCell else {
            fatalError("AnimationCollectionCell not found")
        }

        if let _ = URL(string: images[indexPath.item]) {
            cell.animationImageView.setImage(withSDWeb: images[indexPath.item], placeholderImage: AppImages.myprofilePlaceholder)
        }
        return cell
    }
}

// MARK: CollectionView Delegate Methods
extension AnimationsVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true
        }
        stickerView.image = nil
        if let _ = URL(string: images[indexPath.item]) {
            stickerView.setImage(withSDWeb: images[indexPath.item], placeholderImage: AppImages.myprofilePlaceholder)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = false
        }
    }
}
*/
// MARK: TextField Delegate Methods
extension AnimationsVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }

        let userEnteredString = textField.text ?? ""
        let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as String
        return (newString.count <= 30)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: TextView Delegate Methods
extension AnimationsVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        if let text = textView.text, !text.isEmpty {
            let stickerLabel: JLStickerLabelView

            if let label = self.stickerLabel {
                stickerLabel = label

            } else {

                stickerLabel = stickerView.addLabel()
                self.stickerLabel = stickerLabel

                //stickerLabel.closeView?.image = UIImage(named: "cancel")
                //stickerLabel.rotateView?.image = UIImage(named: "rotate")

                stickerLabel.border?.strokeColor = UIColor.white.cgColor
                stickerLabel.border?.lineWidth = 2

                stickerLabel.enableClose = false
                stickerLabel.closeView?.isHidden = true

                stickerLabel.labelTextView.isUserInteractionEnabled = false
                stickerLabel.labelTextView.foregroundColor = colorSlider.color
            }

            stickerLabel.labelTextView.text = text
            stickerLabel.textViewDidChange(stickerLabel.labelTextView)
            //stickerView.limitImageViewToSuperView()

        } else if let label = stickerLabel {
            label.removeFromSuperview()
            stickerLabel = nil
        }
    }
}
/*
// MARK: CollectionView Cell Class
class AnimationCollectionCell: UICollectionViewCell {

    @IBOutlet weak var animationImageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                clipsToBounds = false
                layer.borderWidth = 2
            } else {
                layer.borderWidth = 0
                clipsToBounds = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        addQualityShadow(ofColor: .black)
        layer.borderColor = AppColors.themeBlueColor.cgColor
        clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        layer.borderWidth = 0
        clipsToBounds = true
    }
}
*/
