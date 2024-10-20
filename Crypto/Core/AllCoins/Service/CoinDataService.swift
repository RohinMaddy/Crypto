//
//  CoinDataService.swift
//  Crypto
//
//  Created by Rohin Madhavan on 15/06/2024.
//

import Foundation

class CoinDataService {
    
    private let baseUrl = "https://api.coingecko.com/api/v3/coins/"
    private let pageLimit = 20
    
    func fetchCoinsAsync(page: Int) async throws -> [Coin] {
        let endpoint = "markets?vs_currency=gbp&order=market_cap_desc&per_page=\(pageLimit)&page=\(page)&price_change_percentage=24&precision=2"
        
        guard let url = URL(string: baseUrl + endpoint) else { throw CoinError.InvalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
            throw CoinError.invalidStatusCode
        } else {
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                return coins
            } catch {
                throw CoinError.jsonParsingFailed
            }
        }
    }
    
    // Requests with completion handler code
    
    func fetchCoins(completion: @escaping(Result<[Coin], CoinError>) -> Void) {
        let endPoint = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=gbp&order=market_cap_desc"
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(CoinError.InvalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Response not in HTTP format")))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: failed to parse with error: \(error)")
                completion(.failure(.jsonParsingFailed))
            }
        }.resume()
    }
    
    func fetchPrice() {
        let endPoint = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=gbp"
        guard let url = URL(string: endPoint) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else { return }
            print(jsonObject)
        }.resume()
    }
}
