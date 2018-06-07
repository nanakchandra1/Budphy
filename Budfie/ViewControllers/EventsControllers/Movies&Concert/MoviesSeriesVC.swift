//
//  MoviesSeriesVC.swift
//  Budfie
//
//  Created by appinventiv on 03/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import ParallaxHeader
import SafariServices
import RealmSwift

enum MoviesConcert {
    case movies
    case concert
    case sports
    case none
}

protocol HitMoviesOrConcertAPI : class {
    func hitMoviesOrConcert(eventState: MoviesConcert)
}

class MoviesSeriesVC: BaseVc {
    
    var obEventModel        : EventModel!
    var eventDetailsModel   : EditEventDetailsModel?
    var moviesOrConcert     : MoviesConcert = .movies
    weak var delegate       : HitMoviesOrConcertAPI?
    var headerView          : AddEventHeaderView!
    var isTimeOut           = false

    @IBOutlet weak var showMoviesDetailsTable: UITableView!

    @IBOutlet weak var navBackgroundView: UIView!
    @IBOutlet weak var favUnFavBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hitEventDetails(eventId: self.obEventModel.eventId,
                             eventCategory: self.obEventModel.eventCategory, hitMore: false)
        self.initialSetUp()
        self.registerNibs()

        if #available(iOS 11.0, *) {
//            showMoviesDetailsTable.contentInsetAdjustmentBehavior = .never
//            showMoviesDetailsTable.insetsContentViewsToSafeArea = false
//            showMoviesDetailsTable.insetsLayoutMarginsFromSafeArea = false
            showMoviesDetailsTable.contentInset = UIEdgeInsetsMake(-view.safeAreaInsets.top, 0, 0, 0)
        }

        if let headerView = showMoviesDetailsTable.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView {

            self.headerView = headerView
            setupHeaderView()
            headerView.setForMoviesOrConcert()
            self.headerView.centerMovieBtn.addTarget(self,
                                                     action: #selector(self.playMovie(_:)),
                                                     for: .touchUpInside)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsImageTapped))
            tapGesture.cancelsTouchesInView = false
            headerView.eventsImage.addGestureRecognizer(tapGesture)

            /*
            headerView.eventsImage.curvHeaderView(height: 250)
            headerView.overlayView.curvHeaderView(height: 250)

            headerView.submitImageBtn.addTarget(self,
            action: #selector(self.shareBtnTapped(_:)),
            for: .touchUpInside)
            headerView.sideCameraBtn.addTarget(self,
            action: #selector(self.unFavBtnTapped(_:)),
            for: .touchUpInside)
            headerView.backBtn.addTarget(self,
            action: #selector(self.backBtnTapped(_:)),
            for: .touchUpInside)
            */

            let headerHeight: CGFloat = 250
            let navViewHeight: CGFloat = 44

            showMoviesDetailsTable.parallaxHeader.view = headerView
            showMoviesDetailsTable.parallaxHeader.height = headerHeight
            showMoviesDetailsTable.parallaxHeader.minimumHeight = navViewHeight
            showMoviesDetailsTable.parallaxHeader.mode = .centerFill
            navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(0)

            showMoviesDetailsTable.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in

                let progress = parallaxHeader.progress

                let alpaComponent = max(0, min(1, ((1 - (progress)) / 0.95)))
                self.navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(alpaComponent)
                //headerView.overlayView.setNeedsDisplay()
                //self.updateHeaderConstraint()
            }
        }
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if !isTimeOut {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ticketLinkBtnTapped(_ sender: UIButton) {

        /*
        if let urlString = eventDetailsModel?.eventVideo {
            let trailerPlayerScene = TrailersPlayerVC.instantiate(fromAppStoryboard: .Events)
            trailerPlayerScene.url = urlString
            present(trailerPlayerScene, animated: false, completion: nil)
        }
        */
        var url = String()
        if let movieUrl = self.eventDetailsModel?.purchase_url, !movieUrl.isEmpty {
            url = movieUrl
        } else if let movieUrl = self.eventDetailsModel?.url, !movieUrl.isEmpty {
            url = movieUrl
        }
        if let url = URL(string: url) {

            if #available(iOS 9.0, *) {

                let safariVC  = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:- shareBtnTapped Button
    //============================
    @objc private func eventsImageTapped(_ sender: UITapGestureRecognizer) {

        if let cell = showMoviesDetailsTable.headerView(forSection: 0) as? TableTopCurveHeaderFooterView {

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
    
    @objc func shareBtnTapped(_ sender: UIButton) {
        // CommonClass.showToast(msg: "Under Development")
        if let shareURL = self.eventDetailsModel?.share_url {
            CommonClass.externalShare(textURL: shareURL, viewController: self)
        }
    }
    
    @IBAction func unFavBtnTapped(_ sender: UIButton) {
        
        if favUnFavBtn.isSelected == true {
            let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
            controller.pageState = .favUnFav
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            present(controller, animated: false, completion: nil)
        } else {
            self.favUnFav()
        }
    }

    func setupHeaderView() {
        
        if let image = self.eventDetailsModel?.eventImage {
            headerView.eventsImage.setImage(withSDWeb: image,
                                            placeholderImage: AppImages.myprofilePlaceholder)
        }

        if self.moviesOrConcert == .movies {
            titleLabel.text = "Movies"
        } else {
            titleLabel.text = "Events"
            headerView.centerMovieBtn.isHidden = true
        }
        if let fav = self.eventDetailsModel?.isFavourite, fav == "0" {
            favUnFavBtn.isSelected = false
            favUnFavBtn.setImage(AppImages.icUnselectFav, for: .normal)
        } else {
            favUnFavBtn.isSelected = true
            favUnFavBtn.setImage(AppImages.icSelectFav, for: .normal)
        }
    }
}

//MARK: Extension for InitialSetup and private methods
//====================================================
extension MoviesSeriesVC {
    
    func initialSetUp() {
        self.showMoviesDetailsTable.delegate = self
        self.showMoviesDetailsTable.dataSource = self
        self.showMoviesDetailsTable.backgroundColor = AppColors.whiteColor
    }
    
    //MARK:- Nib Register method
    //==========================
    fileprivate func registerNibs() {

        let tableTopCurveNib = UINib(nibName: "TableTopCurveHeaderFooterView", bundle: nil)
        self.showMoviesDetailsTable.register(tableTopCurveNib, forHeaderFooterViewReuseIdentifier: "TableTopCurveHeaderFooterView")
        
        let addEventHeaderView = UINib(nibName: "AddEventHeaderView", bundle: nil)
        self.showMoviesDetailsTable.register(addEventHeaderView, forHeaderFooterViewReuseIdentifier: "AddEventHeaderViewId")
    }
    
    //MARK:- hitEventDetails method
    //=============================
    func hitEventDetails(eventId: String, eventCategory: String, hitMore: Bool) {
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Event_Details.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = eventId
        params["event_category"]    = eventCategory
        
        WebServices.getEventDetails(parameters: params, success: { (obEventModel) in
            
            self.eventDetailsModel = obEventModel
            self.setupHeaderView()
            self.showMoviesDetailsTable.reloadData()
            
        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
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
            
            self.delegate?.hitMoviesOrConcert(eventState: self.moviesOrConcert)
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    func favUnFav() {
        
        var movieOrConcert = "0"
        var action = "0"
        if let model = self.eventDetailsModel {
            if model.isFavourite == "0" {
                action = "1"
                self.eventDetailsModel?.isFavourite = "1"
            } else {
                action = "2"
                self.eventDetailsModel?.isFavourite = "0"
            }
            if self.moviesOrConcert == .movies {
                movieOrConcert = "1"
            } else if self.moviesOrConcert == .concert {
                movieOrConcert = "2"
            }
            //        else if self.moviesOrConcert == .sport {
            //            movieOrConcert = "3"
            //        }
            if favUnFavBtn.isSelected == true {
                favUnFavBtn.isSelected = false
                favUnFavBtn.setImage(AppImages.icUnselectFav, for: UIControlState.normal)
            } else {
                favUnFavBtn.isSelected = true
                favUnFavBtn.setImage(AppImages.icSelectFav, for: UIControlState.normal)
            }
            self.hitFavourite(action: action, type: movieOrConcert, event: self.obEventModel)
            //            self.showMoviesDetailsTable.reloadData()
        }
    }
    
}

//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension MoviesSeriesVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            self.favUnFav()
        } else {
            return
        }
    }
    
}
