//
//  BucketNetworkImpl.swift
//  Homework
//
//  Created by 민쓰 on 24/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation

final class BucketNetworkImpl: BucketNetwork {
  
  func requesetBucketData(order: String, space: String, residence: String, page: String, completionHandler: @escaping (Result<[Bucket], NetworkError>) -> Void) {
    
    guard let url = makeComponents(order, space,residence, page).url else {
        return completionHandler(.failure(.error("유효하지 않은 URL 입니다.")))
    }
    
    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        
        guard error == nil else {
            return completionHandler(.failure(.defaultError))
        }
        guard let header = response as? HTTPURLResponse,
            (200..<300) ~= header.statusCode else {
                return completionHandler(.failure(.error("네트워크 상태가 불안정 합니다.")))
        }
        guard let data = data else {
            return completionHandler(.failure(.error("데이터가 없습니다.")))
        }
        
        // JSON Parsing
        if let result = try? JSONDecoder().decode([Bucket].self, from: data) {
            completionHandler(.success(result))
        } else {
            completionHandler(.failure(.error("올바른 형식이 아닙니다.")))
        }
    }
    task.resume()
    
    }
}

private extension BucketNetworkImpl {
    struct BucketAPI {
        static let scheme = "https"
        static let host = "s3.ap-northeast-2.amazonaws.com"
        static let path = "/bucketplace-coding-test/cards/page_1.json"
    }
    
    func makeComponents(_ order: String, _ space: String, _ residence: String, _ page: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = BucketAPI.scheme
        components.host = BucketAPI.host
        components.path = BucketAPI.path
        components.queryItems = []
        zip(["order", "space", "residence"], [order, space, residence]).forEach {
            components.queryItems?.append(URLQueryItem(name: $0, value: $1))
        }
        return components
    }
}
