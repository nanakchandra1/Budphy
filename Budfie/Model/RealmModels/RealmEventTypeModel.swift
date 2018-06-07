//
//  RealmEventType.swift
//  Budfie
//
//  Created by Aakash Srivastav on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class RealmEventType: Object {

    @objc dynamic var id = ""
    @objc dynamic var name = ""

    var appEventType: EventTypesModel {
        let typeDict: JSONDictionary    = ["id": id, "event_type": name]
        let typeJSON                    = JSON(typeDict)
        let type                        = EventTypesModel(initForEventType: typeJSON)
        return type
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
