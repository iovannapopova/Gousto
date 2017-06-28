//
//  WebService.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

final class WebService {
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, _, _) in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }
    
}
