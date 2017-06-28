//
//  CategoriesViewControllerGraph.swift
//  Gousto
//
//  Created by Iovanna Popova on 18/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation
import UIKit

final class CategoriesViewControllerGraph {
    private let selectionTableViewDelegate: TableViewDelegate
    let viewController: CategoryViewController
    
    init(controller: Controller) {
        selectionTableViewDelegate = TableViewDelegate(selectionController: controller)
        let leftButton = UIBarButtonItem(title: "Select",
                                         style: .plain,
                                         target: controller,
                                         action: #selector(Controller.onCategoriesSelected))
        let navigationItem = UINavigationItem(title: "Categories")
        navigationItem.leftBarButtonItem = leftButton
        viewController = CategoryViewController(delegate: selectionTableViewDelegate,
                                                navigationItem: navigationItem,
                                                controller: controller)
        viewController.title  = "Categories"
    }
}
