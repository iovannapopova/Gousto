//
//  SelectionCellViewModel.swift
//  Gousto
//
//  Created by Iovanna Popova on 16/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct SelectionCellViewModel: Equatable {
    
    let title: String
    let isSelected: Bool
    
    static func == (lhs: SelectionCellViewModel,rhs: SelectionCellViewModel) -> Bool {
        if lhs.title != rhs.title {
            return false
        }
        if lhs.isSelected != rhs.isSelected {
            return false
        }
        return true
    }
}

