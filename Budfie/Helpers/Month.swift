//
//  Month.swift
//  Budfie
//
//  Created by appinventiv on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

enum Month : Int {
    
    case jan = 1
    case feb = 2
    case mar = 3
    case apr = 4
    case may = 5
    case jun = 6
    case jul = 7
    case aug = 8
    case sep = 9
    case oct = 10
    case nov = 11
    case dec = 12
    
    var name: String {
        
        switch self {
            
        case .jan: return StringConstants.K_January.localized
        case .feb: return StringConstants.K_February.localized
        case .mar: return StringConstants.K_March.localized
        case .apr: return StringConstants.K_April.localized
        case .may: return StringConstants.K_May.localized
        case .jun: return StringConstants.K_June.localized
        case .jul: return StringConstants.K_July.localized
        case .aug: return StringConstants.K_August.localized
        case .sep: return StringConstants.K_September.localized
        case .oct: return StringConstants.K_October.localized
        case .nov: return StringConstants.K_November.localized
        case .dec: return StringConstants.K_December.localized
            
        }
    }
    
    var image: UIImage {
        
        switch self {
            
        case .jan: return AppImages.ic_holiday_planner_landing_jan
        case .feb: return AppImages.ic_holiday_planner_landing_feb
        case .mar: return AppImages.ic_holiday_planner_landing_mar
        case .apr: return AppImages.ic_holiday_planner_landing_apr
        case .may: return AppImages.ic_holiday_planner_landing_may
        case .jun: return AppImages.ic_holiday_planner_landing_jun
        case .jul: return AppImages.ic_holiday_planner_landing_jul
        case .aug: return AppImages.ic_holiday_planner_landing_aug
        case .sep: return AppImages.ic_holiday_planner_landing_sep
        case .oct: return AppImages.ic_holiday_planner_landing_oct
        case .nov: return AppImages.ic_holiday_planner_landing_nov
        case .dec: return AppImages.ic_holiday_planner_landing_dec
        }
    }

    var largeImage: UIImage {

        switch self {

        case .jan: return AppImages.ic_holiday_jan_bg
        case .feb: return AppImages.ic_holiday_feb_bg
        case .mar: return AppImages.ic_holiday_mar_bg
        case .apr: return AppImages.ic_holiday_apr_bg
        case .may: return AppImages.ic_holiday_may_bg
        case .jun: return AppImages.ic_holiday_june_bg
        case .jul: return AppImages.ic_holiday_july_bg
        case .aug: return AppImages.ic_holiday_aug_bg
        case .sep: return AppImages.ic_holiday_sep_bg
        case .oct: return AppImages.ic_holiday_oct_bg
        case .nov: return AppImages.ic_holiday_nov_bg
        case .dec: return AppImages.ic_holiday_dec_bg
        }
    }
    
}
