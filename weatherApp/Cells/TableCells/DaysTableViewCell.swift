import UIKit
struct ConfigCell {
    var day: String?
    var min: Double?
    var max: Double?
}
class DaysTableViewCell: UITableViewCell {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var minTeperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayData(ConfigCell())
    }

    func displayData(_ config: ConfigCell) {
        dayLabel.text = config.day
        getTemparature(config.max ?? 0.0, maxTemperatureLabel)
        getTemparature(config.min ?? 0.0, minTeperatureLabel)
    }
}
