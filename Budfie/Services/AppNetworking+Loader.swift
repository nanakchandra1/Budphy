//
//  AppNetworking+Loader.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

//import KVNProgress
//import SDWebImage
import UIKit

extension AppNetworking  {
    
    static func showLoader() {
        DispatchQueue.main.async {
            print_debug("\(#function) on \(Date())")
            GiFHUD.showWithOverlay()
        }
    }
    
    static func hideLoader() {
        DispatchQueue.main.async {
            print_debug("\(#function) on \(Date())")
            GiFHUD.dismiss()
        }
    }
    
}
