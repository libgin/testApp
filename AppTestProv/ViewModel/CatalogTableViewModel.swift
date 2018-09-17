//
//  CatalogTableViewModel.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

import Alamofire
import AlamofireImage

import CoreData

class CatalogTableViewModel: ViewModel {
    let netSer = NetworkService.sharedService
    
    let repManager = Repository.sharedRepository
    
    let pageNumberProrerty = Property(1)
    
    var movieModel:Property<[Movie]> = Property([])
    var genreModel:Property<[Genre]> = Property([])
    
    var movieForDetail:Property<Movie?> = Property(nil)
    var movieForDetailDB:Property<MovieDB?> = Property(nil)
    
    override init() {
        super.init()
    }

    func fetchMovies () -> [MovieDB] {
        return self.repManager.fetchMovies()
    }
    
//    func searchMovie(name:String) -> [MovieDB] {
//        return self.repManager.search(text: name)!
//    }
    
    lazy var popularityMovieiCommand:AsyncCommand<AnyObject> = AsyncCommand {
        return self.netSer.popularityMovie(page: self.pageNumberProrerty.get).do( onNext: { [unowned self] result in
            guard let resultJson = result.value(forKeyPath: "results") as? AnyObject else { return }
            if let movie = Mapper<Movie>().mapArray(JSONObject: resultJson) {
                var tempArr =  self.movieModel.get
                tempArr.append(contentsOf: movie)
                self.setGenre(movieList: tempArr)
                
                self.movieModel.set(value: tempArr)

                self.repManager.saveMovie(movies: tempArr)
            }
        })
    }
    
    lazy var  genreListCommand:AsyncCommand<AnyObject> = AsyncCommand  {
        return self.netSer.genreList().do( onNext: { [unowned self] result in
            guard let resultJson = result.value(forKeyPath: "genres") as? AnyObject else { return }
            if let genre = Mapper<Genre>().mapArray(JSONObject: resultJson) {
                self.genreModel.set(value: genre)
            }
        })
    }
    
    func setGenre(movieList:[Movie]) {
        for movie in movieList {
            let arr = genreModel.get
            let arrIds = movie.genre!
            let res = arr.filter ({ arrIds.contains($0.id) })
            movie.genreList.append(contentsOf: res)
            
            let genreStr = movie.genreList.map { String($0.name!) }.joined(separator: ", ")
            movie.genreListStr = genreStr
        }
    }
    
}


















