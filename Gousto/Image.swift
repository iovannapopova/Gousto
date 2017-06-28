//
//  Image.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct Image: Deserializable, Serializable {
    
    let src: URL
    let url: URL
    let width: Int
    
    init(dictionary: [String : Any]) throws {
        src = try dictionary.value(for: "src", via: URL.init)
        url = try dictionary.value(for: "url", via: URL.init)
        width = try dictionary.value(for: "width")
    }
    
    var dictionary: [String : Any] {
        return ["src" : src.absoluteString, "url" : url.absoluteString, "width" : width]
    }
}
