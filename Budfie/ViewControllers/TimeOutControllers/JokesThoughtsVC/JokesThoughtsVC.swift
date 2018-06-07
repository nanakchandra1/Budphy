//
//  JokesThoughtsVC.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 20/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import EmptyDataSet_Swift
import CHTCollectionViewWaterfallLayout

class JokesThoughtsVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var vcState: VCState = .jokes
    var jokesThoughtsList = [String]()
    let thoughtsImages = [ AppImages.icHappyThoughtsCard1,
                           AppImages.icHappyThoughtsCard2,
                           AppImages.icHappyThoughtsCard3,
                           AppImages.icHappyThoughtsCard4 ]
    let jokesImages = [ AppImages.icFunnyJokesCard1,
                        AppImages.icFunnyJokesCard2,
                        AppImages.icFunnyJokesCard3,
                        AppImages.icFunnyJokesCard4 ]

    fileprivate var apiState: ApiState = .loading {
        didSet {
            if oldValue != apiState {
                JokesThoughtsCollectionView.reloadEmptyDataSet()
            }
        }
    }
    
    enum VCState {
        case jokes
        case thoughts
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var JokesThoughtsCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.vcState == .jokes {
            self.hitJokesList()
        } else {
            self.hitThoughtsList()
        }
        
        self.initialSetup()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension JokesThoughtsVC {
    
    func initialSetup() {
        
        self.JokesThoughtsCollectionView.delegate = self
        self.JokesThoughtsCollectionView.dataSource = self
        self.JokesThoughtsCollectionView.contentInset.top = 35
        self.JokesThoughtsCollectionView.backgroundColor = UIColor.clear
        self.setupCollectionView()
        
        //Empty Data Set
        self.JokesThoughtsCollectionView.emptyDataSetSource = self
        self.JokesThoughtsCollectionView.emptyDataSetDelegate = self

        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        if vcState == .jokes {
            self.navigationTitle.text = "Jokes"
//            self.backgroundImage.image = #imageLiteral(resourceName: "jokes_bg")
        } else {
            self.navigationTitle.text = "Happy Thoughts"
//            self.backgroundImage.image = #imageLiteral(resourceName: "thoughts_bg")
        }
    }
    
    //MARK: - CollectionView UI Setup
    func setupCollectionView() {
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // Collection view attributes
        self.JokesThoughtsCollectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.JokesThoughtsCollectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.JokesThoughtsCollectionView.collectionViewLayout = layout
    }

    /*
     func settingEmptyDataSet(isLoading: Bool = true) {
     if isLoading {
     tablePlaceholderText = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
     } else {
     tablePlaceholderText = StringConstants.K_No_Greetings_Found.localized//"BUDFIE hard at work"//
     }
     //showGreetingsTableView.reloadEmptyDataSet()
     }
     */
    
    //MARK: Get Jokes List
    //====================
    func hitJokesList(pages: Int = 1) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Jokes_List.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = pages
        apiState = .loading

        // Get Jokes List
        WebServices.getJokesList(parameters: params, success: { (isSuccess, jokesThoughtsList) in
            
            if isSuccess {
                self.jokesThoughtsList = jokesThoughtsList
                self.apiState = .noData
                self.JokesThoughtsCollectionView.reloadData()
            }
            
        }, failure: { (error) in
            self.apiState = .failed
            //CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK: Get Thought List
    //======================
    func hitThoughtsList(pages: Int = 1) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Thoughts_List.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = pages
        apiState = .loading

        // Get Thought List
        WebServices.getThoughtsList(parameters: params, success: { (isSuccess, jokesThoughtsList) in
            
            if isSuccess {
                self.jokesThoughtsList = jokesThoughtsList
                self.apiState = .noData
                self.JokesThoughtsCollectionView.reloadData()
            }
            
        }, failure: { (error) in
            self.apiState = .failed
            //CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension JokesThoughtsVC : EmptyDataSetSource, EmptyDataSetDelegate {

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
            if self.vcState == .jokes {
                self.hitJokesList()
            } else {
                self.hitThoughtsList()
            }
        case .noData:
            break
        case .loading:
            break
        }
    }
}
