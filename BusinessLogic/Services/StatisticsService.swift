//
//  StatisticsService.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import Foundation
import RxSwift
import RealmSwift

public class StatisticsService {
    private let realm = try! Realm()
    private let url = "http://test.rikmasters.ru/api/statistics/"

    public func fetchStatistics() -> Observable<[Statistic]> {
        return NetworkManager.shared.fetch(urlString: url)
            .map { (response: StatisticsResponse) in
                try! self.realm.write {
                    self.realm.add(response.statistics, update: .modified)
                }
                return response.statistics
            }
    }

    public func getCachedStatistics() -> [Statistic] {
        return Array(realm.objects(Statistic.self))
    }
}

private struct StatisticsResponse: Decodable {
    let statistics: [Statistic]
}
