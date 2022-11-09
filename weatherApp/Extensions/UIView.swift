import Foundation
import UIKit
extension UIView {
    func showActivityIndicator() {
        let indicator = UIView.init(frame: self.bounds)
        indicator.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = indicator.center
        indicator.tag = 100
        DispatchQueue.main.async {
            indicator.addSubview(activityIndicator)
            self.addSubview(indicator)
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let background = self.viewWithTag(100){
                background.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
    }
}
