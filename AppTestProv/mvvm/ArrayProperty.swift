//
//  ArrayProperty.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import RxSwift

final class ArrayProperty<T>: Disposable {
    
    private var value: [T]
    
    var get: [T] {
        get {
            return value
        }
    }
    
    private var modifiedSubject: BehaviorSubject<Modification<T>>
    
    var modified: Observable<Modification<T>> {
        get {
            return modifiedSubject
        }
    }
    
    init(value: [T]) {
        self.modifiedSubject = BehaviorSubject(value: Modification.initialized(values: value))
        self.value = value
    }
    
    convenience init() {
        self.init(value: [])
    }
    
    func set(value: [T]) {
        self.value = value
        self.modifiedSubject.onNext(Modification.set(values: value))
    }
    
    func append(value: T) {
        self.value.append(value)
        self.modifiedSubject.onNext(Modification.add(values: [value]))
    }
    
    func append(values: [T]) {
        if values.isEmpty { return }
        self.value.append(contentsOf: values)
        self.modifiedSubject.onNext(Modification.add(values: values))
    }
    
    func insert(value: T, atIndex index: Int) {
        self.value.insert(value, at: index)
        self.modifiedSubject.onNext(Modification.add(values: [value]))
    }
    
    func clear() {
        self.modifiedSubject.onNext(Modification.remove(values: self.value))
        self.value.removeAll()
    }
    
    func subscribe(onNext: @escaping (Modification<T>) -> Void) -> Disposable {
        return self.modifiedSubject.subscribe(onNext: onNext)
    }
    
    func dispose() {
        self.modifiedSubject.dispose()
    }
}

enum Modification<T> {
    case initialized(values: [T])
    case set(values: [T])
    case remove(values: [T])
    case add(values: [T])
}

