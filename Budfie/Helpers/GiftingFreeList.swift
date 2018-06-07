//
//  GiftingFreeList.swift
//  Budfie
//
//  Created by appinventiv on 05/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

enum GiftingFreeList : Int {
    
    case gift1  = 1
    case gift2  = 2
    case gift3  = 3
    case gift4  = 4
    case gift5  = 5
    
    var name: String {
        
        switch self {
            
        case .gift1 : return "Flowers"
        case .gift2 : return "Guy with Guitar"
        case .gift3 : return "Rose"
        case .gift4 : return "Rose"
        case .gift5 : return "Rose"
            
        }
    }
    
    var image: UIImage {
        
        switch self {
            
        case .gift1 : return #imageLiteral(resourceName: "icGiftingImg1")
        case .gift2 : return #imageLiteral(resourceName: "icGiftingImg2")
        case .gift3 : return #imageLiteral(resourceName: "icGiftingImg3")
        case .gift4 : return #imageLiteral(resourceName: "icGiftingImg3")
        case .gift5 : return #imageLiteral(resourceName: "icGiftingImg3")
            
        }
    }
    
}
