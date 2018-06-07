//
//  BaseVc.swift
//  Onboarding
//
//  Created by on 23/06/17.
//  Copyright © 2017 . All rights reserved.
////

import MessageUI

class BaseVc: UIViewController {
    
    //Properties
    private var keyboardShowNotification : NSObjectProtocol?
    private var keyboardHideNotification : NSObjectProtocol?
    var target: BaseVc!
    
    var keyBoardAppearClosure : ((_ keyboardHeight : CGFloat) -> ())?
    var keyBoardDisappearClosure : (() -> ())?
    
    var isLoading : Bool = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            showAlertForFeedback()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .init(rawValue: 0)
        view.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        //Ending the editing of the view to hide any input view
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navCont = navigationController as? AvoidingMultiPushNavigationController {
            navCont.shouldIgnorePushingViewControllers = true
        }

        //Notification Observer to decrease the size and scroll the tableView
        self.keyboardShowNotification = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
                                                                               object: nil,
                                                                               queue: OperationQueue.main,
                                                                               using: {[weak self] (notification) in

                                                                                guard let strongSelf = self else {
                                                                                    return
                                                                                }

                                                                                guard let info = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
                                                                                
                                                                                let keyBoardHeight = info.cgRectValue.height
                                                                                
                                                                                UIView.animate(withDuration: 0.33,  delay: 0,
                                                                                               options: .curveEaseInOut,
                                                                                               animations: {
                                                                                                
                                                                                                if let keyBoardAppearClosure = strongSelf.keyBoardAppearClosure {
                                                                                                    keyBoardAppearClosure(keyBoardHeight)
                                                                                                }
                                                                                                
                                                                                }, completion: nil)
        })
        
        
        //Notification Observer to increase the size of the tableView
        self.keyboardHideNotification = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
                                                                               object: nil,
                                                                               queue: OperationQueue.main,
                                                                               using: {[weak self] (notification) in

                                                                                guard let strongSelf = self else {
                                                                                    return
                                                                                }

                                                                                UIView.animate(withDuration: 0.33, delay: 0,
                                                                                               options: .curveEaseInOut,
                                                                                               animations: {
                                                                                                
                                                                                                if let keyBoardDisappearClosure = strongSelf.keyBoardDisappearClosure {
                                                                                                    keyBoardDisappearClosure()
                                                                                                }
                                                                                                
                                                                                }, completion: nil)
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navCont = navigationController as? AvoidingMultiPushNavigationController {
            navCont.shouldIgnorePushingViewControllers = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Removing Observer on keyboard
        if let keyboardShowNotification = self.keyboardShowNotification {
            NotificationCenter.default.removeObserver(keyboardShowNotification)
        }
        
        if let keyboardHideNotification = self.keyboardHideNotification {
            NotificationCenter.default.removeObserver(keyboardHideNotification)
        }
    }

    private func showAlertForFeedback() {
        let alert = UIAlertController(title: "Budfie", message: "Do you want to give your feedback?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            TestFairy.pushFeedbackController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Private Functions
extension BaseVc {
    
    //Function to change the image of leftBarButtonItem and add the pop functionality
    func leftBarItemImage(change withImage: UIImage, ofVC target: BaseVc){
        
        self.target = target
        
        var image = withImage
        
        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        target.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pop))
    }
    
    
    //    func leftBarItemImageForSideMenu(change withImage: UIImage, ofVC target: BaseVc){
    //
    //        self.target = target
    //
    //        var image = withImage
    //
    //        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    //
    //        target.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackToSideVC))
    //    }
    //
    //    func rightBarItemImage(change withImage: UIImage, ofVC target: BaseVc){
    //
    //        self.target = target
    //
    //        var image = withImage
    //
    //        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    //
    //        target.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightBarButtonTapped(sender:)))
    //
    //    }
    //
    //    func rightBarButtonTapped(sender : UIButton) {
    //
    //
    //    }
    //
    //    func goBackToSideVC(_ sender : UIBarButtonItem) {
    //        openLeft()
    //    }
    
    
    
}

extension BaseVc: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            break
        case .sent:
            break
        case .failed:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension BaseVc: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            break
        case .sent:
            break
        case .failed:
            break
        case .saved:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
