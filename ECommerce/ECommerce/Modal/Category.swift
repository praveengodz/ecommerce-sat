//
//  Category.swift
//  ECommerce
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation

struct Category : Codable {
    
    let childCategories : [Int]?
    let id : Int?
    let name : String?
    let products : [Product]?
    
    enum CodingKeys: String, CodingKey {
        case childCategories = "child_categories"
        case id = "id"
        case name = "name"
        case products = "products"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        childCategories = try values.decodeIfPresent([Int].self, forKey: .childCategories)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }
    
}
