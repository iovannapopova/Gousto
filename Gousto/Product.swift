//
//  Product.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct Product: Deserializable, Serializable {
    
    let id: String
    let title: String
    let description: String
    let price: NSDecimalNumber
    let imagesByWidth: [String: Image]
    let categories: [Category]
    
    init(dictionary: [String : Any]) throws {
        id = try dictionary.value(for: "id")
        title = try dictionary.value(for: "title")
        description = try dictionary.value(for: "description")
        price = try dictionary.value(for: "list_price", via: NSDecimalNumber.init)
        imagesByWidth = try dictionary.value(for: "images")
        categories = try dictionary.value(for: "categories")
    }
    
    var dictionary: [String : Any] {
        var images: [String: [String: Any]] = [:]
        for image in imagesByWidth {
            images[image.key] = image.value.dictionary
        }
        return ["id" : id,
                "title" : title,
                "description" : description,
                "list_price" : price.stringValue,
                "images": images,
                "categories": categories.map { $0.dictionary }
        ]
    }
}
