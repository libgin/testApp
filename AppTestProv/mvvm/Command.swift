//
//  Command.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import RxSwift

class Command {
    let canExecute: Observable<Bool>!
    private var actions: [(() -> Void)] = []
    
    init(canExecute: Observable<Bool>) {
        self.canExecute = canExecute
    }
    
    convenience init() {
        self.init(canExecute: Observable.just(true))
    }
    
    @objc
    func execute() {
        actions.forEach { action in
            action()
        }
    }
    
    func subscribe(action: @escaping () -> Void) {
        self.actions.append(action)
    }
}

