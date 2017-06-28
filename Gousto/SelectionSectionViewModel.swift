//
//  SelectionSectionViewModel.swift
//  Gousto
//
//  Created by Iovanna Popova on 17/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

struct SelectionSectionViewModel: Equatable {
    
    let title: String
    let cellViewModels: [SelectionCellViewModel]
    
    static func == (lhs: SelectionSectionViewModel, rhs: SelectionSectionViewModel) -> Bool {
        if lhs.title != rhs.title {
            return false
        }
        if lhs.cellViewModels != rhs.cellViewModels {
            return false
        }
        return true
    }
}
