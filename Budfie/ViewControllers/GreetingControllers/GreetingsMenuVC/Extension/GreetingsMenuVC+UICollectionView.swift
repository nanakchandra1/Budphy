//
//  GreetingsMenuVC+UICollectionView.swift
//  Budfie
//
//  Created by appinventiv on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage
import MobileCoreServices

//MARK:- Extension for DataSource and Delegate
//============================================
extension GreetingsMenuVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if greetingType == .animation || greetingType == .faceInHole {
            return (self.greetingCardsList.count + 1)
        }
        return self.greetingCardsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GreetingImagesCell", for: indexPath) as? GreetingImagesCell else {
            fatalError("GreetingImagesCell not found")
        }

        if greetingType == .animation || greetingType == .faceInHole {
            if indexPath.item == 0 {

                if greetingType == .faceInHole {
                    cell.picsImageView.image = #imageLiteral(resourceName: "icChatPlus")
                } else {
                    cell.backgroundColor = .clear
                    cell.contentView.backgroundColor = .clear
                    cell.animatedSelfieStackView.isHidden = false
                }
                cell.picsImageView.contentMode = .center

            } else {
                cell.picsImageView.contentMode = .scaleAspectFill
                cell.picsImageView.setImage(withSDWeb: self.greetingCardsList[indexPath.item - 1].description,
                                            placeholderImage: AppImages.myprofilePlaceholder)
            }
        } else {
            cell.picsImageView.setImage(withSDWeb: self.greetingCardsList[indexPath.item].description,
                                        placeholderImage: AppImages.myprofilePlaceholder)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if (greetingType == .animation || greetingType == .faceInHole) {
            if (indexPath.item == 0) {
                if (greetingType == .animation) {
                    showCameraForGIF()
                } else {
                    AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image, source: .camera)
                }

            } else {
                moveToAnimationsVC(with: self.greetingCardsList[indexPath.row - 1].description)
            }
        } else {
            moveToAnimationsVC(with: self.greetingCardsList[indexPath.row].description)
        }
    }

    private func showCameraForGIF() {

        let imagePickerController = UIImagePickerController()
        let sourceType: UIImagePickerControllerSourceType = .camera
        imagePickerController.allowsEditing = false

        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            imagePickerController.sourceType = sourceType
            imagePickerController.cameraDevice = .front

            imagePickerController.delegate = self
            imagePickerController.showsCameraControls = true

            imagePickerController.mediaTypes = [kUTTypeMovie as String]
            imagePickerController.videoMaximumDuration = 3

            present(imagePickerController, animated: true, completion: nil)
        }
    }

    fileprivate func moveToAnimationsVC(with image: String) {
        let animationsScene = AnimationsVC.instantiate(fromAppStoryboard: .Greeting)
        animationsScene.vcState = self.vcState
        animationsScene.greetingType = self.greetingType
        animationsScene.flowType = self.flowType
        animationsScene.selectedImage = image
        animationsScene.snappedImage = snappedImage
        animationsScene.eventDate = eventDate
        animationsScene.eventId = eventId
        self.navigationController?.pushViewController(animationsScene, animated: true)
    }
}

extension GreetingsMenuVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            snappedImage = image
            moveToAnimationsVC(with: "")

        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            Regift.createGIFFromSource(videoURL, frameCount: 10, delayTime: 0.1) { (result) in
                print("Gif saved to \(String(describing: result))")
                if let url = result {
                    self.moveToAnimationsVC(with: url.absoluteString)
                }
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension GreetingsMenuVC: UICollectionViewDelegateFlowLayout {
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidth = (screenWidth - 21) / 3
        
        return CGSize(width: heightWidth, height: heightWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidth = (screenWidth - 31) / 2
        
        return CGSize(width: heightWidth, height: heightWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

//MARK:- GreetingImagesCell Class
//===============================
class GreetingImagesCell : UICollectionViewCell {
    
    //MARK:- @IBOutlet
    //================
    @IBOutlet weak var picsImageView: FLAnimatedImageView!
    @IBOutlet weak var animatedSelfieStackView: UIStackView!

    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        resetCell()
    }

    private func resetCell() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        animatedSelfieStackView.isHidden = true
    }
    
}
