//
//  ServiceURLMapper.swift
//  EditableProfile
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation
import UIKit

enum ServiceURLType:Int {
    case products      = 0
}

let kBASEURL = "https://stark-spire-93433.herokuapp.com/json"

class ServiceURLMapper: NSObject {
    
    @inline(__always)
    class func mapUrl(type:ServiceURLType,pageCount:Int = 1, appendString:String? = nil) -> URL {
        var urlString:String = ""
        switch type {
        case .products:
            urlString = ServiceURLMapper.getBaseUrl() 
        }
        if let appendString = appendString {
            urlString = urlString + appendString
        }
        return URL(string: (urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!)!
    }
    
    class func getBaseUrl()->String{
        return kBASEURL
    }
    
    //Define Headers
    @inline(__always)
    class func getHTTPHeaderFields()->[String:String]{
        var urlHeader:[String:String] = [String:String]()
        urlHeader["Content-Type"] = "application/json"
        return urlHeader
    }
    
}
