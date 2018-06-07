//
//  EventsCoreDataController.swift
//  Budfie
//
//  Created by yogesh singh negi on 04/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift

class EventsCoreDataController {
    
    // SAVE EVENTS TO LOCAL DB
    class func saveToLocalDB(googleEvent: GoogleEventModel) {

        if let realm = try? Realm() {
            let value = ["id": googleEvent.id, "name": googleEvent.summary, "startDate": googleEvent.date, "startTime": googleEvent.time, "category": "10"]
            try? realm.write {
                realm.create(RealmEvent.self, value: value)
            }
        }
        AppUserDefaults.save(value: "1", forKey: AppUserDefaults.Key.googleEvent)
    }


    class func saveToLocalDB(facebookEvent: FacebookEvent) {

        if let realm = try? Realm() {

            var value: JSONDictionary = ["id": facebookEvent.id, "name": facebookEvent.name, "category": "11"]

            if let startDate = facebookEvent.startTime.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
                value["startDate"] = startDate.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
                value["startTime"] = startDate.toString(dateFormat: DateFormat.fullTime.rawValue)
            }

            if let endDate = facebookEvent.endTime.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
                value["endDate"] = endDate.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
                value["endTime"] = endDate.toString(dateFormat: DateFormat.fullTime.rawValue)
            }

            try? realm.write {
                realm.create(RealmEvent.self, value: value)
            }
        }
        AppUserDefaults.save(value: "1", forKey: AppUserDefaults.Key.facebookEvent)
    }

    //FETCH EVENTS FROM LOCAL DB
    class func fetchAllEventsFromLocalDB(_ completionBlock : ((_ events : [EventModel]) -> Void)) {

        var events = [RealmEvent]()

        if let realm = try? Realm() {
            events = Array(realm.objects(RealmEvent.self))
        }

        var eventModels = [EventModel]()

        for event in events {

            var dic = JSONDictionary()
            dic["event_name"]           = event.name
            dic["event_id"]             = event.id
            dic["event_start_date"]     = event.startDate
            dic["event_start_time"]     = event.startTime
            dic["event_end_date"]       = event.endDate
            dic["event_end_time"]       = event.endTime
            dic["event_category"]       = event.category

            eventModels.append(EventModel(initForEventModel: dic))
        }

        completionBlock(eventModels)
    }
    
    
    // DELETE ALL EVENTS FROM LOCAL DB
    class func deleteEvents() {
        if let realm = try? Realm() {
            let events = realm.objects(RealmEvent.self)
            try? realm.write {
                realm.delete(events)
            }
        }
        AppUserDefaults.save(value: "0",
                             forKey: AppUserDefaults.Key.googleEvent)
    }
    
}
