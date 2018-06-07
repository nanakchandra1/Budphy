//
//  Webservice+EndPoints.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

#if DEBUG
//let BASE_URL = "http://development.budfie.com/api/"
let BASE_URL = "http://staging.budfie.com/api/"
//let BASE_URL = "http://budfie.com/api/"
#else
//let BASE_URL = "http://development.budfie.com/api/"
//let BASE_URL = "http://staging.budfie.com/api/"
let BASE_URL = "http://budfie.com/api/"
#endif

//let BASE_URL = "http://budfiedev.applaurels.com/api/"     //DEVELOPMENT SERVER
//let BASE_URL = "http://budfiesta.applaurels.com/api/"     //STAGING SERVER

extension WebServices {
    
    enum EndPoint : String {
        
        case signup = "social_check"
        case login = "login"
        case otp = "otp"
        case interest = "interest"
        case profile = "profile"
        case event = "event"
        case friend = "friend"
        case contact = "contact"
        case personalEvent = "personal_event"
        case editEvent = "edit_event"
        case editHoliday = "edit_holiday"
        case eventDetails = "event_detail"
        case pendingEvents = "pending_events"
        case eventInvitation = "event_invitation"
        case concerts = "concerts"
        case sports = "sports"
        case logout = "logout"
        case notificationStatus = "notification_status"
        case profileVisibility = "profile_visibility"
        case refreshToken = "refresh_token"
        case movies = "movies"
        case favourite = "favourite"
        case eventDates = "event_dates"
        case moodList = "mood"
        case news = "news"
        case timeOutMovies = "timeout_movies"
        case gifs = "gif"
        case videos = "videos"
        case otherUser = "other_user"
        case block = "block"
        case holiday = "holiday"
        case deleteGreeting = "delete_greeting"
        case changeNumber = "change_number"
        case greeting = "greeting"
        case greetingDetails = "greeting_details"
        case shareGreeting = "share_greeting"
        case thoughts = "thoughts"
        case jokes = "jokes"
        case clips = "clips"
        case gift = "gift"
        case notification = "notification"
        case notificationRead = "notification_read"
        case notificationCount = "notification_count"
        case greetingCards = "greeting_cards"
        case createReminder = "create_reminder"
        case editReminder = "edit_reminder"
        case chatPush = "chat_push"
        case deleteReminder = "delete_reminder"
        case greetingCount = "greeting_count"
        case deleteEvent = "delete_event"
        case googleReverseGeocode = "https://maps.googleapis.com/maps/api/geocode/json"

        var path : String {
            
            switch self {
            case .googleReverseGeocode:
                return self.rawValue
            default:
                let url = BASE_URL
                return url + self.rawValue
            }
        }
    }
}
