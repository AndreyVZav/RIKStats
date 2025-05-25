//
//  Statistic.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import Foundation
import RealmSwift

public class Statistic: Object, Decodable, Identifiable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var userId: Int
    @Persisted public var type: String  // "view", "subscription", "unsubscription"
    @Persisted public var dates: List<Int>

    enum CodingKeys: String, CodingKey {
        case user_id, type, dates
    }

    required public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .user_id)
        type = try container.decode(String.self, forKey: .type)
        let rawDates = try container.decode([Int].self, forKey: .dates)
        dates.append(objectsIn: rawDates)
    }
}
