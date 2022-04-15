//
//  Observable.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import Foundation

//Boxing technique for data binding between View and ViewModel

class Observable <T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
        observer(value)
    }

    
}
