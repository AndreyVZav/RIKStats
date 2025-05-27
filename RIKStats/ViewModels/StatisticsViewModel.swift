//
//  StatisticsViewModel.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//
import Foundation
import RxSwift
import RxRelay
import BusinessLogic

class StatisticsViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    private let userService = UserService()
    private let statisticsService = StatisticsService()
    
    @Published var users: [User] = []
    @Published var statistics: [Statistic] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadCached() {
        users = userService.getCachedUsers()
        statistics = statisticsService.getCachedStatistics()
    }

    func refresh() {
        isLoading = true
        errorMessage = nil

        Observable.zip(
            userService.fetchUsers(),
            statisticsService.fetchStatistics()
        )
        .observe(on: MainScheduler.instance)
        .subscribe { [weak self] users, stats in
            self?.users = users
            self?.statistics = stats
            self?.isLoading = false
        } onError: { [weak self] error in
            self?.errorMessage = error.localizedDescription
            self?.isLoading = false
        }
        .disposed(by: disposeBag)
    }
}

