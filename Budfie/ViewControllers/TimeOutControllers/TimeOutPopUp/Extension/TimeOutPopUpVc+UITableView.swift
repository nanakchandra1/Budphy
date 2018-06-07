//
//  TimeOutPopUpVc+UITableView.swift
//  Budfie
//
//  Created by yogesh singh negi on 21/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

extension TimeOutPopUpVc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moodListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            
            guard let leftCell = tableView.dequeueReusableCell(withIdentifier: "LeftMoodCell", for: indexPath) as? LeftMoodCell else { fatalError("LeftMoodCell not found") }
            
            leftCell.populate(index: self.moodListArray[indexPath.row])
            
            return leftCell
            
        } else {
            
            guard let rightCell = tableView.dequeueReusableCell(withIdentifier: "RightMoodCell", for: indexPath) as? RightMoodCell else { fatalError("RightMoodCell not found") }
            
            rightCell.populate(index: self.moodListArray[indexPath.row])
            
            return rightCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //        if screenWidth < 322 {
        //            return 100
        //        } else if screenWidth < 375 {
        //            return 110
        //        } else {
        //            return 120
        //        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let mood = MoodList(rawValue: (self.moodListArray[indexPath.row])) {
            
            switch mood.name {
                
                //SUCCESS(1=News,2=Clips,3=Funny Jokes,4=Happy Thoughts,5=Shopping,6=Plan Holiday,7=Calm Music,8=Game Winit,9=Game Killit)
                
            case MoodList.clips.name:
                let scene = VideosOrGifsVC.instantiate(fromAppStoryboard: .TimeOut)
                scene.state = .clips
                self.navigationController?.pushViewController(scene, animated: true)
                
            case MoodList.happyThoughts.name:
                //                CommonClass.showToast(msg: "Under Development")
                let scene = JokesThoughtsVC.instantiate(fromAppStoryboard: .TimeOut)
                scene.vcState = .thoughts
                self.navigationController?.pushViewController(scene, animated: true)
                
            case MoodList.gameKillIt.name:
                //let gamesScene = GamesVC.instantiate(fromAppStoryboard: .TimeOut)
                //navigationController?.pushViewController(gamesScene, animated: true)
                //UIApplication.shared.openURL(URL(string: "http://testing.redappletech.com/budfie/crazy-girl/")!)
                CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)

            case MoodList.gameWinIt.name:
                let gamesScene = GamesVC.instantiate(fromAppStoryboard: .TimeOut)
                navigationController?.pushViewController(gamesScene, animated: true)
                //UIApplication.shared.openURL(URL(string: "http://testing.redappletech.com/budfie/crazy-girl/")!)
                //CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
                
            case MoodList.shopping.name:
                //                CommonClass.showToast(msg: "Under Development")
                let scene = GiftsVC.instantiate(fromAppStoryboard: .Events)
                scene.vcState = .exploreMore
                self.navigationController?.pushViewController(scene, animated: true)
                
            case MoodList.calmMusic.name:
                //                CommonClass.showToast(msg: "Under Development")
                let scene = CalmMusicVC.instantiate(fromAppStoryboard: .TimeOut)
                self.navigationController?.pushViewController(scene, animated: true)
                
            case MoodList.jokes.name:
                //                CommonClass.showToast(msg: "Under Development")
                let scene = JokesThoughtsVC.instantiate(fromAppStoryboard: .TimeOut)
                scene.vcState = .jokes
                self.navigationController?.pushViewController(scene, animated: true)
                
            case MoodList.news.name:
                let sceneNewsListingVC = NewsListingVC.instantiate(fromAppStoryboard: .TimeOut)
                sceneNewsListingVC.state = .news
                self.navigationController?.pushViewController(sceneNewsListingVC, animated: true)
                
            case MoodList.planHoliday.name:
                let sceneHolidayPlannerVC = HolidayPlannerVC.instantiate(fromAppStoryboard: .HolidayPlanner)
                sceneHolidayPlannerVC.vcType = .exploreMore
                self.navigationController?.pushViewController(sceneHolidayPlannerVC, animated: true)
                
            default:
                CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
            }
        }
    }
    
}


class LeftMoodCell : UITableViewCell {
    
    @IBOutlet weak var backImageView: UIView!
    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightPointView: UIView!
    @IBOutlet weak var videosGifImage: UIImageView!
    @IBOutlet weak var videosGifsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.mainImageView.border(width: 1, borderColor: AppColors.blackColor)
    }
    
    func initialSetUp() {
        self.contentView.backgroundColor    = UIColor.clear
        self.mainImageView.transform        = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        self.backImageView.transform        = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        self.rightPointView.transform       = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        
        //self.videosGifsLabel.font           = AppFonts.Comfortaa_Bold_0.withSize(20)
        self.videosGifsLabel.textColor      = AppColors.blackColor

        if screenWidth < 350 {
            self.videosGifsLabel.font       = AppFonts.Comfortaa_Bold_0.withSize(20)
        } else {
            self.videosGifsLabel.font       = AppFonts.Comfortaa_Bold_0.withSize(18)
        }
    }
    
    func populate(index: Int) {
        if let mood = MoodList(rawValue: (index)) {
            self.videosGifsLabel.text = mood.name
            self.videosGifImage.image = mood.image
            self.mainImageView.backgroundColor  = mood.backgroundColor
            self.centerView.backgroundColor     = mood.backgroundColor
            self.rightPointView.backgroundColor = mood.backgroundColor
        }
    }
    
}


class RightMoodCell : UITableViewCell {
    
    @IBOutlet weak var backImageView: UIView!
    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var leftPointView: UIView!
    @IBOutlet weak var videosGifImage: UIImageView!
    @IBOutlet weak var videosGifsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.mainImageView.border(width: 1, borderColor: AppColors.blackColor)
    }
    
    func initialSetUp() {
        self.contentView.backgroundColor    = UIColor.clear
        self.mainImageView.transform        = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        self.backImageView.transform        = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        self.leftPointView.transform        = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        
        //self.videosGifsLabel.font           = AppFonts.Comfortaa_Bold_0.withSize(20)
        self.videosGifsLabel.textColor      = AppColors.blackColor

        if screenWidth < 350 {
            self.videosGifsLabel.font       = AppFonts.Comfortaa_Bold_0.withSize(20)
        } else {
            self.videosGifsLabel.font       = AppFonts.Comfortaa_Bold_0.withSize(18)
        }
    }
    
    func populate(index: Int) {
        if let mood = MoodList(rawValue: (index)) {
            self.videosGifsLabel.text = mood.name
            self.videosGifImage.image = mood.image
            self.mainImageView.backgroundColor  = mood.backgroundColor
            self.centerView.backgroundColor     = mood.backgroundColor
            self.leftPointView.backgroundColor  = mood.backgroundColor
        }
    }
}
