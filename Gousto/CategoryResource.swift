//
//  CategoryResource.swift
//  Gousto
//
//  Created by Iovanna Popova on 16/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

private let url = URL(string: "https://api.gousto.co.uk/products/v2.0/categories")!

let categoryResource = Resource<[Category]>(url: url) { data in
    let json = try? JSONSerialization.jsonObject(with: data)
    guard let jsonDict = json as? [String: Any] else {
        return nil
    }
    return try? jsonDict.value(for: "data")
}
