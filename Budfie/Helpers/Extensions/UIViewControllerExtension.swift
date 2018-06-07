//
//  UIViewControllerExtension.swift
//  Seerve
//
//  Created by  on 12/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import MobileCoreServices

extension UINavigationController {
    
    func popToClass<T: UIViewController>(type: T.Type) -> Bool {
        for viewController in self.viewControllers {
            guard viewController is T else { continue }
            self.popToViewController(viewController, animated: true)
            return true
        }
        return false
    }

}

extension UIViewController {
    
    typealias ImagePickerDelegateController = (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    
    func captureImage(delegate controller: ImagePickerDelegateController,
                      photoGallery: Bool = true,
                      camera: Bool = true) {
        
        let chooseOptionText =  StringConstants.Choose_Options.localized
        let alertController = UIAlertController(title: chooseOptionText, message: nil, preferredStyle: .actionSheet)
        
        if photoGallery {
            
            let chooseFromGalleryText =  StringConstants.Choose_from_gallery.localized
            let alertActionGallery = UIAlertAction(title: chooseFromGalleryText, style: .default) { _ in
                self.checkAndOpenLibrary(delegate: controller)
            }
            alertController.addAction(alertActionGallery)
        }
        
        if camera {
            
            let takePhotoText =  StringConstants.Take_Photo.localized
            let alertActionCamera = UIAlertAction(title: takePhotoText, style: .default) { action in
                self.checkAndOpenCamera(delegate: controller)
            }
            alertController.addAction(alertActionCamera)
        }
        
        let cancelText =  StringConstants.Cancel.localized
        let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel) { _ in
        }
        alertController.addAction(alertActionCancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func checkAndOpenCamera(delegate controller: ImagePickerDelegateController) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
            
        case .authorized:
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            
            let sourceType = UIImagePickerControllerSourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                imagePicker.sourceType = sourceType
                
                if imagePicker.sourceType == .camera {
                    imagePicker.showsCameraControls = true
                }
                controller.present(imagePicker, animated: true, completion: nil)
                
            } else {
                
                let cameraNotAvailableText = StringConstants.Camera_not_available.localized
                self.showAlert(title: "Error", msg: cameraNotAvailableText)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                
                if granted {
                    
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = controller
                        
                        let sourceType = UIImagePickerControllerSourceType.camera
                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                            
                            imagePicker.sourceType = sourceType
                            if imagePicker.sourceType == .camera {
                                imagePicker.allowsEditing = true
                                imagePicker.showsCameraControls = true
                            }
                            controller.present(imagePicker, animated: true, completion: nil)
                            
                        } else {
                            let cameraNotAvailableText = StringConstants.Camera_not_available.localized
                            self.showAlert(title: "Error", msg: cameraNotAvailableText)
                        }
                    }
                }
            })
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting(StringConstants.You_have_been_restricted_from_using_the_camera_on_this_device_without_camera_access_this_feature_wont_work.localized)
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting(StringConstants.Please_change_your_privacy_setting_from_the_Settings_app_and_allow_access_to_camera_for_your_app.localized)
        }
    }
    
    func checkAndOpenLibrary(delegate controller: ImagePickerDelegateController) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            
        case .notDetermined:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            let sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            controller.present(imagePicker, animated: true, completion: nil)
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting(StringConstants.Youve_been_restricted_from_using_the_library_on_this_device_Without_camera_access_this_feature_wont_work.localized)
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting(StringConstants.Please_change_your_privacy_setting_from_the_Settings_app_and_allow_access_to_library_for.localized)
            
        case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            let sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.sourceType = sourceType
            controller.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func alertPromptToAllowCameraAccessViaSetting(_ message: String) {
        
        let alertText = StringConstants.Alert.localized
        let cancelText = StringConstants.Cancel.localized
        let settingsText = StringConstants.Settings.localized
        
        let alert = UIAlertController(title: alertText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: settingsText, style: .default, handler: { (action) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///Adds Child View Controller to Parent View Controller
    func add(childViewController:UIViewController){
        
        self.addChildViewController(childViewController)
        childViewController.view.frame = self.view.bounds
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    var removeFromParent:Void{
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title:String? = nil, leftButton:UIBarButtonItem? = nil, rightButton:UIBarButtonItem? = nil, tintColor:UIColor? = nil, barTintColor:UIColor? = nil, titleTextAttributes: [NSAttributedStringKey : Any]? = nil){
        
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor{
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor{
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton{
            self.navigationItem.leftBarButtonItem = button;
        }
        if let button = rightButton{
            self.navigationItem.rightBarButtonItem = button;
        }
        if let ttle = title{
            self.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes{
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    ///Not using static as it won't be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    //function to pop the target from navigation Stack
    @objc func pop(animated:Bool = true) {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
//    func popToViewController(_ viewController:UIViewController, animated:Bool = true) {
//        _ = self.navigationController?.popToViewController(viewController, animated: animated)
//    }
//
//    func popToViewController(atIndex index:Int, animated:Bool = true) {
//
//        if let navVc = self.navigationController, navVc.viewControllers.count > index{
//
//            _ = self.navigationController?.popToViewController(navVc.viewControllers[index], animated: animated)
//        }
//    }
//    
//    func popToRootViewController(animated:Bool = true) {
//        _ = self.navigationController?.popToRootViewController(animated: animated)
//    }
    
    func showAlert( title : String = "", msg : String,_ completion : (()->())? = nil) {
        
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: StringConstants.Ok.localized, style: UIAlertActionStyle.default) { (action : UIAlertAction) -> Void in
            
            alertViewController.dismiss(animated: true, completion: nil)
            completion?()
        }
        
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    @discardableResult
    func popToController<T: UIViewController>(_ controller: T.Type, animated: Bool) -> Bool {
        
        guard let navController = self.navigationController else {
            return false
        }
        
        for viewcontroller in navController.viewControllers {
            if viewcontroller is T {
                let popToController = navController.popToViewController(viewcontroller, animated: animated)
                return (popToController != nil)
            }
        }
        return false
    }
}


