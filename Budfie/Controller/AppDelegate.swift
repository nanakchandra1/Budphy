 //
 //  AppDelegate.swift
 //  Onboarding
 //
 //  Created by Gurdeep Singh on 04/07/16.
 //  Copyright © 2016 Gurdeep Singh. All rights reserved.
 
 import UIKit
 import SwiftyJSON
 import Firebase
 import IQKeyboardManagerSwift
 import FBSDKCoreKit
 import GooglePlaces
 import GoogleMaps
 import CoreData
 import Fabric
 import Crashlytics
 import GoogleSignIn
 import GoogleAPIClientForREST
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum URLSchemeType: Int {
        case none = 0
        case movie
        case concert
        case soccer
        case personal
        case cricket
        
        var eventCategory: String {
            switch self {
            case .none, .personal:
                return ""
            case .movie:
                return "1"
            case .concert:
                return "2"
            case .cricket:
                return "5"
            case .soccer:
                return "3"
            }
        }
    }

    enum PushType: Int {
        case eventInvitation = 1
        case acceptEventInvitation
        case receivedGreeting
        case userBirthday
        case friendBirthday
        case eventNotification
        case eventReminder
        case chat
    }
    
//    var sharedTabbar: TabBarVC?
    var currentuser: UserDetails!
    var helpSupport: UserDetails!
    var window: UIWindow?
    var buildVersionNumber = "24-04-2018 19:00"
    let configuration = FTConfiguration.shared
    var isLaunchedFromRemotePush = false
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let launchOptions = launchOptions,
            let url = launchOptions[.url] as? URL,
            let json = getJson(from: url) {
            
            let typeValue = json["type"].intValue
            let id = json["id"].stringValue
            
            AppUserDefaults.save(value: typeValue, forKey: .appDidOpenWithEventType)
            AppUserDefaults.save(value: id, forKey: .appDidOpenWithEventId)
        }

        if let launchOptions = launchOptions,
            let notification = launchOptions[.remoteNotification] as? JSONDictionary {
            AppUserDefaults.save(value: notification, forKey: .remoteNotification)
            isLaunchedFromRemotePush = true
        }
        
        //MARK: IQKeyboardManager related
        IQBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: AppColors.systemBlueColor], for: .normal)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = [AnimationsVC.self, ChatVC.self]
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatVC.self]
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.toolbarTintColor = AppColors.systemBlueColor

        //MARK: - Setting with Pool Id for s3 image upload...
        AWSController.setupAmazonS3()
        
        AppNetworking.configureAlamofire()
        CommonClass.configureToasterAppearance()
        GiFHUD.setGif("loader.gif")
        
        //MARK: Firebase related
        //FirebaseApp.configure()
        
        //        initialiseDataOfFriendsWithServiceHit()
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(contactStoreDidChange),
        //                                               name: .CNContactStoreDidChange, object: nil)
        
        //application.registerForRemoteNotifications()
        //self.registerUserNotifications()
        self.setUpPopOverView()

        //Adding Google Api Key
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        
        //MARK: Facebook related
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //MARK: Google login related
        GoogleLoginController.shared.configure(withClientId: googleClientId)
        
        /*
         let scene = SportDetailVC.instantiate(fromAppStoryboard: .Events)
         scene.vcType = .batminton
         
         var json = JSONDictionary()
         json["eventID"] = "2"
         
         scene.eventModel = EventModel(initForEventModel: json)
         let navVC = AvoidingMultiPushNavigationController(rootViewController: scene)
         navVC.isNavigationBarHidden = true
         window?.rootViewController = navVC
         window?.makeKeyAndVisible()
         */
        
        /*
         let scene = JokesThoughtsVC.instantiate(fromAppStoryboard: .TimeOut)
         scene.vcState = .thoughts
         let navVC = UINavigationController(rootViewController: scene)
         navVC.isNavigationBarHidden = true
         window?.rootViewController = navVC
         window?.makeKeyAndVisible()
         */
        
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        Database.database().isPersistenceEnabled = true
        DatabaseReference.keepSynced(true)

        // Initialize TestFairy
        TestFairy.begin("050782bf62980e7d0155f8411d98aba3c57e2b9f")

        // Initialize Crashlytics
        Fabric.with([Crashlytics.self])
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let navigationController = self.window?.rootViewController as? UINavigationController,
            navigationController.visibleViewController is GamesVC {
            return [.landscape, .landscapeLeft, .landscapeRight]
        }
        return UIInterfaceOrientationMask.portrait
    }

    //METHOD TO INITIALIZE DATA BY HITTING CONTACT SYNC SERVICE
    func initialiseDataOfFriendsWithServiceHit() {

        ContactsController.shared.syncPhoneBookContacts({

            print_debug("syncPhoneBookContacts completion")

        }, receivedContacts: { (contacts) in

            print_debug("receivedContacts: \(contacts)")

        }, permissionGrantedBlock: { permissionGranted in

            print_debug("permissionGrantedBlock: \(permissionGranted)")

        }, errorOccured: {

            print_debug("errorOccured")

        }, noNetworkBlock: {

            print_debug("noNetworkBlock")
        })
    }

    func setupFirebase() {
        FirebaseHelper.authenticate { (isAuthenticated) in
            if isAuthenticated {
                print_debug("logged in")
            } else {
                print_debug("cannot log in")
            }
        }
    }
    
    func setUpPopOverView() {
        
        configuration.textFont = AppFonts.Comfortaa_Regular_0.withSize(14)
        configuration.textColor = AppColors.blackColor
        //        configuration.localShadow = true
        //        configuration.shadowAlpha = 0.2
        configuration.menuWidth = 100.0
        //        configuration.localShadow
        configuration.textAlignment = .center
        configuration.backgoundTintColor = AppColors.whiteColor
        configuration.borderColor = AppColors.popUpBackground
    }
    
    //    private func application(_ application: UIApplication,
    //                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //        return GIDSignIn.sharedInstance().handle(url,
    //                                                 sourceApplication: sourceApplication,
    //                                                 annotation: annotation)
    //    }
    //
    //    @available(iOS 9.0, *)
    //    private func application(_ app: UIApplication, open url: URL,
    //                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    //        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
    //        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
    //        return GIDSignIn.sharedInstance().handle(url,
    //                                                 sourceApplication: sourceApplication,
    //                                                 annotation: annotation)
    //    }
    //
    //
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "budfie" {
            return appDidOpen(with: url)
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL?,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
            ) || GoogleLoginController.shared.handleUrl(url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme == "budfie" {
            return appDidOpen(with: url)
        }
        
        //MARK: Facebook related
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL?,
            sourceApplication: sourceApplication,
            annotation: annotation) || GIDSignIn.sharedInstance().handle(url,
                                                                         sourceApplication: sourceApplication,
                                                                         annotation: annotation)
    }
    
    private func appDidOpen(with url: URL) -> Bool {
        print_debug(url.absoluteString)
        
        let isBuddyChosen = !AppUserDefaults.value(forKey: .selectedBuddy).stringValue.isEmpty
        
        guard AppUserDefaults.value(forKey: .userData) != JSON.null,
            let json = getJson(from: url),
            isBuddyChosen else {
                return false
        }
        
        let typeValue = json["type"].intValue
        let id = json["id"].stringValue
        
        guard typeValue != 0,
            !id.isEmpty else {
                return false
        }
        
        if let navCont = window?.rootViewController as? UINavigationController,
            let newHomeScreenScene = navCont.viewControllers.first as? NewHomeScreenVC,
            newHomeScreenScene.isViewLoaded,
            let type = AppDelegate.URLSchemeType(rawValue: typeValue),
            let eventDetailCont = getController(for: type, id: id) {
            navCont.pushViewController(eventDetailCont, animated: true)
        }
        return true
    }
    
    private func getJson(from url: URL) -> JSON? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return nil
        }
        
        var json = JSON()
        for item in queryItems {
            if let value = item.value {
                json[item.name] = JSON(value)
            }
        }
        
        return json
    }
    
    func moveToEventDetail(of type: URLSchemeType, with id: String) {
        
        let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
        let navCont = AvoidingMultiPushNavigationController(rootViewController: newHomeScreenScene)
        navCont.isNavigationBarHidden = true
        
        var viewControllers = navCont.viewControllers
        
        /*
         let tabVc = TabBarVC.instantiate(fromAppStoryboard: .Events)
         tabVc.tabBarState = .Event
         tabVc.hideTabbar()
         AppDelegate.shared.sharedTabbar = tabVc
         viewControllers.append(tabVc)
         */
        
        if let eventDetailCont = getController(for: type, id: id) {
            viewControllers.append(eventDetailCont)
        }
        
        navCont.setViewControllers(viewControllers, animated: false)
        
        AppDelegate.shared.window?.rootViewController = navCont
        AppDelegate.shared.window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = .default
    }
    
    func getController(for type: URLSchemeType, id: String) -> UIViewController? {
        
        let event = EventModel(initForEventModel: ["event_id": id,
                                                   "event_category": type.eventCategory])
        
        switch type {
        case .none, .personal:
            return nil
            
        case .movie, .concert:
            
            let moviesOrConcert: MoviesConcert
            
            if type == .movie {
                moviesOrConcert = .movies
            } else {
                moviesOrConcert = .concert
            }
            
            let moviesSeriesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
            moviesSeriesScene.moviesOrConcert = moviesOrConcert
            //moviesSeriesScene.delegate = self
            moviesSeriesScene.obEventModel = event
            return moviesSeriesScene
            
        case .cricket, .soccer:
            
            let sportType: SportDetailVC.SportType
            
            if type == .cricket {
                sportType = .cricket
            } else {
                sportType = .soccer
            }
            
            let sportDetailScene = SportDetailVC.instantiate(fromAppStoryboard: .Events)
            sportDetailScene.vcType = sportType
            //sportDetailScene.delegate = self
            sportDetailScene.eventModel = event
            return sportDetailScene
        }
    }
    
    func logUserForCrashlytics() {
        //        guard isLogin else {
        //            return
        //        }
        //
        //        if let name = AppUserDefaults.value(forKey: .user_fullname, fallBackValue: JSON.null).string,
        //            let id = AppUserDefaults.value(forKey: .user_id, fallBackValue: JSON.null).string,
        //            let email = AppUserDefaults.value(forKey: .user_email, fallBackValue: JSON.null).string {
        //            Crashlytics.sharedInstance().setUserEmail(email)
        //            Crashlytics.sharedInstance().setUserIdentifier(id)
        //            Crashlytics.sharedInstance().setUserName(name)
        //        }
    }
    
 }
 
