//
//  PhoneContactModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift

class PhoneContact: Object {

    @objc dynamic var code = ""
    @objc dynamic var id = ""
    @objc dynamic var localName = ""
    @objc dynamic var serverName = ""
    @objc dynamic var phone = ""
    @objc dynamic var image = ""
    @objc dynamic var lastSynced: Double = 0.0
    @objc dynamic var isBlocked = false

    var name: String {
        if serverName.isEmpty {
            return localName
        } else {
            return serverName
        }
    }

    override static func primaryKey() -> String? {
        return "phone"
    }

    static func getPhoneContacts(from contacts: [ContactModel]) -> [PhoneContact] {
        var phoneContacts = [PhoneContact]()

        for contact in contacts {

            let dict = ["serverName": contact.name, "id": contact.id, "code": contact.code, "phone": contact.phone, "image": contact.image, "isBlocked": contact.isBlocked] as JSONDictionary

            let phoneContact = PhoneContact(value: dict)
            phoneContacts.append(phoneContact)
        }
        return phoneContacts
    }
}
