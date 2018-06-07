//
//  CountryCodeVC+UITableView.swift
//  Budfie
//
//  Created by yogesh singh negi on 09/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK: Extension: for UITableView Delegate and DataSource
//========================================================
extension CountryCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let info = self.filteredCountryList[indexPath.row]
        cell.populateView(info: info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.filteredCountryList[indexPath.row]
        
        self.delegate.setCountryCode(country_info: info)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}


//MARK: CountryCodeCell Prototype Cell class
//==========================================
class CountryCodeCell: UITableViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryCode: UILabel!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {
        self.countryCode.textColor = AppColors.themeBlueColor
        self.countryCode.font = AppFonts.Comfortaa_Regular_0.withSize(12.5)
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView(info: JSONDictionary){
        
        guard let code = info["CountryCode"] else{return}
        guard let name = info["CountryEnglishName"] as? String else{return}
        self.countryCode.text = "\(name)(+\(code))"
        guard let img = info["CountryFlag"] as? String else{return}
        self.countryFlag.image = UIImage(named: img)
    }
    
}
