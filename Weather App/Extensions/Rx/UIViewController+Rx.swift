//
//  UIViewController+Rx.swift
//  Weather App
//
//  Created by Radek Herold on 21.03.2021.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    
    var viewDidLoad: Observable<Void> {
        return self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in Void() }
    }
    
    var viewWillAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
    }
    
    var title: Binder<String> {
        return Binder(self.base) { viewController, title in
            viewController.title = title
        }
    }
}
