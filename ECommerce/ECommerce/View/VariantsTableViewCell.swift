//
//  VariantsTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class VariantsTableViewCell: UITableViewCell {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(variant:Variant)  {
        self.colourLabel.text = variant.color ?? "NA"
        self.sizeLabel.text = "\(variant.size ?? 0)"
        self.priceLabel.text = "\(variant.price ?? 0)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
