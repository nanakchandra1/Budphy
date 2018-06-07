//
//  TabBarVC.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

//MARK: Tab Bar State
//===================
enum TabBarState {
    case Chat
    case Greeting
    case Event
    case TimeOut
    case Menu
    case Shopping
}

//MARK: TabBarVC class
//====================
class TabBarVC: BaseVc {
    
    //MARK: Property
    //==============
    var tabBarState: TabBarState = .Chat
    fileprivate var hasViewAppearedOnce = false
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var tabbarSlideView      : UIView!
    @IBOutlet weak var tabBarView           : UIView!
    @IBOutlet weak var tabViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var tabViewBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var addVcView            : UIView!
    @IBOutlet weak var chatButton           : UIButton!
    @IBOutlet weak var greetingButton       : UIButton!
    @IBOutlet weak var eventButton          : UIButton!
    @IBOutlet weak var timeOutButton        : UIButton!
    @IBOutlet weak var menuButton           : UIButton!
    @IBOutlet weak var topViewSubView       : UIView!
    @IBOutlet weak var topViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowTabBarView     : UIView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasViewAppearedOnce = true
    }
    
    //MARK: @IBAction
    //===============
    
    //MARK: CHAT BUTTON
    //=================
    @IBAction func chatBtnAction(_ sender: UIButton) {
        guard self.tabBarState != .Chat else {
            return
        }
        moveToChatScene()
    }
    
    private func moveToChatScene() {
        self.tabBarState = .Chat
        self.updateTabBarView(completion: {
            for childVC in self.childViewControllers {
                if childVC.restorationIdentifier == "ChatVC" {
                    self.addVcView.bringSubview(toFront: childVC.view)
                    return
                }
            }
            let chatListScene = ChatListVC.instantiate(fromAppStoryboard: .Chat)
            chatListScene.restorationIdentifier = "ChatVC"
            self.appointVC(viewController: chatListScene, TabBarState: .Chat)
        })
    }
    
    //MARK: GREETING BUTTON
    //=====================
    @IBAction func greetingBtnAction(_ sender: UIButton) {
        guard self.tabBarState != .Greeting else {
            return
        }
        moveToGreetingScene()
    }
    
    private func moveToGreetingScene() {
        self.tabBarState = .Greeting
        self.updateTabBarView(completion: {
            for childVC in self.childViewControllers {
                if childVC.restorationIdentifier == "TypeOfGreetingVC" {
                    self.addVcView.bringSubview(toFront: childVC.view)
                    return
                }
            }
            let greetingtVC = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
            greetingtVC.restorationIdentifier = "TypeOfGreetingVC"
            self.appointVC(viewController: greetingtVC, TabBarState: .Greeting)
        })
    }
    
    //MARK: EVENT BUTTON
    //==================
    @IBAction func eventBtnAction(_ sender: UIButton) {
        guard self.tabBarState != .Event else {
            return
        }
        moveToEventScene()
    }
    
    private func moveToEventScene() {
        self.tabBarState = .Event
        self.updateTabBarView(completion: {
            for childVC in self.childViewControllers {
                if let eventScene = childVC as? EventVC {
                    eventScene.setUpCreateEventAnimation()
                    self.addVcView.bringSubview(toFront: childVC.view)
                    eventScene.performCreateEventAnimation()
                    return
                }
            }
            let eventVC = EventVC.instantiate(fromAppStoryboard: .Events)
            eventVC.restorationIdentifier = "EventVC"
            self.appointVC(viewController: eventVC, TabBarState: .Event)
        })
    }
    
    //MARK: TIMEOUT BUTTON
    //====================
    @IBAction func timeOutBtnAction(_ sender: UIButton) {
        guard self.tabBarState != .TimeOut else {
            return
        }
        moveToTimeOutScene()
    }
    
    private func moveToTimeOutScene() {
        self.tabBarState = .TimeOut
        self.updateTabBarView(completion: {
            for childVC in self.childViewControllers {
                if childVC.restorationIdentifier == "TimeOutVC" {
                    self.addVcView.bringSubview(toFront: childVC.view)
                    return
                }
            }
            let timeOutVC = TimeOutVC.instantiate(fromAppStoryboard: .TimeOut)
            timeOutVC.restorationIdentifier = "TimeOutVC"
            self.appointVC(viewController: timeOutVC, TabBarState: .TimeOut)
        })
    }
    
    //MARK: MENU BUTTON
    //=================
    @IBAction func menuBtnAction(_ sender: UIButton) {
        guard self.tabBarState != .Menu else {
            return
        }
        moveToMenuScene()
    }
    
    private func moveToMenuScene() {
        self.tabBarState = .Menu
        self.updateTabBarView(completion: {
            for childVC in self.childViewControllers {
                if childVC.restorationIdentifier == "MenuVC" {
                    self.addVcView.bringSubview(toFront: childVC.view)
                    return
                }
            }
            let menuVC = ExploreMoreVC.instantiate(fromAppStoryboard: .Events)
            menuVC.restorationIdentifier = "MenuVC"
            self.appointVC(viewController: menuVC, TabBarState: .Menu)
        })
    }
    
}


//MARK: Extension for InitialSetup and private methods
//====================================================
extension TabBarVC {
    
    private func initialSetup() {

        self.topViewSubView.backgroundColor = AppColors.favPinkColor
        self.setTabbarToDefault()

        self.chatButton.centerVertically()
        self.greetingButton.centerVertically()
        self.eventButton.centerVertically()
        self.timeOutButton.centerVertically()
        self.menuButton.centerVertically()
        self.clickGivenBtn()
        //        self.eventButton.sendActions(for: .touchUpInside)
    }

    private func clickGivenBtn() {
        
        switch self.tabBarState {
        case .Chat:
            moveToChatScene()
        case .Event:
            moveToEventScene()
        case .Greeting:
            moveToGreetingScene()
        case .Menu:
            moveToMenuScene()
        case .Shopping:
            CommonClass.showToast(msg: "Under Development")
        case .TimeOut:
            moveToTimeOutScene()
        }
    }
    
    func setUpInitialTab(state: TabBarState) {
        
        if self.tabBarState == .Chat {
            self.chatBtnAction(self.chatButton)
        } else if self.tabBarState == .Event {
            self.eventBtnAction(self.eventButton)
        } else if self.tabBarState == .Greeting{
            self.greetingBtnAction(self.greetingButton)
        } else if self.tabBarState == .Menu{
            self.menuBtnAction(self.menuButton)
        } else if self.tabBarState == .TimeOut{
            self.timeOutBtnAction(self.timeOutButton)
        }
    }
    
    private func appointVC(viewController: BaseVc, TabBarState: TabBarState) {
        
        viewController.view.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.addVcView.frame.width,
                                           height: self.addVcView.frame.height)
        self.addChildViewController(viewController)
        self.addVcView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
}


//MARK:- Manage Tab bar
//=====================
extension TabBarVC {
    
    func setTabbarToDefault() {
        
        self.chatButton.setImage(#imageLiteral(resourceName: "icTabChat"), for: .normal)
        self.chatButton.setTitleColor(.black, for: .normal)

        self.greetingButton.setImage(#imageLiteral(resourceName: "icTabGreeting"), for: .normal)
        self.greetingButton.setTitleColor(.black, for: .normal)

        self.eventButton.setImage(#imageLiteral(resourceName: "icTabCalendar"), for: .normal)
        self.eventButton.setTitleColor(.black, for: .normal)

        self.timeOutButton.setImage(#imageLiteral(resourceName: "icTabTimeout"), for: .normal)
        self.timeOutButton.setTitleColor(.black, for: .normal)

        self.menuButton.setImage(#imageLiteral(resourceName: "icTabMore"), for: .normal)
        self.menuButton.setTitleColor(.black, for: .normal)
    }
    
    func updateTabBarView(completion: @escaping () -> Void) {

        let constant = screenWidth/5
        self.setTabbarToDefault()
        switch self.tabBarState {

        case TabBarState.Chat :
            self.chatButton.setTitleColor(AppColors.tabBarIndicatorColor, for: .normal)
            self.updateTopViewConstraint(newConstraint: 0, completion: {
                //self.setTabbarToDefault()
            })
            
        case TabBarState.Greeting :
            self.greetingButton.setTitleColor(AppColors.tabBarIndicatorColor, for: .normal)
            self.updateTopViewConstraint(newConstraint: (constant), completion: {
                //self.setTabbarToDefault()
            })
            
        case TabBarState.Event :
            self.eventButton.setTitleColor(AppColors.tabBarIndicatorColor, for: .normal)
            self.updateTopViewConstraint(newConstraint: (constant) * 2, completion: {
                //self.setTabbarToDefault()
            })
            
        case TabBarState.TimeOut:
            self.timeOutButton.setTitleColor(AppColors.tabBarIndicatorColor, for: .normal)
            self.updateTopViewConstraint(newConstraint:(constant) * 3, completion: {
                //self.setTabbarToDefault()
            })
            
        case TabBarState.Menu :
            self.menuButton.setTitleColor(AppColors.tabBarIndicatorColor, for: .normal)
            self.updateTopViewConstraint(newConstraint:(constant) * 4 , completion: {
                //self.setTabbarToDefault()
            })
            
        case TabBarState.Shopping:
            break
        }
        
        completion()
    }
    
    func updateTopViewConstraint(newConstraint: CGFloat, completion: @escaping () -> Void) {

        guard hasViewAppearedOnce else {
            self.topViewLeadingConstraint.constant = newConstraint
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {

            self.topViewLeadingConstraint.constant = newConstraint
            self.view.layoutIfNeeded()
            
        }, completion:{ (_) in
            completion()
        })
    }
    
    /*
    func showTabbar() {

        guard isViewLoaded else {
            return
        }
        
//        if screenHeight > 740 {
//            self.tabViewBottomConstant.constant = -65
//        } else {
//            self.tabViewHeightConstant.constant = -45
//        }
        self.tabViewHeightConstant.constant = 105
        self.view.setNeedsLayout()
        self.tabBarView.isHidden = false
        self.tabbarSlideView.isHidden = false
    }
    
    func hideTabbar() {

        guard isViewLoaded else {
            return
        }

        self.tabViewHeightConstant.constant = 45
        self.tabBarView.isHidden = true
        self.tabbarSlideView.isHidden = true
        self.view.setNeedsLayout()
    }
 */
    
}
