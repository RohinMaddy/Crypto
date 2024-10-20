//
//  ContentView.swift
//  Crypto
//
//  Created by Rohin Madhavan on 14/06/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CoinsViewModel()
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(viewModel.coins) { coin in
                    CoinView(coin: coin)
                    .onAppear {
                       if coin.id == viewModel.coins.last?.id {
                           viewModel.fetchCoinsAsync()
                        }
                    }
                    .font(.footnote)
                }
            }
            .refreshable {
                viewModel.handleRefresh()
            }
            .onReceive(viewModel.$errorMessage, perform: { message in
                if message != nil {
                    showAlert.toggle()
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(
                    title: Text("Error!"),
                    message: Text(viewModel.errorMessage ?? ""))
            })
            .navigationTitle("Crypto")
        }
    }
}

#Preview {
    ContentView()
}
