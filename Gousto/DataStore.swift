//
//  DataStore.swift
//  Gousto
//
//  Created by Iovanna Popova on 19/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

protocol DataStoreObserver: class {
    func productsDidUpdate(products: [Product])
    func categoriesDidUpdate(categories: [Category])
}

protocol DataStoreProtocol: class {
    var products: [Product] { get }
    var categories: [Category] { get }
}

protocol DataStoreUpdating: class {
    func update(products: [Product])
    func update(categories: [Category])
}
