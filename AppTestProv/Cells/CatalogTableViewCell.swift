//
//  CatalogTableViewCell.swift
//  AppTestProv
//
//  Created by victor on 12.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {
    
    weak var delegate: CatalogTableViewCellDelegate?
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        inititalize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inititalize()
    }
    
    func inititalize() {
        
    }
    
    func setContent(movie: Movie) {
        originalTitle.text = movie.originalTitle
        rating.text = String(format:"Rating %.2f", movie.voteAverage)
        setPosterImage(imgUrl: "https://image.tmdb.org/t/p/w500\(movie.posterPath!)")
    }
    
    func setContentFromDB(movie: MovieDB) {
        originalTitle.text = movie.originalTitle
        rating.text = String(format:"Rating %.2f", movie.voteAverage)
        if movie.posterImg != nil {
            posterImage.image = UIImage(data: movie.posterImg!)
        }     
    }
    
    func setPosterImage(imgUrl: String?) {
        let imageCache = PersistentAutoPurgingImageCache.default
        if let linkUrlString = imgUrl, let linkUrl = URL(string: linkUrlString) {
            if let image = imageCache.image(withIdentifier: linkUrl.lastPathComponent) {
                self.posterImage.image = image
            } else {
                self.posterImage.image = nil
                self.posterImage.af_setImage(withURL: linkUrl, completion: { dataResponse in
                    if let image = dataResponse.result.value {
                        imageCache.add(image, withIdentifier: linkUrl.lastPathComponent)
                    }
                })
            }
        }
    }
    
}

protocol CatalogTableViewCellDelegate: class {
    
}
