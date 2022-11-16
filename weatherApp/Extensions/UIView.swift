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
    
    func getTemparature(_ temperature: Double,_ tempLabel: UILabel) {
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit

        tempLabel.text = measurementFormatter.string(from: measurement)
    }
}
extension String {
    
    func getDay(_ date: String) -> String {
        let dateString = date
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           guard let date = formatter.date(from: dateString) else { return "" }
           formatter.dateFormat = "EEEE"
           let day = formatter.string(from: date)
            let current = formatter.string(from: Date())
        if day == current {
            return "Today"
        }else {
            return day
        }
    }

    static func hourlyFormat(_ time: String) -> String {
        var hour = ""
        if time == "0" {
            hour = "0"
        }else{
            hour = time.replacingOccurrences(of: "00", with: "")
        }
        return hour
    }
}
extension UIImageView {
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImage(from url: URL, imageView: UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
