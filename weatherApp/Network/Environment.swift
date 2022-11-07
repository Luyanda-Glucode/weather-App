//
//  Environment.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation
struct Environment {
    var baseUrl: URL
}

extension Environment {
    static let development = Environment(baseUrl: URL(string: Constants.baseUrl)!)
}
