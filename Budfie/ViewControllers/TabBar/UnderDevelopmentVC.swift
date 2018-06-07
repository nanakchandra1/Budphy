//
//  UnderDevelopmentVC.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 11/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class UnderDevelopmentVC: BaseVc {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
