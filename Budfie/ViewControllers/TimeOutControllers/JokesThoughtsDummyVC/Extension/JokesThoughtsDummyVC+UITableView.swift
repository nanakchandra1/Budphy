//
//  JokesThoughtsDummyVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension JokesThoughtsDummyVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokesThoughtsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JokesThoughtsDummyCell") as? JokesThoughtsDummyCell else {
            fatalError("JokesThoughtsDummyCell not found")
        }
        
        cell.dataLabel.text = self.jokesThoughtsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


class JokesThoughtsDummyCell : UITableViewCell {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dataLabel.textColor = AppColors.blackColor
        self.dataLabel.font = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.contentView.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.roundView.roundCornerWith(radius: 5.0)
        self.roundView.dropShadow(width: 1.5, shadow: AppColors.textFieldBaseLine)
    }
    
}
