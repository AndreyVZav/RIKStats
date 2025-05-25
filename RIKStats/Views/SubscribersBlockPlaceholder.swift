//
//  SubscribersBlockPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI

struct SubscribersBlockPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Наблюдатели")
                .font(.title3).bold()
            
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.2))
                    .frame(height: 80)
                    .overlay(Text("+1356 новых").foregroundColor(.green))
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.2))
                    .frame(height: 80)
                    .overlay(Text("-10 отписок").foregroundColor(.red))
            }
        }
    }
}
