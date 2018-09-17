//
//  DetailViewController.swift
//  AppTestProv
//
//  Created by victor on 12.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var generLbl: UILabel!
    var genreArr:Array<String> = []
    let viewModel = DetailViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.viewModel.movieDetail.change.subscribe(onNext: { _ in
            if self.viewModel.movieDetail.get != nil {
                self.titleLbl.text = self.viewModel.movieDetail.get?.title
                if let path = self.viewModel.movieDetail.get?.backdropPath! {
                    self.setPosterImage(imgUrl: "https://image.tmdb.org/t/p/original\(path)")
                }
                self.releaseDate.text = String(format: "Release Date: %@", self.convertDateFormater((self.viewModel.movieDetail.get?.releaseDate)!))
                self.overviewText.text = self.viewModel.movieDetail.get?.overview
                self.ratingLbl.text = String(format: "Rating: %.2f", (self.viewModel.movieDetail.get?.voteAverage)!)
                
                for genreName in (self.viewModel.movieDetail.get?.genreList)! {
                    self.genreArr.append(genreName.name!)
                }
                self.generLbl.text = self.genreArr.map { String($0) }.joined(separator: ", ")
            }
        })
        
        self.viewModel.movieDetailDB.change.subscribe(onNext: { _ in
            if self.viewModel.movieDetailDB.get != nil {
                self.titleLbl.text = self.viewModel.movieDetailDB.get?.title
                self.releaseDate.text = String(format: "Release Date: %@", self.convertDateFormater((self.viewModel.movieDetailDB.get?.releaseDate)!))
                self.overviewText.text = self.viewModel.movieDetailDB.get?.overview
                self.ratingLbl.text = String(format: "Rating: %.2f", (self.viewModel.movieDetailDB.get?.voteAverage)!)
                
                if let data = self.viewModel.movieDetailDB.get?.backdropImg {
                    self.posterImg.image = UIImage(data: data)
                }
                self.generLbl.text = self.viewModel.movieDetailDB.get?.genreListStr
            }
        })
    }
    
    func setPosterImage(imgUrl: String?) {
        let imageCache = PersistentAutoPurgingImageCache.default
        if let linkUrlString = imgUrl, let linkUrl = URL(string: linkUrlString) {
            if let image = imageCache.image(withIdentifier: linkUrl.lastPathComponent) {
                self.posterImg.image = image
            } else {
                self.posterImg.image = nil
                self.posterImg.af_setImage(withURL: linkUrl, completion: { dataResponse in
                    if let image = dataResponse.result.value {
                        imageCache.add(image, withIdentifier: linkUrl.lastPathComponent)
                    }
                })
            }
        }
    }
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
}


