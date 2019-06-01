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
    var subCategoryIds = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        table.register(UINib(nibName: "SubcategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "SubcategoryTableViewCellID")
        table.tableFooterView = UIView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SubCategoriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoryIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubcategoryTableViewCellID", for: indexPath) as! SubcategoryTableViewCell
        let subcategory = categories.filter{$0.id == subCategoryIds[indexPath.row]}
        cell.setupCell(category: subcategory.first!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
