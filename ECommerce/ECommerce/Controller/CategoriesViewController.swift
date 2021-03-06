//
//  ViewController.swift
//  ECommerce
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var categories = [Category]()
    var mainCategories = [Category]()
    var ranks = [Rank]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.getProducts()
    }

    func setupView() {
        table.register(UINib(nibName: "CategoryTableviewCell", bundle: nil), forCellReuseIdentifier: CategoryTableviewCellID)
        table.register(UINib(nibName: "SubcategoryTableViewCell", bundle: nil), forCellReuseIdentifier: SubcategoryTableViewCellID)
        table.tableFooterView = UIView()
        self.title = "Main Categories"
    }
    
    func getProducts() {
        let categoryList = Storage.retrieve(kCategoryListKey, from: .documents, as: [Category].self)
        let rankList = Storage.retrieve(kRankListKey, from: .documents, as: [Rank].self)
        if categoryList != nil && rankList != nil {
            self.filterData(caetgory: categoryList!, rank: rankList!)
        } else {
            LoadingView.sharedInstance.showActivityIndicatorWithMessage(msg: "")
            LoadingView.sharedInstance.center = self.view.center
            WebserviceManager.getProducts(sender: self, successCallBack: { (result) in
                DispatchQueue.main.async {
                    LoadingView.sharedInstance.hideActivityIndicator()
                    let res = result as! Array<Any>
                    self.filterData(caetgory: res[0] as! [Category], rank: res[1] as! [Rank])
                }
            }) { (error) in
                DispatchQueue.main.async {
                    LoadingView.sharedInstance.hideActivityIndicator()
                    Alerts.sharedInstance.showAlertWithSingleButton(message: "Product details not available", sender: self)
                }
            }
        }
    }
    
    func filterData(caetgory:[Category],rank:[Rank]) {
        self.categories = caetgory
        self.ranks = rank
        let tempCategory = self.categories.filter {$0.childCategories?.count != 0}
        var childCatids = [Int]()
        for temp in tempCategory {
            childCatids.append(contentsOf: temp.childCategories!)
        }
        for mainCategory in tempCategory {
            if childCatids.contains(mainCategory.id!) == false {
                self.mainCategories.append(mainCategory)
            }
        }
        self.table.reloadData()
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == subCategorySegueID {
            let destinationVC = segue.destination as! SubCategoriesViewController
            let indexPath = sender as! IndexPath
            let subCategoryIds = mainCategories[indexPath.section].childCategories
            let subcategory = categories.filter{$0.id == subCategoryIds![indexPath.row]}
            destinationVC.categories = categories
            destinationVC.subCategoryIds = (subcategory.first?.childCategories)!
            destinationVC.categoryName = subcategory.first!.name
            destinationVC.ranks = self.ranks
        }
     }
    
}

extension CategoriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCategories[section].childCategories!.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableviewCellID) as! CategoryTableviewCell
        headerCell.setupCell(category: mainCategories[section])
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryTableViewCellID, for: indexPath) as! SubcategoryTableViewCell
        let subCategoryIds = mainCategories[indexPath.section].childCategories
        let subcategory = categories.filter{$0.id == subCategoryIds![indexPath.row]}
        cell.setupCell(category: subcategory.first!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: subCategorySegueID, sender: indexPath)
    }
}
