//
//  AsyncCommand.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import RxSwift
import RxCocoa

class AsyncCommand<T> {
    
    let canExecute: Observable<Bool>
    let function: () -> Observable<T>
    let executing: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let result: PublishSubject<Result<T>> = PublishSubject()
    let before: PublishSubject<AnyObject?> = PublishSubject()
    let after: PublishSubject<AnyObject?> = PublishSubject()
    let cancelled: PublishSubject<AnyObject?> = PublishSubject()
    var disposable: Disposable?
    var isExecuting: Bool {
        get {
            return (try? executing.value()) ?? false
        }
    }
    
    init(canExecute: Observable<Bool>, function: @escaping () -> Observable<T>) {
        self.canExecute = canExecute
        self.function = function
    }
    
    convenience init(function: @escaping () -> Observable<T>) {
        self.init(canExecute: Observable.just(true), function: function);
    }
    
    func execute() {
        executing.onNext(true);
        before.onNext(nil)
        
        self.disposable?.dispose()
        
        disposable = Observable.deferred(function)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map { Result.Success(value: $0) }
            .catchError { Observable.just(Result.Failure(error: $0)) }
            .do { [weak self] in
                self?.executing.onNext(false)
                self?.after.onNext(nil)
            }
            .subscribe(onNext:{ [weak self] in self?.result.onNext($0) })
        //            .addDisposableTo(bag)
    }
    
    func subscribe(onNext: @escaping (Result<T>) -> Void) -> Disposable {
        return result.subscribe(onNext: onNext)
    }
    
    func subscribeSuccess(onNext: @escaping (T) -> Void) -> Disposable {
        return result.map { result -> T? in
            switch result {
            case .Success(let value):
                return value
            case .Failure(_):
                return nil
            }
            }.filter {$0 != nil}.map {$0!}.subscribe(onNext: onNext)
    }
    
    func before(action: @escaping () -> Void) -> Disposable {
        return before.subscribe { _ in
            action()
        }
    }
    
    func after(action: @escaping () -> Void) -> Disposable {
        return after.subscribe { _ in
            action()
        }
    }
    
    func cancelled(action: @escaping () -> Void) -> Disposable {
        return cancelled.subscribe { _ in
            action()
        }
    }
    
    func cancel() {
        self.disposable?.dispose()
        self.executing.onNext(false);
        self.cancelled.onNext(nil)
    }
}

