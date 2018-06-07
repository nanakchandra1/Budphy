//
//  GreetingColorModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift

class GreetingColor: Object {

    @objc dynamic var red = 0.0
    @objc dynamic var blue = 0.0
    @objc dynamic var green = 0.0

    var hex: String {
        let rgb = ((Int(red) * 255) << 16) | ((Int(green) * 255) << 8) | ((Int(blue) * 255) << 0)
        return String(format:"#%06x", rgb)
    }
}
