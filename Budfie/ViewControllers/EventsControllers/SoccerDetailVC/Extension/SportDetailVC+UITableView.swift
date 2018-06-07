//
//  SportDetailVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 06/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

extension SportDetailVC {
    
    private func soccerCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {

        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDetailCell", for: indexPath) as? SportDetailCell else {
                fatalError("SportDetailCell not found")
            }

            if let detail = sportDetail {
                cell.populate(with: detail)
            }

            return cell

        case (sportDetail.goals.count + 2):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                fatalError("SportDescriptionCell not found")
            }

            return cell

        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoccerGoalScoreCell", for: indexPath) as? SoccerGoalScoreCell else {
                fatalError("SoccerGoalScoreCell not found")
            }

            if indexPath.row == 1 {
                cell.scoreLbl.font = AppFonts.Comfortaa_Regular_0.withSize(18)
                cell.scoreLbl.text = "Goal Score Card"
            } else {
                let index = indexPath.row - 2
                let goal = sportDetail.goals[index]
                cell.scoreLbl.font = AppFonts.Comfortaa_Regular_0.withSize(15)
                cell.scoreLbl.text = "\(index + 1). \(goal.playerName) (\(goal.teamId)) - \(goal.minute) min"
            }

            return cell
        }
    }
    
    private func cricketCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        // Match Status(1=notstarted,2=started,3=completed),
        // type(1=t20,2=one-day,3=test)
        
        if let detail = cricketDetail, detail.match_status == "1", detail.type == "2" || detail.type == "1"  || detail.type == "3" {
            
            if indexPath.row != 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                    fatalError("SportDescriptionCell not found")
                }
                cell.descriptionLbl.text = cricketDetail.description
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StartODICell", for: indexPath) as? StartODICell else {
                fatalError("StartODICell not found")
            }
            
            if let detail = cricketDetail {
                cell.populate(with: detail)
            }
            
            return cell
            
        } else if let detail = cricketDetail, detail.match_status == "2", detail.type == "2" || detail.type == "1" {
            
            if indexPath.row != 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                    fatalError("SportDescriptionCell not found")
                }
                cell.descriptionLbl.text = cricketDetail.description
                return cell
            }
            
            if cricketDetail.innings[1].current_player1 == "" && (cricketDetail.innings[1].team_run == "0" || cricketDetail.innings[1].team_run == "") {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "InprogressODICell", for: indexPath) as? InprogressODICell else {
                    fatalError("InprogressODICell not found")
                }
                
                if let detail = cricketDetail {
                    cell.populate(with: detail)
                }
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Inprogress2InningODICell", for: indexPath) as? Inprogress2InningODICell else {
                    fatalError("Inprogress2InningODICell not found")
                }
                
                if let detail = cricketDetail {
                    cell.populate(with: detail)
                }
                
                return cell
            }
            
        } else if let detail = cricketDetail, detail.match_status == "3", detail.type == "1" || detail.type == "2" {
            
            if indexPath.row != 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                    fatalError("SportDescriptionCell not found")
                }
                cell.descriptionLbl.text = cricketDetail.description
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "completedODICell", for: indexPath) as? completedODICell else {
                fatalError("completedODICell not found")
            }
            
            if let detail = cricketDetail {
                cell.populate(with: detail)
            }
            return cell
            
        } else if let detail = cricketDetail, detail.match_status == "2", detail.type == "3" {
            
            if indexPath.row == 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHeadCell", for: indexPath) as? MatchHeadCell else {
                    fatalError("MatchHeadCell not found")
                }
                
                if let detail = cricketDetail {
                    cell.populate(with: detail)
                }
                
                return cell
                
            } else if indexPath.row == (1+cricketDetail.innings.count) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TossCell", for: indexPath) as? TossCell else {
                    fatalError("TossCell not found")
                }
                cell.tossLbl.text = cricketDetail.toss
                return cell
                
            } else if indexPath.row == (2+cricketDetail.innings.count) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                    fatalError("SportDescriptionCell not found")
                }
                cell.descriptionLbl.text = cricketDetail.description
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InningsCell", for: indexPath) as? InningsCell else {
                fatalError("InningsCell not found")
            }
            
            if let detail = cricketDetail {
                cell.populate(with: detail.innings[indexPath.row-1])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    private func tennisCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHeadCell", for: indexPath) as? MatchHeadCell else {
                fatalError("MatchHeadCell not found")
            }
            
            cell.matchNameLbl.text = self.tennisBadmintonDetails.title
            cell.typeDateLocationLabel.text = self.tennisBadmintonDetails.eventCustomDate

            return cell
            
        } else if indexPath.row == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                fatalError("SportDescriptionCell not found")
            }
            
            cell.descriptionLbl.text = "\(self.tennisBadmintonDetails.result) \(self.tennisBadmintonDetails.description)"
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BatmintonTennisCell", for: indexPath) as? BatmintonTennisCell else {
            fatalError("BatmintonTennisCell not found")
        }
        
        cell.teamScoreModel = self.tennisBadmintonDetails
        cell.populate(model: self.tennisBadmintonDetails)
        
        return cell
    }
    
    private func batmintonCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHeadCell", for: indexPath) as? MatchHeadCell else {
                fatalError("MatchHeadCell not found")
            }
            
            cell.matchNameLbl.text = self.tennisBadmintonDetails.title
            cell.typeDateLocationLabel.text = self.tennisBadmintonDetails.eventCustomDate
            
            return cell
            
        } else if indexPath.row == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SportDescriptionCell", for: indexPath) as? SportDescriptionCell else {
                fatalError("SportDescriptionCell not found")
            }
            
            cell.descriptionLbl.text = "\(self.tennisBadmintonDetails.result) \(self.tennisBadmintonDetails.description)"
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BatmintonTennisCell", for: indexPath) as? BatmintonTennisCell else {
            fatalError("BatmintonTennisCell not found")
        }
        
        cell.teamScoreModel = self.tennisBadmintonDetails
        cell.populate(model: self.tennisBadmintonDetails)
        
        return cell
    }
    
}

extension SportDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if vcType == .soccer, let _ = self.sportDetail {
            let goalCount = sportDetail.goals.count
            if goalCount == 0 {
                return 1
            }
            return (goalCount + 2)
            
        } else if vcType == .cricket, let detail = self.cricketDetail {
            
            if detail.match_status == "2", detail.type == "3" {
                return 3 + detail.innings.count
            } else {
                return 2
            }
            
        } else if (vcType == .batminton || vcType == .tennis), let _ = self.tennisBadmintonDetails {

            let description = "\(self.tennisBadmintonDetails.result)\(self.tennisBadmintonDetails.description)"
            if description.isEmpty {
                return 2
            }
            return 3
        }
        return 0 //2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.vcType == .soccer {
            return self.soccerCell(tableView: tableView, indexPath: indexPath)
            
        } else if self.vcType == .cricket {
            return self.cricketCell(tableView: tableView, indexPath: indexPath)
            
        } else if self.vcType == .batminton {
            return self.batmintonCell(tableView: tableView, indexPath: indexPath)
            
        }  else if self.vcType == .tennis {
            return self.tennisCell(tableView: tableView, indexPath: indexPath)
            
        }
        return UITableViewCell()
    }
    
}

extension SportDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableTopCurveHeaderFooterView") as? TableTopCurveHeaderFooterView else { fatalError("TableTopCurveHeaderFooterView not found") }
        
        //headerCell.shareBtn.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 80
        }
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        /*
         if indexPath.row != 0 {
         return UITableViewAutomaticDimension
         }
         return 400
         */
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}


//MARK: Extension: for UIScrollViewDelegate
//=========================================
extension SportDetailVC: UIScrollViewDelegate {
    
    // To make sure tableview do not scrolls more than screenHeight
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= -screenHeight) {
            scrollView.contentOffset = CGPoint(x: 0, y: (1 - screenHeight))
        }
    }
}



