//
//  GreetingRectModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Realm
import RealmSwift

class GreetingRect: Object {

    @objc dynamic var x = 0.0
    @objc dynamic var y = 0.0
    @objc dynamic var width = 0.0
    @objc dynamic var height = 0.0

    var origin: CGPoint {
        return CGPoint(x: x, y: y)
    }

    var size: CGSize {
        return CGSize(width: width, height: height)
    }

    var rect: CGRect {
        return CGRect(origin: origin, size: size)
    }
}
