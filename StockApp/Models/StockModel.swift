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
    var key: DataModel.Key
}

//enum MyPageKey: String, Codable {
//    case last = "las"
//    case percentageDifference = "pdd"
//    case difference = "ddi"
//    case low = "low"
//    case high = "hig"
//    case buy = "buy"
//    case sell = "sel"
//    case previousClose = "pdc"
//    case ceiling = "cei"
//    case floor = "flo"
//    case groupCode = "gco"
//}
