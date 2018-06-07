//
//  NotificationsVC.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import EmptyDataSet_Swift

protocol GetPendingCountDelegate : class {
    func resetPendingCount()
    func refreshEvents(for date: String)
    //func getPendingCount(date: String)
}

class NotificationsVC: BaseVc {

    // MARK: Public Properties
    var shouldSelectTableCell = true
    var vcState: VCState = .profile
    var notificationListModel = [NotificationListModel]()
    weak var delegate : GetPendingCountDelegate?

    // MARK: Private Properties
    fileprivate var actionableIndex: Int?
    fileprivate var tablePlaceholderText = ""
    
    enum VCState {
        case exploreMore
        case profile
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var showNotificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hitNotificationList(page: "1")
        self.initialSetup()
        self.registerNibs()
        self.seUpPullToRefresh()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if vcState == .exploreMore {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        
        self.hitNotificationList(page: "1")
        refreshControl.endRefreshing()
    }
    
    @objc func deleteBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = self.showNotificationsTableView.indexPath(forItem: sender) else { return }
        
        let id = notificationListModel[indexPath.row].notification_id
        
        self.hitDeleteNotification(notificationId: id)
        self.notificationListModel.remove(at: indexPath.row)
        
        self.showNotificationsTableView.deleteRows(at: [indexPath], with: .middle)
    }
    
    @objc func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        
        guard let cell = gesture.view?.getTableViewCell as? NotificationCell else {
            return
        }

        guard let indexPath = showNotificationsTableView.indexPath(for: cell) else {
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
            showNotificationsTableView.isScrollEnabled = true

            let trailing = cell.backViewTrailing.constant
            let maximumTrailing: CGFloat = 100
            
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
        guard let visibleIndices = showNotificationsTableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleIndices {
            if indexPath.row == index {
                continue
            }
            if let cell = showNotificationsTableView.cellForRow(at: indexPath) as? NotificationCell {
                UIView.animate(withDuration: 0.2) {
                    let minimumPadding: CGFloat = 12
                    cell.backViewTrailing.constant = minimumPadding
                    cell.leadingBackView.constant = minimumPadding
                    cell.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func acceptOrRejectBtnTapped(_ sender: UIButton) {
        
        let cell = sender.getTableViewCell as? MoreInvitationCell
        guard let index = sender.tableViewIndexPath(self.showNotificationsTableView) else { return }
        
        var eventID = String()
        var action = String()
        
        if sender == cell?.acceptBtn {
            action = "1"
        } else {
            action = "2"
        }
        /*
        self.delegate?.getPendingCount(date: self.obInvitationModel[index.row].eventDate)
        
        eventID = self.obInvitationModel[index.row].eventId
        self.obInvitationModel.remove(at: index.row)
        self.showNotificationsTableView.deleteRows(at: [index], with: .middle)
        */
        //        self.noDataFound.isHidden = self.obInvitationModel.isEmpty ? false : true
        //        self.noDataRecordLabel.isHidden = self.obInvitationModel.isEmpty ? false : true
        
        self.hitAcceptOrReject(eventID: eventID, action: action)
    }

}


//MARK:- Private Extension
//========================
extension NotificationsVC {
    
    private func initialSetup() {
        
        self.showNotificationsTableView.delegate = self
        self.showNotificationsTableView.dataSource = self
        self.showNotificationsTableView.backgroundColor = UIColor.clear
        
        //Empty Data Set
        self.showNotificationsTableView.emptyDataSetSource = self
        self.showNotificationsTableView.emptyDataSetDelegate = self
        self.settingEmptyDataSet()
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "NotificationCell", bundle: nil)
        self.showNotificationsTableView.register(cell, forCellReuseIdentifier: "NotificationCell")
    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        if isLoading {
            tablePlaceholderText = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else {
            tablePlaceholderText = "No Notifications Received"
        }
       // No Greeting Drafted
        //showNotificationsTableView.reloadEmptyDataSet()
    }
    
    func seUpPullToRefresh() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self,
                                 action: #selector(self.refresh(refreshControl:)),
                                 for: UIControlEvents.valueChanged)
        self.showNotificationsTableView.addSubview(refreshControl)
    }

    //MARK:- hitDeleteNotification method
    //===================================
    func hitDeleteNotification(notificationId: String) {

        var params = JSONDictionary()

        params["method"]        = "delete_notification"
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["notification_id"]   = notificationId

        //TYPE (1=Sent,2=Received,3=Draft)

        WebServices.deleteNotification(parameters: params, loader: false, success: { [weak self] (isSuccess) in

            guard let strongSelf = self else {
                return
            }

            strongSelf.settingEmptyDataSet(isLoading: false)
            strongSelf.showNotificationsTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitNotificationList method
    //=================================
    func hitNotificationList(page: String) {
        
        var params = JSONDictionary()
        
        params["method"]        = "notification_list"
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["page"]          = page

        //TYPE (1=Sent,2=Received,3=Draft)
        
        WebServices.getNotificationList(parameters: params, loader: false, success: { [weak self] (isSucces, model) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.notificationListModel = model
            strongSelf.settingEmptyDataSet(isLoading: false)
            strongSelf.showNotificationsTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitReadNotification method
    //=================================
    func hitReadNotification(notificationId: String) {
        
        var params = JSONDictionary()
        
        params["method"]        = "read_notification"
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["notification_id"] = notificationId
        
        WebServices.readNotification(parameters: params, loader: true, success: { (isSuccess) in
            
            if isSuccess {
                
            }

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitAcceptOrReject method
    //===============================
    func hitAcceptOrReject(eventID: String, action: String) {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Accept_Reject.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = eventID
        params["action"]            = action
        
        WebServices.acceptOrReject(parameters: params, loader: false, success: { (isSuccess) in
            
            //                self.hitGetPendingInvitaion()
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            
        })
    }
    
}


//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension NotificationsVC : EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let myAttribute = [NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                           NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: tablePlaceholderText, attributes: myAttribute)
        return myAttrString
    }
}


//MARK:- Extension for AcceptOrReject Delegate
//============================================
extension NotificationsVC: AcceptOrReject {
    
    func acceptRejectClicked(isAccept: Bool, eventId: String) {
        
        var action = String()
        var index  = Int()
        
        if isAccept {
            action = "1"
        } else {
            action = "2"
        }
        /*
        for tempIndex in 0..<self.obInvitationModel.count {
            if self.obInvitationModel[tempIndex].eventId == eventId {
                index = tempIndex
            }
        }
        self.delegate?.getPendingCount(date: self.obInvitationModel[index].eventDate)
        
        self.obInvitationModel.remove(at: index)
        
        self.showNotificationsTableView.deleteRows(at: [[0,index]], with: .middle)
        
        //        self.noDataFound.isHidden = self.obInvitationModel.isEmpty ? false : true
        //        self.noDataRecordLabel.isHidden = self.obInvitationModel.isEmpty ? false : true
        */
        self.hitAcceptOrReject(eventID: eventId, action: action)
    }
    
}


// MARK: Gesture Recognizer Delegate Methods
extension NotificationsVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if let view = gestureRecognizer.view,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gestureRecognizer.translation(in: view)
            return abs(translation.y) >= abs(translation.x)
        }

        return true
    }
}
