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
                // блок новых подписчиков
                subscriberCard(
                    count: subscriptions,
                    prefix: "+",
                    title: "Новые наблюдатели в этом месяце",
                    icon: "Frame9801",
                    color: Color(hex: "#4CCD99") // зеленый
                )
                
                // блок отписок
                subscriberCard(
                    count: unsubscriptions,
                    prefix: "-",
                    title: "Пользователей перестали за Вами наблюдать",
                    icon: "Group9412",
                    color: Color(hex: "#FF4D4D") // красный
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func subscriberCard(count: Int, prefix: String, title: String, icon: String, color: Color) -> some View {
        HStack {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 95, height: 50)
                    .foregroundColor(color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(prefix)\(count)")
                        .font(.gilroy(.bold, size: 20))
                        .foregroundColor(.black)
                    
                    Text(title)
                        .font(.gilroy(.medium, size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.leading, 16)
        }
    }
}
