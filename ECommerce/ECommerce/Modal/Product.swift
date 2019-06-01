//  Product.swift
//  ECommerce
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation

struct Product : Codable {
    
    let dateAdded : String?
    let id : Int?
    let name : String?
    let tax : Tax?
    let variants : [Variant]?
    
    enum CodingKeys: String, CodingKey {
        case dateAdded = "date_added"
        case id = "id"
        case name = "name"
        case tax = "tax"
        case variants = "variants"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dateAdded = try values.decodeIfPresent(String.self, forKey: .dateAdded)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        tax = try values.decodeIfPresent(Tax.self, forKey: .tax)
        variants = try values.decodeIfPresent([Variant].self, forKey: .variants)
    }
    
}
