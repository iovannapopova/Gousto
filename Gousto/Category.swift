//
//  Category.swift
//  Gousto
//
//  Created by i.popova on 06.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct Category: Deserializable, Serializable {
    
    let id: String
    let title: String
    
    init(dictionary: [String : Any]) throws {
        id = try dictionary.value(for: "id")
        title = try dictionary.value(for: "title")
    }
    
    var dictionary: [String : Any] {
        return ["id" : id, "title" : title]
    }
}
