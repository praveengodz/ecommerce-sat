//
//  RankProduct.swift
//  ECommerce
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation
struct RankProduct : Codable {
    
    let id : Int?
    let viewCount : Int?
    let orderCount : Int?
    let shares : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case viewCount = "view_count"
        case orderCount = "order_count"
        case shares = "shares"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        viewCount = try values.decodeIfPresent(Int.self, forKey: .viewCount)
        orderCount = try values.decodeIfPresent(Int.self, forKey: .orderCount)
        shares = try values.decodeIfPresent(Int.self, forKey: .shares)
    }
    
}
