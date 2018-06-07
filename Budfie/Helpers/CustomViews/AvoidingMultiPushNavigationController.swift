//
//  AvoidingMultiPushNavigationController.swift
//  Budfie
//
//  Created by Aakash Srivastav on 21/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class AvoidingMultiPushNavigationController: UINavigationController {

    // MARK: - Properties

    var shouldIgnorePushingViewControllers = false

    // MARK: - Push

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !shouldIgnorePushingViewControllers {
            super.pushViewController(viewController, animated: animated)
        }
        shouldIgnorePushingViewControllers = true
    }
}
