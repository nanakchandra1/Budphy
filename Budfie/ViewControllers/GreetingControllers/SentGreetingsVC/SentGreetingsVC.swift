//
//  SentGreetingsVC.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift
import Realm
import EmptyDataSet_Swift

enum ApiState {
    case failed
    case noData
    case loading
}

protocol ResetGreetingCountDelegate: class {
    func resetGreetingCount()
}

class SentGreetingsVC: BaseVc {

    // MARK: Public Properties
    var flowType: FlowType = .home
    var greetingType: GreetingType = .animation
    var vcState: VCState = .create
    var shouldSelectTableCell = true
    var eventDate = String()
    var eventId   = String()
    fileprivate var apiState: ApiState = .loading {
        didSet {
            if oldValue != apiState {
                showGreetingsTableView.reloadEmptyDataSet()
            }
        }
    }
    weak var delegate: ResetGreetingCountDelegate?

    // MARK: Private Properties
    var greetings = [Greeting]()
    var modelGreetingList = [GreetingListModel]()
    fileprivate var actionableIndex: Int?
    //fileprivate var tablePlaceholderText = ""
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var showGreetingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        self.registerNibs()
        refreshData()
        /*
        else if self.vcState == .draft {
            self.fetchAllRecords()
        }
        */
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.vcState == .draft {
            self.fetchAllRecords()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if flowType != .events {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editBtnTapped(_ sender: UIButton) {

        guard let indexPath = self.showGreetingsTableView.indexPath(forItem: sender) else {
            return
        }
        let greeting = self.greetings[indexPath.row]
        openEditGreeting(with: greeting)
    }

    fileprivate func refreshData() {
        if self.vcState == .sent || self.vcState == .receive {
            apiState = .loading
            self.hitGreetingList(page: "1", loader: false)
        }
    }
    
    func openEditGreeting(with greeting: Greeting) {
        guard let greetingType = GreetingType(rawValue: greeting.greetingType) else {
            return
        }
        hideOtherActionsIfNeeded(except: nil)
        
        let animationsVCScene = AnimationsVC.instantiate(fromAppStoryboard: .Greeting)
        animationsVCScene.vcState = .draft
        animationsVCScene.greetingType = greetingType
        animationsVCScene.greeting = greeting
        animationsVCScene.eventId = eventId
        animationsVCScene.eventDate = eventDate
        self.navigationController?.pushViewController(animationsVCScene, animated: true)
    }
    
    @objc func deleteBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = self.showGreetingsTableView.indexPath(forItem: sender) else { return }
        
        if self.vcState == .draft {
            self.deleteSelected(greeting: self.greetings[indexPath.row])
        } else {
            self.hitDeleteGreeting(greetingId: modelGreetingList[indexPath.row].greeting_id,
                                   shareId: modelGreetingList[indexPath.row].share_id,
                                   loader: false)
        }
        self.modelGreetingList.remove(at: indexPath.row)
        self.showGreetingsTableView.deleteRows(at: [indexPath], with: .middle)
    }
    
    @objc func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        
        guard let cell = gesture.view?.getTableViewCell as? SentDraftReceiveCell else {
            return
        }

        guard let indexPath = showGreetingsTableView.indexPath(for: cell) else {
            return
        }

        let translationX = gesture.translation(in: gesture.view).x
        let minimumPadding: CGFloat = 12

        switch gesture.state {

        case .began:
            hideOtherActionsIfNeeded(except: indexPath.row)
            shouldSelectTableCell = false

        case .ended:

            shouldSelectTableCell = true
            showGreetingsTableView.isScrollEnabled = true

            let trailing = cell.backViewTrailing.constant
            var maximumTrailing: CGFloat = 80
            
            if self.vcState == .draft {
                maximumTrailing = 160
            }
            let toMoveToTrailing: CGFloat

            if (trailing > maximumTrailing/2) {
                toMoveToTrailing = maximumTrailing
                actionableIndex = indexPath.row
            } else {
                toMoveToTrailing = minimumPadding
                actionableIndex = nil
            }

            UIView.animate(withDuration: 0.2) {
                cell.backViewTrailing.constant = toMoveToTrailing
                cell.leadingBackView.constant = ((2 * minimumPadding) - toMoveToTrailing)
                cell.layoutIfNeeded()
            }

        default:
            let currentTrailing = cell.backViewTrailing.constant
            let finalTrailing = max(minimumPadding, (currentTrailing - translationX))
            cell.backViewTrailing.constant = finalTrailing
            cell.leadingBackView.constant = ((2 * minimumPadding) - finalTrailing)
        }
        gesture.setTranslation(.zero, in: gesture.view)
    }

    private func hideOtherActionsIfNeeded(except index: Int?) {
        guard let visibleIndices = showGreetingsTableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleIndices {
            if indexPath.row == index {
                continue
            }
            if let cell = showGreetingsTableView.cellForRow(at: indexPath) as? SentDraftReceiveCell {
                UIView.animate(withDuration: 0.2) {
                    let minimumPadding: CGFloat = 12
                    cell.backViewTrailing.constant = minimumPadding
                    cell.leadingBackView.constant = minimumPadding
                    cell.layoutIfNeeded()
                }
            }
        }
    }
    
}


//MARK:- Private Extension
//========================
extension SentGreetingsVC {
    
    private func initialSetup() {
        
        self.showGreetingsTableView.delegate = self
        self.showGreetingsTableView.dataSource = self
        self.showGreetingsTableView.backgroundColor = UIColor.clear
        
        //Empty Data Set
        self.showGreetingsTableView.emptyDataSetSource = self
        self.showGreetingsTableView.emptyDataSetDelegate = self

        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        if self.vcState == .sent {
            self.navigationTitle.text = "Sent"
        } else if self.vcState == .receive {
            self.navigationTitle.text = "Received"
        } else if self.vcState == .draft {
            self.navigationTitle.text = "Drafts"
        }
    }
    
    func fetchAllRecords() {
        
        self.modelGreetingList.removeAll()
        self.greetings.removeAll()
        
        if let realm = try? Realm() {
            
            let greetings = realm.objects(Greeting.self).filter({ greeting in
                if let id = greeting.id {
                    return (greeting.isDraft && !id.isEmpty)
                }
                return greeting.isDraft
            }).reversed()
            for greet in greetings {
                self.greetings.append(greet)
                self.modelGreetingList.append(GreetingListModel(initWithGreeting: greet))
            }
            apiState = .noData
            self.showGreetingsTableView.reloadData()
            //self.greetings = greetings
        }
    }
    
    func deleteSelected(greeting: Greeting) {
        
        if let realm = try? Realm() {
            try! realm.write {
                realm.delete(greeting)
            }
        }
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "SentDraftReceiveCell", bundle: nil)
        self.showGreetingsTableView.register(cell, forCellReuseIdentifier: "SentDraftReceiveCell")
    }

    /*
     func settingEmptyDataSet(isLoading: Bool = true) {
     if isLoading {
     tablePlaceholderText = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
     } else {
     switch self.vcState {
     case .draft:
     tablePlaceholderText = "No Greeting Drafted"
     case .sent:
     tablePlaceholderText = "No Greeting Sent"
     case .receive:
     tablePlaceholderText = "No Greeting Received"
     default:
     tablePlaceholderText = StringConstants.K_No_Greetings_Found.localized
     }
     }
     // No Greeting Drafted
     //showGreetingsTableView.reloadEmptyDataSet()
     }
     */
    
    //MARK:- hitDeleteGreeting method
    //===============================
    func hitDeleteGreeting(greetingId: String, shareId: String = "", loader: Bool = true) {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Delete_Greeting.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["greeting_id"]   = greetingId
        params["share_id"]      = shareId
        
        if self.vcState == .sent {
            params["type"]          = "1"
        } else if self.vcState == .receive {
            params["type"]          = "2"
        } else if self.vcState == .draft {
            params["type"]          = "3"
        }
        
        //TYPE (1=Sent,2=Received,3=Draft)
        
        WebServices.deleteGreeting(parameters: params, loader: loader, success: { [weak self] (isSuccess) in

            guard let strongSelf = self else {
                return
            }

            strongSelf.apiState = .noData
            strongSelf.showGreetingsTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitGreetingList method
    //=============================
    func hitGreetingList(page: String, loader: Bool = true) {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Greeting_List.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["page"]          = page
        
        if self.vcState == .sent {
            params["type"]          = "1"
        } else if self.vcState == .receive {
            params["type"]          = "2"
        }
        
        //TYPE (1=Sent,2=Received,3=Draft)
        
        WebServices.getGreetingList(parameters: params, loader: loader, success: { [weak self] (model) in

            guard let strongSelf = self else {
                return
            }

            strongSelf.delegate?.resetGreetingCount()
            strongSelf.modelGreetingList = model
            strongSelf.apiState = .noData
            strongSelf.showGreetingsTableView.reloadData()

        } , failure: { [weak self] (err) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.apiState = .noData
            //CommonClass.showToast(msg: err.localizedDescription)
        })
    }
    
    //MARK:- hitCreateGreeting method
    //===============================
    func hitCreateGreeting(type: String, loader: Bool = true) {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Create_Greeting.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["title"]         = ""
        params["type"]          = type
        params["message"]       = ""
        params["color_code"]    = ""
        params["music"]         = ""
        params["url"]           = ""
        
        //TYPE (1=Animated,2=Face in a hole,3=Popup or 3D,4=Classic & Funny)
        
        WebServices.createGreeting(parameters: params, loader: loader, success: { [weak self] _ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.apiState = .noData
            strongSelf.showGreetingsTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitGreetingDetails method
    //================================
    func hitGreetingDetails(greetingId: String, page: String = "", loader: Bool = true) {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Greeting_Details.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["greeting_id"]   = greetingId
        params["share_id"]      = page
        
        if self.vcState == .sent {
            params["type"]          = "1"
        } else if self.vcState == .receive {
            params["type"]          = "2"
        }
        
        //TYPE (1=Sent,2=Received)
        
        WebServices.getGreetingDetails(parameters: params, loader: loader, success: { [weak self] (model) in

            guard let strongSelf = self else {
                return
            }

            //strongSelf.modelGreetingList = model
            strongSelf.apiState = .noData
            strongSelf.showGreetingsTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitAddGreeting method
    //==============================
    func addGreetingToEvent(greetingId: String, greetingImg: String) {
        
        let params: JSONDictionary = ["method": "edit",
                                      "access_token": AppDelegate.shared.currentuser.access_token,
                                      "greeting_id": greetingId,
                                      "event_id": eventId]
        
        // Add Greeting
        //================
        WebServices.editEvent(parameters: params, success: { [weak self] (isSuccess) in
            
            guard let strongSelf = self else {
                return
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
                CommonClass.showToast(msg: err.localizedDescription)
        })
    }
    
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension SentGreetingsVC : EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let title: String

        switch apiState {
        case .failed:
            title = "Wake Up Your Connection"
        case .noData:
            title = "Oops..No Result Found"
        case .loading:
            return nil
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.black,
                                                        .font: AppFonts.AvenirNext_Regular.withSize(17)]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        return attributedString
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let description: String

        switch apiState {
        case .failed:
            description = "Your internet seems too slow to reach our server."
        case .noData:
            description = "There is no result. Please add so that we can show some results."
        case .loading:
            description = StringConstants.K_Loading_Your_Favourites.localized
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: AppColors.textGrayColor,
                                                        .font: AppFonts.Comfortaa_Regular_0.withSize(15)]
        let attributedString = NSAttributedString(string: description, attributes: attributes)
        return attributedString
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        switch apiState {
        case .failed:
            return #imageLiteral(resourceName: "icWakeupConnection")
        case .noData:
            return #imageLiteral(resourceName: "icNoResultFound")
        case .loading:
            return nil
        }
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {

        let buttonTitle: String

        switch apiState {
        case .failed:
            buttonTitle = "Try Again"
        case .noData:
            //buttonTitle = "Okay, Thanks"
            return nil
        case .loading:
            return nil
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: AppColors.themeBlueColor,
                                                        .font: AppFonts.AvenirNext_Regular.withSize(17)]
        let attributedString = NSAttributedString(string: buttonTitle, attributes: attributes)
        return attributedString
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        switch apiState {
        case .failed:
            refreshData()
        case .noData:
            break
        case .loading:
            break
        }
    }
}

// MARK: Gesture Recognizer Delegate Methods
extension SentGreetingsVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if let view = gestureRecognizer.view,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gestureRecognizer.translation(in: view)
            let shouldRecognize = abs(translation.y) >= abs(translation.x)
            return shouldRecognize
        }

        return true
    }
}
