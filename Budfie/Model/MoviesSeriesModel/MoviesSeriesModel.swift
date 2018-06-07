//
//  MoviesSeriesModel.swift
//  Budfie
//
//  Created by appinventiv on 03/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class MoviesSeriesModel {
    
    var moviesId            : String
    var moviesName          : String
    var moviesTitle         : String
    var moviesType          : String
    var moviesDuration      : String
    var moviesImage         : String
    var moviesReleaseDate   : String
    var moviesLocation      : String
    var moviesVideo         : String
    var moviesDesc          : String
    var moviesURL           : String
    var moviesTime          : String
    
    init(initForMoviesSeries json: JSON) {
        
        self.moviesId           = json["id"].stringValue
        self.moviesName         = json["movie_name"].stringValue
        self.moviesTitle        = json["movie_title"].stringValue
        self.moviesType         = json["movie_type"].stringValue
        self.moviesDuration     = json["movie_duration"].stringValue
        self.moviesReleaseDate  = json["movie_release_date"].stringValue
        self.moviesDesc         = json["movie_story"].stringValue
        self.moviesImage        = json["movie_image"].stringValue
        self.moviesVideo        = json["movie_video"].stringValue
        self.moviesURL          = json["movie_url"].stringValue
        self.moviesLocation     = json["movie_location"].stringValue
        self.moviesTime         = json["movie_time"].stringValue
    }
    
}



/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Movie List has been fetched successfully",
    "VALUE": [
    {
    "id": "1",
    "movie_type": "1",
    "movie_name": "abc",
    "movie_title": "xyz",
    "movie_image": "",
    "movie_video": "fasfdASF",
    "movie_url": "",
    "movie_duration": "",
    "movie_story": "SADASdAD"
    }
    ]
}

*/
