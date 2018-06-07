//
//  QuickReminderVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension QuickReminderVC {
    
    private func healthCallBillCellSetting(cell: HealthCallBillCell) -> HealthCallBillCell {
        
        cell.selectOption(type: self.reminderModel.type)
        cell.healthBtn.addTarget(self,
                                 action: #selector(selectReminderType),
                                 for: .touchUpInside)
        cell.callBtn.addTarget(self,
                               action: #selector(selectReminderType),
                               for: .touchUpInside)
        cell.billBtn.addTarget(self,
                               action: #selector(selectReminderType),
                               for: .touchUpInside)
        
        return cell
    }
    
    private func nameCellSetting(cell: QuickReminderCell, row: Int) -> QuickReminderCell {
        
//        cell.eventNameTextField.keyboardType = .namePhonePad
        cell.eventNameTextField.tintColor = UIColor.clear
//        cell.eventNameTextField.addTarget(self,
//                                          action: #selector(readName),
//                                          for: .editingChanged)

        if row == 2 {
            cell.settingCell(placeholderName: "Reminder Title",
                             isDownArrow: false,
                             isCalendar: false,
                             isClock: false)

            cell.eventNameTextField.text = reminderModel.name
            cell.eventNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return cell
        }

        cell.settingCell(placeholderName: "Reminder Type",
                         isDownArrow: true,
                         isCalendar: false,
                         isClock: false)

        cell.eventNameTextField.inputView = pickerView
        cell.eventNameTextField.inputAccessoryView = pickerToolbar

        /*
         MultiPicker.noOfComponent = 1
         MultiPicker.openMultiPickerIn(cell.eventNameTextField,
         firstComponentArray: reminderTypes,
         secondComponentArray: [],
         firstComponent: nil,
         secondComponent: nil,
         titles: [""],
         doneBlock: { (str1, str2) in

         self.reminderModel.type = self.getReminderType(text: str1)
         self.showReminderOptionsTableView.reloadData()
         })
        */
        
        let (reminderText, reminderImage) = getNameReminder(text: self.reminderModel.type)
        cell.eventNameTextField.text = reminderText
        cell.textFieldEndImageView.image = reminderImage

        return cell
    }
    
    private func dateTimeCellSetting(cell: QuickReminderCell, row: Int) -> QuickReminderCell {
        
        var minDate = Date()
        let maxDate = Calendar.current.date(byAdding: .year, value:1 , to: Date())
        
        if row == 3 {
            cell.settingCell(placeholderName: StringConstants.Date.localized,
                             isDownArrow: false,
                             isCalendar: true,
                             isClock: false)
            
            if !reminderModel.date.isEmpty {
                if let date = reminderModel.date.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                    cell.eventNameTextField.text = date.toString(dateFormat: DateFormat.showDateFormat.rawValue)
                }
            }
            
            DatePicker.openDatePickerIn(cell.eventNameTextField,
                                        outPutFormate: DateFormat.calendarDate.rawValue,
                                        mode: .date,
                                        minimumDate: minDate,
                                        maximumDate: maxDate!,
                                        selectedDate: Date(),
                                        doneBlock: { (dateStr,date) in
                                            
                                            let dateShow = date.toString(dateFormat: DateFormat.showDateFormat.rawValue)
                                            
                                            cell.eventNameTextField.text = dateShow
                                            self.reminderModel.date = dateStr
            })
            return cell
            
        } else {
            
            cell.settingCell(placeholderName: StringConstants.Time.localized,
                             isDownArrow: false,
                             isCalendar: false,
                             isClock: true)
            
            if !reminderModel.time.isEmpty {
                if let date = reminderModel.time.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                    cell.eventNameTextField.text = date.toString(dateFormat: DateFormat.timein12Hour.rawValue)
                } else if let date = reminderModel.time.toDate(dateFormat: DateFormat.fullTime.rawValue) {
                    cell.eventNameTextField.text = date.toString(dateFormat: DateFormat.timein12Hour.rawValue)
                }
            }
            
            if !self.reminderModel.date.isEmpty {
                if let minD = self.reminderModel.date.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) {
                    minDate = minD
                }
            }
            
            DatePicker.openDatePickerIn(cell.eventNameTextField,
                                        outPutFormate: DateFormat.fullTime.rawValue,
                                        mode: .time,
                                        minimumDate: minDate,
                                        maximumDate: maxDate!,
                                        selectedDate: Date(),
                                        doneBlock: { (dateStr,date) in
                                            
                                            let dateShow = date.toString(dateFormat: DateFormat.timein12Hour.rawValue)
                                            
                                            // Converting String Date to Date Format
                                            cell.eventNameTextField.text = dateShow
                                            self.reminderModel.time = dateStr
            })
            
            return cell
        }
    }
    
    private func RepeatCellSetting(cell: QuickReminderCell) -> QuickReminderCell {
        
        cell.settingCell(placeholderName: StringConstants.K_Repeat.localized,
                         isDownArrow: true,
                         isCalendar: false,
                         isClock: false)
        
        if !self.reminderModel.repeatReminder.isEmpty {
            cell.eventNameTextField.text = getRecurringType(byIndex: self.reminderModel.repeatReminder)
        }
        // PickerView
        MultiPicker.noOfComponent = 1
        MultiPicker.openMultiPickerIn(cell.eventNameTextField,
                                      firstComponentArray: self.repeatTypeArray,
                                      secondComponentArray: [],
                                      firstComponent: nil,
                                      secondComponent: nil,
                                      titles: [""],
                                      doneBlock: { (str1, str2) in
                                        cell.eventNameTextField.text = str1
                                        self.reminderModel.repeatReminder = getRecurringType(byName: str1)
        })
        
        return cell
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let name = textField.text {
            reminderModel.name = name
        }
    }
    
}

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension QuickReminderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HealthCallBillCell") as? HealthCallBillCell else {
                fatalError("HealthCallBillCell not found")
            }
            
            return self.healthCallBillCellSetting(cell: cell)
            
        } else if indexPath.row == 6 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoundBtnCellId") as? RoundBtnCell else {
                fatalError("RoundBtnCell not found")
            }

            let buttonText = reminderModel.id.isEmpty ? "CREATE":"UPDATE"
            cell.roundBtn.setTitle(buttonText, for: .normal)

            cell.contentView.backgroundColor = UIColor.clear
            cell.roundBtn.addTarget(self,
                                    action: #selector(submitBtnTapped),
                                    for: .touchUpInside)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuickReminderCell") as? QuickReminderCell else {
            fatalError("QuickReminderCell not found")
        }
        
        switch indexPath.row {
            
        case 1, 2:
            return self.nameCellSetting(cell: cell, row: indexPath.row)
            
        case 3:
            return self.dateTimeCellSetting(cell: cell, row: indexPath.row)
            
        case 4:
            return self.dateTimeCellSetting(cell: cell, row: indexPath.row)
            
        default:
            return self.RepeatCellSetting(cell: cell)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return CGFloat.leastNonzeroMagnitude
        } else if indexPath.row == 6 {
            return 80
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}


class HealthCallBillCell: UITableViewCell {
    
    @IBOutlet weak var healthBtn        : UIButton!
    @IBOutlet weak var callBtn          : UIButton!
    @IBOutlet weak var billBtn          : UIButton!
    @IBOutlet weak var healthImageView  : UIImageView!
    @IBOutlet weak var callImageView    : UIImageView!
    @IBOutlet weak var billImageView    : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.contentView.endEditing(true)
    }
    
    func selectOption(type: String) {
        
        initialSetup()
        
        switch type {
        case "1":
            healthImageView.image = AppImages.icReminderHealthSelected
        case "2":
            callImageView.image = AppImages.icReminderCallSelected
        case "3":
            billImageView.image = AppImages.icReminderBillpaymentSelected
        default:
            break
        }
        
    }
    
    private func initialSetup() {
        healthImageView.image = AppImages.icReminderHealthUnselect
        callImageView.image = AppImages.icReminderCallUnselect
        billImageView.image = AppImages.icReminderBillpaymentUnselect
    }
    
}
