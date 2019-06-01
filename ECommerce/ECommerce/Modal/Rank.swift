//
//  Rank.swift
//  ECommerce
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation

struct Rank : Codable {
    let rankProducts : [RankProduct]?
    let rankName : String?
    
    enum CodingKeys: String, CodingKey {
        case rankProducts = "products"
        case rankName = "ranking"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rankProducts = try values.decodeIfPresent([RankProduct].self, forKey: .rankProducts)
        rankName = try values.decodeIfPresent(String.self, forKey: .rankName)
    }
}
