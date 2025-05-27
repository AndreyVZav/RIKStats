//
//  GenderAgeChartPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI
import Charts
import BusinessLogic

struct GenderAgeChartPlaceholder: View {
    @ObservedObject var viewModel: StatisticsViewModel

       struct GenderData: Identifiable {
           let id = UUID()
           let gender: String
           let count: Int
       }

       private var genderStats: [GenderData] {
           let males = viewModel.users.filter { $0.sex.uppercased() == "M" }.count
           let females = viewModel.users.filter { $0.sex.uppercased() == "W" }.count

           print("Males: \(males), Females: \(females)")
           print("User sexes:", viewModel.users.map { $0.sex })
           
           return [
               GenderData(gender: "Мужчины", count: males),
               GenderData(gender: "Женщины", count: females)
           ]
       }

       var body: some View {
           VStack(alignment: .leading) {
               Text("Распределение по полу")
                   .font(.title3).bold()

               Text("Загружено пользователей: \(viewModel.users.count)")
                   .font(.caption)
                   .foregroundColor(.gray)
               
               if genderStats.allSatisfy({ $0.count == 0 }) {
                   Text("Нет данных")
                       .foregroundColor(.gray)
               } else {
                   Chart(genderStats) { data in
                       SectorMark(
                           angle: .value("Количество", data.count),
                           innerRadius: .ratio(0.5),
                           angularInset: 1
                       )
                       .foregroundStyle(by: .value("Пол", data.gender))
                       .cornerRadius(4)
                   }
                   .frame(height: 200)
                   .chartLegend(position: .trailing)
               }
           }
           .padding()
           .onAppear {
               viewModel.loadCached()
               if viewModel.users.isEmpty {
                   viewModel.refresh()
               }
           }
       }
}
