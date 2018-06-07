//
//  AppUserDefaults+Key.swift
//  StarterProj
//
//  Created by MAC on 07/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation

extension AppUserDefaults {

    enum Key : String {
        
//        case Accesstoken
        case tutorialDisplayed
        case userData
        case supportData
        case userId
        case isIntesrest
        case googleEvent
        case facebookEvent
        case phoneEvent
        case timeStamp
        case isThankYou
        case lastContactSyncedTime

        case appDidOpenWithEventType
        case appDidOpenWithEventId

        case remoteNotification
        case toMoveTochatRoomId
        case chatBackgroundInfo
        case selectedBuddy

        case usedFortunes
        case fortune
        case fortuneExpiry
    }
}
