//
//  JokesThoughtsDummyVC.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 20/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import EmptyDataSet_Swift

class JokesThoughtsDummyVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var vcState: VCState = .jokes
    var jokesThoughtsList = [String]()
    fileprivate var tablePlaceholderText = ""
    
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
    @IBOutlet weak var showJokesThoughtsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.vcState == .jokes {
            self.hitJokesList()
        } else {
            self.hitThoughtsList()
        }
        
        self.initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension JokesThoughtsDummyVC {
    
    func initialSetup() {
        
        self.showJokesThoughtsTableView.delegate = self
        self.showJokesThoughtsTableView.dataSource = self
        self.showJokesThoughtsTableView.backgroundColor = UIColor.clear
        
        //Empty Data Set
        self.showJokesThoughtsTableView.emptyDataSetSource = self
        self.showJokesThoughtsTableView.emptyDataSetDelegate = self
        self.settingEmptyDataSet()
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        if vcState == .jokes {
            self.navigationTitle.text = "Jokes"
        } else {
            self.navigationTitle.text = "Happy Thoughts"
        }
    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        if isLoading {
            tablePlaceholderText = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else {
            tablePlaceholderText = StringConstants.K_No_Greetings_Found.localized//"BUDFIE hard at work"//
        }
        //showGreetingsTableView.reloadEmptyDataSet()
    }
    
    //MARK: Get Jokes List
    //====================
    func hitJokesList(pages: Int = 1) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Jokes_List.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = pages
        
        // Get Jokes List
        WebServices.getJokesList(parameters: params, success: { (isSuccess, jokesThoughtsList) in
            
            if isSuccess {
                self.jokesThoughtsList = jokesThoughtsList
                self.showJokesThoughtsTableView.reloadData()
            }
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK: Get Thought List
    //======================
    func hitThoughtsList(pages: Int = 1) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Thoughts_List.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = pages

        // Get Thought List
        WebServices.getThoughtsList(parameters: params, success: { (isSuccess, jokesThoughtsList) in
            
            if isSuccess {
                self.jokesThoughtsList = jokesThoughtsList
                self.showJokesThoughtsTableView.reloadData()
            }
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}


//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension JokesThoughtsDummyVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let myAttribute = [NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                           NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: tablePlaceholderText, attributes: myAttribute)
        
        return myAttrString
    }
}
