//
//  AddEventsVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 15/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK: Extension: UITableView private methods
//============================================
extension AddEventsVC {
    
    func headerViewMethod(headerView: AddEventHeaderView) -> AddEventHeaderView {
        
        if let img = self.eventImage {
            headerView.eventsImage.image = img
            headerView.cameraImageBtn.isHidden = true
            cameraBtn.isHidden = false
            headerView.addPhotoLabel.isHidden = true
        }
        headerView.eventsImage.curvHeaderView(height: 250)
        headerView.overlayView.curvHeaderView(height: 250)
        /*
        headerView.backBtn.addTarget(self, action: #selector(self.backBtnTapped(_:)), for: .touchUpInside)
        headerView.cameraImageBtn.addTarget(self,
                                            action: #selector(cameraBtnTapped(_ :)),
                                            for: .touchUpInside)
        headerView.sideCameraBtn.addTarget(self,
                                           action: #selector(cameraBtnTapped(_ :)),
                                           for: .touchUpInside)
        */
        return headerView
    }
    
    func eventNameCell(addEventCell: AddEventCell) -> AddEventCell {
        
        addEventCell.eventNameTextField.tintColor = UIColor.blue
        addEventCell.eventNameTextField.text = self.storeFormData[StringConstants.Event_Name.localized]
        addEventCell.populate(placeholderName: StringConstants.Event_Name.localized,
                              isDownArrow: false,
                              isLocation: false)
        addEventCell.eventNameTextField.addTarget(self,
                                                  action: #selector(textFieldValueChanged(_ : )),
                                                  for: .editingChanged)
        return addEventCell
    }
    
    func eventTypeCell(addEventCell: AddEventCell) -> AddEventCell {
        
        addEventCell.eventNameTextField.tintColor = UIColor.clear
        addEventCell.eventNameTextField.text = self.storeFormData[StringConstants.Event_Type.localized]
        addEventCell.eventNameTextField.delegate = self
        addEventCell.populate(placeholderName: StringConstants.Event_Type.localized,
                              isDownArrow: true,
                              isLocation: false)
        addEventCell.locationBtn.addTarget(self,
                                           action: #selector(eventTypeBtnTapped),
                                           for: .touchUpInside)

        addEventCell.eventNameTextField.inputView = pickerView
        addEventCell.eventNameTextField.inputAccessoryView = pickerToolbar

        /*
         MultiPicker.noOfComponent = 1
         MultiPicker.openMultiPickerIn(addEventCell.eventNameTextField,
         firstComponentArray: self.eventType,
         secondComponentArray: [],
         firstComponent: nil,
         secondComponent: nil,
         titles: [""],
         doneBlock: { (str1, str2) in

         addEventCell.eventNameTextField.text = str1
         self.storeFormData[StringConstants.Event_Type.localized] = str1

         if let image = self.storeFormData[StringConstants.event_image.localized], image.isEmpty {
         self.headerView.eventsImage.image = getEventDetailsImage(eventName: str1)
         addEventCell.textFieldEndImageView.image = getEventListImage(eventName: str1)
         self.headerView.cameraImageBtn.isHidden = true
         self.headerView.addPhotoLabel.isHidden = true
         self.cameraBtn.isHidden = false
         }
         })
         */
        
        return addEventCell
    }
    
    func locationCell(addEventCell: AddEventCell) -> AddEventCell {
        
        addEventCell.locationBtn.addTarget(self,
                                           action: #selector(locationBtnTapped),
                                           for: .touchUpInside)
        addEventCell.eventNameTextField.tintColor = UIColor.black
        addEventCell.eventNameTextField.text = self.storeFormData[StringConstants.Location.localized]
        addEventCell.eventNameTextField.addTarget(self, action: #selector(getLocationByUser), for: .editingChanged)
        addEventCell.populate(placeholderName: StringConstants.Location.localized,
                              isDownArrow: false,
                              isLocation: true)
        
        return addEventCell
    }
    
    func remindMeCell(addEventCell: AddEventCell) -> AddEventCell {
        
        addEventCell.eventNameTextField.tintColor = UIColor.clear
        addEventCell.eventNameTextField.text = self.storeFormData[StringConstants.Remind_Me.localized]
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
                                        self.storeFormData[StringConstants.Remind_Me.localized] = str1
        })
        return addEventCell
    }
    
    func dateAndTimeCell(dateTimeCell: DateTimeCell) -> DateTimeCell {
        
        dateTimeCell.dateTextField.text = self.storeFormData[StringConstants.Date.localized]
        dateTimeCell.timeTextField.text = self.storeFormData[StringConstants.Time.localized]
//        dateTimeCell.dateTextField.titleColor = UIColor.clear
//        dateTimeCell.timeTextField.titleColor = UIColor.clear
        dateTimeCell.timeTextField.delegate = self
        
        // DatePicker
        let minDate = Date()
        let maxDate = Calendar.current.date(byAdding: .year, value:3 , to: minDate)
        
        DatePicker.openDatePickerIn(dateTimeCell.dateTextField,
                                    outPutFormate: DateFormat.dOBServerFormat.rawValue,
                                    mode: .date,
                                    minimumDate: minDate,
                                    maximumDate: maxDate!,
                                    selectedDate: minDate,
                                    doneBlock: { (dateStr,date) in
                                        
                                        self.eventDate = date
                                        
                                        let dateShow = date.toString(dateFormat: DateFormat.showDateFormat.rawValue)
                                        
                                        dateTimeCell.dateTextField.text = dateShow
                                        self.storeFormData[StringConstants.Date.localized] = dateShow
                                        dateTimeCell.timeTextField.text = ""
                                        self.storeFormData[StringConstants.Time.localized] = ""
                                        self.addEventTableView.reloadRows(at: [[0,2]], with: .none)
        })
        
        DatePicker.openDatePickerIn(dateTimeCell.timeTextField,
                                    outPutFormate: DateFormat.timein12Hour.rawValue,
                                    mode: .time,
                                    minimumDate: minDate,
//                                    maximumDate: maxDate!,
                                    selectedDate: self.eventDate,
                                    doneBlock: { (dateStr,date) in
                                        
                                        // Converting String Date to Date Format
                                        dateTimeCell.timeTextField.text = dateStr
                                        self.storeFormData[StringConstants.Time.localized] = dateStr
        })
        
        return dateTimeCell
    }
    
    func recurringCell(tableView: UITableView, indexPath: IndexPath) -> RecurringEventCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecurringEventCell", for: indexPath) as? RecurringEventCell else { fatalError("RecurringEventCell not found") }
        
        if self.isRecurring {
            cell.yesRadioImage.image = AppImages.icChooseMusicRadioOn
            cell.noRadioImage.image = AppImages.icChooseMusicRadioOff
        } else {
            cell.yesRadioImage.image = AppImages.icChooseMusicRadioOff
            cell.noRadioImage.image = AppImages.icChooseMusicRadioOn
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
        cell.textFieldEndImageView.isHidden = false

        if let recurringTime = self.storeFormData["recurringDate"], !recurringTime.isEmpty {
            cell.eventNameTextField.text = getRecurringType(byIndex: recurringTime)
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
                                        self.storeFormData["recurringDate"] = getRecurringType(byName: str1)
        })
        
        return cell
    }
    
}


//MARK: Extension: for Delagates and DataSource of UITableView
//============================================================
extension AddEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6+3
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {

            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableTopCurveHeaderFooterView") as? TableTopCurveHeaderFooterView else { fatalError("TableTopCurveHeaderFooterView not found") }

            headerCell.shareBtn.isHidden = true
            //headerCell.shareBtn.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
            return headerCell

            /*
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView else { fatalError("AddEventHeaderView not found") }
            
            return self.headerViewMethod(headerView: headerView)
            */
            
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
            case 0,1,7,6:
                guard var addEventCell = tableView.dequeueReusableCell(withIdentifier: "AddEventCellId") as? AddEventCell else { fatalError("AddEventCell not found") }
                
                if indexPath.row == 1 {
                    //EventName
                    addEventCell = self.eventNameCell(addEventCell: addEventCell)
                    
                } else if indexPath.row == 0 {
                    //EventType
                    addEventCell = self.eventTypeCell(addEventCell: addEventCell)
                    
                } else if indexPath.row == 6 {
                    //Location
                    addEventCell = self.locationCell(addEventCell: addEventCell)
                    
                } else {
                    //Reminde Me
                    addEventCell = self.remindMeCell(addEventCell: addEventCell)
                }
                return addEventCell
                
            case 2:
                guard let dateTimeCell = tableView.dequeueReusableCell(withIdentifier: "DateTimeCellId") as? DateTimeCell else { fatalError("DateTimeCell not found") }
                
                return self.dateAndTimeCell(dateTimeCell: dateTimeCell)
                
            case 3:
                return self.recurringCell(tableView: tableView, indexPath: indexPath)
                
            case 4:
                return self.recurringDateCell(tableView: tableView, indexPath: indexPath)
                
            case 5:
                return self.recurringDateCell(tableView: tableView, indexPath: indexPath)
                
            default:
                guard let roundBtnCell = tableView.dequeueReusableCell(withIdentifier: "RoundBtnCellId") as? RoundBtnCell else { fatalError("RoundBtnCell not found") }
                
                roundBtnCell.roundBtn.addTarget(self,
                                                action: #selector(submitBtnTapped(_ : )),
                                                for: .touchUpInside)
                return roundBtnCell
            }
            
        case 1:
            
            guard let greetingCell = tableView.dequeueReusableCell(withIdentifier: "EditGreetingCellId") as? EditGreetingCell else { fatalError("EditGreetingCell not found") }
            
            return greetingCell
            
        default:
            
            guard let moreFriend = tableView.dequeueReusableCell(withIdentifier: "MoreFriendsCellId") as? MoreFriendsCell else { fatalError("MoreFriendsCell not found") }
            
            return moreFriend
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 5 {
                return CGFloat.leastNonzeroMagnitude
            }
            
            if !isRecurring {
                if indexPath.row == 4 {
                    return CGFloat.leastNonzeroMagnitude
                }
            }
            
            if screenWidth < 322 {
                if indexPath.row == 8 {
                    return 70
                }
                return 60
            } else {
                if indexPath.row == 8 {
                    return 100
                }
                return 75
            }
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
        /*
        if section == 0 {
            return 250
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
        */
    }

//    @objc func shareBtnTapped(_ sender: UIButton) {
//        CommonClass.showToast(msg: "Under Development")
//    }
    
}

//MARK: Extension: for UIScrollViewDelegate
//=========================================
extension AddEventsVC: UIScrollViewDelegate {

    // To make sure tableview do not scrolls more than screenHeight
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= -screenHeight) {
            scrollView.contentOffset = CGPoint(x: 0, y: (1 - screenHeight))
        }
    }
}


class RecurringEventCell: UITableViewCell {
    
    @IBOutlet weak var yesRadioImage: UIImageView!
    @IBOutlet weak var noRadioImage: UIImageView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var bottomLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.recurrin.backgroundColor    = AppColors.addEventBaseLine
    }
    
}
