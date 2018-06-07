//
//  SportDetailVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 23/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit
import RealmSwift

class SportDetailVC: BaseVc {

    enum SportType: Int {
        case soccer = 3
        case cricket = 5
        case batminton = 6
        case tennis = 7
    }

    var sportDetail     : SportDetail!
    var cricketDetail   : CricketDetailsModel!
    var tennisBadmintonDetails : TennisBadmintonModel!
    var eventModel      : EventModel!
    var vcType          : SportType = .soccer

    weak var delegate : HitMoviesOrConcertAPI?

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var navBackgroundView: UIView!
    @IBOutlet weak var favUnFavBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.eventModel.isFavourite == "0" {
            self.favUnFavBtn.isSelected = true
        } else {
            self.favUnFavBtn.isSelected = false
        }
        self.setFavUnFavImage()
 
        let addEventHeaderView = UINib(nibName: "AddEventHeaderView", bundle: nil)
        detailTableView.register(addEventHeaderView, forHeaderFooterViewReuseIdentifier: "AddEventHeaderViewId")

        let tableTopCurveNib = UINib(nibName: "TableTopCurveHeaderFooterView", bundle: nil)
        self.detailTableView.register(tableTopCurveNib, forHeaderFooterViewReuseIdentifier: "TableTopCurveHeaderFooterView")

        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.backgroundColor = .clear

        if #available(iOS 11.0, *) {
            //detailTableView.contentInsetAdjustmentBehavior = .never
            //detailTableView.insetsContentViewsToSafeArea = false
            //detailTableView.insetsLayoutMarginsFromSafeArea = false
            detailTableView.contentInset = UIEdgeInsetsMake(-view.safeAreaInsets.top, 0, 0, 0)
        }

        if let headerView = detailTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView {

            //self.headerView = headerView
            setupSportImage()
            headerView.setForSports()

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsImageTapped))
            tapGesture.cancelsTouchesInView = false
            headerView.eventsImage.addGestureRecognizer(tapGesture)

            let headerHeight: CGFloat = 250
            let navViewHeight: CGFloat = 44

            detailTableView.parallaxHeader.view = headerView
            detailTableView.parallaxHeader.height = headerHeight
            detailTableView.parallaxHeader.minimumHeight = navViewHeight
            detailTableView.parallaxHeader.mode = .centerFill

            navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(0)

            detailTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in

                let progress = parallaxHeader.progress

                let alpaComponent = max(0, min(1, ((1 - (progress)) / 0.95)))
                self.navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(alpaComponent)
                //headerView.overlayView.setNeedsDisplay()
                //self.updateHeaderConstraint()
            }
        }

        switch vcType {
        case .soccer:
            titleLabel.text = "Soccer"
        case .cricket:
            titleLabel.text = "Cricket"
        case .batminton:
            titleLabel.text = "Batminton"
        case .tennis:
            titleLabel.text = "Tennis"
        }
        refreshData()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func shareBtnTapped(_ sender: UIButton) {
        //CommonClass.showToast(msg: "Under Development")
        
        var shareURL = ""
        
        if self.vcType == .soccer {
            shareURL = self.sportDetail.share_url
        } else if self.vcType == .cricket {
            shareURL = self.cricketDetail.share_url
        } else {
            shareURL = self.tennisBadmintonDetails.share_url
        }
        CommonClass.externalShare(textURL: shareURL, viewController: self)
    }

    private func refreshData() {
        switch vcType {
        case .soccer:
            getSoccerDetails()
        case .cricket:
            getCricketDetails()
        case .batminton:
            getBadmintonDetails()
        case .tennis:
            getTennisDetails()
        }
    }

    @IBAction func refreshBtnTapped(_ sender: UIButton) {
        refreshData()
    }

    @IBAction func unFavBtnTapped(_ sender: UIButton) {
        
        if favUnFavBtn.isSelected == true {
            let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
            controller.pageState = .favUnFav
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: false, completion: nil)

        } else {
            self.favUnFav()
        }
    }
    
    func setFavUnFavImage() {
        
        if favUnFavBtn.isSelected == true {
            favUnFavBtn.isSelected = false
            favUnFavBtn.setImage(AppImages.icUnselectFav, for: UIControlState.normal)
        } else {
            favUnFavBtn.isSelected = true
            favUnFavBtn.setImage(AppImages.icSelectFav, for: UIControlState.normal)
        }
    }
    
    //MARK:- hitFavourite method
    //==========================
    func hitFavourite(action: String, type: String, event: EventModel) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Add_Remove_Favourite.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["action"]            = action
        params["type"]              = type
        params["type_id"]           = event.eventId
        
        WebServices.addFavourite(parameters: params, loader: false, success: { (isSuccess) in

            if let realm = try? Realm() {
                if action == "1" { // 1 denotes has to make favourite

                    let realmEvent = event.realmEvent
                    try? realm.write {
                        realm.add(realmEvent, update: true)
                    }

                } else if action == "2" { // 2 denotes has to remove from favourite

                    try? realm.write {
                        realm.delete(realm.objects(RealmEvent.self).filter("id=%@",event.eventId))
                    }
                }
            }

            self.delegate?.hitMoviesOrConcert(eventState: .sports)
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    func favUnFav() {
        
        var action = "0"
        var type = "0"

        if self.vcType == .soccer, let model = self.sportDetail {
            if model.isFavourite == "0" {
                action = "1"
                self.sportDetail.isFavourite = "1"
            } else {
                action = "2"
                self.sportDetail.isFavourite = "0"
            }
            type = "3"
        } else if self.vcType == .cricket, let model = self.cricketDetail {
            if model.isFavourite == "0" {
                action = "1"
                self.cricketDetail.isFavourite = "1"
            } else {
                action = "2"
                self.cricketDetail.isFavourite = "0"
            }
            type = "4"
        } else if self.vcType == .tennis, let model = self.tennisBadmintonDetails {
            if model.isFavourite == "0" {
                action = "1"
                self.tennisBadmintonDetails.isFavourite = "1"
            } else {
                action = "2"
                self.tennisBadmintonDetails.isFavourite = "0"
            }
            type = "6"
        } else if self.vcType == .batminton, let model = self.tennisBadmintonDetails {
            if model.isFavourite == "0" {
                action = "1"
                self.tennisBadmintonDetails.isFavourite = "1"
            } else {
                action = "2"
                self.tennisBadmintonDetails.isFavourite = "0"
            }
            type = "5"
        }
        self.setFavUnFavImage()
        self.hitFavourite(action: action, type: type, event: self.eventModel)
        //            self.showMoviesDetailsTable.reloadData()
    }
    
    func getSoccerDetails() {
        
        var params               = JSONDictionary()
        params["method"]         = StringConstants.K_Event_Details.localized
        params["access_token"]   = AppDelegate.shared.currentuser.access_token
        params["event_id"]       = eventModel.eventId
        params["event_category"] = vcType.rawValue
        
        WebServices.getSportDetails(parameters: params, success: { [weak self] sportDetail in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.sportDetail = sportDetail
            strongSelf.setupSportImage()
            strongSelf.detailTableView.reloadData()
            
        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getCricketDetails() {
        
        var params: JSONDictionary = JSONDictionary()
        params["method"]        = StringConstants.K_Event_Details.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["event_id"]      = eventModel.eventId
        params["event_category"] = vcType.rawValue

        WebServices.getCricketDetails(parameters: params, success: { [weak self] cricketDetail in

            guard let strongSelf = self else {
                return
            }

            strongSelf.cricketDetail = cricketDetail
            strongSelf.setupSportImage()
            strongSelf.detailTableView.reloadData()

        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getBadmintonDetails() {
        
        var params: JSONDictionary = JSONDictionary()
        params["method"]        = StringConstants.K_Event_Details.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["event_id"]      = eventModel.eventId
        params["event_category"] = vcType.rawValue
        
        WebServices.getBadmintonDetails(parameters: params, success: { [weak self] badmintonDetails in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.tennisBadmintonDetails = badmintonDetails
            strongSelf.setupSportImage()
            strongSelf.detailTableView.reloadData()
            
        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getTennisDetails() {
        
        var params: JSONDictionary = JSONDictionary()
        params["method"]        = StringConstants.K_Event_Details.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["event_id"]      = eventModel.eventId
        params["event_category"] = vcType.rawValue
        
        WebServices.getTennisDetails(parameters: params, success: { [weak self] tennisDetails in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.tennisBadmintonDetails = tennisDetails
            strongSelf.setupSportImage()
            strongSelf.detailTableView.reloadData()
            
        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupSportImage() {
        if self.vcType == .soccer, sportDetail != nil,
            //let img = detail.image,
            let addEventHeader = detailTableView.parallaxHeader.view as? AddEventHeaderView {
            //addEventHeader.eventsImage.setImage(withSDWeb: img, placeholderImage: AppImages.myprofilePlaceholder)
            addEventHeader.eventsImage.image = AppImages.icSoccer
            //addEventHeader.eventsImage.setImage(withSDWeb: self.sportDetail.eventImage, placeholderImage: AppImages.myprofilePlaceholder)//image = AppImages.icSoccer//AppImages.myprofilePlaceholder

            if sportDetail.gameDuration > 89 {
                addEventHeader.liveLbl.text = "Full Time"
                addEventHeader.liveLblContainerView.isHidden = false
            } else if sportDetail.gameDuration > 0 {
                addEventHeader.liveLblContainerView.isHidden = false
                addEventHeader.liveLbl.text = "Time: \(sportDetail.gameDuration) min"
            }

        } else if self.vcType == .cricket, cricketDetail != nil,
            //let img = detail.image,
            let addEventHeader = detailTableView.parallaxHeader.view as? AddEventHeaderView {
            addEventHeader.eventsImage.image = AppImages.icCricket
            addEventHeader.liveLblContainerView.isHidden = !(cricketDetail.match_status == "2")

        } else if self.vcType == .batminton, tennisBadmintonDetails != nil,
            //let img = detail.image,
            let addEventHeader = detailTableView.parallaxHeader.view as? AddEventHeaderView {
            addEventHeader.eventsImage.image = AppImages.icBadminton

        } else if self.vcType == .tennis, tennisBadmintonDetails != nil,
            //let img = detail.image,
            let addEventHeader = detailTableView.parallaxHeader.view as? AddEventHeaderView {
            addEventHeader.eventsImage.image = AppImages.icTennis
        }
    }

    @objc private func eventsImageTapped(_ sender: UITapGestureRecognizer) {

        if let cell = detailTableView.headerView(forSection: 0) as? TableTopCurveHeaderFooterView {

            let location = sender.location(in: cell)
            let modifiedLocation = CGPoint(x: location.x, y: -location.y)

            if cell.shareBtn.frame.contains(modifiedLocation) {
                shareBtnTapped(cell.shareBtn)
            }
            /* else if cell.frame.contains(modifiedLocation) {
             return

             } else if let imageView = sender.view as? UIImageView,
             let urlString = data?.response.result.user_detail.user_cover_pic {
             showGalleryImageViewer(for: imageView, with: urlString)
             }*/

        }
        /* else if let imageView = sender.view as? UIImageView,
         let urlString = data?.response.result.user_detail.user_cover_pic {
         showGalleryImageViewer(for: imageView, with: urlString)
         }*/
    }
    
}


//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension SportDetailVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            self.favUnFav()
        } else {
            return
        }
    }
    
}

