import UIKit
import Combine
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var cancelable: AnyCancellable?
    var viewModel = WeatherViewModel()
    var current: [CurrentConditions]?
    var city = ["Pretoria","London","Barcelona","New York"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showActivityIndicator()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTableView()
        getWeather(Constants.baseUrl)
        
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "CitiesTableViewCell")
        //tableView.register(UINib(nibName: String(describing: CitiesTableViewCell.self, bundle: nil)))
    }
    
    private func getWeather(_ url: String) {
        DispatchQueue.main.async { [self] in
            viewModel.getWeather(url)
            viewModelStateBinding()
        }
    }
    
    private func showValues() {
        guard let city = viewModel.weather?.data?.request?[0].query else { return }
        if let first = city.components(separatedBy: ",").first {
            title = first
        }
        
        guard let currentConditions = viewModel.weather?.data?.current_condition,
            let weather = viewModel.weather?.data?.weather else { return }
        current = currentConditions
        for items in currentConditions {
            guard let temp = items.temp_C, let temperature = Double(temp) else { return }
            
            view.getTemparature(temperature, temparatureLabel)
            
            guard let description = items.weatherDesc else { return }
            for desc in description {
                descriptionLabel.text = desc.value
            }
        }
        
        for date in weather {
            guard let day = date.date else { return }
            dateLabel.text = String().getDay(day)
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
                self?.tableView.reloadData()
            case .error(let error):
                print("show error \(error.localizedDescription)")
            }
            
        }
    }
    
    func navigateToDetailsScreen(from navigationController: UINavigationController?, weather: WeatherResponse) {
        let weatherDetails = Detailed7DaysViewController(weather: weather)
        self.navigationController?.pushViewController(weatherDetails, animated: true)
    }

    @IBAction func addNewCity(_ sender: Any) {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let city = alertController.textFields?.first?.text {

                 self.city.append(city)
                self.tableView.reloadData()
            }
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter City Name"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
     
        self.present(alertController, animated: true)
    }
    @IBAction func searchCity(_ sender: Any) {
        let alertController = UIAlertController(title: "Search City", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Search", style: .default, handler: { [self] alert -> Void in
            if let cityName = alertController.textFields?.first?.text {
                   let filtered = city.filter {$0.contains(cityName) }
                    city = filtered
                    tableView.reloadData()
            }
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter City Name"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
     
        self.present(alertController, animated: true)
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
        return city.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as? CitiesTableViewCell else { return UITableViewCell() }
        let replaced = city[indexPath.row].replacingOccurrences(of: "+", with: " ")
        cell.cityLbl.text = replaced
        
        cell.cities = city
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stringTest = Constants.baseUrl
        var cityName = ""
        if city[indexPath.row].contains(" "){
            cityName = city[indexPath.row].replacingOccurrences(of: " ", with: "+")
            }else{
                cityName = city[indexPath.row]
            }
        let replaced = stringTest.replacingOccurrences(of: "Pretoria", with: cityName)
        getWeather(replaced)
        
        title = cityName
    }
}
