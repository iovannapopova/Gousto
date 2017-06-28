//
//  CellVewModel.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct CellViewModel: Equatable {
    
    let text: String
    let detail: String
    let imageURL: URL
    
    static func == (lhs: CellViewModel,rhs: CellViewModel) -> Bool {
        if lhs.text != rhs.text {
            return false
        }
        if lhs.detail != rhs.detail {
            return false
        }
        if lhs.imageURL != rhs.imageURL {
            return false
        }
        return true
    }
    
}
