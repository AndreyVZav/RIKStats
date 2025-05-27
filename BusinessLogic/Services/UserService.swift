//
//  UserService.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import Foundation
import RxSwift
import RealmSwift

public class UserService {
    
    public init() {}
    
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    private let url = "http://test.rikmasters.ru/api/users/"
    
    public func fetchUsers() -> Observable<[User]> {
        return NetworkManager.shared.fetch(urlString: url)
            .map { (response: UsersResponse) in
                do {
                    try self.realm.write {
                        self.realm.add(response.users, update: .modified)
                    }
                } catch {
                    print("Realm write error: \(error)")
                }
                return response.users
            }
    }
    
    public func getCachedUsers() -> [User] {
        return Array(realm.objects(User.self))
    }
}

private struct UsersResponse: Decodable {
    let users: [User]
}
