import SwiftUI

struct HomeView: View {
    // MARK: - Variables
    @EnvironmentObject var coordinator: BaseCoordinator
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        self.homeView
    }
    
    // MARK: - Home View
    var homeView: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.coordinator.actionHomeWithdrawals(viewModel: self.viewModel)
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .frame(width: 44, height: 44)
                    .padding(.trailing, 16)
                }
                HStack {
                    Text("Money")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(.leading, 16)
                    Spacer()
                }
                
                self.balanceView
                    .padding(.top, 32)
                
                self.cardsView
                    .padding(.top, 24)
                
                self.recentTransactionsView
                    .padding(.top, 24)
                
            }
        }
        .background(content: {
            Color(hex: "#F6F7F9")
                .ignoresSafeArea()
        })
        .onAppear(perform: {
            self.viewModel.fetchData()
        })
        .refreshable {
            self.viewModel.fetchData()
        }
        .scrollIndicators(.never)
    }
    
    
    // MARK: - Balance View
    private var balanceView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
            VStack {
                HStack {
                    Image(.icEuFlag)
                    Text("EUR account")
                        .foregroundStyle(Color(hex: "#7E8493"))
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                }
                
                HStack {
                    Text("€\(self.viewModel.totalBalance)")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Cards View
    private var cardsView: some View {
        let last3Cards = Array(self.viewModel.cards.prefix(3))
        
        return ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
            
            VStack {
                HStack {
                    Text("My cards")
                        .font(.system(size: 17, weight: .medium))
                    Spacer()
                    
                    if !self.viewModel.cards.isEmpty {
                        Button(action: {
                            print("See All Cards")
                        }, label: {
                            Text("See All")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.blue)
                        })
                    }
                }
                .padding(.bottom, 9)
                
                VStack(spacing: 24) {
                    ForEach(last3Cards, id: \.id) { card in
                        self.cardView(card: card)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Card View
    private func cardView(card: CardModel) -> some View {
        HStack(alignment: .center) {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(Color(hex: "#2B2C39"))
                    .frame(width: 48, height: 32)
                Text("\(card.cardLast4 ?? "")")
                    .foregroundStyle(.white)
                    .font(.system(size: 10))
                    .padding(.trailing, 6)
                    .padding(.bottom, 4)
            }
            Text("\(card.cardName ?? "")")
                .font(.system(size: 15, weight: .medium))
            Spacer()
        }
    }
    
    
    // MARK: - Recent Tranasactions View
    private var recentTransactionsView: some View {
        let last3Transactions = Array(self.viewModel.cardsTransactions.prefix(3))
        
        return ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
            
            VStack {
                HStack {
                    Text("Recent transactions")
                        .font(.system(size: 17, weight: .medium))
                    Spacer()
                    
                    if !self.viewModel.cardsTransactions.isEmpty {
                        Button(action: {
                            print("See All Transactions")
                        }, label: {
                            Text("See All")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.blue)
                        })
                    }
                }
                .padding(.bottom, 9)
                
                VStack(spacing: 24) {
                    ForEach(last3Transactions, id: \.id) { transaction in
                        self.transactionView(transaction: transaction)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
    
    private func transactionView(transaction: CardTransactionModel) -> some View {
        let amount = Double(transaction.amount ?? "0")?.convertTransactionDoubleToCurrency()
        let type = transaction.tribeTransactionType ?? "+"
        let pan = transaction.pan ?? ""
        
        return HStack(alignment: .center) {
            Image(type == "+" ? .icIncome : .icOutcome)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text("\(transaction.merchantName ?? "No Name")")
                    .font(.system(size: 15, weight: .medium))
                if type == "-" && transaction.tribeTransactionId != nil {
                    Text("•• \(transaction.tribeTransactionId ?? "")")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#7E8493"))
                }
            }
            Spacer()
            HStack(spacing: 8) {
                Text("\(amount ?? "0")")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(type == "+" ? Color(hex: "#00AC4F") : .black)
                Image(pan == "+" ? "ic-check" : "")
                    .frame(width: 20, height: 20)
            }
            
        }
    }
}
