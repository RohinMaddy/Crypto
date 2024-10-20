//
//  Coin.swift
//  Crypto
//
//  Created by Rohin Madhavan on 15/06/2024.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    let image: String
    let marketCapChangePercentage24h: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case marketCapChangePercentage24h = "market_cap_change_percentage_24h"
    }
}
