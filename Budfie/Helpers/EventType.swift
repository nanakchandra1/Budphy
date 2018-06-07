//
//  EventType.swift
//  Budfie
//
//  Created by appinventiv on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

func getEventListImage(typeId: String) -> UIImage {
    switch typeId {
    case "1": return AppImages.icEventsCake
    case "2": return AppImages.icEventsRing
    case "4": return AppImages.icEventsMeeting
    case "5": return AppImages.icEventsBurger
    case "7": return AppImages.icEventsDate
    case "8": return AppImages.icEventsMetime
    case "9": return AppImages.icEventsMatch
    case "10": return AppImages.icEventsMovie
    case "f": return AppImages.icEventsFb
    case "g": return AppImages.icEventsGoogleplus
    default:
        return AppImages.myprofilePlaceholder
    }
}

func getEventListImage(eventName: String) -> UIImage {
    switch eventName {
    case "Birthday"         : return AppImages.icEventsCake
    case "Anniversary"      : return AppImages.icEventsRing
    case "Official Meeting" : return AppImages.icEventsMeeting
    case "Party"            : return AppImages.icEventsBurger
    case "Date"             : return AppImages.icEventsDate
    case "Me Time"          : return AppImages.icEventsMetime
    case "Match"            : return AppImages.icEventsMatch
    case "Movie/Event"      : return AppImages.icEventsMovie
    case "Holiday"          : return AppImages.icHoliday
    case "f"                : return AppImages.icEventsFb
    case "g"                : return AppImages.icEventsGoogleplus
    default:
        return AppImages.myprofilePlaceholder
    }
}

func getEventDetailsImage(eventName: String) -> UIImage {
    switch eventName {
    case "Birthday"         : return AppImages.icBirthday
    case "Anniversary"      : return AppImages.icAnniversary
    case "Official Meeting" : return AppImages.icOfficeMeeting
    case "Party"            : return AppImages.icParty
    case "Date"             : return AppImages.icDate
    case "Me Time"          : return AppImages.icMeTime
    case "Match"            : return AppImages.icMatch
    case "Movie/Event"      : return AppImages.icMovie
    default:
        return AppImages.myprofilePlaceholder
    }
}

func getEventDetailsImage(typeId: String) -> UIImage {
    switch typeId {
    case "1": return AppImages.icBirthday
    case "2": return AppImages.icAnniversary
    case "4": return AppImages.icOfficeMeeting
    case "5": return AppImages.icParty
    case "7": return AppImages.icDate
    case "8": return AppImages.icMeTime
    case "9": return AppImages.icMatch
    case "10": return AppImages.icMovie
    case "f": return AppImages.icEventsFb
    case "g": return AppImages.icEventsGoogleplus
    default:
        return AppImages.myprofilePlaceholder
    }
}

/*
 "event_type" = Birthday;
 id = 1;
 },
 {
 "event_type" = Anniversary;
 id = 2;
 },
 {
 "event_type" = "Official Meeting";
 id = 4;
 },
 {
 "event_type" = Party;
 id = 5;
 },
 {
 "event_type" = Date;
 id = 7;
 },
 {
 "event_type" = "Me Time";
 id = 8;
 },
 {
 "event_type" = Match;
 id = 9;
 },
 {
 "event_type" = "Movie/Event";
 id = 10;
 }
 */

/*
"event_type" = Birthday;
id = 1;
},
{
    "event_type" = Anniversary;
    id = 2;
},
{
    "event_type" = "Official Meeting";
    id = 4;
},
{
    "event_type" = Party;
    id = 5;
},
{
    "event_type" = Date;
    id = 7;
},
{
    "event_type" = "Me Time";
    id = 8;
},
{
    "event_type" = Match;
    id = 9;
},
{
    "event_type" = "Movie/Event";
    id = 10;
}
*/
