//
//  BucketNetwork.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//


import Foundation

enum NetworkError: Error {
  case error(String)
  case defaultError
  
  var message: String? {
      switch self {
      case let .error(msg):
          return msg
      case .defaultError:
          return "잠시 후에 다시 시도해주세요."
      }
  }
}

protocol BucketNetwork {
    func requesetBucketData(
        order: String,
        space: String,
        residence: String,
        page: String,
        completionHandler: @escaping (Result<[Bucket], NetworkError>) -> Void
    )
}

