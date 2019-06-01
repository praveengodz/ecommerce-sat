//
//  ProductDetailViewController.swift
//  ECommerce
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addedDateLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var variantTable: UITableView!
    
    var product:Product!
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.variantTable.register(UINib(nibName: "VariantsTableViewCell", bundle: nil), forCellReuseIdentifier: VariantsTableViewCellID)
        self.variantTable.tableFooterView = UIView()
        self.title = "Product Detail"
        self.titleLabel.text = product.name
        self.addedDateLabel.text = "Added on \(product.dateAdded?.getFormatedDateString() ?? "-")"
        self.taxLabel.text = "\(product.tax?.name ?? "") : \(product.tax?.value ?? 0) %"
    }
}


extension ProductDetailViewController : UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.variants!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:VariantsTableViewCellID , for: indexPath) as! VariantsTableViewCell
        cell.setupCell(variant: product.variants![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: productDetailSegueID, sender: indexPath)
    }
}
