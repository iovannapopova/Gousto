//
//  TableViewDelegate.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import UIKit
import Foundation

final class TableViewDelegate : NSObject, UITableViewDelegate {
    private unowned let selectionController: TableSelection
    
    init(selectionController: TableSelection) {
        self.selectionController = selectionController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionController.onRowSelected(at: indexPath)
    }
    
}
