//
//  Requests.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import Foundation
import Alamofire

public class Requests { //https://api.themoviedb.org/3/find/tt4158110?api_key=api_key&language=en-US&external_source=imdb_id
        
    let apiKey = "?api_key=6fd199f6205b1154183cd87c532c3fe3"
    
    func baseURL() -> String {
        return "https://api.themoviedb.org/3/movie/"
    }
    
    func popularityMovie(page:Int) ->  DataRequest {
        return  Alamofire.request("\(self.baseURL())top_rated?page=\(page)&language=en-US&api_key=6fd199f6205b1154183cd87c532c3fe3", method: .get, parameters: nil , encoding: JSONEncoding.default, headers:nil)

    }
    
    func getGenreList() -> DataRequest { //http://api.themoviedb.org/3/genre/movie/list?api_key=6fd199f6205b1154183cd87c532c3fe3
        return  Alamofire.request("http://api.themoviedb.org/3/genre/movie/list?api_key=6fd199f6205b1154183cd87c532c3fe3", method: .get, parameters: nil , encoding: JSONEncoding.default, headers:nil)
    }
    
    func getImageByURL(urlStr: String) -> DataRequest { //https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg
        return  Alamofire.request("https://image.tmdb.org/t/p\(urlStr)", method: .get, parameters: nil , encoding: JSONEncoding.default, headers:nil)
    }
    
    
    
}
