//
//  LoadingView.swift
//  EditableProfile
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//


import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var indicatorBackgroundView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    var showSmallView = false

    class var sharedInstance : LoadingView {
        struct Indicator {
            static let instance : LoadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingView
        }
        return Indicator.instance
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicatorBackgroundView.layer.cornerRadius = 8.0
    }
    
    
    func showActivityIndicatorWithMessage(msg: String, view:UIView) {
        DispatchQueue.main.async {
            self.msgLabel.text = msg
            self.indicator.startAnimating()
            var window = UIApplication.shared.keyWindow
            if window == nil {
                window = UIApplication.shared.windows[0]
            }
            view.addSubview(self)
            view.updateConstraints()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func showActivityIndicatorWithMessage(msg: String) {
        DispatchQueue.main.async {
            self.msgLabel.text = msg
            self.indicator.startAnimating()
            var window = UIApplication.shared.keyWindow
            if window == nil {
                window = UIApplication.shared.windows[0]
            }
            window?.addSubview(self)
            window?.updateConstraints()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if self.indicator.isAnimating
            {
                self.indicator.stopAnimating()
                self.removeFromSuperview()
                while UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
}
