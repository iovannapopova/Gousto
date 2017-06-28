//
//  ProductDetailViewModel.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct ProductDetailViewModel: Equatable {
    
    let title: String
    let description: String
    let price: String
    let imageURL: URL
    
    static func == (lhs: ProductDetailViewModel, rhs: ProductDetailViewModel) -> Bool {
        if lhs.title != rhs.title {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.price != rhs.price {
            return false
        }
        if lhs.imageURL != rhs.imageURL {
            return false
        }
        return true
    }
}
