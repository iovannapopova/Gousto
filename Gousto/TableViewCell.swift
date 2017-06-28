//
//  TableViewCell.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import UIKit
import Foundation

class TableViewCell: UITableViewCell {
    
    var viewModel: CellViewModel! {
        didSet {
            if oldValue != viewModel {
                update()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.textColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        textLabel?.text = viewModel.text
        detailTextLabel?.text = viewModel.detail
        imageView?.image = nil
        let task = URLSession.shared.dataTask(with: viewModel.imageURL) { (responseData, response, _) in
            guard let data = responseData else {
                return
            }
            DispatchQueue.main.async {
                guard response?.url == self.viewModel.imageURL else {
                    return
                }
                self.imageView?.image = UIImage(data: data, scale: UIScreen.main.scale)
                self.setNeedsLayout()
                
            }
        }
        task.resume()
    }
}
