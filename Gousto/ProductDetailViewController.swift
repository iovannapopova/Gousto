//
//  ProductDetailViewController.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var text: String?
    var viewModel: ProductDetailViewModel! {
        didSet {
            update()
        }
    }
    let descriptionLabel: UILabel
    let priceLabel: UILabel
    let imageView: UIImageView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        priceLabel = UILabel()
        priceLabel.textColor = .gray
        priceLabel.textAlignment = .right
        imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = view.bounds.size.width
        let height:CGFloat = 250.0
        let inset:CGFloat = 20.0
        imageView.frame = CGRect(x: 0.0, y: topLayoutGuide.length, width: width, height: height)
        
        let descriptionSize = descriptionLabel.sizeThatFits(CGSize(width: width - 2*inset, height: CGFloat.infinity))
        descriptionLabel.frame = CGRect(x: inset, y: imageView.frame.size.height + imageView.frame.origin.y + inset, width: descriptionSize.width, height: descriptionSize.height)
        
        let priceSize = priceLabel.sizeThatFits(CGSize(width: width - inset, height: CGFloat.infinity))
        priceLabel.frame = CGRect(x: inset, y: (descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y + inset), width: view.frame.size.width - 2*inset, height: priceSize.height)
    }
    
    func update() {
        
        title = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        
        imageView.image = nil
        let task = URLSession.shared.dataTask(with: viewModel.imageURL) { (responseData, response, _) in
            guard let data = responseData else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data, scale: UIScreen.main.scale)
                self.view.setNeedsLayout()
            }
        }
        task.resume()
        
    }
    
}
