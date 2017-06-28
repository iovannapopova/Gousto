//
//  ControllerTests.swift
//  Gousto
//
//  Created by Iovanna Popova on 19/03/2017.
//  Copyright © 2017 i.popova. All rights reserved.
//

import XCTest
@testable import Gousto

final class FakeDataStore: DataStoreProtocol {
    var products: [Product] = []
    var categories: [Gousto.Category] = []
}

final class UISpy: UI {
    var cellViewModels: [CellViewModel] = []
}

final class SelectionUISpy: SelectionUI {
    var sectionViewModels: [SelectionSectionViewModel] = []
}

final class RoutingSpy: Routing {
    var dismissCategoryWasCalled: Bool = false
    var showProductDetailWasCalledWithModel: ProductDetailViewModel? = nil
    func dismissCategorySelectionViewController() {
        dismissCategoryWasCalled = true
    }
    func showProductDetailViewController(with model: ProductDetailViewModel) {
        showProductDetailWasCalledWithModel = model
    }
}

final class ControllerTests: XCTestCase {
    
    private let dataStore = FakeDataStore()
    private let productsUI: UISpy = UISpy()
    private let categoriesUI: SelectionUISpy = SelectionUISpy()
    private let router: RoutingSpy = RoutingSpy()
    private var controller: Controller!
    
    override func setUp() {
        controller = Controller(store: dataStore)
        controller.productsUI = productsUI
        controller.categoriesUI = categoriesUI
        controller.router = router
        
        dataStore.products = testProducts
        dataStore.categories = testCategories
    }
    
    func test_whenUIDidAppear_updatesUIWithViewModels() {
        controller.uiDidAppear()
        
        let expectedViewModel = [CellViewModel(text: "Balsajo Black Garlic Cloves",
                                               detail: "Price: 9.95",
                                               imageURL: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!),
                                 CellViewModel(text: "Sancerre Blanc",
                                               detail: "Price: 7.95",
                                               imageURL: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!)
        ]
        XCTAssertEqual(productsUI.cellViewModels, expectedViewModel)
    }
    
    func test_whenSelectionUIDidAppear_updatesSelectionUIWithViewModels() {
        controller.selectionUIDidAppear()
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: true,
                                                     firstCategorySelected: false,
                                                     secondCategorySelected: false)
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
    
    func test_whenCategoryRowIsSelected_updatesSelectionUI() {
        controller.onRowSelected(at: IndexPath(row: 0, section: 1))
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: false,
                                                     firstCategorySelected: true,
                                                     secondCategorySelected: false)
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
    
    func test_whenAllCategoryRowIsSelected_updatesSelectionUI() {
        controller.onRowSelected(at: IndexPath(row: 0, section: 1))
        controller.onRowSelected(at: IndexPath(row: 0, section: 0))
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: true,
                                                     firstCategorySelected: false,
                                                     secondCategorySelected: false)
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
    
    func test_whenLastCategoryIsDeselected_selectsAllCategories() {
        controller.onRowSelected(at: IndexPath(row: 0, section: 1))
        controller.onRowSelected(at: IndexPath(row: 0, section: 1))
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: true,
                                                     firstCategorySelected: false,
                                                     secondCategorySelected: false)
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
    
    func test_whenTwoCategoriesAreSelected_selectsBothInUI() {
        controller.onRowSelected(at: IndexPath(row: 0, section: 1))
        controller.onRowSelected(at: IndexPath(row: 1, section: 1))
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: false,
                                                     firstCategorySelected: true,
                                                     secondCategorySelected: true)
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
    
    func test_whenCategoryDeselected_deselectsOnlyThisCategory() {
        controller.onRowSelected(at: IndexPath(row: 0, section: 1))
        controller.onRowSelected(at: IndexPath(row: 1, section: 1))
        controller.onRowSelected(at: IndexPath(row: 1, section: 1))
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: false,
                                                     firstCategorySelected: true,
                                                     secondCategorySelected: false)
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
    
    func test_whenCategoryIsSelected_filtersProducts() {
        controller.onRowSelected(at: IndexPath(row: 1, section: 1))
        controller.onCategoriesSelected()
        
        let expectedVM = [CellViewModel(text: "Sancerre Blanc",
                                        detail: "Price: 7.95",
                                        imageURL: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!)]
        XCTAssertEqual(productsUI.cellViewModels, expectedVM)
    }
    
    func test_whenDoneSelectingCategories_dismissesCategoryVC() {
        
        controller.onCategoriesSelected()
        
        XCTAssertTrue(router.dismissCategoryWasCalled)
    }
    
    func test_whenProductRowSelected_showsProductDetailVCWithViewModel() {
        controller.categoriesUI = nil
        
        controller.onRowSelected(at: IndexPath(row: 0, section: 0))
        
        let expectedVM = ProductDetailViewModel(title: "Balsajo Black Garlic Cloves",
                                                description: "What happens if you leave a premium garlic bulb in an oven for a few weeks to slow cook? You get this wonderful stuff! With a sweet, strong and balsamicky taste, it’s a seriously exciting ingredient to try out in your cooking.",
                                                price: "Price: 9.95",
                                                imageURL: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Wines-Red-BaronBayRiojaReserva_26683-x400.jpg")!)
        XCTAssertEqual(router.showProductDetailWasCalledWithModel, expectedVM)
    }
    
    func test_whenProductsAreUpdates_updatesProductUI() {
        controller.productsDidUpdate(products: testProducts)
        
        let expectedViewModel = [CellViewModel(text: "Balsajo Black Garlic Cloves",
                                               detail: "Price: 9.95",
                                               imageURL: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!),
                                 CellViewModel(text: "Sancerre Blanc",
                                               detail: "Price: 7.95",
                                               imageURL: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!)]
        XCTAssertEqual(productsUI.cellViewModels, expectedViewModel)
    }
    
    func test_whenCategoriesAreUpdates_updatesCategoriesUI() {
        controller.categoriesDidUpdate(categories: testCategories)
        
        let expectedVM = expectedCategoriesViewModel(allCategoriesSelected: true,
                                                     firstCategorySelected: false,
                                                     secondCategorySelected: false)
        
        XCTAssertEqual(categoriesUI.sectionViewModels, expectedVM)
    }
}

private let testCategories = [
    Gousto.Category(id: "a44b4c22-e489-11e6-9d77-027ca04bdf39", title: "Most Popular"),
    Gousto.Category(id: "faeedf8a-bf7d-11e5-a0f9-02fada0dd3b9", title: "Drinks Cabinet")
]

private let image = Image(src: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!,
                          url: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Balsajo-BlackGarlic_17876-x200.jpg")!,
                          width: 200)
private let bigImage = Image(src: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Wines-Red-BaronBayRiojaReserva_26683-x400.jpg")!,
                             url: URL(string: "https://production-media.gousto.co.uk/cms/product-image-landscape/Wines-Red-BaronBayRiojaReserva_26683-x400.jpg")!,
                             width: 400)

private let testProducts = [
    Product(id: "0a8e892c-1780-11e6-9f77-0255e2c77e1d",
            title: "Balsajo Black Garlic Cloves",
            description: "What happens if you leave a premium garlic bulb in an oven for a few weeks to slow cook? You get this wonderful stuff! With a sweet, strong and balsamicky taste, it’s a seriously exciting ingredient to try out in your cooking.",
            price: NSDecimalNumber(string: "9.95"),
            imagesByWidth: ["150": image, "400": bigImage],
            categories: [testCategories[0]]),
    Product(id: "02c225f2-63b4-11e6-8516-023d2759e21d",
            title: "Sancerre Blanc",
            description: "Intriguing notes of vanilla and chocolate make this fruity, full-bodied wine unique. With a long, pleasant finish and woody aroma supporting it, this characterful wine is a good match with beef dishes. ABV 14%.",
            price: NSDecimalNumber(string: "7.95"),
            imagesByWidth: ["150": image, "400": bigImage],
            categories: [testCategories[1]])
]

private func expectedCategoriesViewModel(allCategoriesSelected: Bool,
                                         firstCategorySelected: Bool,
                                         secondCategorySelected: Bool) -> [SelectionSectionViewModel] {
    let allCategoriesViewModel = SelectionSectionViewModel(
        title: "All Categories",
        cellViewModels: [
            SelectionCellViewModel(title: "All Categories", isSelected: allCategoriesSelected)
        ]
    )
    let otherCategoriesViewModel = SelectionSectionViewModel(
        title: "Other categories",
        cellViewModels: [
            SelectionCellViewModel(title: "Most Popular", isSelected: firstCategorySelected),
            SelectionCellViewModel(title: "Drinks Cabinet", isSelected: secondCategorySelected)
        ]
    )
    return [allCategoriesViewModel, otherCategoriesViewModel]
}

private extension Product {

    init(id: String, title: String, description: String, price: NSDecimalNumber, imagesByWidth: [String: Image], categories: [Gousto.Category]) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.imagesByWidth = imagesByWidth
        self.categories = categories
    }
}

private extension Image {
    
    init(src: URL, url: URL, width: Int) {
        self.src = src
        self.url = url
        self.width = width
    }
}

private extension Gousto.Category {
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
