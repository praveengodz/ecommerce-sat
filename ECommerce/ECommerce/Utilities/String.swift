//
//  String.swift
//  ECommerce
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation

extension String {
    func getFormatedDateString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        if let date = dateFormatterGet.date(from: self) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}
