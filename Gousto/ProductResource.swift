//
//  ProductResource.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

private let url = URL(string: "https://api.gousto.co.uk/products/v2.0/products?includes%5B%5D=categories&includes%5B%5D=attributes&image_sizes%5B%5D=400&image_sizes%5B%5D=150")!

let productResource = Resource<[Product]>(url: url) { data in
    let json = try? JSONSerialization.jsonObject(with: data)
    guard let jsonDict = json as? [String: Any] else {
        return nil
    }
    return try? jsonDict.value(for: "data")
}
