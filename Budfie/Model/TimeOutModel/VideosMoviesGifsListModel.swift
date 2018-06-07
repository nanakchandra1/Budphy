//
//  VideosMoviesGifsListModel.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class VideosMoviesGifsListModel {
    
    let name : String
    let url : String
    let movieId : String
    
    init(initWithList json : JSON) {
        
        self.name = json["thumbnail"].string ?? json["image"].string ?? json["gif"].stringValue
        self.url = json["video_url"].string ?? json["video"].string ?? json["name"].stringValue
        self.movieId = json["movie_id"].stringValue
        
    }
    
}


// TimeOut Movies
/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Video List fetched successfully",
    "VALUE": [
    {
    "url": "https://www.youtube.com/watch?v=AG67Lu45QMQ",
    "thumbnail": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682c3159bf41516776497.jpg",
    "type": "1"
    },
    {
    "url": "https://www.youtube.com/watch?v=GEdP0AKP9e8",
    "thumbnail": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682a633385f1516776035.jpg",
    "type": "1"
    },
    {
    "name": "Flying",
    "url": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a700a468fb101517292102.gif",
    "type": "2"
    },
    {
    "name": "Loader",
    "url": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a6075152defb1516270869.gif",
    "type": "2"
    }
    ]
}
*/

//changes
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Movie List has been fetched successfully";
    VALUE =     (
        {
            image = "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682a633385f1516776035.jpg";
            "movie_id" = 1;
            "video_url" = "https://www.youtube.com/watch?v=GEdP0AKP9e8";
    },
        {
            image = "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a683428140061516778536.jpg";
            "movie_id" = 6;
            "video_url" = "https://www.youtube.com/watch?v=2QKg5SZ_35I";
    }
    );
}
*/
/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Movie List has been fetched successfully",
    "VALUE": [
    {
    "image": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682a633385f1516776035.jpg",
    "video_url": "https://www.youtube.com/watch?v=GEdP0AKP9e8"
    },
    {
    "image": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682c3159bf41516776497.jpg",
    "video_url": "https://www.youtube.com/watch?v=AG67Lu45QMQ"
    },
    {
    "image": "https://s3.amazonaws.com/appinventiv-development/budfie/budfie5a682ca22f70f1516776610.jpg",
    "video_url": "https://www.youtube.com/watch?v=-K9ujx8vO_A"
    }
*/

// Videos
/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Video List fetched successfully",
    "VALUE": [
    {
    "video": "safasf",
    "thumbnail": "sfsdgfsdgf"
    },
    {
    "video": "fasfas",
    "thumbnail": "sfasf"
    }
    ]
}
*/

// Gifs
/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Gif List fetched successfully",
    "VALUE": [
    {
    "name": "asdasd",
    "gif": "asdasd"
    }
    ]
}
*/
