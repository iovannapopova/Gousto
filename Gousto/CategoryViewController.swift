//
//  CategoryViewController.swiftsu
//  Gousto
//
//  Created by Iovanna Popova on 16/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    private let tableView: UITableView
    private let tableViewDataSource: SelectionTableViewDataSource
    private let navigationBar: UINavigationBar
    var controller: Controller
    
    var sectionViewModels: [SelectionSectionViewModel] = [] {
        didSet {
            tableViewDataSource.sectionViewModels = sectionViewModels
            tableView.reloadData()
        }
    }
    
    init(delegate: TableViewDelegate, navigationItem: UINavigationItem, controller: Controller) {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableViewDataSource =  SelectionTableViewDataSource()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = delegate
        navigationBar = UINavigationBar()
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
        navigationBar.pushItem(navigationItem, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(tableView)
        view.addSubview(navigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controller.selectionUIDidAppear()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let barHeight = topLayoutGuide.length + 44
        navigationBar.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: barHeight)
        tableView.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.size.height)
        tableView.contentInset.top = barHeight
    }
}

extension CategoryViewController: SelectionUI { }
