//
//  SubCategoriesViewController.swift
//  ECommerce
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class SubCategoriesViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var categories = [Category]()
    var ranks = [Rank]()
    var subCategoryIds = [Int]()
    var categoryName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        table.register(UINib(nibName: "SubcategoryTableViewCell", bundle: nil), forCellReuseIdentifier: SubcategoryTableViewCellID)
        table.tableFooterView = UIView()
        self.title = categoryName
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == productListSegueID {
            let destinationVC = segue.destination as! ProductListViewController
            let indexPath = sender as! IndexPath
            let subcategory = categories.filter{$0.id == subCategoryIds[indexPath.row]}
            destinationVC.category = subcategory.first
            destinationVC.ranks = self.ranks
        }
    }
    

}

extension SubCategoriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoryIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryTableViewCellID, for: indexPath) as! SubcategoryTableViewCell
        let subcategory = categories.filter{$0.id == subCategoryIds[indexPath.row]}
        cell.setupCell(category: subcategory.first!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: productListSegueID, sender: indexPath)
    }
}
