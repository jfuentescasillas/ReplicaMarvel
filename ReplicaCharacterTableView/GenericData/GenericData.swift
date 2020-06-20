//
//  GenericData.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 08/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import Foundation


class GenericData<T>: NSObject {
    typealias observer = ((T?) -> Void)

    var data: T? {
        didSet {
            notify()
        }
    }

    var observer: observer?
    
    init(_ data: T?) {
        self.data = data
    }

    func addObserver(_ observer: @escaping observer) {
        self.observer = observer
    }

    func notify() {
        self.observer?(data)
    }
}
