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
           let males = viewModel.users.filter { $0.sex.lowercased() == "male" }.count
           let females = viewModel.users.filter { $0.sex.lowercased() == "female" }.count

           return [
               GenderData(gender: "Мужчины", count: males),
               GenderData(gender: "Женщины", count: females)
           ]
       }

       var body: some View {
           VStack(alignment: .leading) {
               Text("Распределение по полу")
                   .font(.title3).bold()

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
           }
       }
   }
