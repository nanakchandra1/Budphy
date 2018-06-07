//
//  NotificationsVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell else {
            fatalError("NotificationCell not found")
        }
        
        cell.populateView(model: notificationListModel[indexPath.row])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        panGesture.delegate = self
        //panGesture.cancelsTouchesInView = false
        cell.backView.addGestureRecognizer(panGesture)
    
        cell.deleteBtn.addTarget(self,
                                 action: #selector(deleteBtnTapped(_:)),
                                 for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.notificationListModel[indexPath.row]
        
        if model.read_status != "1" {
            self.hitReadNotification(notificationId: model.notification_id)
            self.notificationListModel[indexPath.row].read_status = "1"
        }

        guard let eventDate = model.notification_time.toDate(dateFormat: DateFormat.shortDate.rawValue) else {
            return
        }

        switch model.notification_type {
            
        case 1,2,7:
            
            let scene = EditEventVC.instantiate(fromAppStoryboard: .Events)

            var dic                 = JSONDictionary()
            dic["event_category"]   = "4"
            dic["event_date"]       = eventDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
            dic["event_name"]       = model.event_name
            dic["event_id"]         = model.event_id
            dic["event_image"]      = model.event_image
            dic["user_id"]          = model.sender_id

            if model.notification_type == 1 {
                
                scene.eventState = .invitation
                scene.inviteDetails = InvitationModel(initForInviteModel: JSON(dic))
                
            } else {
                
                dic["event_start_date"] = eventDate.toString(dateFormat: DateFormat.calendarDate.rawValue)

                scene.eventState = .view
                scene.obEventModel = EventModel(initForEventModel: dic)
            }
            self.navigationController?.pushViewController(scene, animated: true)
            
        case 3:
            
            var dic             = JSONDictionary()
            dic["greeting_id"]  = model.event_id
            dic["title"]        = model.event_name
            dic["greeting"]     = model.event_image
            dic["share_id"]     = model.sender_id
            dic["share_by"]     = model.sender_name
            
            let scene = GreetingPreviewVC.instantiate(fromAppStoryboard: .Greeting)
            scene.flowType = .events
            scene.vcState = .receive
            scene.modelGreetingList = GreetingListModel(initWithListModel: JSON(dic))
            self.navigationController?.pushViewController(scene, animated: true)

        case 4:
            // Self Birthday
            return
        case 5:
            // Friend's Birthday
            return
        case 6:
            
            var dic                 = JSONDictionary()
            dic["event_category"]   = model.category
            dic["event_date"]       = eventDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
            dic["event_name"]       = model.event_name
            dic["event_id"]         = model.event_id
            dic["event_image"]      = model.event_image
            dic["user_id"]          = model.sender_id
            
            if model.category == 2 || model.category == 3 {
                
                let moviesSeriesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
                
                if model.category == 2 {
                    dic["event_category"]   = "2"
                    moviesSeriesScene.moviesOrConcert = .concert
                } else {
                    dic["event_category"]   = "1"
                    moviesSeriesScene.moviesOrConcert = .movies
                }
                
                moviesSeriesScene.obEventModel = EventModel(initForEventModel: dic)
                self.navigationController?.pushViewController(moviesSeriesScene, animated: true)
                
            } else {
                
                var sportType: SportDetailVC.SportType = .soccer
                
                if model.category == 4 {
                    sportType = .cricket
                    dic["event_category"]   = "5"
                } else if model.category == 5 {
                    sportType = .soccer
                    dic["event_category"]   = "3"
                } else if model.category == 6 {
                    sportType = .batminton
                    dic["event_category"]   = "6"
                } else if model.category == 7 {
                    sportType = .tennis
                    dic["event_category"]   = "7"
                }
                
                let sportDetailScene = SportDetailVC.instantiate(fromAppStoryboard: .Events)
                //AppDelegate.shared.sharedTabbar?.hideTabbar()
                sportDetailScene.vcType = sportType
                sportDetailScene.eventModel = EventModel(initForEventModel: dic)
                self.navigationController?.pushViewController(sportDetailScene, animated: true)
            }

        case 8:
            //Chat
            return
        case 9:
            //Call
            return
        case 10:
            //Health
            return
        case 11:
            //Bill Pay
            return
        default:
            return
        }
        showNotificationsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if shouldSelectTableCell {
            return indexPath
        }
        return nil
    }
    
}
