//
//  CoinsViewModel.swift
//  Crypto
//
//  Created by Rohin Madhavan on 15/06/2024.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    private var page = 0
    private let service = CoinDataService()
    
    init() {
        fetchCoins()
    }
    
    func handleRefresh() {
        coins.removeAll()
        page = 0
        fetchCoins()
    }
    
    @MainActor
    func fetchCoinsAsync() {
        page += 1
        Task(priority: .medium) {
            do {
                coins = try await service.fetchCoinsAsync(page: page)
            } catch let error as CoinError {
                errorMessage = error.customDescription
            } catch {
                errorMessage = error.localizedDescription
            }
            
        }
    }
    
    func fetchCoins() {
        service.fetchCoins { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins.append(contentsOf: coins)
                case .failure(let error):
                    self?.errorMessage = error.customDescription
                }
            }
        }
    }
    
}
