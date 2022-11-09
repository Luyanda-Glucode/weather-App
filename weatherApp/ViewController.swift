import UIKit
import Combine
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var cancelable: AnyCancellable?
    var viewModel = WeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showActivityIndicator()
        setupTableView()
        getWeather()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "CitiesTableViewCell")
    }
    
    private func getWeather() {
        DispatchQueue.main.async { [self] in
            viewModel.getWeather()
            viewModelStateBinding()
        }
    }
    
    private func showValues() {
        guard let currentConditions = viewModel.weather?.data?.current_condition, let weather = viewModel.weather?.data?.weather else { return }
        for items in currentConditions {
            guard let temp = items.temp_C, let temperature = Double(temp) else { return }
            
           getTemparature(temperature, temparatureLabel)
            
            guard let description = items.weatherDesc else { return }
            for desc in description {
                descriptionLabel.text = desc.value
            }
        }
        
        for date in weather {
            dateLabel.text = date.date
        }
    }
    
    private func viewModelStateBinding() {
        self.cancelable = viewModel.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            self?.view.hideActivityIndicator()
            switch state {
            case .idle: break
            case .loading:
                self?.view.showActivityIndicator()
            case .loaded:
                self?.showValues()
            case .error(let error):
                print("show error \(error.localizedDescription)")
            }
            
        }
    }
    
    func navigateToDetailsScreen(from navigationController: UINavigationController?, weather: WeatherResponse) {
    let weatherDetails = Detailed7DaysViewController(weather: weather)
    self.navigationController?.pushViewController(weatherDetails, animated: true)
    }

    
    @IBAction func Details(_ sender: Any) {
        if let data = viewModel.weather {
            navigateToDetailsScreen(from: navigationController, weather: data)
        }else{
            print("Response model is empty.")
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as? CitiesTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.cityLbl.text = "Pretoria"
            cell.countryLbl.text = "South Africa"
        }else if indexPath.row == 1 {
            cell.cityLbl.text = "London"
            cell.countryLbl.text = "United Kindom"
        }else if indexPath.row == 2 {
            cell.cityLbl.text = "Barcelona"
            cell.countryLbl.text = "Europe"
        }else if indexPath.row == 3 {
            cell.cityLbl.text = "New York"
            cell.countryLbl.text = "America"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            title = "Pretoria"
        }else if indexPath.row == 1 {
            title = "London"
        }else if indexPath.row == 2 {
            title = "Barcelona"
        }else if indexPath.row == 3 {
            title = "New York"
        }
    }
}
extension ViewController {
    private func getTemparature(_ temperature: Double,_ tempLabel: UILabel) {
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit

        tempLabel.text = measurementFormatter.string(from: measurement)
    }
}
