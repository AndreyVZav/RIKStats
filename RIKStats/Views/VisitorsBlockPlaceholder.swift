//
//  VisitorsBlockPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI
import Charts
import BusinessLogic

struct VisitorsBlockPlaceholder: View {
    let statistics: [Statistic]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Посетители")
                .font(.title2).bold()
            
            if viewData.isEmpty {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(Text("Нет данных").foregroundColor(.gray))
            } else {
                Chart(viewData) { entry in
                    LineMark(
                        x: .value("Дата", entry.date, unit: .day),
                        y: .value("Посещения", entry.count)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
            }
        }
    }
    
    /// преобразуем список статистик с type == "view" в удобные для графика значения
    private var viewData: [VisitEntry] {
        let views = statistics.filter { $0.type == "view" }
        
        // сгруппировать все даты (Int timestamps) и посчитать количество на каждую дату
        var dateCounts: [Date: Int] = [:]
        for stat in views {
            for timestamp in stat.dates {
                let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                let day = Calendar.current.startOfDay(for: date)
                dateCounts[day, default: 0] += 1
            }
        }
        
        // вернуть отсортированные по дате записи
        return dateCounts
            .map { VisitEntry(date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
    }
}

struct VisitEntry: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
