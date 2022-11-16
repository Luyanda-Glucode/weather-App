import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var hourlyLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayHourlyData(ConfigCollectionCell())
    }
    func displayHourlyData(_ config: ConfigCollectionCell) {
        getTemparature(config.temperature ?? 0.0, maxTemperatureLabel)
        hourlyLabel.text = String.hourlyFormat(config.hour ?? "")
        guard let url = config.image else { return }
        UIImageView.downloadImage(from: URL(string: url)! , imageView: weatherImage)
    }
}
struct ConfigCollectionCell {
    var temperature: Double?
    var hour: String?
    var image: String?
}
