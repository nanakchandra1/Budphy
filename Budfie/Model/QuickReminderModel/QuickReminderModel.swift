//
//  QuickReminderModel.swift
//  Budfie
//
//  Created by appinventiv on 19/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class QuickReminderModel {

    var id              : String = ""
    var type            : String = ""  //Type(1=Health,2=Call,3=BillPay,4=Others)
    var name            : String = ""
    var time            : String = ""
    var date            : String = ""
    var repeatReminder  : String = ""  //Repeat(1=Daily,2=Weekly,3=Monthly,4=Yearly)

    init() {

    }

    init(with invite: InvitationModel) {
        id              = invite.eventId

        switch invite.eventType.lowercased() {
        case "health":
            type = "1"
        case "call":
            type = "2"
        case "billpay":
            type = "3"
        case "others":
            type = "4"
        default:
            type = ""
        }

        /*
         if let eventTime = invite.eventTime.toDate(dateFormat: DateFormat.fullTime.rawValue) {
         time = eventTime.toString(dateFormat: DateFormat.fullTime.rawValue)
         }
        */
        time            = invite.eventTime
        date            = invite.eventDate
        repeatReminder  = invite.repeatType
        name            = invite.eventName
    }
}
