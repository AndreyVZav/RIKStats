//
//  NetworkManager.swift
//  RIKStats
//
//  Created by Андрей Завадский on 25.05.2025.
//

import Foundation
import RxSwift

public class NetworkManager {
    public static let shared = NetworkManager()
    private init() {}
    
    public func fetch<T: Decodable>(urlString: String) -> Observable<T> {
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "Invalid URL", code: 0))
        }
        
        return Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "No data", code: 0))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decoded)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
