//
//  SubcategoryTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 31/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class SubcategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(category:Category) {
        self.contentLabel.text = category.name
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
