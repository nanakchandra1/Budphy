//
//  GreetingModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift

class Greeting: Object {

    @objc dynamic var id: String?
    @objc dynamic var greetingType = 0

    @objc dynamic var faceHoleImageUrl: String?
    @objc dynamic var musicUrl: String?
    @objc dynamic var isDraft = false
    @objc dynamic var dateString: String?
    
    @objc dynamic var faceInHoleImageData: Data?
    @objc dynamic var faceInHoleImageUrl: String?

    @objc dynamic var greetingTitle: String?
    @objc dynamic var greetingDescription: String?

    @objc dynamic var descriptionViewX = 0.0
    @objc dynamic var descriptionViewY = 0.0
    @objc dynamic var descriptionViewRotation = 0.0
    @objc dynamic var descriptionViewScale = 0.0
    @objc dynamic var descriptionViewBounds: GreetingRect?

    //@objc dynamic var faceImageData: Data?
    @objc dynamic var faceImageX = 0.0
    @objc dynamic var faceImageY = 0.0
    @objc dynamic var faceImageRotation = 0.0
    @objc dynamic var faceImageScaleX = 0.0
    @objc dynamic var faceImageScaleY = 0.0

    @objc dynamic var greetingColor: GreetingColor?

//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
