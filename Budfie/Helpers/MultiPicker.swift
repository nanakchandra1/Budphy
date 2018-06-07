//
//  ViewCustomerVC.swift
//  YoDwollaDemo
//
//  Created by  on 24/10/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//


import UIKit

class MultiPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal typealias PickerDone = (_ firstValue: String, _ secondValue: String) -> Void
    fileprivate var doneBlock : PickerDone!
    
    fileprivate var firstValueArray : [String]?
    fileprivate var secondValueArray = [String]()
    static var noOfComponent = 2
    
    
    class func openMultiPickerIn(_ textField: UITextField? ,
                                 firstComponentArray: [String],
                                 secondComponentArray: [String],
                                 firstComponent: String?,
                                 secondComponent: String?,
                                 titles: [String]?, doneBlock: @escaping PickerDone) {
        
        let picker = MultiPicker()
        picker.doneBlock = doneBlock
        
        picker.openPickerInTextField(textField,
                                     firstComponentArray: firstComponentArray,
                                     secondComponentArray: secondComponentArray,
                                     firstComponent: firstComponent,
                                     secondComponent: secondComponent)
        
        if titles != nil {
            
            let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/4 - 10,
                                              y: 0,
                                              width: 100,
                                              height: 30))
            
            label.text = titles![0].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            
            picker.addSubview(label)
            
            if MultiPicker.noOfComponent > 1 {
                
                let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width * 3/4 - 50,
                                                  y: 0,
                                                  width: 100,
                                                  height: 30))
                
                label.text = titles![1].uppercased()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                
                picker.addSubview(label)
            } else {
                
                label.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width,
                                     height: 30)
                
                label.textAlignment = NSTextAlignment.center
            }
        }
    }
    
    fileprivate func openPickerInTextField(_ textField: UITextField?,
                                       firstComponentArray: [String],
                                       secondComponentArray: [String],
                                       firstComponent: String?, secondComponent: String?) {
        
        firstValueArray  = firstComponentArray
        secondValueArray = secondComponentArray
        
        self.delegate = self
        self.dataSource = self
        
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = AppColors.systemBlueColor
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = AppColors.systemBlueColor
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
        
        let index = self.firstValueArray?.index(where: {$0 == firstComponent })
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
        
        if MultiPicker.noOfComponent > 1 {
            let index1 = self.secondValueArray.index(where: {$0 == secondComponent })
            self.selectRow(index1 ?? 0, inComponent: 1, animated: true)
        }
    }
    
    @IBAction fileprivate func pickerCancelButtonTapped() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction fileprivate func pickerDoneButtonTapped() {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let index1 : Int?
        let firstValue : String?
        index1 = self.selectedRow(inComponent: 0)
        
        if firstValueArray?.count == 0{return}
        else{firstValue = firstValueArray?[index1!]}
        
        var index2 :Int!
        var secondValue: String!
        if MultiPicker.noOfComponent > 1 {
            index2 = self.selectedRow(inComponent: 1)
            secondValue = secondValueArray[index2]
        }
        self.doneBlock(firstValue!, secondValue ?? "")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return firstValueArray!.count
        }
        return secondValueArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return MultiPicker.noOfComponent
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
            
        case 0:
            return firstValueArray?[row]
        case 1:
            return secondValueArray[row]
        default:
            return ""
        }
    }
}







class DatePicker: UIDatePicker {
    
    internal typealias PickerDone = (_ selection: String,_ date:Date) -> Void
    fileprivate var doneBlock: PickerDone!
    fileprivate var datePickerFormat: String = ""
    
    
    fileprivate var dateFormatter: DateFormatter {
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = self.datePickerFormat
        let enUSPOSIXLocale: Locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale
        
        return dateFormatter
    }
    
    
    class func openDatePickerIn(_ textField: UITextField?,
                                outPutFormate: String,
                                mode: UIDatePickerMode,
                                minimumDate: Date? = nil,
                                maximumDate: Date? = nil,
                                minuteInterval: Int = 1,
                                selectedDate: Date?, doneBlock: @escaping PickerDone) {
        
        let picker = DatePicker()
        picker.doneBlock = doneBlock
        picker.datePickerFormat = outPutFormate
        picker.datePickerMode = mode
        picker.dateFormatter.dateFormat = outPutFormate
        
        if let sDate = selectedDate {
            picker.setDate(sDate, animated: false)
        }
        picker.minuteInterval = minuteInterval
        
        if mode == .time {
            
            if let sDate = selectedDate, let minDate = minimumDate {
                
                let calendar = Calendar.current
                let startOfSelectedDate = calendar.startOfDay(for: sDate)
                let startOfCurrentDate = calendar.startOfDay(for: minDate)
                
                if startOfSelectedDate == startOfCurrentDate {
                    picker.minimumDate = minDate
                    
                    if let maxDate = maximumDate {
                        picker.maximumDate = maxDate
                    }
                }
            }
        } else {
            picker.minimumDate = minimumDate
            picker.maximumDate = maximumDate
        }
        
        picker.openDatePickerInTextField(textField)
    }
    
    fileprivate func openDatePickerInTextField(_ textField: UITextField?) {
        
        if let text = textField?.text, !text.isEmpty, let selDate = self.dateFormatter.date(from: text) {
            self.setDate(selDate, animated: false)
        }
        
        self.addTarget(self, action: #selector(DatePicker.datePickerChanged(_:)), for: UIControlEvents.valueChanged)
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerCancelButtonTapped))
        
        cancelButton.tintColor = AppColors.systemBlueColor
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self,
                                         action: #selector(pickerDoneButtonTapped))
        
        doneButton.tintColor = AppColors.systemBlueColor
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                          target: nil,
                                          action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField?.inputView = self
        textField?.inputAccessoryView = toolbar
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        //        let selected = self.dateFormatter.string(from: sender.date)
        
        //        self.doneBlock(selected)
    }
    
    @IBAction fileprivate func pickerCancelButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction fileprivate func pickerDoneButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let selected = self.dateFormatter.string(from: self.date)
        
        self.doneBlock(selected,self.date)
    }
}
