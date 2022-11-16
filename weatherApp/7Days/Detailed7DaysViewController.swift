import UIKit

class Detailed7DaysViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    
    var weather: WeatherResponse?
    var hour: [Hourly]?
    
    init(weather: WeatherResponse?) {
        self.weather = weather
        super.init(nibName: "Detailed7DaysViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        displayValues()
        hourlyWeather()
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.register(UINib(nibName: String(describing: HourlyCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        tableView.register(UINib(nibName: String(describing: DaysTableViewCell.self), bundle: nil), forCellReuseIdentifier: "DaysTableViewCell")
        
        collectionView.layer.cornerRadius = 12.0
        collectionView.clipsToBounds = true
        tableView.layer.cornerRadius = 12.0
        tableView.clipsToBounds = true
    }
    
    private func displayValues() {
        guard let values = weather?.data?.request else {  return }
        for item in values {
            cityNameLabel.text = item.query
        }
        
        guard let values = weather?.data?.current_condition else {  return }
        for item in values {
            guard let temp = item.temp_C, let temperature = Double(temp) else { return }
            view.getTemparature(temperature, temperatureLabel)
            guard let description = item.weatherDesc else {  return }
            for desc in description {
                weatherDescLabel.text = desc.value
            }
        }
    }
    
    private func hourlyWeather() {
        guard let values = weather?.data?.weather else {  return }
        for items in values {
            guard let hourly = items.hourly else { return }
            hour = hourly
            break;
        }
    }
}

extension Detailed7DaysViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourly = hour else { return 0}
        return hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell,
              let hourly = hour,
              let temp = hourly[indexPath.row].tempC,
              let time = hourly[indexPath.row].time,
              let temperature = Double(temp),
              let image = hourly[indexPath.row].weatherIconUrl?[0],
              let url = image.value  else {return UICollectionViewCell()}
        cell.displayHourlyData(ConfigCollectionCell(temperature: temperature,hour: time, image: url))
        return cell
    }
}

extension Detailed7DaysViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let days = weather?.data?.weather else {  return 0}
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DaysTableViewCell", for: indexPath) as? DaysTableViewCell,
              let days = weather?.data?.weather,
              let max = days[indexPath.row].maxtempC,
              let maxTemperature = Double(max),
              let min = days[indexPath.row].mintempC,
              let minTemperature = Double(min),
              let date = days[indexPath.row].date else { return UITableViewCell() }
        cell.displayData(ConfigCell(day: String().getDay(date),min: minTemperature,max: maxTemperature))
        return cell
    }
}
