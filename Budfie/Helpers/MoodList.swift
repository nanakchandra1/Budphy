//
//  MoodList.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

enum MoodList : Int {
    
    //1=Movies,2=News,3=Videos,4=Gif
    //SUCCESS(1=Movies,2=News,3=Videos,4=Gif,5=Funny Jokes)
    //SUCCESS(1=News,2=Clips,3=Jokes,4=Happy Thoughts,5=Games,6=Shopping)
    //SUCCESS(1=News,2=Clips,3=Funny Jokes,4=Happy Thoughts,5=Shopping,6=Plan Holiday,7=Calm Music,8=Game Winit,9=Game Killit)
    
    case news           = 1
    case clips          = 2
    case jokes          = 3
    case happyThoughts  = 4
    case shopping       = 5
    case planHoliday    = 6
    case calmMusic      = 7
    case gameWinIt      = 8
    case gameKillIt     = 9
    
    var name: String {
        
        switch self {
            
        case .clips         : return StringConstants.K_Clips.localized
        case .news          : return StringConstants.K_News.localized
        case .happyThoughts : return StringConstants.K_Happy_Thoughts.localized
        case .gameWinIt     : return StringConstants.K_Game_Winit.localized
        case .jokes         : return StringConstants.K_Funny_Jokes.localized
        case .shopping      : return "Gifting"
        case .gameKillIt    : return StringConstants.K_Game_Killit.localized
        case .planHoliday   : return StringConstants.K_Plan_Holiday.localized
        case .calmMusic     : return StringConstants.K_Calm_Music.localized
            
        }
    }
    
    var image: UIImage {
        
        switch self {
            
        case .clips         : return AppImages.ic52PopupVideos
        case .news          : return AppImages.ic52PopupNews
        case .happyThoughts : return AppImages.ic52PopupThoughts
        case .gameWinIt     : return AppImages.ic52PopupGames
        case .jokes         : return AppImages.ic52PopupJokes
        case .shopping      : return AppImages.icShopping
        case .gameKillIt    : return AppImages.ic52PopupGames
        case .planHoliday   : return AppImages.icHp
        case .calmMusic     : return AppImages.ic52PopupCalmMusic
            
        }
    }
    
    var backgroundColor: UIColor {
        
        switch self {
            
        case .clips         : return AppColors.clipsPopUp
        case .news          : return AppColors.newsPopUp
        case .happyThoughts : return AppColors.thoughtsPopUp
        case .gameWinIt     : return AppColors.gamesPopUp
        case .jokes         : return AppColors.jokesPopUp
        case .shopping      : return AppColors.shoppingPopUp
        case .gameKillIt    : return AppColors.gamesPopUp
        case .planHoliday   : return AppColors.holidayPopUp
        case .calmMusic     : return AppColors.musicPopUp
            
        }
    }
    
}
