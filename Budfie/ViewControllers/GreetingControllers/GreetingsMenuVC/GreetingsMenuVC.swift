//
//  GreetingsMenuVC.swift
//  Budfie
//
//  Created by appinventiv on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import EmptyDataSet_Swift

//MARK: GreetingsMenuVC class
//===========================
class GreetingsMenuVC: BaseVc {
    
    //MARK: Public Properties
    //=======================
    var flowType: FlowType = .home
    var greetingType: GreetingType = .animation
    var vcState: VCState = .create
    var greetingCardsList = [NewsListModel]()
    var eventId = String()
    var eventDate = String()
    var tablePlaceholderText = String()
    var snappedImage: UIImage?
    
    //MARK: Private Properties
    //========================
//    var images: [String] = []
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navBar: CurvedNavigationView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navBackBtn: UIButton!
    @IBOutlet weak var greetingsCollectionView: UICollectionView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hitGreetingCardList()
//        flowType = .eventDate
        self.initialSetUp()
        self.seUpPullToRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        snappedImage = nil
    }
    
    //MARK: IBAction
    //==============
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if flowType == .home {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        
        self.hitGreetingCardList()
        refreshControl.endRefreshing()
    }
    
}

//MARK:- Extension for Private methods
//====================================
extension GreetingsMenuVC {
    
    fileprivate func initialSetUp() {

        self.greetingsCollectionView.delegate = self
        self.greetingsCollectionView.dataSource = self
        
        //Empty Data Set
        self.greetingsCollectionView.emptyDataSetSource = self
        self.greetingsCollectionView.emptyDataSetDelegate = self
        self.settingEmptyDataSet()
        
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navBar.backgroundColor = UIColor.clear
        self.navTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.navTitle.textColor = AppColors.whiteColor
        
        switch self.greetingType {
        case .animation:
//            images = animationImages
            self.navTitle.text = "Animated"
        case .faceInHole, .normalImage:
//            images = faceHoleImages
            self.navTitle.text = "Face in a hole"
        case .popUp3D:
//            images = popUp3DImages
            self.navTitle.text = "Classic"
        case .classicFunny:
//            images = funnyImages
            self.navTitle.text = "Fun"
        }
//        self.setImages()
    }
    
    func seUpPullToRefresh() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self,
                                 action: #selector(self.refresh(refreshControl:)),
                                 for: UIControlEvents.valueChanged)
        self.greetingsCollectionView.addSubview(refreshControl)
    }
    
    /*
    fileprivate func setImages() {
        
        let amazonBucketUrl = "https://s3.amazonaws.com/appinventiv-development/budfie/greetings/"
        
        let animationImages = [
            "\(amazonBucketUrl)animated/Confidential_Giff.gif",
            "\(amazonBucketUrl)animated/miss_you_Giff.gif",
            "\(amazonBucketUrl)animated/Thank_you_Giff.gif"
        ]

        let funnyImages = [
            "\(amazonBucketUrl)funny/1_undernewmanagement.png",
            "\(amazonBucketUrl)funny/2_gameover.png",
            "\(amazonBucketUrl)funny/3_meow.png",
            "\(amazonBucketUrl)funny/4_sorry.png",
            "\(amazonBucketUrl)funny/5_happybirthday.png",
            "\(amazonBucketUrl)funny/6_sorry+for+being+such+as+ass.png",
            "\(amazonBucketUrl)funny/7_you+are+hot.png",
            "\(amazonBucketUrl)funny/8_soul+mates.png",
            "\(amazonBucketUrl)funny/9_babyshower.png",
            "\(amazonBucketUrl)funny/10_happybirthday+2.png",
            "\(amazonBucketUrl)funny/11_Party+time.png",
            "\(amazonBucketUrl)funny/12_happy+Anniversary.png",
            "\(amazonBucketUrl)funny/13_friday.png",
            "\(amazonBucketUrl)funny/14_party+time2.png"
        ]
        
        let faceHoleImages = [
            "\(amazonBucketUrl)face/4.5.1_jamsebond.png",
            "\(amazonBucketUrl)face/4.5.2_monkey.png",
            "\(amazonBucketUrl)face/4.5.3_bikinigirl.png",
            "\(amazonBucketUrl)face/4.5.4_car.png",
            "\(amazonBucketUrl)face/4.5.5_santa.girls.png",
            "\(amazonBucketUrl)face/4.5.6_wonderwomen.png",
            "\(amazonBucketUrl)face/4.5.7_body+man.png",
            "\(amazonBucketUrl)face/4.5.8_bahubali.png",
            "\(amazonBucketUrl)face/4.5.9_superhero.png"
        ]
        
        let popUp3DImages = [
            "\(amazonBucketUrl)popup/5.1_fan.png",
            "\(amazonBucketUrl)popup/5.2_myheart.png",
            "\(amazonBucketUrl)popup/5.3_flyheart.png",
            "\(amazonBucketUrl)popup/5.4_Thanks+a+Million+.png",
            "\(amazonBucketUrl)popup/5.5_missyou.png",
            "\(amazonBucketUrl)popup/5.6_getwellsoon.png",
            "\(amazonBucketUrl)popup/5.7_happy+birthday.png",
            "\(amazonBucketUrl)popup/5.8_keep+smiling.png",
            "\(amazonBucketUrl)popup/5.9_sending+love.png",
            "\(amazonBucketUrl)popup/5.10_sending+love.png",
            "\(amazonBucketUrl)popup/5.11_getwell+soon.png",
            "\(amazonBucketUrl)popup/5.12_Birthday.png",
            "\(amazonBucketUrl)popup/5.13_Thankyou.png"
        ]
        
 
    }
    */
    
    //MARK:- hitGreetingCardList method
    //=================================
    func hitGreetingCardList() {
        
        var params = JSONDictionary()
        
        params["method"]        = "cards"
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        
        switch self.greetingType {
        case .animation:
            params["type"] = "1"
        case .faceInHole, .normalImage:
            params["type"] = "4"
        case .popUp3D:
            params["type"] = "2"
        case .classicFunny:
            params["type"] = "3"
        }
        
        //TYPE (1=Animated,2=Popup,3=Funny,4=Face in a hole)
        
        WebServices.getGreetingCardList(parameters: params, loader: false, success: { [weak self] (isSuccess, model) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.greetingCardsList = model
//            strongSelf.settingEmptyDataSet(isLoading: false)
            strongSelf.greetingsCollectionView.reloadData()
            
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        if isLoading {
            tablePlaceholderText = "Loading all your favorites"//"Loading..."
        } else {
            tablePlaceholderText = "No Cards Found"//"BUDFIE hard at work"//
        }
        //showGreetingsTableView.reloadEmptyDataSet()
    }
    
}


//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension GreetingsMenuVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let myAttribute = [NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                           NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: tablePlaceholderText, attributes: myAttribute)
        return myAttrString
    }
}

