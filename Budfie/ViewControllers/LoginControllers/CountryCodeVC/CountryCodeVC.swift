//
//  CountryCodeVC.swift
//  Onboarding
//
//  Edited by yogesh singh negi on 02/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK:- Get Selected Country Code
//================================
protocol SetContryCodeDelegate : class {
    func setCountryCode(country_info: JSONDictionary)
}

//MARK:- CountryCodeVC Class
//==========================
class CountryCodeVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var countryInfo         = JSONDictionaryArray()
    var filteredCountryList = JSONDictionaryArray()
    weak var delegate       : SetContryCodeDelegate!
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView       : UIView!
    @IBOutlet weak var backBtn              : UIButton!
    @IBOutlet weak var navigationTitle      : UILabel!
    @IBOutlet weak var countryCodeTableView : UITableView!
    @IBOutlet weak var searchBar            : UITextField!
    @IBOutlet weak var searchBarView        : UIView!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = StringConstants.Select_Country.localized
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backbtnTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchEditingChanged(_ sender: UITextField) {
        
        let filter = self.countryInfo.filter({ ($0["CountryEnglishName"] as? String ?? "").localizedCaseInsensitiveContains(sender.text!)
        })
        self.filteredCountryList = filter
        
        if sender.text == ""{
            self.filteredCountryList = self.countryInfo
        }
        self.countryCodeTableView.reloadData()
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension CountryCodeVC {
    
    private func initialSetup(){
        
        self.countryCodeTableView.delegate = self
        self.countryCodeTableView.dataSource = self
        
        self.readJson()
        
        self.navigationView.backgroundColor = AppColors.themeBlueColor
        self.navigationView.curvView()// For curve shape view..
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.Country_Code.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.searchBarView.roundCornerWith(radius: 17.5)
        self.searchBarView.backgroundColor = AppColors.imageBackView
        
        self.searchBar.font = AppFonts.Comfortaa_Light_0.withSize(14)
        self.searchBar.placeholder = StringConstants.Search_Country.localized
        self.searchBar.textColor = AppColors.blackColor
        self.searchBar.backgroundColor = UIColor.clear
    }
    
    private func readJson() {
        
        let file = Bundle.main.path(forResource: "countryData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        
        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionaryArray
        
        self.countryInfo = jsonData!
        self.filteredCountryList = jsonData!
        self.countryCodeTableView.reloadData()
    }
    
}

