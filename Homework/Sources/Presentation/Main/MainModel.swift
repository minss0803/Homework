//
//  MainModel.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation

struct MainModel {

    let bucketNetwork: BucketNetwork
    init(bucketService: BucketNetwork = BucketNetworkImpl()) {
        self.bucketNetwork = bucketService
    }
    
    func getBucketList(order: String,
                       space: String,
                       residence: String,
                       page: String,
                       completion: @escaping (Result<[Bucket], NetworkError>) -> Void) {
        
        bucketNetwork.requesetBucketData(order: order, space: space, residence: residence, page: page) { result in
            completion(result)
        }
    }
}
