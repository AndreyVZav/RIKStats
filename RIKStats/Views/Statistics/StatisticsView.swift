//
//  StatisticsView.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // посетители - заголовок и блок графика
                VisitorsBlockPlaceholder()
                
                // часто посещают - список юзеров
                FrequentVisitorsPlaceholder()
                
                // пол и возраст
                GenderAgeChartPlaceholder()
                
                // наблюдатели
                SubscribersBlockPlaceholder()
            }
            .padding()
        }
        .navigationTitle("Статистика")
    }
}

#Preview {
    StatisticsView()
}
