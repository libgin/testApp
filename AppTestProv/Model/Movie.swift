//
//  Movie.swift
//  AppTestProv
//
//  Created by victor on 11.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class Movie: Mappable {
    
     var posterImge : Date?
    
    var adult = 0
    var backdropPath : String?
    var moveiId : Int = 0
    var originalLanguage : String?
    var originalTitle : String?
    var overview : String?
    var popularity : Float = 0.0
    var posterPath : String?
    var releaseDate : String?
    var title : String?
    var video : Bool?
    var voteAverage : Float = 0.0
    var voteCount : Int = 0
    
    var genreListStr : String? = ""
    
    var genre: [Int]?
    
    var genreList = Array<Genre>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        moveiId <- (map["id"])
        adult <- (map["adult"])
        backdropPath <- (map["backdrop_path"])
        originalLanguage <- (map["original_language"])
        originalTitle <- (map["original_title"])
        overview <- (map["overview"])
        popularity <- (map["popularity"])
        posterPath <- (map["poster_path"])
        releaseDate <- (map["release_date"])
        title <- (map["title"])
        video <- (map["video"])
        voteAverage <- (map["vote_average"])
        voteCount <- (map["vote_count"])
        
        genre <- map["genre_ids"]
    }
}


/*
 {
 adult = 0;
 "backdrop_path" = "/nl79FQ8xWZkhL3rDr1v2RFFR6J0.jpg";
 "genre_ids" =             (
 35,
 18,
 10749
 );
 id = 19404;
 "original_language" = hi;
 "original_title" = "\U0926\U093f\U0932\U0935\U093e\U0932\U0947 \U0926\U0941\U0932\U094d\U0939\U0928\U093f\U092f\U093e \U0932\U0947 \U091c\U093e\U092f\U0947\U0902\U0917\U0947";
 overview = "Raj is a rich, carefree, happy-go-lucky second generation NRI. Simran is the daughter of Chaudhary Baldev Singh, who in spite of being an NRI is very strict about adherence to Indian values. Simran has left for India to be married to her childhood fianc\U00e9. Raj leaves for India with a mission at his hands, to claim his lady love under the noses of her whole family. Thus begins a saga.";
 popularity = "13.967";
 "poster_path" = "/uC6TTUhPpQCmgldGyYveKRAu8JN.jpg";
 "release_date" = "1995-10-20";
 title = "Dilwale Dulhania Le Jayenge";
 video = 0;
 "vote_average" = "9.199999999999999";
 "vote_count" = 1873;
 },
 */
