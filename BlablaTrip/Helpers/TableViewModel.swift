//
//  TableViewModel.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

protocol TableViewModel {
    associatedtype Model: Sequence
    var model: Model { get }
    
    var numberOfSection: Int { get }
    
    func numberOfRowIn(_ section: Int) -> Int
    func elementAt(_ indexPath: IndexPath) -> Model.Element
}

extension TableViewModel where Model: Collection {
    var numberOfSection: Int { return 1 }
    
    func numberOfRowIn(_ section: Int) -> Int {
        return model.count
    }
    
    func elementAt(_ indexPath: IndexPath) -> Model.Element {
        guard case 0...model.count = indexPath.row else {
            fatalError("model object cannot be found at row: \(indexPath.row)!")
        }
        let index = model.index(model.startIndex, offsetBy: indexPath.row)
        return model[index]
    }
}
