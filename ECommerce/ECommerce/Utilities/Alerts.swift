//
//  Alerts.swift
//  EditableProfile
//
//  Created by Apple on 30/04/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit

class Alerts: NSObject,UIAlertViewDelegate {
    
    static let alertButtonColor = UIColor.darkText
    static let sharedInstance: Alerts = {
        return Alerts()
    }()
    /**
     Creates a alertView without actions.
     
     - parameter msg: The message that has to be shown in the alertView
     - parameter sender: The controller where the alert has to be shown
     
     - returns: nothing.
     */
    
    func showAlertWithSingleButton(_ title:String = "", message: String, sender: AnyObject) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel , handler: { (finished) -> Void in
            if finished.style == UIAlertAction.Style.cancel {

            }
        }))
        alert.view.tintColor = Alerts.alertButtonColor
        DispatchQueue.main.async { () -> Void in
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showAlertWithTitle(_ title: String = "", message: String, okButtonTitle: String?, cancelButtonTitle: String?, sender: AnyObject, Yesaction: @escaping () -> (), Noaction: @escaping () -> ()) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if let alertOkButtonTitle = okButtonTitle {
            
            let OKAction = UIAlertAction(title: alertOkButtonTitle, style: UIAlertAction.Style.default, handler: { (finished) -> Void in
                Yesaction()
            })
            alertController.addAction(OKAction)
        }
        if let alertCancelButtonTitle = cancelButtonTitle {
            
            let cancelAction = UIAlertAction(title: alertCancelButtonTitle, style: UIAlertAction.Style.cancel, handler: {
                
                (finished) -> Void in
                
                alertController.dismiss(animated: true, completion: nil)
                Noaction()
            })
            alertController.addAction(cancelAction)
        }
        alertController.view.tintColor = UIColor.darkGray
        DispatchQueue.main.async {
            sender.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    class func showActionSheet(_ title: String?, _ message: String?, options: [String], sender: AnyObject, call: @escaping ((_ index: Int?)->Void))
    {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for st in options {
            let action = UIAlertAction(title: st, style: .default, handler: { (actionn) in
                DispatchQueue.main.async {
                    call(options.index(of: actionn.title!))
                    sender.dismiss(animated: true, completion: nil)
                }
            })
            actionSheet.addAction(action)
        }
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (actionn) in
            DispatchQueue.main.async {
                call(nil)
                sender.dismiss(animated: true, completion: nil)
            }
        })
        actionSheet.addAction(action)
        sender.present(actionSheet, animated: true, completion: nil)
    }
}
