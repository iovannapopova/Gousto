//
//  Controller.swift
//  Gousto
//
//  Created by Iovanna Popova on 18/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

protocol UI: class {
    var cellViewModels: [CellViewModel] { get set }
}

protocol SelectionUI: class {
    var sectionViewModels: [SelectionSectionViewModel] { get set }
}

protocol TableSelection: class {
    func onRowSelected(at indexPath: IndexPath)
}

protocol UIDelegate: class {
    func uiDidAppear()
}

protocol SelectionUIDelegate: class {
    func selectionUIDidAppear()
}

final class Controller {
    fileprivate unowned let store: DataStoreProtocol
    fileprivate var products: [Product] { return store.products }
    fileprivate var categories: [Category] { return store.categories }
    
    fileprivate var selectedCategories: Set<String>? = nil
    
    weak var productsUI: UI!
    weak var categoriesUI: SelectionUI?
    weak var router: Routing!
    
    fileprivate var filteredProducts: [Product] {
        guard let selectedCategories = selectedCategories else {
            return products
        }
        return products.filter { (product) -> Bool in
            for category in product.categories {
                if selectedCategories.contains(category.id) {
                    return true
                }
            }
            return false
        }
    }
    
    init(store: DataStoreProtocol) {
        self.store = store
    }
    
    @objc func onCategoriesSelected() {
        updateProductsUI()
        router.dismissCategorySelectionViewController()
    }
    
    fileprivate func updateProductsUI() {
        productsUI.cellViewModels = filteredProducts.map { product in
            return CellViewModel(text: product.title,
                                 detail: "Price: " + product.price.stringValue,
                                 imageURL: product.imagesByWidth["150"]!.url)
        }
    }
    
    fileprivate func updateCategoriesUI() {
        let viewModel = SelectionCellViewModel(title: "All Categories",
                                               isSelected: self.selectedCategories == nil)
        let allCategoriesSectionViewModel = SelectionSectionViewModel(title: "All Categories",
                                                                      cellViewModels: [viewModel])
        let cellViewModels = categories.map { category in
            return SelectionCellViewModel(title: category.title,
                                          isSelected: selectedCategories?.contains(category.id) ?? false)
        }
        let categoriesSectionViewModel = SelectionSectionViewModel(title: "Other categories",
                                                                   cellViewModels: cellViewModels)
        self.categoriesUI?.sectionViewModels = [allCategoriesSectionViewModel, categoriesSectionViewModel]
    }
}

extension Controller: TableSelection {
    func onRowSelected(at indexPath: IndexPath) {
        if categoriesUI != nil {
            if indexPath.section == 0 {
                selectedCategories = nil
            } else {
                if selectedCategories == nil {
                    selectedCategories = []
                }
                let categoryID = categories[indexPath.row].id
                if selectedCategories!.contains(categoryID) {
                    selectedCategories!.remove(categoryID)
                    selectedCategories = selectedCategories!.isEmpty ? nil : selectedCategories
                } else {
                    selectedCategories!.insert(categoryID)
                }
            }
            updateCategoriesUI()
        } else {
            let product = filteredProducts[indexPath.row]
            let vm = ProductDetailViewModel(title: product.title,
                                            description: product.description,
                                            price: "Price: " + product.price.stringValue,
                                            imageURL: product.imagesByWidth["400"]!.url)
            router.showProductDetailViewController(with: vm)
        }
    }
}

extension Controller: UIDelegate {
    func uiDidAppear() {
        updateProductsUI()
    }
}

extension Controller: SelectionUIDelegate {
    func selectionUIDidAppear() {
        updateCategoriesUI()
    }
}

extension Controller: DataStoreObserver {
    func productsDidUpdate(products: [Product]) {
        updateProductsUI()
    }
    
    func categoriesDidUpdate(categories: [Category]) {
        updateCategoriesUI()
    }
}
