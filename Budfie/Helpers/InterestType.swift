//
//  InterestType.swift
//  Budfie
//
//  Created by appinventiv on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

func getImage(subCategoryId: String) -> UIImage {
    switch subCategoryId {
    case "1": return AppImages.interestCricket
    case "2": return AppImages.interestFootball
    case "3": return AppImages.interestRacket
    case "5": return AppImages.interestBadminton
    case "6": return AppImages.interestBollywood
    case "7": return AppImages.interestHollywood
    case "8": return AppImages.interestTollywood
    case "10": return AppImages.interestPlay
    case "11": return AppImages.interestKids
    case "12": return AppImages.interestFood
    case "13": return AppImages.interestAdventure
    default:
        return AppImages.profileGallery
    }
}

func getName(subCategoryId:String) -> String {
    switch subCategoryId {
    case "1": return StringConstants.Cricket.localized
    case "2": return StringConstants.Football.localized
    case "3": return StringConstants.Badminton.localized
    case "5": return StringConstants.Tennis.localized
    case "6": return StringConstants.Bollywood.localized
    case "7": return StringConstants.Hollywood.localized
    case "8": return StringConstants.Tollywood.localized
    case "10": return StringConstants.Plays.localized
    case "11": return StringConstants.Kids.localized
    case "12": return "\(StringConstants.Food.localized) \(StringConstants.Festivals.localized)"
    case "13": return StringConstants.Adventure.localized
    default:
        return "Not Found"
    }
}
