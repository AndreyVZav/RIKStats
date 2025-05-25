//
//  FrequentVisitorsPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct FrequentVisitorsPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Чаще всех посещают Ваш профиль")
                .font(.title3).bold()
            
            ForEach(0..<3) { _ in
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading) {
                        Text("username")
                            .font(.headline)
                        Text("age")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
        }
    }
}
