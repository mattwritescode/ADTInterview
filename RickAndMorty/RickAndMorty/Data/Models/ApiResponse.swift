//
//  ApiResponse.swift
//  RickAndMorty
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - ApiResponse
struct ApiResponse: Codable {
    let info: Info
    let results: [Episode]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String
    let prev: JSONNull?
}

// MARK: - Episode
struct Episode: Codable, Identifiable {
    let id: Int
    let name, airDate, episodeCode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episodeCode = "episode"
        case characters, url, created
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
