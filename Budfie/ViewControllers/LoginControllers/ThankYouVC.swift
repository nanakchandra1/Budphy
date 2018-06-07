//
//  ThankYouVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 12/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

// Page State Enum
enum ControllerState{
    case invite
    case interest
}

//MARK: PushToHomeScreen Delegate
//===============================
protocol PushToHomeScreenDelegate : class {
    func pushHomeScreen()
}

//MARK: ThankYouVC class
//======================
class ThankYouVC: BaseVc {
    
    //MARK: Properties
    //================
    var state = ControllerState.interest
    weak var delegate: PushToHomeScreenDelegate?
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var thankYouImageView: UIImageView!
    @IBOutlet weak var imageBackView: UIView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.state == .interest {
            self.thankYouImageView.image = AppImages.thankyou
        } else {
            AppUserDefaults.save(value: "1", forKey: AppUserDefaults.Key.isThankYou)
            self.thankYouImageView.image = AppImages.ic_congratulations
        }
        
        self.view.backgroundColor = UIColor.clear
        self.initialSetUpForAnimation()
        self.startCenterAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            if self.state == .interest {
//                self.hidePopUp()
                self.view.removeFromSuperview()
                self.delegate?.pushHomeScreen()
                
            } else if let navCont = self.navigationController {
                
                var eventScene: EventVC?
                let viewControllers = navCont.viewControllers
                
                for controller in viewControllers {
                    if let tabbarScene = controller as? TabBarVC {
                        
                        let childControllers = tabbarScene.childViewControllers
                        
                        for child in childControllers {
                            if let eventCont = child as? EventVC {
                                eventScene = eventCont
                                break
                            }
                        }
                        break
                    }
                }

                eventScene?.childVC.getPersonelEvents(page: 1, reloadSimple: false)
                eventScene?.didSelectButton(at: 0)
//                self.hidePopUp()
                self.view.removeFromSuperview()
                self.delegate?.pushHomeScreen()
                //® self.getPersonelEvents(page: 1)
            }
        }
    }
    
    //MARK: setup Animation
    //=====================
    func initialSetUpForAnimation() {
        
        self.imageBackView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
    }
    
    //MARK: Start Animation
    //=====================
    func startCenterAnimation() {
        
        UIView.animate(withDuration: 1,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut],
                       animations: {
                        self.imageBackView.transform = .identity
        }, completion: { (state) in
            
        })
    }
    
}
