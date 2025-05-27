//
//  SubscribersBlockPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct SubscribersBlockPlaceholder: View {
    @ObservedObject var viewModel: StatisticsViewModel
    
    private var subscriptions: Int {
        viewModel.statistics.filter { $0.type == "subscription" }.flatMap { $0.dates }.count
    }
    
    private var unsubscriptions: Int {
        viewModel.statistics.filter { $0.type == "unsubscription" }.flatMap { $0.dates }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Наблюдатели")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#1A1A1A"))
            
            VStack(spacing: 12) {
                // Блок новых подписчиков
                subscriberCard(
                    count: subscriptions,
                    prefix: "+",
                    title: "Новые наблюдатели в этом месяце",
                    icon: "chart.line.uptrend.xyaxis",
                    color: Color(hex: "#4CCD99") // Зеленый
                )
                
                // Блок отписок
                subscriberCard(
                    count: unsubscriptions,
                    prefix: "-",
                    title: "Пользователей перестали за Вами наблюдать",
                    icon: "chart.line.downtrend.xyaxis",
                    color: Color(hex: "#FF4D4D") // Красный
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func subscriberCard(count: Int, prefix: String, title: String, icon: String, color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
                .frame(height: 60)
                .overlay(
                    HStack(spacing: 12) {
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(color)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(prefix)\(count)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(color)
                            
                            Text(title)
                                .font(.system(size: 12))
                                .foregroundColor(color.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                        .padding(.leading, 16)
                )
        }
    }
}
