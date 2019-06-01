//
//  WebserviceManager.swift
//  EditableProfile
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import Foundation
import UIKit

class WebserviceManager: NSObject {
    class func getProducts(sender:AnyObject,  successCallBack : @escaping SuccessCallBack, failureCallback : @escaping FailuerCallBack) -> Void{
        _ = ServiceManager.sharedInstance.callAPI(method: .Get, url: ServiceURLMapper.mapUrl(type: .products, appendString: nil), dictData :[:] , sender: sender, successCallBack: { (response) in
            if ((response as? [String : Any]) != nil) {
                do {
                    let categoriesJSON = response["categories"]
                    let rankJSON = response["rankings"]
                    let categoryJSONData = try JSONSerialization.data(withJSONObject: categoriesJSON as Any , options: .prettyPrinted)
                    let category = try JSONDecoder().decode([Category].self, from: categoryJSONData)
                    let rankJSONData = try JSONSerialization.data(withJSONObject: rankJSON as Any , options: .prettyPrinted)
                    let rank = try JSONDecoder().decode([Rank].self, from: rankJSONData)
                    successCallBack([category,rank] as AnyObject)
                }
                catch {
                    failureCallback("no result found" as AnyObject)
                }
            } else {
                failureCallback(response["Message"] as AnyObject)
            }
        }, failureCallBack: { (errorString) in
            failureCallback(errorString)
        }) { (authFailure) in
            failureCallback(authFailure)
        }
    }
    
}
