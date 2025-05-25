//
//  User.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import Foundation
import RealmSwift

public class User: Object, Decodable, Identifiable {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var username: String
    @Persisted public var sex: String
    @Persisted public var isOnline: Bool
    @Persisted public var age: Int
    @Persisted public var avatarURL: String

    enum CodingKeys: CodingKey {
        case id, username, sex, isOnline, age, files
    }

    enum FileKeys: CodingKey {
        case id, url, type
    }

    required public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        sex = try container.decode(String.self, forKey: .sex)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
        age = try container.decode(Int.self, forKey: .age)

        var files = try container.nestedUnkeyedContainer(forKey: .files)
        var avatar = ""
        while !files.isAtEnd {
            let file = try files.nestedContainer(keyedBy: FileKeys.self)
            if try file.decode(String.self, forKey: .type) == "avatar" {
                avatar = try file.decode(String.self, forKey: .url)
                break
            }
        }
        avatarURL = avatar
    }
}
