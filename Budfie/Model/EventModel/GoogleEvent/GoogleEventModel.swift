//
//  GoogleEventModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 03/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import GoogleAPIClientForREST
import CoreData

class GoogleEventModel {
    
    var hangoutLink: String = ""
    var location: String = ""
    var reminders: String = ""
    var status: String = ""
    var summary: String = ""
    var attendees: String = ""
    var kind: String = ""
    var organizer: String = ""
    var originalStartTime: String = ""
    var updated: String = ""
    var conferenceData: String = ""
    var htmlLink: String = ""
    var id: String = ""
    var end: String = ""
    var recurringEventId: String = ""
    var etag: String = ""
    var start: String = ""
    var iCalUID: String = ""
    var created: String = ""
    var sequence: String = ""
    
    var date: String = ""
    var time: String = ""
    
    init() {}
    
    init(with event: GTLRCalendar_Event) {
        
        let googleEvent = GoogleEventModel()
        
        googleEvent.id = event.identifier ?? ""
        googleEvent.summary = event.summary ?? ""
        
        if let start = event.start?.dateTime ?? event.start?.date {
            
            googleEvent.date = start.date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
            
            googleEvent.time = start.date.toString(dateFormat: DateFormat.shortTime.rawValue)
        }
        
        EventsCoreDataController.saveToLocalDB(googleEvent: googleEvent)
    }
        
}


// Google Events
/*
 GTLRCalendar_Event 0x17465fe60: {
 "hangoutLink":"https://plus.google.com/hangouts/_/appinventiv.com/rajat-dhasmana?hceid=cmFqYXQuZGhhc21hbmFAYXBwaW52ZW50aXYuY29t.2c66n6pkb2asf7maf4ukjgilc4",
 "location":"Appinventiv, H-23, 2nd Floor, Sector 63, H Block, Sector 62, Noida, Uttar Pradesh 201301, India",
 "reminders":{useDefault},
 "status":"confirmed",
 "creator":{email},
 "summary":"iOS Team meeting",
 "attendees":[37],
 "kind":"calendar#event",
 "organizer":{email},
 "originalStartTime":{dateTime},
 "updated":"2018-02-01T11:20:11.574Z",
 "conferenceData"?:{entryPoints,conferenceId,signature,conferenceSolution,createRequest},
 "htmlLink":"https://www.google.com/calendar/event?eid=MmM2Nm42cGtiMmFzZjdtYWY0dWtqZ2lsYzRfMjAxODAyMDhUMTEzMDAwWiB5b2dlc2gubmVnaUBhcHBpbnZlbnRpdi5jb20",
 "identifier":"2c66n6pkb2asf7maf4ukjgilc4_20180208T113000Z",
 "end":{dateTime},
 "recurringEventId":"2c66n6pkb2asf7maf4ukjgilc4",
 "etag":""3034968023148000"",
 "start":{dateTime},
 "iCalUID":"2c66n6pkb2asf7maf4ukjgilc4@google.com",
 "created":"2017-11-29T09:15:03.000Z",
 "sequence":1
 }
 */
