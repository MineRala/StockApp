//
//  StockModel.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import Foundation

struct StockModel: Codable {
    var myPageDefaults: [MyPageDefaults]
    var myPage: [MyPage]

    enum CodingKeys: String, CodingKey {
        case myPageDefaults = "mypageDefaults"
        case myPage = "mypage"
    }
}


struct MyPageDefaults: Codable {
    var cod: String
    var gro: String
    var tke: String
    var def: String
}


struct MyPage: Codable {
    var name: String
    var key: String
}
