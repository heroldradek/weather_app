//
//  Rx.swift
//  Weather App
//
//  Created by Radek Herold on 21.03.2021.
//

import RxSwift
import RxSwiftExt
import RxCocoa

public extension Observable {
    func toVoid() -> Observable<Void> {
        return mapTo(())
    }
}
