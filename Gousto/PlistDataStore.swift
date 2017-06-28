//
//  PlistDataStore.swift
//  Gousto
//
//  Created by Iovanna Popova on 19/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

final class PlistDataStore: DataStoreProtocol, DataStoreUpdating {
    private(set) var products: [Product] {
        didSet {
            serialize(products, toFileAt: productPlist)
        }
    }
    private(set) var categories: [Category] {
        didSet {
            serialize(categories, toFileAt: categoryPlist)
        }
    }
    
    weak var observer: DataStoreObserver!
    
    init() {
        //TODO: move disk access off the main thread
        products = deserializeFromFile(at: productPlist)
        categories = deserializeFromFile(at: categoryPlist)
    }
    
    func update(products: [Product]) {
        self.products = products
        observer.productsDidUpdate(products: products)
    }
    
    func update(categories: [Category]) {
        self.categories = categories
        observer.categoriesDidUpdate(categories: categories)
    }
}

private func serialize<A: Serializable>(_ entities: [A], toFileAt url:URL) {
    (entities.map { $0.dictionary } as NSArray).write(to: url, atomically: true)
}

private func deserializeFromFile<A: Deserializable>(at url:URL) -> [A] {
    return (NSArray(contentsOf: url) ?? []).flatMap {
        $0 as? [String: Any]
    }.flatMap {
        try? A(dictionary: $0)
    }
}

private let cachesDir = FileManager().urls(for: .cachesDirectory, in: .userDomainMask)[0]
private let productPlist = cachesDir.appendingPathComponent("products.plist")
private let categoryPlist = cachesDir.appendingPathComponent("categories.plist")
