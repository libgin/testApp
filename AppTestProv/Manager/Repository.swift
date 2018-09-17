//
//  Repository.swift
//  AppTestProv
//
//  Created by victor on 15.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import RxSwift
import ObjectMapper
import SwiftyJSON
import CoreData
import Alamofire
import AlamofireImage

let kRepositoryName: String = "MovieDB"

class Repository {
    let netSer = NetworkService.sharedService
    static let sharedRepository = Repository()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let netService = NetworkService.sharedService
    
    init() {
        
    }

    func saveMovie (movies: [Movie]) {
        for movie in movies {
            if !self.isExist(id:Int(movie.moveiId)) {
                downloadPosterImg(movie: movie)
                downloadBackdropImg(movie: movie)
                let newMovie = NSEntityDescription.insertNewObject(forEntityName: kRepositoryName, into: self.context)
                newMovie.setValue(movie.title, forKey: "title")
                newMovie.setValue(movie.voteAverage, forKey: "voteAverage")
                newMovie.setValue(movie.releaseDate, forKey: "releaseDate")
                newMovie.setValue(movie.overview, forKey: "overview")
                newMovie.setValue(movie.originalTitle, forKey: "originalTitle")
                newMovie.setValue(Int(movie.moveiId), forKey: "idMovie")
                newMovie.setValue(movie.backdropPath, forKey: "backdropPath")
                newMovie.setValue(movie.posterPath, forKey: "posterPath")
                newMovie.setValue(movie.genreListStr, forKey: "genreListStr")
        
                do {
                    try self.context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchMovies() -> [MovieDB] {
        return  try! context.fetch(MovieDB.fetchRequest())
    }

    func search(text: String) -> [MovieDB]?  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: kRepositoryName)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        do {
            let results = try context.fetch(request)
            var movieArr:[MovieDB] = []
            if results.count > 0 {
                for movie in results {
                    movieArr.append(movie as! MovieDB)
                }
                return movieArr
            } else {
                print("not found")
                return movieArr
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func isExist(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kRepositoryName)
        fetchRequest.predicate = NSPredicate(format: "idMovie = %d", argumentArray: [id])
        let res = try! context.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    
    func downloadPosterImg(movie: Movie) {
        let url = "https://image.tmdb.org/t/p/w500\(movie.posterPath!)"
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                self.insertPosterImgData(data:UIImageJPEGRepresentation(image, 0)! , movieId: movie.moveiId)
                //print("PosterImg downloaded: \(image)")
            }
        }
    }
    
    func downloadBackdropImg(movie: Movie) {
        let url = "https://image.tmdb.org/t/p/original\(movie.backdropPath!)"
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                self.insertBackdropImgData(data:UIImageJPEGRepresentation(image, 0)! , movieId: movie.moveiId)
                //print("BackdropImg downloaded: \(image)")
            }
        }
    }
    
    func insertPosterImgData(data: Data, movieId: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kRepositoryName)
        
        fetchRequest.predicate = NSPredicate(format: "idMovie = %d", argumentArray: [movieId])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(data, forKey: "posterImg")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    func insertBackdropImgData(data: Data, movieId: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kRepositoryName)
        
        fetchRequest.predicate = NSPredicate(format: "idMovie = %d", argumentArray: [movieId])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(data, forKey: "backdropImg")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    

}
