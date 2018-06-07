//
//  InvitationVC.swift
//  Budfie
//
//  Created by appinventiv on 29/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import EmptyDataSet_Swift

/*
protocol GetPendingCount : class {
    func getPendingCount(date: String)
}
*/

class InvitationVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var obInvitationModel = [InvitationModel]()
    weak var delegate : GetPendingCountDelegate?
    var shouldSelectTableCell = true
    
    // MARK: Private Properties
    fileprivate var actionableIndex: Int?
    fileprivate var tablePlaceholderText = ""

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView       : UIView!
    @IBOutlet weak var navigationTitle      : UILabel!
    @IBOutlet weak var backBtn              : UIButton!
    @IBOutlet weak var statusBar            : UIView!
    @IBOutlet weak var showInvitationTableView: UITableView!
    @IBOutlet weak var noDataFound          : UIImageView!
    @IBOutlet weak var noDataRecordLabel    : UILabel!
    @IBOutlet weak var floatQuickReminderBtn: UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hitGetPendingInvitaion()
        self.initialSetUp()
        self.registerNibs()
        self.seUpPullToRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setUpCreateReminderAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.performCreateReminderAnimation()
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {

        self.hitGetPendingInvitaion()
        refreshControl.endRefreshing()
    }

    private func setUpCreateReminderAnimation() {
        floatQuickReminderBtn.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
    }

    private func performCreateReminderAnimation() {

        UIView.animate(withDuration: 0.3,
                       delay: 0.5,
                       options: .curveEaseInOut,
                       animations: {
                        self.floatQuickReminderBtn.transform = .identity
        }, completion: nil)
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func acceptOrRejectBtnTapped(_ sender: UIButton) {
        
        let cell = sender.getTableViewCell as? MoreInvitationCell
        guard let indexPath = sender.tableViewIndexPath(self.showInvitationTableView) else { return }

        let action: String
        let type: String
        let invitation = obInvitationModel[indexPath.row]
        
        if sender == cell?.acceptBtn {
            action = "1"
        } else {
            action = "2"
        }

        if invitation.eventType == "Holiday" {
            type = "2"
        } else {
            type = "1"
        }

        self.obInvitationModel.remove(at: indexPath.row)
        self.showInvitationTableView.deleteRows(at: [indexPath], with: .middle)
        
//        self.noDataFound.isHidden = self.obInvitationModel.isEmpty ? false : true
//        self.noDataRecordLabel.isHidden = self.obInvitationModel.isEmpty ? false : true

        self.hitAcceptOrReject(invitation: invitation, action: action, type: type)
    }

    @IBAction func floatBtnTapped(_ sender: UIButton) {
        
        let quickReminderScene = QuickReminderVC.instantiate(fromAppStoryboard: .Settings)
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        quickReminderScene.delegate = self
        self.navigationController?.pushViewController(quickReminderScene, animated: true)
    }

    @objc func deleteBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = self.showInvitationTableView.indexPath(forItem: sender) else { return }
        
        let id = obInvitationModel[indexPath.row].eventId
        self.hitDeleteReminder(reminderId: id)
        self.obInvitationModel.remove(at: indexPath.row)
        self.showInvitationTableView.deleteRows(at: [indexPath], with: .middle)
    }
    
    @objc func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        
        guard let cell = gesture.view?.getTableViewCell as? NotificationCell else {
            return
        }
        
        guard let indexPath = showInvitationTableView.indexPath(for: cell) else {
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
            showInvitationTableView.isScrollEnabled = true
            
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
        guard let visibleIndices = showInvitationTableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visibleIndices {
            if indexPath.row == index {
                continue
            }
            if let cell = showInvitationTableView.cellForRow(at: indexPath) as? NotificationCell {
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


//MARK:- Extension for private methods
//====================================
extension InvitationVC {
    
    func initialSetUp() {
        
        self.showInvitationTableView.delegate = self
        self.showInvitationTableView.dataSource = self
        self.showInvitationTableView.backgroundColor = UIColor.clear
        
        //Empty Data Set
        self.showInvitationTableView.emptyDataSetSource = self
        self.showInvitationTableView.emptyDataSetDelegate = self
        self.settingEmptyDataSet()
        
        // set header view..
        self.navigationView.backgroundColor = UIColor.clear
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = "Reminders"
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
//        self.noDataRecordLabel.text = "No Data"
//        self.noDataRecordLabel.font = AppFonts.Comfortaa_Bold_0.withSize(20)
//        self.noDataRecordLabel.textColor = AppColors.noDataFound
        self.noDataFound.isHidden = true
        self.noDataRecordLabel.isHidden = true
        
        self.floatQuickReminderBtn.backgroundColor = AppColors.themeBlueColor
        self.floatQuickReminderBtn.roundCornerWith(radius: self.floatQuickReminderBtn.frame.width/2)
        self.floatQuickReminderBtn.dropShadow(width: 5.0, shadow: AppColors.floatBtnShadow)

    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        
        var placeholder = ""
        if isLoading {
            placeholder = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else {
            placeholder = StringConstants.K_No_Pending_Reminders.localized//"BUDFIE hard at work"//"No Pending Invitations"
        }
        
        let myAttribute = [ NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                            NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: placeholder, attributes: myAttribute)
        
        self.showInvitationTableView.emptyDataSetView { view in
            view.titleLabelString(myAttrString)
//                .detailLabelString(NSAttributedString.init(string: "No Data"))
//                .image(AppImages.icNodata)
//                .imageAnimation(imageAnimation)
//                .buttonTitle(buttonTitle, for: .normal)
//                .buttonTitle(buttonTitle, for: .highlighted)
//                .buttonBackgroundImage(buttonBackgroundImage, for: .normal)
//                .buttonBackgroundImage(buttonBackgroundImage, for: .highlighted)
//                .dataSetBackgroundColor(backgroundColor)
//                .verticalOffset(verticalOffset)
//                .verticalSpace(spaceHeight)
//                .shouldDisplay(true, view: tableView)
//                .shouldFadeIn(true)
//                .isTouchAllowed(true)
//                .isScrollAllowed(true)
                .isImageViewAnimateAllowed(true)
                .didTapDataButton {
                    // Do something
                }
                .didTapContentView {
                    // Do something
            }
        }
    }
    
    func registerNibs() {
        
        let cell = UINib(nibName: "MoreInvitationCell", bundle: nil)
        self.showInvitationTableView.register(cell, forCellReuseIdentifier: "MoreInvitationCell")
        
        let notificationCell = UINib(nibName: "NotificationCell", bundle: nil)
        self.showInvitationTableView.register(notificationCell, forCellReuseIdentifier: "NotificationCell")
    }
    
    func seUpPullToRefresh() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self,
                                 action: #selector(self.refresh(refreshControl:)),
                                 for: UIControlEvents.valueChanged)
        self.showInvitationTableView.addSubview(refreshControl)
    }

    //MARK:- hitDeleteReminder method
    //===============================
    func hitDeleteReminder(reminderId: String) {

        var params = JSONDictionary()

        params["method"]        = "delete_reminder"
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["reminder_id"]   = reminderId

        WebServices.deleteReminder(parameters: params, loader: false, success: { [weak self] (isSuccess) in

            guard let strongSelf = self else {
                return
            }

            strongSelf.settingEmptyDataSet(isLoading: false)
            strongSelf.showInvitationTableView.reloadData()

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitGetPendingInvitaion method
    //====================================
    func hitGetPendingInvitaion() {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Fetch_Pending_Events.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = "1"
        
        WebServices.getPendingInvites(parameters: params, loader: false, success: { (obInvitationModel) in
//            self.obInvitationModel.removeAll()

            self.settingEmptyDataSet(isLoading: false)
            self.obInvitationModel = obInvitationModel

            self.delegate?.resetPendingCount()

//            self.noDataFound.isHidden = self.obInvitationModel.isEmpty ? false : true
//            self.noDataRecordLabel.isHidden = self.obInvitationModel.isEmpty ? false : true
            self.showInvitationTableView.reloadData()

        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
//            self.noDataFound.isHidden = self.obInvitationModel.isEmpty ? false : true
//            self.noDataRecordLabel.isHidden = self.obInvitationModel.isEmpty ? false : true

        }
    }
    
    //MARK:- hitAcceptOrReject method
    //===============================
    func hitAcceptOrReject(invitation: InvitationModel, action: String, type: String) {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Accept_Reject.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = invitation.eventId
        params["action"]            = action
        params["type"]              = type
        
        WebServices.acceptOrReject(parameters: params, loader: false, success: { [weak self] (isSuccess) in
            self?.delegate?.refreshEvents(for: invitation.eventDate)

//                self.hitGetPendingInvitaion()
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            
        })
    }
    
    func getNameReminder(text: String) -> (String, UIImage) {
        
        switch text {
        case "Health":
            return ("Health", AppImages.icReminderHealthSelected)
        case "Call":
            return ("Call", AppImages.icReminderCallSelected)
        case "BillPay":
            return ("Bill Payment", AppImages.icReminderBillpaymentSelected)
        default:
            return ("", AppImages.icAddeventDropdown)
        }
    }
    
}


extension InvitationVC: DoRefreshOnPop {
    
    func hitService() {
        self.hitGetPendingInvitaion()
    }
    
}


//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension InvitationVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
}


//MARK:- Extension for AcceptOrReject Delegate
//============================================
extension InvitationVC: AcceptOrReject {
    
    func acceptRejectClicked(isAccept: Bool, eventId: String) {

        guard let index = obInvitationModel.index(where: { invitation -> Bool in
            return invitation.eventId == eventId
        }) else {
            return
        }

        let action: String
        let type  : String
        let invitation = obInvitationModel[index]
        
        if isAccept {
            action = "1"
        } else {
            action = "2"
        }

        if invitation.eventType == "Holiday" {
            type = "2"
        } else {
            type = "1"
        }

        //self.delegate?.getPendingCount(date: invitation.eventDate)
        self.obInvitationModel.remove(at: index)
        self.showInvitationTableView.deleteRows(at: [[0, index]], with: .middle)
        
//        self.noDataFound.isHidden = self.obInvitationModel.isEmpty ? false : true
//        self.noDataRecordLabel.isHidden = self.obInvitationModel.isEmpty ? false : true

        self.hitAcceptOrReject(invitation: invitation, action: action, type: type)
    }
    
}

// MARK: Gesture Recognizer Delegate Methods
extension InvitationVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let view = gestureRecognizer.view,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gestureRecognizer.translation(in: view)
            return abs(translation.y) >= abs(translation.x)
        }
        
        return true
    }
}

