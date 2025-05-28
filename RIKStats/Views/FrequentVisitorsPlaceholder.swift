//
//  FrequentVisitorsPlaceholder.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import SwiftUI
import RealmSwift
import BusinessLogic

struct FrequentVisitorsPlaceholder: View {
    @State private var topUsers: [BusinessLogic.User] = []

        var body: some View {
            VStack(alignment: .leading) {
                Text("Чаще всех посещают Ваш профиль")
                    .font(.gilroy(.bold, size: 20))

                if topUsers.isEmpty {
                    Text("Нет данных")
                        .foregroundColor(.gray)
                } else {
                    ForEach(topUsers) { user in
                        HStack {
                            ZStack(alignment: .bottomTrailing) {
                                AsyncImage(url: URL(string: user.avatarURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                    
                                }
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                                
                                if user.isOnline {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                Text("\(user.age) лет")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                loadTopUsers()
            }
        }

        private func loadTopUsers() {
            do {
                let realm = try Realm()
                let users = realm.objects(BusinessLogic.User.self)
                self.topUsers = Array(users.prefix(3))
            } catch {
                print("Realm error: \(error)")
            }
        }
    }

struct FrequentVisitorsPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        FrequentVisitorsPlaceholder()
    }
}
