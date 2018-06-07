//
//  CreateHolidayPlannerVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 31/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView methods
//========================================
extension CreateHolidayPlannerVC {
    
    func dateCell(cell : DateTimeCell) -> DateTimeCell {
        
        cell.setHolidayPlannerView()
        
        cell.dateTextField.text = self.storeHolidayModel.fromDate
        cell.timeTextField.text = self.storeHolidayModel.toDate
        
        return cell
    }
    
    func originDestinationCell(cell : AddEventCell, indexPath: IndexPath) -> AddEventCell {
        
        cell.eventNameTextField.textColor = AppColors.blackColor
        cell.textFieldEndImageView.isHidden = false
        cell.textFieldEndImageView.image = AppImages.icAddeventLocation
        cell.eventNameTextField.tintColor = UIColor.black
        cell.eventNameTextField.addTarget(self,
                                          action: #selector(textFieldDidChange),
                                          for: .editingChanged)
//        cell.eventNameTextField.delegate = self
        
        if indexPath.row == 1 {
            cell.eventNameTextField.text = self.storeHolidayModel.origin
            cell.eventNameTextField.placeholder = "Origin"
        } else {
            cell.eventNameTextField.text = self.storeHolidayModel.destination
            cell.eventNameTextField.placeholder = "Destination"
        }
        return cell
    }
    
}


//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension CreateHolidayPlannerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateTimeCellId") as? DateTimeCell else { fatalError("DateTimeCell not found") }
            
            return self.dateCell(cell: cell)
            
        case 1,2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddEventCellId") as? AddEventCell else { fatalError("AddEventCell not found") }
            
            return self.originDestinationCell(cell: cell, indexPath: indexPath)
            
        case 3,4:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingDestinationCell", for: indexPath) as? TrendingDestinationCell else { fatalError("TrendingDestinationCell not found") }
            
            if indexPath.row == 3 {
                cell.trendingHeaderLabel.text = "Trending International Destination"
                cell.isNational = false
            } else {
                cell.trendingHeaderLabel.text = "Trending National Destination"
                cell.isNational = true
            }
            cell.delegate = self
            cell.destinationCollectionView.reloadData()

            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdultsKidsCell", for: indexPath) as? AdultsKidsCell else { fatalError("AdultsKidsCell not found") }
            
            if !self.storeHolidayModel.adult.isEmpty {
                cell.adultBtn.setTitle(self.storeHolidayModel.adult, for: .normal)
            }
            if !self.storeHolidayModel.kids.isEmpty {
                cell.kidsBtn.setTitle(self.storeHolidayModel.kids, for: .normal)
            }
            
            cell.adultBtn.addTarget(self,
                                    action: #selector(adultKidsBtnClicked( _ : )),
                                    for: .touchUpInside)
            cell.kidsBtn.addTarget(self,
                                   action: #selector(adultKidsBtnClicked( _ : )),
                                   for: .touchUpInside)
            
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectStayCell", for: indexPath) as? SelectStayCell else { fatalError("SelectStayCell not found") }
            
            if self.storeHolidayModel.isHomeStayHidden {
                cell.radioHomeOnOff.isHidden = true
                cell.homeBtn.isHidden = true
                cell.stayHomeImage.isHidden = true
                cell.stayHomeLabel.isHidden = true
                self.stayState = HolidayStayType.hotels
            } else {
                cell.radioHomeOnOff.isHidden = false
                cell.homeBtn.isHidden = false
                cell.stayHomeImage.isHidden = false
                cell.stayHomeLabel.isHidden = false
            }
            
            if self.stayState == HolidayStayType.hotels {
                cell.radioHotelOnOff.image = AppImages.icChooseMusicRadioOn
                cell.radioHomeOnOff.image = AppImages.icChooseMusicRadioOff
            } else if self.stayState == HolidayStayType.homeStay {
                cell.radioHotelOnOff.image = AppImages.icChooseMusicRadioOff
                cell.radioHomeOnOff.image = AppImages.icChooseMusicRadioOn
            } else {
                cell.radioHotelOnOff.image = AppImages.icChooseMusicRadioOff
                cell.radioHomeOnOff.image = AppImages.icChooseMusicRadioOff
            }
            
            cell.hotelBtn.addTarget(self,
                                    action: #selector(radioBtnClicked( _ : )),
                                    for: .touchUpInside)
            cell.homeBtn.addTarget(self,
                                   action: #selector(radioBtnClicked( _ : )),
                                   for: .touchUpInside)
            
            return cell
            
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RateHotelCell", for: indexPath) as? RateHotelCell else { fatalError("RateHotelCell not found") }
            
            if self.storeHolidayModel.isHomeStayHidden {
                self.stayState = HolidayStayType.hotels
            }
            if self.stayState == HolidayStayType.hotels {
                cell.hotelArrow.isHidden = false
                cell.homeArrow.isHidden = true
            } else if self.stayState == HolidayStayType.homeStay {
                cell.hotelArrow.isHidden = true
                cell.homeArrow.isHidden = false
            }
            switch self.storeHolidayModel.rating {
            case "1":
                cell.firstStarTapped()
            case "2":
                cell.secondStarTapped()
            case "3":
                cell.thirdStarTapped()
            case "4":
                cell.forthStarTapped()
            default:
                cell.fifthStarTapped()
            }
            cell.delegate = self
            /*
             cell.firstStarBtn.addTarget(self,
             action: #selector(rateBtnClicked( _ : )),
             for: .touchUpInside)
             cell.secondStarBtn.addTarget(self,
             action: #selector(rateBtnClicked( _ : )),
             for: .touchUpInside)
             cell.thirdStarBtn.addTarget(self,
             action: #selector(rateBtnClicked( _ : )),
             for: .touchUpInside)
             cell.forthStarBtn.addTarget(self,
             action: #selector(rateBtnClicked( _ : )),
             for: .touchUpInside)
             cell.fifthStarBtn.addTarget(self,
             action: #selector(rateBtnClicked( _ : )),
             for: .touchUpInside)
             */
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoundBtnCellId", for: indexPath) as? RoundBtnCell else { fatalError("RoundBtnCell not found") }
            
            cell.roundBtn.setTitle("Submit", for: .normal)
            cell.roundBtn.addTarget(self,
                                    action: #selector(submitBtnTapped(_ : )),
                                    for: .touchUpInside)
            return cell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
            
            if screenWidth < 322 {
                return 65
            }
            return 70
            
        } else if indexPath.row == 3 || indexPath.row == 4 {
            
            if screenWidth < 322 {
                return 250
            }
            return 250
            
        } else if indexPath.row == 5 || indexPath.row == 6 {
            
            if screenWidth < 322 {
                return 100
            }
            return 100
            
        } else if  indexPath.row == 7 {
            
            if screenWidth < 322 {
                return 135
            }
            return 135
            
        } else {
            
            if screenWidth < 322 {
                return 90
            }
            return 100
        }
    }
}
