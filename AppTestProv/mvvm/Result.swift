//
//  Result.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import RxSwift

enum Result<T> {
    case Success(value: T)
    case Failure(error: Error)
}
