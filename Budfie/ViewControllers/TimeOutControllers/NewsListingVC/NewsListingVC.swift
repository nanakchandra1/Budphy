//
//  NewsListingVC.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import EmptyDataSet_Swift

class NewsListingVC: BaseVc {
    
    //MARK: Properties
    //================
    var obNewsList = [NewsListModel]()
    var state: pageState = .news

    enum pageState {
        case news
        case jokes
    }

    fileprivate var apiState: ApiState = .loading {
        didSet {
            if oldValue != apiState {
                newsListScrollView.reloadEmptyDataSet()
            }
        }
    }
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var newsListScrollView: UIScrollView!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navBar: CurvedNavigationView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navBackBtn: UIButton!
    @IBOutlet weak var newsBackView1: UIView!
    @IBOutlet weak var newsBackView2: UIView!
    @IBOutlet weak var newsBackView3: UIView!
    @IBOutlet weak var newsBackView4: UIView!
    @IBOutlet weak var newsBackView5: UIView!
    @IBOutlet weak var newsBackView6: UIView!
    @IBOutlet weak var newsBackView7: UIView!
    @IBOutlet weak var newsBackView8: UIView!
    @IBOutlet weak var newsBackView9: UIView!
    @IBOutlet weak var newsBackView10: UIView!
    @IBOutlet weak var shortNewsLabel1: UILabel!
    @IBOutlet weak var shortNewsLabel2: UILabel!
    @IBOutlet weak var shortNewsLabel3: UILabel!
    @IBOutlet weak var shortNewsLabel4: UILabel!
    @IBOutlet weak var shortNewsLabel5: UILabel!
    @IBOutlet weak var shortNewsLabel6: UILabel!
    @IBOutlet weak var shortNewsLabel7: UILabel!
    @IBOutlet weak var shortNewsLabel8: UILabel!
    @IBOutlet weak var shortNewsLabel9: UILabel!
    @IBOutlet weak var shortNewsLabel10: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hitNewsList()
        self.initialSetUp()
    }
    
    //MARK: @IBAction
    //===============
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newsBtn1(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 0)
    }
    
    @IBAction func newsBtn2(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 1)
    }
    
    @IBAction func newsBtn3(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 2)
    }
    
    @IBAction func newsBtn4(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 3)
    }
    
    @IBAction func newsBtn5(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 4)
    }
    
    @IBAction func newsBtn6(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 5)
    }
    
    @IBAction func newsBtn7(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 6)
    }
    
    @IBAction func newsBtn8(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 7)
    }
    
    @IBAction func newsBtn9(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 8)
    }
    
    @IBAction func newsBtn10(_ sender: UIButton) {
        self.showDetailedNew(pageNumber: 9)
    }
    
}


//MARK:- Extension for Private methods
//====================================
extension NewsListingVC {
    
    fileprivate func initialSetUp() {

        newsListScrollView.emptyDataSetSource = self
        newsListScrollView.emptyDataSetDelegate = self

        self.newsListScrollView.isHidden = true
        self.statusBar.backgroundColor  = AppColors.themeBlueColor
        self.navBar.backgroundColor     = UIColor.clear
        self.navTitle.font              = AppFonts.AvenirNext_Medium.withSize(20)
        self.navTitle.textColor         = AppColors.whiteColor
    }
    
    //MARK: Get News List
    //===================
    func hitNewsList() {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Top_News.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        apiState = .loading
        
        // Get News List
        WebServices.getNewsList(parameters: params, success: { (isSuccess, obNewsList) in
            
            if isSuccess {
                self.apiState = .noData
                self.obNewsList = obNewsList
                self.populateNews()
                self.newsListScrollView.isHidden = false
            }
            
        }, failure: { (error) in
            self.apiState = .failed
            //CommonClass.showToast(msg: error.localizedDescription)
            //self.navigationController?.popViewController(animated: true)
        })
    }
    
    func populateNews() {
        
        self.shortNewsLabel1.text = self.obNewsList[0].title
        self.shortNewsLabel2.text = self.obNewsList[1].title
        self.shortNewsLabel3.text = self.obNewsList[2].title
        self.shortNewsLabel4.text = self.obNewsList[3].title
        self.shortNewsLabel5.text = self.obNewsList[4].title
        self.shortNewsLabel6.text = self.obNewsList[5].title
        self.shortNewsLabel7.text = self.obNewsList[6].title
        self.shortNewsLabel8.text = self.obNewsList[7].title
        self.shortNewsLabel9.text = self.obNewsList[8].title
        self.shortNewsLabel10.text = self.obNewsList[9].title
    }
    
    func showDetailedNew(pageNumber: Int) {
        
        if self.obNewsList.isEmpty {
            return
        }
        let scene = NewsDetailedVC.instantiate(fromAppStoryboard: .TimeOut)
        scene.obNewsList = self.obNewsList
        scene.pageNumber = pageNumber
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension NewsListingVC : EmptyDataSetSource, EmptyDataSetDelegate {

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

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        switch apiState {
        case .failed:
            return true
        case .noData:
            return false
        case .loading:
            return true
        }
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        switch apiState {
        case .failed:
            hitNewsList()
        case .noData:
            break
        case .loading:
            break
        }
    }
}

