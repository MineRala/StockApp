//
//  Enpoint.swift
//  StockApp
//
//  Created by Mine Rala on 22.09.2024.
//

import Foundation

enum Endpoint {
    enum Constant {
        static let baseURL = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/"
    }

    case stockModel
    case stockDataModel(fields: String, stcs: String)

    var url: URL? {
        switch self {
        case .stockModel:
            return URL(string: "\(Constant.baseURL)ForeksMobileInterviewSettings")
        case .stockDataModel(let fields, let stcs):
            return URL(string: "\(Constant.baseURL)ForeksMobileInterview?fields=\(fields)&stcs=\(stcs)")
        }
    }
}
