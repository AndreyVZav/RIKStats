//
//  StatisticsView.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        ScrollView {
            contentView
        }
        .navigationTitle("Статистика")
        .refreshable {
            viewModel.refresh()
        }
        .onAppear(perform: onAppear)
        .alert(item: alertBinding(for: viewModel.errorMessage)) { error in
            Alert(
                title: Text("Ошибка"),
                message: Text(error.message),
                dismissButton: .default(Text("ОК"))
            )
        }
    }
}

private extension StatisticsView {
    func onAppear() {
        viewModel.loadCached()
        if viewModel.users.isEmpty || viewModel.statistics.isEmpty {
            viewModel.refresh()
        }
    }
    
    func alertBinding(for errorMessage: String?) -> Binding<ErrorWrapper?> {
        Binding(
            get: {
                errorMessage.map { ErrorWrapper(message: $0) }
            },
            set: { _ in viewModel.errorMessage = nil }
        )
    }
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            ProgressView("Загрузка...")
        } else {
            VStack(spacing: 24) {
                VisitorsBlockPlaceholder(statistics: viewModel.statistics)
                FrequentVisitorsPlaceholder()
                GenderAgeChartPlaceholder(viewModel: viewModel)
                SubscribersBlockPlaceholder()
            }
            .padding()
        }
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}


#Preview {
    StatisticsView()
}
