//
//  ContactsController.swift
//  Mongo
//
//  Created by appinventiv on 16/11/17.
//  Copyright © 2017 MongoApp. All rights reserved.


import Contacts
import RealmSwift
import SwiftyJSON

class ContactsController {
    
    var device_uuid = ""
    
    enum ContactSyncState {
        case stopped, inProgress, completed
    }
    
    var contactPermissionEnabled : Bool {
        if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == CNAuthorizationStatus.denied {
            return false
        } else {
            return true
        }
    }
    var isContactSync: ContactSyncState = ContactSyncState.stopped
    static let shared = ContactsController()
    fileprivate var errorOccured: errorBlock!
    fileprivate var noNetworkBlock: errorBlock!
    
    internal typealias UserContactsBlock = (_ ContactsModel: [PhoneContact]) -> Void
    internal typealias errorBlock = () -> Void
    
    fileprivate init() {
    }
    
    //MARK:- Contact fetching
    func syncPhoneBookContacts(_ completionBlock : @escaping (()->()), receivedContacts : @escaping (([PhoneContact])->()),permissionGrantedBlock : @escaping ((Bool) -> Void), errorOccured : @escaping errorBlock, noNetworkBlock : @escaping errorBlock) {
        
        self.errorOccured = errorOccured
        self.noNetworkBlock = noNetworkBlock

        self.findContacts({ contacts in
            DispatchQueue.main.async {
                completionBlock()
            }
        }, receivedContacts: { contacts in
            receivedContacts(contacts)

        }, permissionGranted: { (granted : Bool) -> Void in
            DispatchQueue.main.async {
                permissionGrantedBlock(granted)
            }
        })
    }
    
    //MARK:- CNContact Framework
    //MARK:- findContacts
    //function to fetch contact detail from Contacts framework
    
    @available(iOS 9.0, *)
    
    private func findContacts(_ completionBlock: @escaping ([CNContact])->(), receivedContacts : @escaping (([PhoneContact]) -> Void), permissionGranted: @escaping ((Bool) -> Void)) {
        
        var contacts = [CNContact]()
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
        store.requestAccess(for: CNEntityType.contacts) { (accessPermissionGranted : Bool,error : Error?) in
            if error == nil {
                if accessPermissionGranted {
                    DispatchQueue.global(qos: .background).async {
                        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        do {
                            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact,stop) -> Void in
                                contacts.append(contact)
                            })
                        }
                        catch let error as NSError {
                            print_debug(error.localizedDescription)
                        }
                        self.accessDetail(contacts, completionBlock: { cntcts in
                            completionBlock(contacts)
                            receivedContacts(cntcts)
                        })
                    }
                } else {
                    permissionGranted(false)
                }
            } else {
                permissionGranted(false)
                print_debug(error)
            }
        }
    }
    
    @available(iOS 9.0, *)
    private func accessDetail(_ contacts: [CNContact], completionBlock: @escaping ([PhoneContact])->()) {
        print_debug("\(#function), \(contacts.count)")

        var contactToSave = [PhoneContact]()
        let syncedTime = Date().timeIntervalSince1970

        for contact in contacts {

            let givenName = contact.givenName
            let familyName = contact.familyName
            var name = ""

            if familyName.isEmpty {
                name = givenName
            } else {
                name = "\(givenName) \(familyName)"
            }
            
            for number in contact.phoneNumbers {

                let characterSet = CharacterSet(charactersIn: "+0123456789").inverted
                let phoneNumber = number.value.stringValue.components(separatedBy: characterSet).joined(separator: "")
                let offset: Int

                guard let user = AppDelegate.shared.currentuser else {
                    return
                }

                guard let firstChar = phoneNumber.first else {
                    continue
                }

                switch firstChar {
                case "0":
                    offset = 1
                case "+":
                    offset = 3
                default:
                    offset = 0
                }

                let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: offset)
                let truncated = String(phoneNumber[startIndex...])

                if truncated.count != 10 || truncated == user.phone_no {
                    //if truncated.count != 10 {
                    continue
                }

                if name.isEmpty {
                    name = truncated
                }

                let value: JSONDictionary = ["localName": name, "code": "+91", "phone": truncated, "lastSynced": syncedTime]
                let contact = PhoneContact(value: value)
                contactToSave.append(contact)

                if let realm = try? Realm() {
                    try? realm.write {
                        realm.create(PhoneContact.self, value: value, update: true)
                    }
                }
            }
        }

        print_debug("\(#function) lastSynced: \(syncedTime)")
        saveContactsToLocalDB(contactToSave, lastSynced: syncedTime, completionBlock: completionBlock)
    }

    private func saveContactsToLocalDB(_ contacts: [PhoneContact], lastSynced: Double, completionBlock: @escaping ([PhoneContact])->()) {
        print_debug("\(#function), \(contacts.count)")

        DispatchQueue.main.async {

            guard let realm = try? Realm() else {
                print_debug("FAILED TO GET REALM")
                return
            }

            /*
             try? realm.write {
             realm.add(contacts, update: true)
             }
             */

            try? realm.write {
                let lastSyncedTime = AppUserDefaults.value(forKey: .lastContactSyncedTime).doubleValue
                print_debug("\(#function) lastSynced < \(lastSynced)")
                let contactsToBeRemoved = realm.objects(PhoneContact.self).filter("lastSynced == \(lastSyncedTime)")
                print_debug("\(#function) contactsToBeRemoved: \(contactsToBeRemoved.count)")
                realm.delete(contactsToBeRemoved)
            }

            AppUserDefaults.save(value: lastSynced, forKey: AppUserDefaults.Key.lastContactSyncedTime)

            let updatedContacts = Array(realm.objects(PhoneContact.self))
            self.syncContactInPagination(updatedContacts) { (friendContacts) in
                completionBlock(friendContacts)
            }
        }
    }
    
    private func syncContactInPagination(_ phoneContacts: [PhoneContact], completionBlock: @escaping ([PhoneContact])->()) {
        var uploadedContact = 0
        print_debug("\(#function), \(phoneContacts.count)")

        func syncContact() {

            guard AppDelegate.shared.currentuser != nil else {
                return
            }

            if uploadedContact < phoneContacts.count {

                var contactChunk: [PhoneContact] = Array(phoneContacts[uploadedContact..<min(uploadedContact+250,phoneContacts.count)])
                
                if contactChunk.count == 0 {
                    contactChunk = [phoneContacts[uploadedContact]]
                }

                var contactsDict = JSONDictionaryArray()
                
                for contact in contactChunk {
                    let dict = ["phone_no": contact.phone, "country_code": "+91"]
                    contactsDict.append(dict)
                }

                DispatchQueue.backgroundQueueAsync {
                    self.syncContactOnRemoteDB(contactsDict) { cntcts in

                        uploadedContact = min(uploadedContact+250, phoneContacts.count)
                        DispatchQueue.main.async {
                            syncContact()
                        }
                        completionBlock(cntcts)
                    }
                }

            } else {
                
                print_debug("\(phoneContacts.count) contact synced at: ")
                print_debug("\n \(Date())")
                completionBlock([PhoneContact]())
            }
        }
        
        if !phoneContacts.isEmpty {
            syncContact()
        }
    }
    
    private func syncContactOnRemoteDB(_ contacts: JSONDictionaryArray, completionBlock : @escaping ([PhoneContact])->Void) {

        print_debug("\(#function), \(contacts.count)")
        var params = [String: Any]()
        
        //params["user_id"] = "user_id_here"
        params["method"] = "contact_sync"
        params["access_token"] = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        
        let contactsJSONString = CommonClass.convertToJson(jsonDic: contacts)
        if contactsJSONString == "[]" {
            return
        } else {
            params["contacts"] = contactsJSONString
        }
        //params["contacts"] = contact
        
        print_debug("Contact count: \(contacts.count)")
        print_debug(params)
        
        WebServices.contactSync(parameters: params, loader: false, success: { (success, contacts) in

            if success {
                print_debug("Printing Received Contacts: \(contacts)")
                let updatedContacts = self.updateContacts(contacts)
                completionBlock(updatedContacts)
            }

        }) { (error) in
            
        }
    }

    @discardableResult
    func updateContacts(_ contacts: [ContactModel]) -> [PhoneContact] {

        let phoneContacts = PhoneContact.getPhoneContacts(from: contacts)

        if let realm = try? Realm() {
            try? realm.write {
                realm.add(phoneContacts, update: true)
            }
        }
        return phoneContacts
    }

    func fetchBudfieContacts() -> [PhoneContact] {
        if let realm = try? Realm() {
            let phoneContacts: Results<PhoneContact>
            if let currentUserId = AppDelegate.shared.currentuser?.user_id {
                phoneContacts = realm.objects(PhoneContact.self).filter("id != '\(currentUserId)' AND id != '' AND isBlocked = false")
            } else {
                phoneContacts = realm.objects(PhoneContact.self).filter("id != '' AND isBlocked = false")
            }
            return Array(phoneContacts)
        }
        return [PhoneContact]()
    }

    func fetchNonBudfieContacts() -> [PhoneContact] {
        if let realm = try? Realm() {
            let phoneContacts: Results<PhoneContact>
            if let currentUserId = AppDelegate.shared.currentuser?.user_id {
                phoneContacts = realm.objects(PhoneContact.self).filter("id != '\(currentUserId)' AND id == ''")
            } else {
                phoneContacts = realm.objects(PhoneContact.self).filter("id == ''")
            }
            return Array(phoneContacts)
        }
        return [PhoneContact]()
    }
}
