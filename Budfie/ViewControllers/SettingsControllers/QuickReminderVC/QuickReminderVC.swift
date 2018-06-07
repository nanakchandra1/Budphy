//
//  QuickReminderVC.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

protocol DoRefreshOnPop: class {
    func hitService()
}

class QuickReminderVC: BaseVc {

    // MARK: Public Properties
    var reminderModel = QuickReminderModel()
    let repeatTypeArray  = ["Daily","Weekly","Monthly","Yearly"]
    weak var delegate: DoRefreshOnPop?

    var reminderTypes = ["Health","Call","Bill Payment","Others"]

    lazy var pickerView = UIPickerView()
    lazy var pickerToolbar = UIToolbar()

    // MARK: Private Properties
    fileprivate var tablePlaceholderText = ""
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var showReminderOptionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
        self.initialSetup()
        self.registerNibs()
    }

    private func setupToolbar() {

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelButtonTapped))

        cancelButton.tintColor = AppColors.systemBlueColor

        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(pickerDoneButtonTapped))

        doneButton.tintColor = AppColors.systemBlueColor

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        pickerToolbar.sizeToFit()
        let toolbarItems = [cancelButton, spaceButton, doneButton]
        pickerToolbar.setItems(toolbarItems, animated: true)
        pickerToolbar.backgroundColor = UIColor.lightText
    }

    @objc private func pickerCancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }

    @objc private func pickerDoneButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)

        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let typeText = reminderTypes[selectedRow]

        self.reminderModel.type = self.getReminderType(text: typeText)
        self.showReminderOptionsTableView.reloadData()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectReminderType(_ sender: UIButton) {
        
        guard let cell = sender.getTableViewCell as? HealthCallBillCell else { return }
        
        switch sender {
        case cell.healthBtn:
            self.reminderModel.type = "1"
            
        case cell.callBtn:
            self.reminderModel.type = "2"

        default:
            self.reminderModel.type = "3"
            
        }
        self.showReminderOptionsTableView.reloadData()
    }
    
    @objc func submitBtnTapped() {
        view.endEditing(true)
        if !checkForEmpty() {
            return
        }
        hitQuickReminder()
    }
    /*
    @objc func readName(_ sender: UITextField) {
        
        if let text = sender.text, !text.isEmpty {
            self.reminderModel.name = text
        }
    }
    */
}


//MARK:- Private Extension
//========================
extension QuickReminderVC {
    
    private func initialSetup() {

        pickerView.dataSource = self
        pickerView.delegate = self

        self.showReminderOptionsTableView.delegate = self
        self.showReminderOptionsTableView.dataSource = self
        self.showReminderOptionsTableView.backgroundColor = UIColor.clear
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "QuickReminderCell", bundle: nil)
        self.showReminderOptionsTableView.register(cell, forCellReuseIdentifier: "QuickReminderCell")
        
        let roundCell = UINib(nibName: "RoundBtnCell", bundle: nil)
        self.showReminderOptionsTableView.register(roundCell, forCellReuseIdentifier: "RoundBtnCellId")
        
    }
    
    fileprivate func checkForEmpty() -> Bool {
        
        if self.reminderModel.type.isEmpty {
            CommonClass.showToast(msg: "Please enter reminder type")
            return false
        }
        if self.reminderModel.date.isEmpty {
            CommonClass.showToast(msg: "Please enter date")
            return false
        }
        if self.reminderModel.time.isEmpty {
            CommonClass.showToast(msg: "Please enter time")
            return false
        }
        return true
    }
    
    func getNameReminder(text: String) -> (String, UIImage) {
        
        switch text {
        case "1":
            return ("Health", AppImages.icReminderHealthSelected)
        case "2":
            return ("Call", AppImages.icReminderCallSelected)
        case "3":
            return ("Bill Payment", AppImages.icReminderBillpaymentSelected)
        case "4":
            return ("Others", AppImages.icEventsOthers)
        default:
            return ("", AppImages.icAddeventDropdown)
        }
    }
    
    func getReminderType(text: String) -> String {
        
        switch text {
        case "Health":
            return "1"
        case "Call":
            return "2"
        case "Bill Payment":
            return "3"
        case "Others":
            return "4"
        default:
            return ""
        }
    }
    
    //MARK:- hitQuickReminder method
    //==============================
    func hitQuickReminder() {
        
        var params = JSONDictionary()

        if !reminderModel.id.isEmpty {
            params["reminder_id"]        = reminderModel.id
            params["method"]        = "edit"
        } else {
            params["method"]        = "custom"
        }
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["type"]          = self.reminderModel.type
        params["name"]          = self.reminderModel.name //"Quick Reminder"
        params["datetime"]      = "\(self.reminderModel.date) \(self.reminderModel.time)"
        params["repeat"]        = self.reminderModel.repeatReminder
        
        WebServices.quickReminder(parameters: params, success: { [weak self] (isSucces) in

            guard let strongSelf = self else {
                return
            }
            
            if isSucces {
                CommonClass.showToast(msg: "Your Reminder Set Successfully")
                strongSelf.delegate?.hitService()
                strongSelf.navigationController?.popViewController(animated: true)
            }

        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
}

// MARK: PickerView DataSource Methods
extension QuickReminderVC: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderTypes.count
    }
}

// MARK: PickerView Delegate Methods
extension QuickReminderVC: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let eventTypeView: EventTypePickerView

        if let typeView = view as? EventTypePickerView {
            eventTypeView = typeView
        } else {
            eventTypeView = EventTypePickerView()
        }

        let typeText = reminderTypes[row]
        let type = getReminderType(text: typeText)
        let (reminderText, reminderImage) = getNameReminder(text: type)

        eventTypeView.pickerlabel.text = reminderText
        eventTypeView.pickerImage.image = reminderImage

        return eventTypeView
    }
}

