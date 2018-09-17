//
//  DetailViewModel.swift
//  AppTestProv
//
//  Created by victor on 12.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class DetailViewModel: ViewModel {
    let movieDetail: Property<Movie?> = Property(nil)
    let movieDetailDB: Property<MovieDB?> = Property(nil)
    
    override init() {
        super.init()
    }
}
