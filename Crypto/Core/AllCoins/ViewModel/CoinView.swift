//
//  CoinView.swift
//  Crypto
//
//  Created by Rohin Madhavan on 18/06/2024.
//

import SwiftUI

struct CoinView: View {
    @State var coin: Coin
    var body: some View {
        HStack(spacing: 14){
            Text("\(coin.marketCapRank)")
                .foregroundStyle(.gray)
                .padding(.leading, 5)
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.circle)
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(coin.name)
                    .fontWeight(.semibold)
                Text(coin.symbol.uppercased())
            }
            .padding(.leading, 5)
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text(coin.currentPrice, format: .currency(code: "GBP"))
                    .fontWeight(.semibold)
                if coin.marketCapChangePercentage24h > 0 {
                    Text("\(coin.marketCapChangePercentage24h)")
                        .foregroundStyle(.green)
                } else {
                    Text("\(coin.marketCapChangePercentage24h)")
                        .foregroundStyle(.red)
                }
                
            }
            .padding(.trailing, 5)
        }

    }
}

#Preview {
    CoinView(coin: Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", currentPrice: 51292.75, marketCapRank: 1, image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", marketCapChangePercentage24h: -0.84587))
}
