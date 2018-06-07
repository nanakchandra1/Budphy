//
//  TimeOutPopUpVc.swift
//  Budfie
//
//  Created by yogesh singh negi on 20/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

enum MoodType : Int {
    
    //1=Happy,2=Bored,3=Mad,4=Bad,5=Sad
    case happy = 1
    case bored = 2
    case mad = 3
    case sad = 4
    
    var getType : String {
        switch self {
        default:
            return String(self.rawValue)
        }
    }

    var moodText : String {
        switch self {
        case .happy:
            return "Let's celebrate!"
        case .bored:
            return "Let's add some fun!"
        case .mad:
            return "Let's calm you down!"
        case .sad:
            return "Let's cheer you up!"
        }
    }
}

class TimeOutPopUpVc: BaseVc {
    
    //MARK: Properties
    //================
    var moodListArray = [Int]()
    var moodType: MoodType?

    fileprivate var apiState: ApiState = .loading {
        didSet {
            if oldValue != apiState {
                showMoodListTableView.reloadEmptyDataSet()
            }
        }
    }

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var headerLabel      : UILabel!
    @IBOutlet weak var smileFaceImage   : UIImageView!
    @IBOutlet weak var status           : UIView!
    @IBOutlet weak var showMoodListTableView: UITableView!
    //    @IBOutlet weak var backBtnName: UIButton!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.hitMoodList()
        self.setUpInitial()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()

        //self.smileFaceImage.layer.cornerRadius = self.smileFaceImage.frame.width / 2
        //self.smileFaceImage.border(width: 3, borderColor: AppColors.whiteColor)
//    }

    //MARK: @IBAction
    //===============
    @IBAction func backBtnTapped(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.parent?.navigationController?.popViewController(animated: true)
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: extension for private methods
//===================================
extension TimeOutPopUpVc {
    
    //MARK: Initital SetUp
    //====================
    fileprivate func setUpInitial() {
        
        self.showMoodListTableView.delegate         = self
        self.showMoodListTableView.dataSource       = self
        self.showMoodListTableView.backgroundColor  = UIColor.clear
        
        //Empty Data Set
        self.showMoodListTableView.emptyDataSetSource = self
        self.showMoodListTableView.emptyDataSetDelegate = self

        if screenWidth > 323 {
            self.showMoodListTableView.bounces = false
            self.showMoodListTableView.isScrollEnabled = false
        }
        
        self.status.backgroundColor                 = AppColors.themeBlueColor
        self.navigationView.backgroundColor         = UIColor.clear
        self.headerLabel.text                       = moodType?.moodText //StringConstants.K_Lets_Try_To_Make_You_Happy.localized
        self.headerLabel.textColor                  = AppColors.blackColor
        self.headerLabel.font                       = AppFonts.AvenirNext_Regular.withSize(20)
    }
    
    //MARK: Get MoodList
    //==================
    func hitMoodList() {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Mood_Options.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["mood_type"]         = self.moodType?.getType

        apiState = .loading

        // Get MoodList
        WebServices.getMoodsList(parameters: params, loader: false, success: { (isSuccess, moodList) in
            
            self.apiState = .noData
            self.moodListArray = moodList
            self.showMoodListTableView.reloadData()
            
        }, failure: { (error) in
            self.apiState = .failed
            self.showMoodListTableView.reloadData()
            //CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    /*
     func settingEmptyDataSet(isLoading: Bool = true) {

     var placeholder = ""
     if isLoading {
     placeholder = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
     } else {
     placeholder = StringConstants.K_No_Mood_Options_Found.localized//"BUDFIE hard at work"//"No Mood Option Found"
     }

     let myAttribute = [ NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
     NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
     let myAttrString = NSAttributedString(string: placeholder, attributes: myAttribute)

     self.showMoodListTableView.emptyDataSetView { view in
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
     */
    
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension TimeOutPopUpVc : EmptyDataSetSource, EmptyDataSetDelegate {

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
            hitMoodList()
        case .noData:
            break
        case .loading:
            break
        }
    }
}
