//
//  Property.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import RxSwift

class Property<T>: Disposable {
    var value: T {
        didSet {
            subject.onNext(value)
        }
    }
    var get: T {
        get {
            return value
        }
    }
    private var subject: BehaviorSubject<T>
    var change: Observable<T> {
        get {
            return subject
        }
    }
    
    init(value: T) {
        self.subject = BehaviorSubject(value: value)
        self.value = value
    }
    
    convenience init(_ value: T) {
        self.init(value: value)
    }
    
    func set(value: T) {
        self.value = value
    }
    
    func subscribe(onNext: @escaping (T) -> Void) -> Disposable {
        return subject.subscribe(onNext: onNext)
    }
    
    func dispose() {
        subject.dispose()
    }
}

