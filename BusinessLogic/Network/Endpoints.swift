//
//  Endpoints.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import Foundation

public enum Endpoints {
    public static let baseURL = "http://test.rikmasters.ru/api/"
    
    public static var users: URL {
        return URL(string: baseURL + "users/")!
    }
    
    public static var statistics: URL {
        return URL(string: baseURL + "statistics/")!
    }
}
