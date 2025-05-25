//
//  VisitorsBlockPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct VisitorsBlockPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Посетители")
                .font(.title2).bold()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(Text("График посещений").foregroundColor(.gray))
        }
    }
}
