//
//  Router.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import UIKit
import Foundation

protocol Routing: class {
    func showProductDetailViewController(with model: ProductDetailViewModel)
    func dismissCategorySelectionViewController()
}

final class Router: Routing {
    let navigationController : UINavigationController
    let viewController: ViewController
    let tableViewDelegate: TableViewDelegate
    unowned let controller: Controller
    
    var detailViewController: ProductDetailViewController!
    var categoriesViewControllerGraph: CategoriesViewControllerGraph!
    
    init(controller: Controller) {
        tableViewDelegate = TableViewDelegate(selectionController: controller)
        viewController = ViewController(delegate: tableViewDelegate, controller: controller)
        viewController.title = "Gousto"
        navigationController = UINavigationController(rootViewController: viewController)
        self.controller = controller
        
        controller.productsUI = viewController
        controller.router = self
        let leftButton = UIBarButtonItem(title: "Categories",
                                         style: .plain,
                                         target: self,
                                         action: #selector(showCategoriesSelectionViewController))
        viewController.navigationItem.leftBarButtonItem = leftButton
    }
    
    func showProductDetailViewController(with model: ProductDetailViewModel) {
        detailViewController = ProductDetailViewController()
        detailViewController.viewModel = model
        navigationController.pushViewController(detailViewController, animated: true)
    }
  
    @objc func showCategoriesSelectionViewController() {
        categoriesViewControllerGraph = CategoriesViewControllerGraph(controller: controller)
        controller.categoriesUI = categoriesViewControllerGraph.viewController
        viewController.present(categoriesViewControllerGraph.viewController, animated: true)
    }
    
    func dismissCategorySelectionViewController() {
        categoriesViewControllerGraph.viewController.dismiss(animated: true)
        categoriesViewControllerGraph = nil
    }
}
