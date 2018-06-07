//
//  Webservices+TimeOut.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WebServices {
    
    //MARK:- GET LONG HOLIDAYS
    //========================
    static func getHolidays(for year: String,
                            loader : Bool = true,
                            success : @escaping ([[[Holiday]]]) -> Void,
                            failure : @escaping (Error) -> Void) {

        let parameters: JSONDictionary = ["method": "holiday_list", "year": year, "access_token": AppDelegate.shared.currentuser.access_token]

        print_debug("")
        print_debug("=============GET LONG HOLIDAYS==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.holiday)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")

        AppNetworking.GET(endPoint: WebServices.EndPoint.holiday, parameters: parameters, loader: loader, success: { json in

            let code = json["CODE"].intValue

            WebServices.handleInvalidUser(withCode: code)

            if code == WSStatusCode.SUCCESS.rawValue {

                var longHolidayMonths = [[[Holiday]]]()

                for monthHolidaysJSON in json["VALUE"].arrayValue {

                    var monthHolidays = [[Holiday]]()

                    for holidaysJSON in monthHolidaysJSON.arrayValue {

                        var holidays: [Holiday] = []

                        for holidayJSON in holidaysJSON.arrayValue {

                            if let holiday = Holiday(with: holidayJSON) {
                                holidays.append(holiday)
                            }
                        }

                        monthHolidays.append(holidays)
                    }

                    longHolidayMonths.append(monthHolidays)
                }

                success(longHolidayMonths)
            }

        }) { (error) in

            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- CREATE HOLIDAY PLAN
    //==========================
    static func createHolidayPlan(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Bool) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============CREATE HOLIDAY PLAN=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.holiday)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.holiday, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
//                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(true)
            } else {
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(false)
            }
        }) { (error) in
            failure(error)
            print_debug(error)
        }
    }
    
}
