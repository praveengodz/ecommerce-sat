//  Variant.swift
//  ECommerce
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation

struct Variant : Codable {
    
    let color : String?
    let id : Int?
    let price : Int?
    let size : Int?
    
    enum CodingKeys: String, CodingKey {
        case color = "color"
        case id = "id"
        case price = "price"
        case size = "size"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
    }
    
}
