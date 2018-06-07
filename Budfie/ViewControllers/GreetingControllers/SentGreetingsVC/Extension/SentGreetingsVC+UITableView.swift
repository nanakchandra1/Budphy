//
//  SentGreetingsVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension SentGreetingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelGreetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentDraftReceiveCell") as? SentDraftReceiveCell else {
            fatalError("SentDraftReceiveCell not found")
        }
        
        cell.populateView(model: modelGreetingList[indexPath.row])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        panGesture.delegate = self
        //panGesture.cancelsTouchesInView = false
        cell.backView.addGestureRecognizer(panGesture)
        
        if self.vcState == .sent {
            cell.sentSetting()
        } else if self.vcState == .receive {
            cell.receiveSetting()
        } else if self.vcState == .draft {
            cell.draftSetting()
        }
    
        cell.editBtn.addTarget(self, action: #selector(editBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let greeting = self.modelGreetingList[indexPath.row]
        
        if flowType == .events {
            if self.vcState == .draft {
                let greetingDraft = self.greetings[indexPath.row]
                openEditGreeting(with: greetingDraft)
            } else {
                addGreetingToEvent(greetingId: greeting.greeting_id, greetingImg: greeting.greeting)
            }
            return
        }
        
        let sceneGreetingPreviewVC = GreetingPreviewVC.instantiate(fromAppStoryboard: .Greeting)
        sceneGreetingPreviewVC.vcState = self.vcState
        sceneGreetingPreviewVC.modelGreetingList = greeting
        
        /*
        if self.vcState == .draft {
            sceneGreetingPreviewVC.greeting = self.greetings[indexPath.row]
        }
        */
        self.navigationController?.pushViewController(sceneGreetingPreviewVC, animated: true)
        
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
