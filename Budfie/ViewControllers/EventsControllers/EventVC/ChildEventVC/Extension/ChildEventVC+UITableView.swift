//
//  ChildEventVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 15/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

//MARK: Extension: for UITableView Delegate and DataSource
//========================================================
extension ChildEventVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if self.state == .concert {
        //            return self.obConcertModel.count
        //        } else if self.state == .movies {
        //            return self.obMoviesSeriesModel.count
        //        } else {
        //            return self.calenderEventDict.count
        //        }
        if self.calenderEventDict.isEmpty {
            return 0
        }
        return self.calenderEventDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowEventCellId", for: indexPath) as? ShowEventCell else { fatalError("ShowEventCell not found") }
        
        let model = self.calenderEventDict[indexPath.row]
        
        if self.state == .personal {
            
            cell.eventName.text = model.eventName
            cell.eventTime.text = model.eventStartTime
            cell.eventTime.isHidden = false
            cell.editEventBtn.isUserInteractionEnabled = true
            cell.moviesConcertImage.isHidden = false
            cell.eventTypeImage.isHidden = true
            cell.editEventBtn.setImage(AppImages.icEventsEdit, for: .normal)
            cell.editEventBtn.addTarget(self,
                                        action: #selector(editBtnTapped(_ : )),
                                        for: UIControlEvents.touchUpInside)
            
            if model.eventCategory == "1" || model.eventCategory == "2" || model.eventCategory == "3" || model.eventCategory == "6" || model.eventCategory == "5" {
                cell.editEventBtn.isUserInteractionEnabled = true
                cell.eventName.numberOfLines = 2
                cell.editEventBtn.isHidden = false
//                cell.eventTypeImage.isHidden = true
                cell.moviesConcertImage.setImage(withSDWeb: model.eventImage, placeholderImage: AppImages.myprofilePlaceholder)
                if model.eventCategory == "1" {
                    cell.eventTime.isHidden = true
                } else {
                    cell.eventTime.isHidden = false
                }
                if model.isFavourite == "0" {
                    cell.editEventBtn.setImage(AppImages.icUnselectHeart, for: .normal)
                } else {
                    cell.editEventBtn.setImage(AppImages.icSelectHeart, for: .normal)
                }
                if model.eventCategory == "3" {
                    //cell.eventName.text = model.eventName
                    if model.sportType == "1" {
                        cell.moviesConcertImage.image = AppImages.icCricket
                    } else if model.sportType == "2" {
                        cell.moviesConcertImage.image = AppImages.icSoccer
                    } else if model.sportType == "3" {
                        cell.moviesConcertImage.image = AppImages.icBadminton
                    } else if model.sportType == "4" {
                        cell.moviesConcertImage.image = AppImages.icTennis
                    }
                }
            } else if model.eventCategory == "10" {
                cell.editEventBtn.isUserInteractionEnabled = false
                cell.editEventBtn.isHidden = true
                cell.editEventBtn.setImage(AppImages.icEventsGoogleplus, for: .normal)
                cell.moviesConcertImage.image = AppImages.icEventsGoogleplus
            } else if model.eventCategory == "11" {
                cell.editEventBtn.isUserInteractionEnabled = false
                cell.editEventBtn.isHidden = true
                cell.editEventBtn.setImage(AppImages.icEventsFb, for: .normal)
                cell.moviesConcertImage.image = AppImages.icEventsFb
            } else {
                
                if model.eventImage.isEmpty {
                    let image = getEventListImage(eventName: model.eventType)
                    cell.moviesConcertImage.image = image
//                    cell.eventTypeImage.isHidden = false
//                    cell.moviesConcertImage.isHidden = true
                } else {
                    cell.moviesConcertImage.setImage(withSDWeb: model.eventImage, placeholderImage: AppImages.myprofilePlaceholder)
//                    cell.eventTypeImage.isHidden = true
//                    cell.moviesConcertImage.isHidden = false
                }
                
                if self.calenderEventDict[indexPath.row].userId == AppDelegate.shared.currentuser.user_id {
                    cell.editEventBtn.isHidden = false
                } else {
                    cell.editEventBtn.isHidden = true
                }
            }
        } else if self.state == .concert || self.state == .movies || self.state == .sport {
            cell.editEventBtn.addTarget(self,
                                        action: #selector(unFavBtnTapped(_ : )),
                                        for: UIControlEvents.touchUpInside)
            cell.populateWithMoviesConcert(event: model)
            if self.state == .movies {
                cell.eventTime.isHidden = true
            } else {
                cell.eventTime.isHidden = false
            }
            if self.state == .sport {
                //                cell.eventName.text = model.league
                if model.sportType == "1" {
                    cell.moviesConcertImage.image = AppImages.icCricket
                } else if model.sportType == "2" {
                    cell.moviesConcertImage.image = AppImages.icSoccer
                } else if model.sportType == "3" {
                    cell.moviesConcertImage.image = AppImages.icBadminton
                } else if model.sportType == "4" {
                    cell.moviesConcertImage.image = AppImages.icTennis
                }
            }
            cell.editEventBtn.isUserInteractionEnabled = true
        } else {
            cell.populateWithModel(event: model)
            cell.eventTime.text = "\(model.eventStartTime) - \(model.eventEndTime)"
            cell.editEventBtn.isHidden = true
            cell.eventTypeImage.image = AppImages.icPhone
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.calenderEventDict[indexPath.row]
        
        if self.state == .concert {
            
            let moviesSeriesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
            //AppDelegate.shared.sharedTabbar?.hideTabbar()
            moviesSeriesScene.moviesOrConcert = .concert
            model.eventCategory = "2"
            moviesSeriesScene.delegate = self
            moviesSeriesScene.obEventModel = model
            self.navigationController?.pushViewController(moviesSeriesScene, animated: true)
            
        } else if self.state == .movies {
            
            let moviesSeriesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
            //AppDelegate.shared.sharedTabbar?.hideTabbar()
            moviesSeriesScene.moviesOrConcert = .movies
            model.eventCategory = "1"
            moviesSeriesScene.delegate = self
            moviesSeriesScene.obEventModel = model
            self.navigationController?.pushViewController(moviesSeriesScene, animated: true)
            
        }  else if self.state == .sport {
            
            var sportType: SportDetailVC.SportType = .soccer
            
            if model.sportType == "1" {
                sportType = .cricket
                model.eventCategory = "5"
            } else if model.sportType == "2" {
                sportType = .soccer
                model.eventCategory = "3"
            } else if model.sportType == "3" {
                sportType = .batminton
                model.eventCategory = "6"
            } else if model.sportType == "4" {
                sportType = .tennis
                model.eventCategory = "7"
            }
            
            let sportDetailScene = SportDetailVC.instantiate(fromAppStoryboard: .Events)
            //AppDelegate.shared.sharedTabbar?.hideTabbar()
            sportDetailScene.vcType = sportType
            sportDetailScene.delegate = self
            sportDetailScene.eventModel = model
            self.navigationController?.pushViewController(sportDetailScene, animated: true)
            
        } else if self.state == .personal {
            
            if model.eventCategory == "10" {
                
                
            } else {
                
                //AppDelegate.shared.sharedTabbar?.hideTabbar()
                
                if model.eventCategory == "1" {
                    let moviesSeriesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
                    moviesSeriesScene.obEventModel = model
                    moviesSeriesScene.delegate = self
                    moviesSeriesScene.moviesOrConcert = .movies
                    self.navigationController?.pushViewController(moviesSeriesScene, animated: true)
                    
                } else if model.eventCategory == "2" {
                    let moviesSeriesScene = MoviesSeriesVC.instantiate(fromAppStoryboard: .Events)
                    moviesSeriesScene.obEventModel = model
                    moviesSeriesScene.delegate = self
                    moviesSeriesScene.moviesOrConcert = .concert
                    self.navigationController?.pushViewController(moviesSeriesScene, animated: true)
                    
                } else if model.eventCategory == "3" || model.eventCategory == "5" || model.eventCategory == "6" || model.eventCategory == "7" {
                    
                    var sportType: SportDetailVC.SportType = .soccer
                    
                    if model.sportType == "1" {
                        sportType = .cricket
                    } else if model.sportType == "2" {
                        sportType = .soccer
                    } else if model.sportType == "3" {
                        sportType = .batminton
                    } else if model.sportType == "4" {
                        sportType = .tennis
                    }
                    
                    let sportDetailScene = SportDetailVC.instantiate(fromAppStoryboard: .Events)
                    sportDetailScene.eventModel = model
                    sportDetailScene.vcType = sportType
                    sportDetailScene.delegate = self
                    self.navigationController?.pushViewController(sportDetailScene, animated: true)
                    
                } else {

                    if model.eventType == "Holiday" {

                        let holidayPlannerEventScene = HolidayPlannerEventVC.instantiate(fromAppStoryboard: .HolidayPlanner)
                        holidayPlannerEventScene.plannerEvent = model
                        holidayPlannerEventScene.delegate = self
                        navigationController?.pushViewController(holidayPlannerEventScene, animated: true)

                    } else {

                        let editEventScene = EditEventVC.instantiate(fromAppStoryboard: .Events)
                        editEventScene.obEventModel = model
                        editEventScene.eventState = .view
                        editEventScene.delegateForPersonalEvents = self
                        self.navigationController?.pushViewController(editEventScene, animated: true)
                    }
                }
            }
        }
    }
    
}
