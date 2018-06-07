//
//  EditEventVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 22/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

extension EditEventVC {
    
    func recurringCell(tableView: UITableView, indexPath: IndexPath) -> RecurringEventCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecurringEventCell", for: indexPath) as? RecurringEventCell else { fatalError("RecurringEventCell not found") }
        
        if self.isRecurring {
            cell.yesRadioImage.image = AppImages.icChooseMusicRadioOn
            cell.noRadioImage.image = AppImages.icChooseMusicRadioOff
        } else {
            cell.yesRadioImage.image = AppImages.icChooseMusicRadioOff
            cell.noRadioImage.image = AppImages.icChooseMusicRadioOn
        }
        if eventState == .view || eventState == .invitation {
            cell.bottomLineView.isHidden = true
            cell.yesBtn.isUserInteractionEnabled = false
            cell.noBtn.isUserInteractionEnabled = false
        } else {
            cell.bottomLineView.isHidden = false
            cell.yesBtn.isUserInteractionEnabled = true
            cell.noBtn.isUserInteractionEnabled = true
        }
        cell.yesBtn.addTarget(self,
                              action: #selector(radioRecurringBtnTapped(_:)),
                              for: .touchUpInside)
        cell.noBtn.addTarget(self,
                             action: #selector(radioRecurringBtnTapped(_:)),
                             for: .touchUpInside)
        return cell
    }
    
    func recurringDateCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddEventCellId") as? AddEventCell else { fatalError("AddEventCell not found") }
        
        cell.eventNameTextField.placeholder = "Recurring Type"
        cell.textFieldEndImageView.image = AppImages.icAddeventDropdown

        if !self.eventDetailsModel.recurring_type.isEmpty {
            cell.eventNameTextField.text = getRecurringType(byIndex: self.eventDetailsModel.recurring_type)
        }

        if eventState == .view || eventState == .invitation {
            cell.textFieldBottomView.isHidden = true
            cell.eventNameTextField.isUserInteractionEnabled = false
            cell.textFieldEndImageView.isHidden = true
        } else {
            cell.textFieldBottomView.isHidden = false
            cell.eventNameTextField.isUserInteractionEnabled = true
            cell.textFieldEndImageView.isHidden = false
        }
        
        // PickerView
        MultiPicker.noOfComponent = 1
        MultiPicker.openMultiPickerIn(cell.eventNameTextField,
                                      firstComponentArray: self.recurringTypeArray,
                                      secondComponentArray: [],
                                      firstComponent: nil,
                                      secondComponent: nil,
                                      titles: [""],
                                      doneBlock: { (str1, str2) in
                                        cell.eventNameTextField.text = str1
                                        self.eventDetailsModel.recurring_type = getRecurringType(byName: str1)
        })
        
        return cell
    }
    
}

//MARK: Extension: for Delagates and DataSource of UITableView
//============================================================
extension EditEventVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventDetailsModel == nil {
            return 0
        } else if section == 0 {
            return 5+3
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return 5
        
        if self.eventDetailsModel == nil {
            return 0
        } else {
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableTopCurveHeaderFooterView") as? TableTopCurveHeaderFooterView else { fatalError("TableTopCurveHeaderFooterView not found") }
            
            headerCell.shareBtn.isHidden = (eventState == .edit)
            return headerCell
            
        } else {
            return UIView()
        }
    }
    
    //MARK: Setting the Cell view
    //===========================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0,1,6,7:
                guard let addEventCell = tableView.dequeueReusableCell(withIdentifier: "AddEventCellId") as? AddEventCell else { fatalError("AddEventCell not found") }
                
                if eventState == .view || eventState == .invitation {
                    addEventCell.textFieldBottomView.isHidden = true
                    addEventCell.eventNameTextField.isUserInteractionEnabled = false
                } else {
                    addEventCell.textFieldBottomView.isHidden = false
                    addEventCell.eventNameTextField.isUserInteractionEnabled = true
                }
                
                if indexPath.row == 1 {
                    addEventCell.eventNameTextField.tintColor = UIColor.blue
                    addEventCell.eventNameTextField.text = self.eventDetailsModel.eventName
                    var placeHolder = ""
                    if eventState == .invitation || (self.obEventModel.userId != AppDelegate.shared.currentuser.user_id) || eventState == .view {
                        placeHolder = StringConstants.Event_Name_Not_Mandatory.localized
                    } else {
                        placeHolder = StringConstants.Event_Name.localized
                    }
                    addEventCell.populate(placeholderName: placeHolder,
                                          isDownArrow: false,
                                          isLocation: false)
                    addEventCell.eventNameTextField.addTarget(self,
                                                              action: #selector(textFieldValueChanged(_ : )),
                                                              for: .editingChanged)
                } else if indexPath.row == 0 {
                    
                    var placeHolder = ""
                    if eventState == .invitation || (self.obEventModel.userId != AppDelegate.shared.currentuser.user_id) || eventState == .view {
                        placeHolder = StringConstants.Event_Type_Not_Mandatory.localized
                    } else {
                        placeHolder = StringConstants.Event_Type.localized
                    }
                    addEventCell.populate(placeholderName: placeHolder,
                                          isDownArrow: true,
                                          isLocation: false)

                    for temp in self.obEventTypeModel {
                        if temp.id == self.eventDetailsModel.eventType {
                            addEventCell.eventNameTextField.text = temp.eventType
                            if self.eventDetailsModel.eventImage.isEmpty {
                                self.headerView.eventsImage.image = getEventDetailsImage(typeId: temp.id)
                                addEventCell.textFieldEndImageView.image = getEventListImage(typeId: temp.id)
                            }
                        }
                    }
                    addEventCell.textFieldEndImageView.image = getEventListImage(typeId: self.eventDetailsModel.eventType)
                    addEventCell.eventNameTextField.tintColor = UIColor.clear

                    addEventCell.eventNameTextField.inputView = pickerView
                    addEventCell.eventNameTextField.inputAccessoryView = pickerToolbar

                    /* PickerView
                     MultiPicker.noOfComponent = 1
                     MultiPicker.openMultiPickerIn(addEventCell.eventNameTextField,
                     firstComponentArray: self.eventType,
                     secondComponentArray: [],
                     firstComponent: nil,
                     secondComponent: nil,
                     titles: [""],
                     doneBlock: { (str1, str2) in
                     addEventCell.eventNameTextField.text = str1
                     
                     for temp in self.obEventTypeModel {
                     if temp.eventType == str1 {
                     self.eventDetailsModel.eventType = temp.id
                     }
                     }
                     if self.eventDetailsModel.eventImage.isEmpty {
                     self.headerView.eventsImage.image = getEventDetailsImage(eventName: str1)
                     addEventCell.textFieldEndImageView.image = getEventListImage(eventName: str1)
                     }
                     })
                     */
                    addEventCell.textFieldEndImageView.isHidden = false
                    /*
                    if eventState == .view || eventState == .invitation {
                        addEventCell.textFieldEndImageView.isHidden = true
                    } else {
                        addEventCell.textFieldEndImageView.isHidden = false
                    }
                    */
                } else if indexPath.row == 6 {
                    addEventCell.locationBtn.addTarget(self,
                                                       action: #selector(locationBtnTapped),
                                                       for: .touchUpInside)
                    addEventCell.eventNameTextField.tintColor = UIColor.black
                    addEventCell.eventNameTextField.text = self.eventDetailsModel.eventLocation
                    addEventCell.eventNameTextField.addTarget(self, action: #selector(getLocationByUser), for: .editingChanged)
                    addEventCell.populate(placeholderName: StringConstants.Location.localized,
                                          isDownArrow: false,
                                          isLocation: true)
                    addEventCell.eventNameTextField.inputView = nil
                    addEventCell.eventNameTextField.keyboardType = .default

                    if eventState == .view || eventState == .invitation {
                        addEventCell.locationBtn.isUserInteractionEnabled = false
                    } else {
                        addEventCell.locationBtn.isUserInteractionEnabled = true
                    }
                } else {
                    addEventCell.eventNameTextField.tintColor = UIColor.clear
                    addEventCell.eventNameTextField.text = self.eventDetailsModel.remindMe
                    addEventCell.populate(placeholderName: StringConstants.Remind_Me.localized,
                                          isDownArrow: true,
                                          isLocation: false)

                    // PickerView
                    MultiPicker.noOfComponent = 1
                    MultiPicker.openMultiPickerIn(addEventCell.eventNameTextField,
                                                  firstComponentArray: self.eventTimeArray,
                                                  secondComponentArray: [],
                                                  firstComponent: nil,
                                                  secondComponent: nil,
                                                  titles: [""],
                                                  doneBlock: { (str1, str2) in
                                                    addEventCell.eventNameTextField.text = str1
                                                    self.eventDetailsModel.remindMe = str1
                    })
                    if eventState == .view || eventState == .invitation {
                        addEventCell.textFieldEndImageView.isHidden = true
                    } else {
                        addEventCell.textFieldEndImageView.isHidden = false
                    }
                }
                return addEventCell
                
            case 2:
                guard let dateTimeCell = tableView.dequeueReusableCell(withIdentifier: "DateTimeCellId") as? DateTimeCell else { fatalError("DateTimeCell not found") }
                
                if eventState == .view || eventState == .invitation {
                    dateTimeCell.dateBottomView.isHidden = true
                    dateTimeCell.timeBottomView.isHidden = true
                    dateTimeCell.dateTextField.isUserInteractionEnabled = false
                    dateTimeCell.timeTextField.isUserInteractionEnabled = false
                } else {
                    dateTimeCell.dateBottomView.isHidden = false
                    dateTimeCell.timeBottomView.isHidden = false
                    dateTimeCell.dateTextField.isUserInteractionEnabled = true
                    dateTimeCell.timeTextField.isUserInteractionEnabled = true
                    dateTimeCell.dateTextField.delegate = self
                }
                
                if let date = self.eventDetailsModel.eventDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                    let dateStr = date.toString(dateFormat: DateFormat.showDateFormat.rawValue)
                    dateTimeCell.dateTextField.text = dateStr
                }
                if let time = self.eventDetailsModel.eventTime.toDate(dateFormat: DateFormat.fullTime.rawValue) {
                    let dateStr = time.toString(dateFormat: DateFormat.timein12Hour.rawValue)
                    dateTimeCell.timeTextField.text = dateStr
                }
                dateTimeCell.timeTextField.delegate = self
                if eventState == .invitation || (self.obEventModel.userId != AppDelegate.shared.currentuser.user_id) || eventState == .view {
                    dateTimeCell.dateTextField.placeholder = StringConstants.Date_Not_Mandatory.localized
                    dateTimeCell.timeTextField.placeholder = StringConstants.Time_Not_Mandatory.localized
                } else {
                    dateTimeCell.dateTextField.placeholder = StringConstants.Date.localized
                    dateTimeCell.timeTextField.placeholder = StringConstants.Time.localized
                }
                
                // DatePicker
                let minDate = Date()
                let maxDate = Calendar.current.date(byAdding: .year, value:3 , to: minDate)
                let selectedDate = self.eventDetailsModel.eventDate.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) ?? minDate
                
                DatePicker.openDatePickerIn(dateTimeCell.dateTextField,
                                            outPutFormate: DateFormat.dOBServerFormat.rawValue,
                                            mode: .date,
                                            minimumDate: minDate,
                                            maximumDate: maxDate!,
                                            selectedDate: selectedDate,
                                            doneBlock: { (dateStr,date) in
                                                
                                                self.eventDate = date
                                                
                                                let dateStr2 = date.toString(dateFormat: DateFormat.showDateFormat.rawValue)
                                                dateTimeCell.dateTextField.text = dateStr2
                                                self.eventDetailsModel.eventDate = dateStr
                                                dateTimeCell.timeTextField.text = ""
                                                self.eventDetailsModel.eventTime = ""
                                                self.addEventTableView.reloadRows(at: [[0,2]], with: .none)
                })

                DatePicker.openDatePickerIn(dateTimeCell.timeTextField,
                                            outPutFormate: DateFormat.timein12Hour.rawValue,
                                            mode: .time,
                                            minimumDate: minDate,
                                            selectedDate: self.eventDate,
                                            doneBlock: { (dateStr,date) in
                                                
                                                // Converting String Date to Date Format
                                                dateTimeCell.timeTextField.text = dateStr
                                                self.eventDetailsModel.eventTime = date.toString(dateFormat: DateFormat.fullTime.rawValue)
                })
                
                return dateTimeCell
                
            case 3:
                return self.recurringCell(tableView: tableView, indexPath: indexPath)
                
            case 4:
                return self.recurringDateCell(tableView: tableView, indexPath: indexPath)
                
            case 5:
                return self.recurringDateCell(tableView: tableView, indexPath: indexPath)
                
            default:
                return UITableViewCell()
            }
            
        case 1:
            
            guard let greetingCell = tableView.dequeueReusableCell(withIdentifier: "EditGreetingCellId") as? EditGreetingCell else { fatalError("EditGreetingCell not found") }
            
            if eventState == .view  || eventState == .invitation {
                greetingCell.editBtn.isHidden = true
            } else {
                greetingCell.editBtn.isHidden = false
            }
            greetingCell.editBtn.addTarget(self,
                                           action: #selector(self.editGreetingBtnTapped(_:)),
                                           for: .touchUpInside)
            greetingCell.eventDetailsModel = self.eventDetailsModel
            greetingCell.delegate = self
            greetingCell.greetingCollectionView.reloadData()
            return greetingCell
            
        case 2:
            
            guard let moreFriend = tableView.dequeueReusableCell(withIdentifier: "MoreFriendsCellId") as? MoreFriendsCell else { fatalError("MoreFriendsCell not found") }
            
            guard let ownerDetails = tableView.dequeueReusableCell(withIdentifier: "EventOwnerCell") as? EventOwnerCell else { fatalError("EventOwnerCell not found") }
            
            if eventState == .view  || eventState == .invitation {
                moreFriend.addMoreBtn.isHidden = true
            } else {
                moreFriend.addMoreBtn.isHidden = false
            }
            
            if eventState == .view,
                self.obEventModel != nil,
                (self.obEventModel.userId == AppDelegate.shared.currentuser.user_id) {
                
                moreFriend.friendList = self.eventDetailsModel.invitees
                moreFriend.inviteFriendLabel.text = "Invited Friends"
                moreFriend.delegate = self
                moreFriend.moreFriendsView.dataSource = moreFriend
                moreFriend.moreFriendsView.reloadData()
                
                return moreFriend
                
            } else if (eventState == .view  || eventState == .invitation) {
                
                ownerDetails.friendList = self.eventDetailsModel.eventOwner
                ownerDetails.inviteFriendLabel.text = "Invited By"
                ownerDetails.delegate = self
                ownerDetails.moreFriendsView.dataSource = moreFriend
                ownerDetails.moreFriendsView.reloadData()
                
                return ownerDetails
            } else {
                moreFriend.friendList = self.eventDetailsModel.invitees
                moreFriend.inviteFriendLabel.text = "Invited Friends"
                moreFriend.delegate = self
                moreFriend.moreFriendsView.dataSource = moreFriend
                moreFriend.moreFriendsView.reloadData()
                moreFriend.addMoreBtn.addTarget(self,
                                                action: #selector(self.addMoreBtnTapped(_:)),
                                                for: .touchUpInside)
                return moreFriend
            }
            
        case 3:
            
            guard let attendeeCell = tableView.dequeueReusableCell(withIdentifier: "AttendeeCell") as? AttendeeCell else { fatalError("AttendeeCell not found") }
            
            if eventState == .invitation || (self.obEventModel.userId != AppDelegate.shared.currentuser.user_id) {
                attendeeCell.inviteFriendLabel.text = "Attending"
            } else {
                attendeeCell.inviteFriendLabel.text = "Attendees"
            }
            attendeeCell.friendList = self.eventDetailsModel.attendees
            attendeeCell.delegate = self
            attendeeCell.moreFriendsView.reloadData()
            
            return attendeeCell
            
        default:
            
            guard let roundBtnCell = tableView.dequeueReusableCell(withIdentifier: "RoundBtnCellId") as? RoundBtnCell else { fatalError("RoundBtnCell not found") }
            let btnText = ((eventState == .edit) ? "UPDATE" : "DELETE")
            roundBtnCell.roundBtn.setTitle(btnText, for: .normal)
            roundBtnCell.roundBtn.addTarget(self,
                                            action: #selector(submitBtnTapped(_ : )),
                                            for: .touchUpInside)
            return roundBtnCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = AppColors.eventSaperator
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 5 {
                
                return CGFloat.leastNonzeroMagnitude
                
            } else if (indexPath.row == 3 || indexPath.row == 4) && (eventState == .invitation || (self.obEventModel.userId != AppDelegate.shared.currentuser.user_id)) {
                
                return CGFloat.leastNonzeroMagnitude
            } else if indexPath.row == 3 && eventState == .view {
                
                return CGFloat.leastNonzeroMagnitude
            }
            if !isRecurring {
                if indexPath.row == 4 {
                    return CGFloat.leastNonzeroMagnitude
                }
            }
            if (eventState == .view || eventState == .invitation) && indexPath.row == 6 {
                return self.eventDetailsModel.eventLocation.isEmpty ? CGFloat.leastNonzeroMagnitude : 70.0
            }
        }
        
        switch indexPath.section {
            
        case 0:
            if (eventState == .view || eventState == .invitation) && indexPath.row == 1 {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 70.0
            }
            
        case 1:
            if self.eventDetailsModel.greeting.isEmpty && eventState == .edit {
                return 60.0
            } else if self.eventDetailsModel.greeting.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return 100.0
            
        case 2:
            if self.obEventModel != nil,
                self.obEventModel.userId == AppDelegate.shared.currentuser.user_id {
                if self.eventDetailsModel.invitees.count == 0 && eventState == .edit {
                    return 70.0
                } else if self.eventDetailsModel.invitees.count == 0 {
                    return CGFloat.leastNonzeroMagnitude
                } else {
                    return 100.0
                }
            } else {
                return 100.0
            }
            
        case 3:
            if eventState == .edit {
                return CGFloat.leastNonzeroMagnitude
            } else if self.eventDetailsModel.attendees.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 100.0
            }
            
        case 4:
            if let user = AppDelegate.shared.currentuser,
                let event = obEventModel,
                event.userId != user.user_id {
                return CGFloat.leastNonzeroMagnitude
            } else if /*eventState == .view || */eventState == .invitation {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 100.0
            }
            
        default:
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.eventDetailsModel == nil {
            return CGFloat.leastNonzeroMagnitude
        }
        
        switch section {
            
        case 1:
            if self.eventDetailsModel.greeting.isEmpty && eventState == .edit {
                return 5.0
            } else if self.eventDetailsModel.greeting.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return 5.0
            
        case 2:
            if self.obEventModel != nil,
                self.obEventModel.userId == AppDelegate.shared.currentuser.user_id {
                if self.eventDetailsModel.invitees.count == 0 {
                    return CGFloat.leastNonzeroMagnitude
                } else {
                    return 5.0
                }
            } else if self.eventDetailsModel.eventOwner.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 5.0
            }
            
        case 3:
            if let user = AppDelegate.shared.currentuser,
                let event = obEventModel,
                event.userId != user.user_id {
                return CGFloat.leastNonzeroMagnitude
            } else if eventState == .edit {
                return CGFloat.leastNonzeroMagnitude
            } else if self.eventDetailsModel.attendees.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 5.0
            }

            /*
             if eventState == .edit {
             return CGFloat.leastNonzeroMagnitude
             } else if self.eventDetailsModel.attendees.count == 0 {
             return CGFloat.leastNonzeroMagnitude
             } else {
             return 5.0
             }
             */
            
        case 4:
            return CGFloat.leastNonzeroMagnitude
            /*
             if /*eventState == .view || */eventState == .invitation {
             return CGFloat.leastNonzeroMagnitude
             } else {
             return 5.0
             }
             */
            
        default:
            return 5.0
        }
    }
}


//MARK: Extension: for UITextFieldDelegate
//========================================
extension EditEventVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPath(tableView: self.addEventTableView) else { return false }
        
        if indexPath.row == 2 {
            guard let cell = textField.getTableViewCell as? DateTimeCell else { return false }
            
            if textField == cell.dateTextField {
                
            } else if textField == cell.timeTextField {
                
                if let text = cell.dateTextField.text, text.isEmpty {
                    CommonClass.showToast(msg: "Please Select Date First")
                    return false
                }
            }
        } else if indexPath.row == 6 {
            self.didSendLocation()
            return false
        }
        return true
    }
    
}

