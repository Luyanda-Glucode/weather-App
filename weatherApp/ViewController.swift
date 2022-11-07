//
//  ViewController.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/02.
//

import UIKit
import Resolver
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @Injected var viewModel: WeatherViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getWeather()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "CitiesTableViewCell")
    }
    
    private func getWeather() {
        viewModel.getWeather()
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
