//
//  GenderAgeChartPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct GenderAgeChartPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Пол и возраст")
                .font(.title3).bold()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 250)
                .overlay(Text("Диаграммы").foregroundColor(.gray))
        }
    }
}
