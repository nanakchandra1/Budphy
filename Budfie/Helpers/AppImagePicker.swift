//
//  AppImagePicker.swift
//  ALBoum Agency
//
//  Created by Manish Nainwal on 1/5/17.
//  Copyright © 2017 Manish Nainwal. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import Photos

enum CaptureType {
    case image
    case video
}

enum SourceType {
    case camera
    case gallery
}

class AppImagePicker {
    
    class func showImagePicker(delegateVC : UIViewController,
                               whatToCapture : CaptureType = .image,source:SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.allowsEditing = false
        
        if source == .camera {
            
            self.checkCamera(delegateVC: delegateVC, cameraStatus: { (status) in
                if status{
                    let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
                    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                        imagePickerController.sourceType = sourceType
                        if imagePickerController.sourceType == .camera {
                            imagePickerController.showsCameraControls = true
                        }
                    }
                    
                    if whatToCapture == .image {
                        imagePickerController.mediaTypes = [kUTTypeImage as String]
                    }
                    else {
                        imagePickerController.mediaTypes = [kUTTypeMovie as String]
                    }
                    imagePickerController.delegate = delegateVC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    
                    delegateVC.present(imagePickerController, animated: true, completion: nil)
                }else{
                    return
                }
            })
        }else{
            self.checkGalley(delegateVC: delegateVC, galleryStatus: { (status) in
                if status{
                    imagePickerController.allowsEditing = false
                    imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    if whatToCapture == .image {
                        imagePickerController.mediaTypes = [kUTTypeImage as String]
                    }
                    else {
                        imagePickerController.mediaTypes = [kUTTypeMovie as String]
                    }
                    imagePickerController.delegate = delegateVC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    
                    delegateVC.present(imagePickerController, animated: true, completion: nil)
                }else{
                    return
                }
            })
        }
        
    }
    
    class func checkGalley(delegateVC : UIViewController,galleryStatus :  @escaping (_ success : Bool) -> Void){
        
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) -> Void in
            switch status {
                
            case PHAuthorizationStatus.authorized:
                
                galleryStatus(true)
            case .denied,.restricted:
                
                let alertController = UIAlertController (title: "", message: "You don't have permission to access the Gallery. Please go to device settings and enable the Gallery permissions.", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.shared.openURL(url)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                
                delegateVC.present(alertController, animated: true, completion: nil);
                galleryStatus(false)
                
            case  .notDetermined:
                
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized{
                        galleryStatus(true)
                        
                    }else{
                        galleryStatus(false)
                    }
                })
            }
        }
    }
    
    class func checkCamera(delegateVC : UIViewController,cameraStatus :  @escaping (_ success : Bool) -> Void){
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        // The client is authorized to access the hardware supporting a media type.
        case .authorized:
            cameraStatus(true)
        case .restricted,.denied:
            let alertController = UIAlertController (title: "", message: "You don't have permission to access the Camera. Please go to device settings and enable the Camera permissions.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            delegateVC.present(alertController, animated: true, completion: nil);
            cameraStatus(false)
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    cameraStatus(true)
                    
                } else {
                    cameraStatus(false)
                    
                }
            }
        }
    }
    
    class func showImagePicker(delegateVC : UIViewController,
                               whatToCapture : CaptureType = .image,
                               allowsEditing: Bool = true) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let destructiveAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        
        //MARK: Getting image using App Camera...
        //MARK: =============================
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = allowsEditing

            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                imagePickerController.sourceType = sourceType
                
                if imagePickerController.sourceType == .camera {
                    imagePickerController.showsCameraControls = true
                }
                
                imagePickerController.delegate = delegateVC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate

                if whatToCapture == .image {
                    imagePickerController.mediaTypes = [kUTTypeImage as String]
                }
                else {
                    imagePickerController.mediaTypes = [kUTTypeMovie as String]
                    imagePickerController.videoMaximumDuration = 3
                }
                
                delegateVC.present(imagePickerController, animated: true, completion: nil)//.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        //MARK: Getting image using App Gallery...
        //MARK: =============================
        let gallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = allowsEditing
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary

            if whatToCapture == .video {
                imagePickerController.mediaTypes = [kUTTypeMovie as String]
            } else {
                imagePickerController.mediaTypes = [kUTTypeImage as String]
            }
            
            imagePickerController.delegate = delegateVC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            
            delegateVC.present(imagePickerController, animated: true, completion: nil)
        }
        
        alertController.addAction(destructiveAction)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        
        delegateVC.present(alertController, animated: true, completion: nil)
    }
    
}
