//
//  ImageModel.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 28/08/23.
//

import Foundation

struct ImageModel: Codable {
    
    struct ImageResponse: Codable {
        let url : URL
    }
    
    let created: Int
    let data: [ImageResponse]
    
}
