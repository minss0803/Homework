//
//  Bucket.swift
//  iOSTest_ChangSikJeong
//
//  Created by Sicc on 17/09/2019.
//  Copyright © 2019 chang sic jung. All rights reserved.
//

import Foundation

struct Bucket: Decodable {
  let id: Int
  let imageUrl: String
  let nickname: String
  let profileImageUrl: String
  let description: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case imageUrl = "image_url"
    case nickname
    case profileImageUrl = "profile_image_url"
    case description
  }
}
