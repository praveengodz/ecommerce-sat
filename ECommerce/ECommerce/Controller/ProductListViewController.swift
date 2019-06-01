//
//  ProductListViewController.swift
//  ECommerce
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var category:Category!
    var ranks = [Rank]()
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        products = category.products!
        table.register(UINib(nibName: "SubcategoryTableViewCell", bundle: nil), forCellReuseIdentifier: SubcategoryTableViewCellID)
        table.tableFooterView = UIView()
        self.title = category.name
    }

    @IBAction func filterAction(_ sender: Any) {
        let filter: UIAlertController = UIAlertController(title: "", message: "Sort products by ", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        filter.addAction(cancelActionButton)
        for rank in ranks {
            let rankButton = UIAlertAction(title: rank.rankName, style: .default) { _ in
                self.sortProducts(rank: rank)
            }
            filter.addAction(rankButton)
        }
        self.present(filter, animated: true, completion: nil)
    }
    
    func sortProducts(rank:Rank) {
        for rankProduct in rank.rankProducts! {
            let product = products.filter{$0.id == rankProduct.id}
            if product.count == 1 {
                switch rank.rankName {
                case  mostViewedProducts :
                    product.first!.sortValue = rankProduct.viewCount!
                case mostOrderedProducts :
                    product.first!.sortValue = rankProduct.orderCount!
                case mostSharedProducts :
                    product.first!.sortValue = rankProduct.shares!
                default :
                    product.first!.sortValue = 0
                }
            }
        }
        products = (category.products?.sorted(by: { $0.sortValue > $1.sortValue }))!
        table.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productDetailSegueID {
            let destinationVC = segue.destination as! ProductDetailViewController
            let indexPath = sender as! IndexPath
            destinationVC.product = products[indexPath.row]
        }
    }

}

extension ProductListViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryTableViewCellID, for: indexPath) as! SubcategoryTableViewCell
        cell.contentLabel.text = products[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: productDetailSegueID, sender: indexPath)
    }
}
