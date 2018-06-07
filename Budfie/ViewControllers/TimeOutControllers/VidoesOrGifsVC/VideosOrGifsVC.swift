//
//  VideosOrGifsVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 21/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SafariServices
import EmptyDataSet_Swift
import SDWebImage

class VideosOrGifsVC: BaseVc {
    
    //MARK: Properties
    //================
    var state: pageState = .news
    var commonList = [GifsVideosModel]()
    enum pageState {
        case news
        case clips
        case funnyJokes
        case happythoughts
        case games
        case shopping
        //News,2=Clips,3=Funny Jokes,4=Happy Thoughts,5=Games,6=Shopping
    }

    fileprivate var apiState: ApiState = .loading {
        didSet {
            if oldValue != apiState {
                showVideosGifsCollectionView.reloadEmptyDataSet()
            }
        }
    }
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navBar: CurvedNavigationView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navBackBtn: UIButton!
    @IBOutlet weak var showVideosGifsCollectionView: UICollectionView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetUp()
        self.hitCommonList()
        self.seUpPullToRefresh()
    }
    
    //MARK: IBAction
    //==============
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        self.hitCommonList()
        refreshControl.endRefreshing()
    }
}

//MARK:- Extension for Private methods
//====================================
extension VideosOrGifsVC {
    
    //MARK: initial setup
    //===================
    fileprivate func initialSetUp() {
        
        self.showVideosGifsCollectionView.delegate = self
        self.showVideosGifsCollectionView.dataSource = self
        
        //Empty Data Set
        self.showVideosGifsCollectionView.emptyDataSetSource = self
        self.showVideosGifsCollectionView.emptyDataSetDelegate = self

        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navBar.backgroundColor = UIColor.clear
        self.navTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.navTitle.textColor = AppColors.whiteColor
        self.navTitle.text = "Clips"
//        self.setTitle()
    }
    
    //MARK: set title
    //===============
    fileprivate func setTitle() {
        /*
        if self.state == .gif {
            self.navTitle.text = StringConstants.K_Videos.localized
        } else if self.state == .gifs {
            self.navTitle.text = StringConstants.K_Gifs.localized
        } else if self.state == .movies {
            self.navTitle.text = StringConstants.Movies.localized
        }
        */
    }
    
    func seUpPullToRefresh() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self,
                                 action: #selector(self.refresh(refreshControl:)),
                                 for: UIControlEvents.valueChanged)
        self.showVideosGifsCollectionView.addSubview(refreshControl)
    }
    
    //MARK: make params
    //=================
    func makeParam(page: Int = 1) -> JSONDictionary {
        
        var params = JSONDictionary()
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = page
        params["method"]            = StringConstants.K_Clips_List.localized
        
        /*
        switch self.state {
        case .gifs:
            params["method"]        = StringConstants.K_Gif_List.localized
            params["category"]      = "1"
        case .videos:
            params["method"]        = StringConstants.K_Videos_List.localized
        default:
            params["method"]        = StringConstants.K_Movie_List.localized
        }
 */
        return params
    }
    
    //MARK: Get Common List
    //=====================
    func hitCommonList(page: Int = 1) {
        
        var params = JSONDictionary()
        params = self.makeParam(page: page)
        apiState = .loading

        WebServices.getGifsVideosList(parameters: params, loader: false, success: { [weak self] (isSuccess, commonList) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.settingEmptyDataSet(isLoading: false)
            strongSelf.commonList = commonList
            strongSelf.apiState = .noData
            strongSelf.showVideosGifsCollectionView.reloadData()
            
            }, failure: { [weak self] (error) in

                guard let strongSelf = self else {
                    return
                }
                strongSelf.apiState = .failed
                //CommonClass.showToast(msg: error.localizedDescription)
        })

        /*
        // Get Common List
        switch self.state {
        case .gifs:
            WebServices.getGifsList(parameters: params, loader: false, success: { [weak self] (isSuccess, commonList) in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.settingEmptyDataSet(isLoading: false)
                strongSelf.commonList = commonList
                strongSelf.showVideosGifsCollectionView.reloadData()

            }, failure: { (error) in
                CommonClass.showToast(msg: error.localizedDescription)
            })

        case .videos:
            WebServices.getVideosList(parameters: params, loader: false, success: { [weak self] (isSuccess, commonList) in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.settingEmptyDataSet(isLoading: false)
                strongSelf.commonList = commonList
                strongSelf.showVideosGifsCollectionView.reloadData()

            }, failure: { (error) in
                CommonClass.showToast(msg: error.localizedDescription)
            })

        case .movies:
            WebServices.getTimeOutMovies(parameters: params, loader: false, success: { [weak self] (isSuccess, commonList) in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.settingEmptyDataSet(isLoading: false)
                strongSelf.commonList = commonList
                strongSelf.showVideosGifsCollectionView.reloadData()

            }, failure: { (error) in
                CommonClass.showToast(msg: error.localizedDescription)
            })
 
        }
 */
    }
    
    func openLinks(link: String) {
        
        if #available(iOS 9.0, *) {
            let safariVC  = SFSafariViewController(url: URL(string: link)!)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(URL(string: link)!)
        }
    }
    /*
    func moviesMoodSelected(indexPath: IndexPath) {
        
        let model = self.commonList[indexPath.row]
        
        var eventJSON: JSONDictionary = JSONDictionary()
        eventJSON["event_id"] = model.movieId
        eventJSON["event_category"] = "1"
        
        let moviesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
        moviesScene.moviesOrConcert = .movies
        moviesScene.isTimeOut = true
        moviesScene.obEventModel = EventModel(initForEventModel: eventJSON)
        self.navigationController?.pushViewController(moviesScene, animated: true)
    }
     */
    
    func videosMoodSelected(indexPath: IndexPath) {
        
        let model = self.commonList[indexPath.row]
        
        let trailerPlayerScene = TrailersPlayerVC.instantiate(fromAppStoryboard: .Events)
        trailerPlayerScene.url = model.url
        present(trailerPlayerScene, animated: false, completion: nil)
        //            self.openLinks(link: model.url)
        //        CommonClass.showToast(msg: "Under Development")
    }
    
    func gifsMoodSelected(indexPath: IndexPath) {
        
        let previewScene = GifPreviewVC.instantiate(fromAppStoryboard: .TimeOut)
        previewScene.gifName = self.commonList[indexPath.row].thumbnail
        previewScene.gifURL = self.commonList[indexPath.row].url
        self.navigationController?.pushViewController(previewScene, animated: true)
    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        
        var placeholder = ""
        if isLoading {
            placeholder = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else {
            placeholder = StringConstants.K_No_Videos_Gifs_Found.localized//"BUDFIE hard at work"//"No Videos Or Gifs Found"
        }
        
        let myAttribute = [ NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                            NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: placeholder, attributes: myAttribute)
        
        self.showVideosGifsCollectionView.emptyDataSetView { view in
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
    
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension VideosOrGifsVC : EmptyDataSetSource, EmptyDataSetDelegate {

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
            hitCommonList()
        case .noData:
            break
        case .loading:
            break
        }
    }
}
