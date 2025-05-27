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
    
    enum TimeFilter: String, CaseIterable, Identifiable {
        case today = "Сегодня"
        case week = "Неделя"
        case month = "Месяц"
        case allTime = "Все время"
        
        var id: String { self.rawValue }
    }
    
    @State private var selectedFilter: TimeFilter = .today
    
    struct GenderData: Identifiable {
        let id = UUID()
        let gender: String
        let count: Int
    }
    
    struct AgeGroup: Identifiable {
        let id = UUID()
        let range: String
        let percent: Int
    }
    
    private var genderStats: [GenderData] {
        let males = viewModel.users.filter { $0.sex.uppercased() == "M" }.count
        let females = viewModel.users.filter { $0.sex.uppercased() == "W" }.count
        
        return [
            GenderData(gender: "Мужчины", count: males),
            GenderData(gender: "Женщины", count: females)
        ]
    }
    
    private var totalCount: Int {
        genderStats.reduce(0) { $0 + $1.count }
    }
    
    private var ageGroups: [AgeGroup] {
        let users = viewModel.users
        let ageRanges: [(String, ClosedRange<Int>)] = [
            ("18–21", 18...21),
            ("22–25", 22...25),
            ("26–30", 26...30),
            ("31–35", 31...35),
            ("36–40", 36...40),
            ("40–50", 41...50),
            (">50", 51...150)
        ]
        
        return ageRanges.map { label, range in
            let count = users.filter { range.contains($0.age) }.count
            let percent = totalCount > 0 ? Int((Double(count) / Double(totalCount)) * 100) : 0
            return AgeGroup(range: label, percent: percent)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Пол и возраст")
                .font(.title3).bold()
            
            Picker("", selection: $selectedFilter) {
                ForEach(TimeFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            
            if genderStats.allSatisfy({ $0.count == 0 }) {
                Text("Нет данных")
                    .foregroundColor(.gray)
            } else {
                Chart(genderStats) { data in
                    SectorMark(
                        angle: .value("Количество", data.count),
                        innerRadius: .ratio(0.90),
                        angularInset: 1
                    )
                    .foregroundStyle(data.gender == "Мужчины"
                                     ? Color(hex: "#FF2E00")
                                     : Color(hex: "#F99963"))
                    .cornerRadius(4)
                }
                .frame(height: 160)
                
                // Подписи под кругом
                HStack {
                    Spacer()
                    HStack(spacing: 24) {//по центру
                        ForEach(genderStats) { data in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(data.gender == "Мужчины" ? Color(hex: "#FF2E00") : Color(hex: "#F99963"))
                                    .frame(width: 10, height: 10)
                                
                                Text("\(data.gender) \(percent(of: data.count))%")
                                    .font(.footnote)
                            }
                        }
                    }
                    Spacer()
                }
                
                // Возрастная структура
                VStack(spacing: 8) {
                    ForEach(ageGroups) { group in
                        HStack {
                            Text(group.range)
                                .font(.caption)
                                .frame(width: 50, alignment: .leading)
                            
                            Rectangle()
                                .fill(Color.orange)
                                .frame(width: CGFloat(group.percent * 2), height: 6)
                                .cornerRadius(3)
                            
                            Text("\(group.percent)%")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(minWidth: 30, alignment: .trailing)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 8)
                
            }
        }
        .padding()
        .onAppear {
            viewModel.loadCached()
            if viewModel.users.isEmpty {
                viewModel.refresh()
            }
            
            let males = viewModel.users.filter { $0.sex.uppercased() == "M" }.count
            let females = viewModel.users.filter { $0.sex.uppercased() == "W" }.count
            print("Males: \(males), Females: \(females)")
            
        }
    }
    
    private func percent(of count: Int) -> Int {
        guard totalCount > 0 else { return 0 }
        return Int((Double(count) / Double(totalCount)) * 100)
    }
    
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
