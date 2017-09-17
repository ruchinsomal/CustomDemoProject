//
//  RSSongsData.swift
//
//  Created by Ruchin Somal on 17/09/17
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class RSSongsData: NSCoding {

    
  private struct SerializationKeys {
    static let results = "results"
    static let resultCount = "resultCount"
  }

  // MARK: Properties
  public var results: [RSResults]?
  public var resultCount: Int?

    
  public convenience init(object: Any) {
    self.init(json: R_JSON(object))
  }

    
  public required init(json: R_JSON) {
    if let items = json[SerializationKeys.results].array { results = items.map { RSResults(json: $0) } }
    resultCount = json[SerializationKeys.resultCount].int
  }
    
    
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = results { dictionary[SerializationKeys.results] = value.map { $0.dictionaryRepresentation() } }
    if let value = resultCount { dictionary[SerializationKeys.resultCount] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.results = aDecoder.decodeObject(forKey: SerializationKeys.results) as? [RSResults]
    self.resultCount = aDecoder.decodeObject(forKey: SerializationKeys.resultCount) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(results, forKey: SerializationKeys.results)
    aCoder.encode(resultCount, forKey: SerializationKeys.resultCount)
  }

}
