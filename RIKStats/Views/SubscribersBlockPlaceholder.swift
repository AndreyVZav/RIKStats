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
            VStack(alignment: .leading, spacing: 12) {
                Text("Наблюдатели")
                    .font(.title3).bold()
                
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.2))
                        .frame(height: 80)
                        .overlay(Text("+\(subscriptions) новых").foregroundColor(.green))
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.2))
                        .frame(height: 80)
                        .overlay(Text("-\(unsubscriptions) отписок").foregroundColor(.red))
                }
            }
            .padding(.horizontal)
        }
    }
