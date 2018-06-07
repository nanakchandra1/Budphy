//
//  Globals.swift
//  Onboarding
//
//  Created by  on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit

let googleClientId = "210712617424-emo073e77jri0bpqfvjtnoi6cgvjlo3p.apps.googleusercontent.com" //com.budfie.com
//"278792202337-gk96o1aqse5ba4i4urpruk5c6800ulng.apps.googleusercontent.com" //com.budfiebeta.com
let googleApiKey = "AIzaSyBNXEEwL-kAJgrcTcIghSnPficCii1EOws" //"AIzaSyAkyXNIbx7OWS-mAPOfrkkrl554Zk2rESg"
let deviceToken = DeviceDetail.deviceToken

//let S3_PoolId = "us-east-1:3d272d9b-a7c9-448b-8eb6-7311bc17834b"

let basicTextCode = "YnVkZmllOmJmIzI0KW5rJEByZDg2"

let IsIPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate

let spacingBetweenItems: CGFloat = 15.0
let spacingTopDownItems: CGFloat = 5.0

let totalSpacing: CGFloat = (spacingBetweenItems * CGFloat(numberOfItemsCollection) + 1)
let numberOfItemsCollection: Int = 5

let heightForItem = (screenWidth - totalSpacing) / (CGFloat(numberOfItemsCollection) - 1)

enum DateFormat : String {
    
    case dOBServerFormat = "dd-MM-yyyy"
//    case editProfile = "dd MM yyy"
    case dOBAppFormat = "dd MMM"
    case dOBProfileFormat = "MMM, yyyy"
    case calendarDate = "yyyy-MM-dd"
    case commonDate = "dd MM yyy"
    case fullDate = "yyyy-MM-dd HH:mm:ss +0000"
    case shortDate = "yyyy-MM-dd HH:mm:ss"
    case shortTime = "HH:mm"
    case fullTime = "HH:mm:ss"
    case timein12Hour = "hh:mm a"
    case showDateFormat = "dd-MMM-yyyy"
    case showProfileDate = "dd MMM yyyy"
    case day = "EEEE"
    case dateWithSlash = "dd/MM/yyyy"
    case cricketDate = "E, d MMMM"
}


enum DeviceType : String {
    case iPhone = "2"
}

enum LoginType : String {
    case Facebook = "2"
    case Google = "3"
    case Budfie = "1"
}

func print_debug <T> (_ object: T) {
    #if DEBUG
        // TODO: Comment Next Statement To Deactivate Logs
        print(object)
    #endif
}

var isSimulatorDevice:Bool {
    
    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}

//MARK:- delay with Seconds Method
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}
