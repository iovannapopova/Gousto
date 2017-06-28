//
//  Resource.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}


