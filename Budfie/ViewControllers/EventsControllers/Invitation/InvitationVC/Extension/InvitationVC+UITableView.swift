//
//  InvitationVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 15/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableViewDelegate and UITableViewDataSource
//==================================================================
extension InvitationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.obInvitationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.obInvitationModel[indexPath.row]
        
        if model.category == "1" {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInvitationCell") as? MoreInvitationCell else {
                fatalError("MoreInvitationCell not found")
            }
            
            cell.populate(objc: model)
            cell.acceptBtn.addTarget(self,
                                     action: #selector(acceptOrRejectBtnTapped( _ :)),
                                     for: .touchUpInside)
            cell.rejectBtn.addTarget(self,
                                     action: #selector(acceptOrRejectBtnTapped( _ :)),
                                     for: .touchUpInside)
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell else {
            fatalError("NotificationCell not found")
        }

        cell.populateInvitationView(model: model)
        let (_, image) = getNameReminder(text: model.eventType)
        cell.notificationImage.image = image
        cell.greetingName.text = model.eventName //text

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        panGesture.delegate = self
        //panGesture.cancelsTouchesInView = false
        cell.backView.addGestureRecognizer(panGesture)

        cell.deleteBtn.addTarget(self,
                                 action: #selector(deleteBtnTapped),
                                 for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.obInvitationModel[indexPath.row]
        
        if model.category == "1" {
            return 125
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.obInvitationModel[indexPath.row]
        
        if model.category == "1" {
            
            let editEventSene = EditEventVC.instantiate(fromAppStoryboard: .Events)
            editEventSene.eventState = .invitation
            editEventSene.delegate = self
            editEventSene.inviteDetails = self.obInvitationModel[indexPath.row]
            self.navigationController?.pushViewController(editEventSene, animated: true)

        } else {

            let quickReminderScene = QuickReminderVC.instantiate(fromAppStoryboard: .Settings)
            quickReminderScene.reminderModel = QuickReminderModel(with: self.obInvitationModel[indexPath.row])
            quickReminderScene.delegate = self
            self.navigationController?.pushViewController(quickReminderScene, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    //    //MARK: Deleting Cell
    //    //===================
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if editingStyle == UITableViewCellEditingStyle.delete{
    ////            self.nameArray.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .middle)
    //
    //        }
    //    }
    //
    //    //MARK: User Define Method for Custom Delete Button On Swipe
    //    //==========================================================
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //        //Custom Delete Button on Swipe
    //        let myDeleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: {(action,indexPath) in
    ////            self.nameArray.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .middle)
    //        })
    //        myDeleteButton.backgroundColor = UIColor.cyan
    //
    //        //Custom Change Name Button on Swipe
    //        let changeLabelName = UITableViewRowAction(style: .default, title: "Change_Name", handler: {(action,indexPath) in
    ////            self.nameArray.remove(at: indexPath.row)
    ////            self.nameArray.insert("AppInventiv", at: indexPath.row)
    //            tableView.reloadRows(at: [indexPath], with: .right)
    //        })
    //
    //        return [changeLabelName,myDeleteButton]
    //    }
    
}
