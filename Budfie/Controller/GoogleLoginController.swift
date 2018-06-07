
//  GoogleLoginController.swift
//  GoogleLogin
//
//  Created by on 10/09/17.
//  Copyright © 2017 . All rights reserved.

//import Google
import GoogleSignIn
//import GoogleAPIClient
import GoogleAPIClientForREST
import SwiftyJSON

class GoogleLoginController : NSObject {
    
    // MARK: Variables and properties...
    static let shared = GoogleLoginController()
    fileprivate(set) var currentGoogleUser: GoogleUser?
    fileprivate weak var contentViewController:UIViewController!
    fileprivate var hasAuthInKeychain: Bool {
        let hasAuth = GIDSignIn.sharedInstance().hasAuthInKeychain()
        return hasAuth
    }
    // Events
    var isEventFetch : Bool = false
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    private let service = GTLRCalendarService()
    var eventsArray = String()
    
    var success : ((_ googleUser : GoogleUser) -> ())?
    var failure : ((_ error : Error) -> ())?
    var fetchEventCompletion: (([GoogleEventModel]?, Error?) -> ())?
    
    private override init() {}
    
    func configure(withClientId clientId:String) {
        
        GIDSignIn.sharedInstance().clientID = clientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func handleUrl(_ url: URL, options: [UIApplicationOpenURLOptionsKey : Any])->Bool{
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    // MARK: - Method for google login...
    // MARK: ============================
    func login(fromViewController viewController : UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!,
               success : @escaping(_ googleUser : GoogleUser) -> (),
               failure : @escaping(_ error : Error) -> ()) {
        
        self.isEventFetch = false
        
        if hasAuthInKeychain {
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
        
        contentViewController = viewController
        self.success = success
        self.failure = failure
    }
    
    // MARK: - Method for google login...
    // MARK: ============================
    func loginWithEventFetch(fromViewController viewController : UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!, completion: @escaping (([GoogleEventModel]?, Error?) -> ())) {
        
        self.isEventFetch = true
        fetchEventCompletion = completion
        
        if hasAuthInKeychain {
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
        contentViewController = viewController
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
}

// MARK: - GIDSignInUIDelegate and GIDSignInDelegate delegare methods...
// MARK: ===============================================================
extension GoogleLoginController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    // MARK: To get user details like name, email etc.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            
            if isEventFetch {
                self.service.authorizer = user.authentication.fetcherAuthorizer()
                fetchEvents()
                success = nil
                failure = nil

            } else {
                let googleUser = GoogleUser(user)
                currentGoogleUser = googleUser
                success?(googleUser)
            }
            
        } else {
            failure?(error)
            fetchEventCompletion?(nil, error)
        }
        
        success = nil
        failure = nil
    }
    
    // MARK: - To present to your controller
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        contentViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - To dismiss from your controller
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        contentViewController.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Get Google Events Methods
// MARK: ===========================
extension GoogleLoginController {
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 100000
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Display the start dates and event summaries in the UITextView
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            fetchEventCompletion?(nil, error)
            return
        }
        
        // DELETING OLD ENTERIES
        EventsCoreDataController.deleteEvents()
        
        var googleEventModel = [GoogleEventModel]()
        
        if let events = response.items, !events.isEmpty {
            
            for event in events {
                googleEventModel.append(GoogleEventModel(with: event))
            }
        }

        fetchEventCompletion?(googleEventModel, error)
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
//        let alert = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: UIAlertControllerStyle.alert
//        )
//        let ok = UIAlertAction(
//            title: "OK",
//            style: UIAlertActionStyle.default,
//            handler: nil
//        )
//        alert.addAction(ok)
//        self.present(alert, animated: true, completion: nil)
        CommonClass.showToast(msg: "\(title): \(message)")
    }
    
}

// MARK: - Model class to store the user information...
// MARK: ==============================================
class GoogleUser {
    
    let id: String
    let name: String
    let email: String
    let image: URL?
    
    required init(_ googleUser: GIDGoogleUser) {
        
        id = googleUser.userID
        name = googleUser.profile.name
        email = googleUser.profile.email
        image = googleUser.profile.imageURL(withDimension: 200)
    }
    
    var dictionaryObject: [String:Any] {
        
        var dictionary          = [String:Any]()
        dictionary["_id"]       = id
        dictionary["email"]     = email
        dictionary["image"]     = image?.absoluteString ?? ""
        dictionary["name"]      = name
        return dictionary
    }
    
}

