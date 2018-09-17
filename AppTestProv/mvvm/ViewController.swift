//
//  ViewController.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

infix operator <->
infix operator <-
infix operator </-

func <-> (left: Property<String>, right: UITextField) {
    left.change
        .filter { $0 != right.text }
        .subscribe(onNext: { right.text = $0 })
    
    right.rx.text.filter({ (str) -> Bool in
        left.value != str
    }).subscribe(onNext: { val in
        left.value = val!
    })
}

func <-> (left: Property<String>, right: UITextView) {
    left.change
        .filter { $0 != right.text }
        .subscribe(onNext: { right.text = $0 })
    
    right.rx.text.filter({ (str) -> Bool in
        left.value != str
    }).subscribe(onNext: { val in
        left.value = val!
    })
}

func <-> (left: Property<Bool>, right: UISwitch) {
    left.change
        .filter { right.isOn != $0 }
        .subscribe(onNext: { right.isOn = $0 })
    
    right.rx.value.filter({ (val) -> Bool in
        left.value != val
    }).subscribe(onNext: { val in
        left.value = val
    })
}

func <- (left: Property<String>, right: UILabel) {
    left.subscribe(onNext: { right.text = $0 })
}

func <- (left: Command, right: UIButton) -> Disposable {
    return right.rx.tap.subscribe(onNext: { left.execute() })
}

func <- (left: Command, right: UIBarButtonItem) -> Disposable {
    return right.rx.tap.subscribe(onNext: { left.execute() })
}

func <- (left: Property<NSURL?>, right: UIImageView) {
    left.change
        .map { $0! }
        .subscribe(onNext: { right.af_setImage(withURL: $0 as URL) })
}

func <-<T> (left: AsyncCommand<T>, right: UIButton) {
    right.rx.tap.subscribe(onNext: { left.execute() })
    Observable.combineLatest(left.executing, left.canExecute) { !$0 && $1 }.subscribe(onNext: { right.isEnabled = $0 })
}

func <-<T> (left: AsyncCommand<T>, right: UIBarButtonItem) {
    right.rx.tap.subscribe(onNext: { left.execute() })
    Observable.combineLatest(left.executing, left.canExecute) { !$0 && $1 }.subscribe(onNext: { right.isEnabled = $0 })
}

func <-<T> (left: AsyncCommand<T>, right: UIActivityIndicatorView) {
    right.hidesWhenStopped = true
    left.executing.subscribe(onNext: {
        if $0 {
            right.startAnimating()
        } else {
            right.stopAnimating()
        }
    })
}

func </-<T> (left: AsyncCommand<T>, right: UIControl) {
    left.executing.subscribe(onNext: { right.isEnabled = !$0 })
}

