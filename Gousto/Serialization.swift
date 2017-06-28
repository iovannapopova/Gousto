//
//  Serialization.swift
//  Gousto
//
//  Created by i.popova on 05.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import Foundation

enum DeserializationError: Error {
    case invalidType
    case transformFailed
}

protocol Deserializable {
    
    init(dictionary: [String: Any]) throws
    
}

protocol Serializable {
    var dictionary: [String: Any] { get }
}

extension Dictionary {
    
    func value<A>(for key: Key) throws -> A {
        guard let result = self[key] as? A else {
            throw DeserializationError.invalidType
        }
        return result
    }
    
    func value<A: Deserializable>(for key: Key) throws -> [String: A] {
        guard let dictionary = self[key] as? [String: [String: Any]] else {
            throw DeserializationError.invalidType
        }
        var result: [String: A] = [:]
        for (resultKey, resultDict) in dictionary {
            result[resultKey] = try? A(dictionary: resultDict)
        }
        return result
    }
    
    func value<A: Deserializable>(for key: Key) throws -> [A] {
        guard let array = self[key] as? [[String: Any]] else {
            throw DeserializationError.invalidType
        }
        return array.flatMap { try? A(dictionary: $0)}
    }
    
    func value<A>(for key: Key, via transform: (String) -> A) throws -> A {
        guard let str = self[key] as? String else {
            throw DeserializationError.invalidType
        }
        return transform(str)
    }
    
    func value<A>(for key: Key, via transform: (String) -> A?) throws -> A {
        guard let str = self[key] as? String else {
            throw DeserializationError.invalidType
        }
        guard let result = transform(str) else {
            throw DeserializationError.transformFailed
        }
        return result
    }

}
