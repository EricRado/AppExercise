//
//  JSONEntry.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/12/19.
//

import Foundation

struct JSONItem: Decodable {
    // MARK: - Properties
    let id: String
    let type: String
    let date: String?
    let data: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        type = try values.decode(String.self, forKey: .type)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        data = try values.decodeIfPresent(String.self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case date
        case data
    }
}
