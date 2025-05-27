//
//  AgeHistogramPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 27.05.2025.
//

import SwiftUI
import Charts
import BusinessLogic

struct AgeHistogramPlaceholder: View {
    @ObservedObject var viewModel: StatisticsViewModel
    
    struct AgeGroup: Identifiable {
        let id = UUID()
        let label: String
        let count: Int
    }
    
    private var ageGroups: [AgeGroup] {
        let users = viewModel.users
        
        let groups = [
            ("до 18", users.filter { $0.age < 18 }.count),
            ("18–30", users.filter { $0.age >= 18 && $0.age <= 30 }.count),
            ("31–50", users.filter { $0.age > 30 && $0.age <= 50 }.count),
            ("50+", users.filter { $0.age > 50 }.count)
        ]
        
        return groups.map { AgeGroup(label: $0.0, count: $0.1) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Возрастное распределение")
                .font(.title3).bold()
            
            if ageGroups.allSatisfy({ $0.count == 0 }) {
                Text("Нет данных")
                    .foregroundColor(.gray)
            } else {
                Chart(ageGroups) { group in
                    BarMark(
                        x: .value("Группа", group.label),
                        y: .value("Количество", group.count)
                    )
                    .foregroundStyle(Color.purple)
                }
                .frame(height: 200)
            }
        }
        .padding()
    }
}
