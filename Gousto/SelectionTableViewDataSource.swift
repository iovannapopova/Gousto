//
//  SelectionTableViewDataSource.swift
//  Gousto
//
//  Created by Iovanna Popova on 16/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation
import UIKit

class SelectionTableViewDataSource : NSObject, UITableViewDataSource {
    
    var sectionViewModels: [SelectionSectionViewModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = sectionViewModels[section]
        return sectionViewModel.cellViewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.selectionStyle = .none
        let sectionViewModel = sectionViewModels[indexPath.section]
        let cellViewModel = sectionViewModel.cellViewModels[indexPath.row]
        cell.textLabel?.text = cellViewModel.title
        cell.accessoryType = cellViewModel.isSelected ? .checkmark : .none
        return cell
    }
    
    
}
