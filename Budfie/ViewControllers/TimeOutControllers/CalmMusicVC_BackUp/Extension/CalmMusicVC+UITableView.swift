//
//  CalmMusicVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 10/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension CalmMusicVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalmMusicCell", for: indexPath) as? CalmMusicCell else { fatalError("CalmMusicCell not found") }
        
        if index == indexPath {
            cell.selectedMusic()
        } else {
            cell.unSelectedMusic()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pause()
        if index == indexPath {
            index = [-1,-1]
        } else {
            index = indexPath
            playMusic()
        }
        self.showMusicList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
