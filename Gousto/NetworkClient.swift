//
//  NetworkClient.swift
//  Gousto
//
//  Created by Iovanna Popova on 19/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

final class NetworkClient {
    
    private unowned let dataStore: DataStoreUpdating
    private let webService: WebService
    
    init(dataStore: DataStoreUpdating) {
        self.dataStore = dataStore
        webService = WebService()
    }
    
    func refresh() {
        webService.load(resource: productResource) { products in
            guard let products = products else {
                return
            }
            DispatchQueue.main.async {
               self.dataStore.update(products: products)
            }
        }
        
        webService.load(resource: categoryResource) { categories in
            guard let categories = categories else {
                return
            }
            DispatchQueue.main.async {
                self.dataStore.update(categories: categories)
            }
        }
    }
}

