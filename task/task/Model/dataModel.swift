//
//  dataModel.swift
//  task
//
//  Created by Tirumala on 27/05/23.
//

import Foundation


struct ResponseDataModel: Decodable {

  var id      : String?    = nil
  var author           : String?    = nil
  var width        : Int? = nil
  var height          : Int? = nil
  var url : String? = nil
  var download_url : String? = nil
 
  enum CodingKeys: String, CodingKey {

    case id      = "id"
    case author           = "author"
    case width        = "width"
    case height          = "height"
    case url = "url"
    case download_url = "download_url"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

      id      = try values.decodeIfPresent(String.self    , forKey: .id      )
      author           = try values.decodeIfPresent(String.self    , forKey: .author           )
      width        = try values.decodeIfPresent(Int.self , forKey: .width        )
      height          = try values.decodeIfPresent(Int.self , forKey: .height          )
      url = try values.decodeIfPresent(String.self , forKey: .url )
      download_url = try values.decodeIfPresent(String.self , forKey: .download_url )
 
  }

  init() {

  }

}
