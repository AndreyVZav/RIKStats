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
    @State private var selectedRange: TimeRange = .day
    
    enum TimeRange: String, CaseIterable, Identifiable {
        case day = "По дням"
        case week = "По неделям"
        case month = "По месяцам"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Посетители")
                .font(.title2).bold()
            
            HStack(alignment: .center, spacing: 12) {
                Image("Frame9801")
                    .resizable()
                    .frame(width: 95, height: 50)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("\(viewData.reduce(0) { $0 + $1.count })")
                            .font(.title2).bold()
                        Image(systemName: "arrow.up")
                            .foregroundColor(.green)
                    }
                    Text("Количество посетителей в этом месяце выросло")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            Picker("", selection: $selectedRange) {
                ForEach(TimeRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            
            if viewData.isEmpty {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(Text("Нет данных").foregroundColor(.gray))
            } else {
                
                let maxEntry = viewData.max(by: { $0.count < $1.count })
                
                Chart {
                    ForEach(viewData) { entry in
                        LineMark(
                            x: .value("Дата", entry.date),
                            y: .value("Посещения", entry.count)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.red)
                        .symbol(Circle())
                        .symbolSize(50)
                        .annotation(position: .top) {
                            if let maxEntry = maxEntry, entry == maxEntry {
                                Text("\(entry.count) посетителей")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: dateStride)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: dateFormat)
                    }
                }
            }
        }
    }
    
    private var dateFormat: Date.FormatStyle {
        switch selectedRange {
        case .day:
            return .dateTime.day().month(.abbreviated)
        case .week:
            return .dateTime.week().month(.abbreviated)
        case .month:
            return .dateTime.month()
        }
    }

    private var dateStride: Calendar.Component {
        switch selectedRange {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        }
    }
    
    /// преобразуем список статистик с type == "view" в удобные для графика значения
    private var viewData: [VisitEntry] {
        let views = statistics.filter { $0.type == "view" }
        
        // сгруппировать все даты (Int timestamps) и посчитать количество на каждую дату
        var dateCounts: [Date: Int] = [:]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        
        for stat in views {
            for timestamp in stat.dates {
                guard let date = formatter.date(from: String(timestamp)) else { continue }
                let key: Date
                switch selectedRange {
                case .day:
                    key = Calendar.current.startOfDay(for: date)
                case .week:
                    key = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
                case .month:
                    key = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date)) ?? date
                }
                dateCounts[key, default: 0] += 1
            }
        }
        
        // вернуть отсортированные по дате записи
        return dateCounts.map { VisitEntry(date: $0.key, count: $0.value) }
            .sorted(by: { $0.date < $1.date })
    }
}

struct VisitEntry: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    
    static func == (lhs: VisitEntry, rhs: VisitEntry) -> Bool {
        lhs.date == rhs.date && lhs.count == rhs.count
    }
}
