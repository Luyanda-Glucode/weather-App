//
//  CitiesTableViewCell.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/02.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLbl: UILabel!
    var cities = [String]()
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func removeCity(_ sender: Any) {
        cities.remove(at: index)
    }
}
