//
//  FaceInHoleVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 01/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift
import SDWebImage

// MARK: FaceInHole Delegate

protocol FaceInHoleDelegate: class {
    func didFinishPuttingFaceInHole(image: UIImage?)
}

class FaceInHoleVC: BaseVc {

    // MARK: Public Properties
    var flowType: FlowType = .home
    var greetingType: GreetingType = .animation
    var vcState: VCState = .create
    
    var faceImage: UIImage?
    var imageViewHeight: CGFloat = 0
    var greeting: Greeting?
    var selectedImage = String()
    weak var delegate: FaceInHoleDelegate?

    // MARK: Private Properties
    fileprivate var holeImage: UIImage?
    fileprivate lazy var faceImageView = UIImageView()
    fileprivate var hasViewAppearedOnce = false

    // MARK: IBOutlets
    @IBOutlet weak var faceInHoleImageView: UIImageView!
    @IBOutlet weak var faceInHoleImageViewHeight: NSLayoutConstraint!

    // MARK: View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let unwrappedFaceImage = faceImage else {
            return
        }
        if self.vcState == .create {
            faceInHoleImageView.setImage(withSDWeb: self.selectedImage, placeholderImage: AppImages.myprofilePlaceholder)
        }
        if let imgStr = greeting?.faceHoleImageUrl,
            let url = URL(string: imgStr) {
            self.faceInHoleImageView.sd_addActivityIndicator()
            self.faceInHoleImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            faceInHoleImageView.sd_setImage(with: url, placeholderImage: AppImages.myprofilePlaceholder, options: SDWebImageOptions.progressiveDownload, completed: { [weak self] (image, _, _, _) in
                self?.holeImage = image
            })
        }

        faceInHoleImageViewHeight.constant = imageViewHeight
        faceImageView.image = unwrappedFaceImage

        //faceImageView.translatesAutoresizingMaskIntoConstraints = false
        faceImageView.clipsToBounds = true
        faceImageView.contentMode = .scaleAspectFill
        faceImageView.isUserInteractionEnabled = true
        view.insertSubview(faceImageView, at: 0)

        let movePanGesture = UIPanGestureRecognizer(target: self, action: #selector(didMoveView))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateView))
        let pinchZoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(didZoomView))

        movePanGesture.delegate = self
        rotateGesture.delegate = self
        pinchZoomGesture.delegate = self

        view.addGestureRecognizer(movePanGesture)
        view.addGestureRecognizer(rotateGesture)
        view.addGestureRecognizer(pinchZoomGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasViewAppearedOnce {
            let holedImageFrame = faceInHoleImageView.frame
            faceImageView.frame = holedImageFrame

            if let greetingOb = greeting,
                greetingOb.isDraft {

                let rotation = CGFloat(greetingOb.faceImageRotation)

                let scaleX = CGFloat(greetingOb.faceImageScaleX)
                let scaleY = CGFloat(greetingOb.faceImageScaleY)

                let centerX = CGFloat(greetingOb.faceImageX)
                let centerY = CGFloat(greetingOb.faceImageY)

                guard scaleX != 0, scaleY != 0 else {
                    return
                }

                faceImageView.center = CGPoint(x: centerX, y: centerY)

                faceImageView.transform = faceImageView.transform.rotated(by: rotation)
                faceImageView.transform = faceImageView.transform.scaledBy(x: scaleX, y: scaleY)
            }
        }
        hasViewAppearedOnce = true
    }

    // MARK: Private Methods
    /*
    private func aspectFill(_ image: UIImage) {
        let imageViewSize = image.aspectFill(for: faceInHoleImageView.size)
        faceInHoleImageViewHeight.constant = imageViewSize.height
    }
    */

    @objc private func didRotateView(_ gesture: UIRotationGestureRecognizer) {
        let rotation = gesture.rotation
        faceImageView.transform = faceImageView.transform.rotated(by: rotation)
        gesture.rotation = 0
    }

    @objc private func didZoomView(_ gesture: UIPinchGestureRecognizer) {
        let scale = gesture.scale
        faceImageView.transform = faceImageView.transform.scaledBy(x: scale, y: scale)
        gesture.scale = 1
    }

    @objc private func didMoveView(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        faceImageView.center = CGPoint(x: (faceImageView.center.x + translation.x), y: (faceImageView.center.y + translation.y))
        gesture.setTranslation(.zero, in: view)
    }

    // MARK: IBActions
    @IBAction func doneBtnTapped(_ sender: UIButton) {

        if let realm = try? Realm() {
            try? realm.write {
                
                guard let greetingOb = greeting else {
                    return
                }
                
                greetingOb.faceImageX = Double(faceImageView.centerX)
                greetingOb.faceImageY = Double(faceImageView.centerY)

                greetingOb.faceImageScaleX = Double(faceImageView.transform.a)
                greetingOb.faceImageScaleY = Double(faceImageView.transform.d)

                let rotation = atan2(faceImageView.transform.b, faceImageView.transform.a)
                greetingOb.faceImageRotation = Double(rotation)
                greetingOb.isDraft = true

                /*
                if let img = faceImage {
                    greetingOb.faceImageData = UIImageJPEGRepresentation(img, 1)
                }
                */
            }
        }

        let snapShotImage: UIImage
        if #available(iOS 10.0, *) {
            snapShotImage = view.asImage(frame: faceInHoleImageView.frame)
        } else {
            snapShotImage = view.asImageIniOS9(frame: faceInHoleImageView.frame)
        }

        delegate?.didFinishPuttingFaceInHole(image: snapShotImage)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image, allowsEditing: false)
    }

}

// MARK: GestureRecognizer Delegate Methods
extension FaceInHoleVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: Extension for Opening Camera or Gallery
extension FaceInHoleVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            faceImage = pickedImage
            faceImageView.image = pickedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
