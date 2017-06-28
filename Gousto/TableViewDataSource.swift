//
//  TableViewDataSource.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import UIKit
import Foundation

class TableViewDataSource : NSObject, UITableViewDataSource {
    
    var cellViewModels: [CellViewModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        cell.viewModel = cellViewModels[indexPath.row]
        return cell
    }

}
