//
//  PlaceModel.swift
//  Mongo
//
//  Created by appinventiv on 16/10/17.
//  Copyright © 2017 MongoApp. All rights reserved.
//

import CoreLocation
import SwiftyJSON

public class Place {
    public internal(set) var placemark: CLPlacemark?
    public internal(set) var coordinates: CLLocationCoordinate2D?
    public internal(set) var countryCode: String?
    public internal(set) var country: String?
    public internal(set) var state: String?
    public internal(set) var county: String?
    public internal(set) var postcode: String?
    public internal(set) var city: String?
    public internal(set) var cityDistrict: String?
    public internal(set) var road: String?
    public internal(set) var houseNumber: String?
    public internal(set) var name: String?
    public internal(set) var POI: String?
    public internal(set) var rawDictionary: [String:Any]?

    internal init() { }

    internal init(googleJSON json: JSON) {
        func ab(forType type: String) -> JSON? {
            return json["address_components"].arrayValue.first(where: { data in
                return data["types"].arrayValue.contains(where: { entry in
                    return entry.stringValue == type
                })
            })
        }

        if let lat = json["geometry"]["location"]["lat"].double, let lon = json["geometry"]["location"]["lng"].double {
            self.coordinates = CLLocationCoordinate2DMake(lat, lon)
        }
        self.name = ab(forType: "establishment")?["short_name"].string
        if let countryData = ab(forType: "country") {
            self.countryCode = countryData["short_name"].string
            self.country = countryData["long_name"].string
        }
        self.postcode = ab(forType: "postal_code")?["short_name"].string
        self.state = ab(forType: "administrative_area_level_1")?["short_name"].string
        self.city = ab(forType: "locality")?["short_name"].string
        self.cityDistrict = ab(forType: "administrative_area_level_2")?["short_name"].string
        self.road = ab(forType: "route")?["short_name"].string
        if self.road == nil {
            self.road = ab(forType: "neighborhood")?["short_name"].string
        }
        self.houseNumber = ab(forType: "street_number")?["short_name"].string
        self.POI = ab(forType: "point_of_interest")?["short_name"].string
        self.rawDictionary = json.dictionaryObject
    }

    internal init?(placemark: CLPlacemark?) {
        guard let p = placemark else { return nil }
        self.placemark = p

        self.name = p.name
        self.coordinates = p.location?.coordinate
        self.countryCode = p.isoCountryCode
        self.country = p.country
        self.postcode = p.postalCode
        self.cityDistrict = p.administrativeArea
        self.road = p.thoroughfare
        self.houseNumber = p.subAdministrativeArea

        if #available(iOS 11.0, *) {
            if let address = p.postalAddress {
                self.city = address.city
            }
        } else {
            self.city = p.locality
        }
    }
}
