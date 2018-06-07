//
//  extensions.swift
//  Onboarding
//
//  Created by  on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation
import UIKit

extension UIImageView{
    
    func imageFromURl(_ url: String){
        if let url = NSURL(string: url) {
            
            DispatchQueue.global().async {
                if let data = NSData(contentsOf: url as URL) {
                    let img = UIImage(data: data as Data)
                    
                    DispatchQueue.main.async {
                        self.image = img
                    }
                }
            }
        }
    }
}


