//
//  RSResults.swift
//
//  Created by Ruchin Somal on 17/09/17
//  Copyright (c) . All rights reserved.
//

import Foundation

public final class RSResults: NSCoding {

    
  private struct SerializationKeys {
    static let kind = "kind"
    static let trackId = "trackId"
    static let trackHdPrice = "trackHdPrice"
    static let contentAdvisoryRating = "contentAdvisoryRating"
    static let discCount = "discCount"
    static let isStreamable = "isStreamable"
    static let artworkUrl30 = "artworkUrl30"
    static let artworkUrl60 = "artworkUrl60"
    static let previewUrl = "previewUrl"
    static let discNumber = "discNumber"
    static let trackViewUrl = "trackViewUrl"
    static let collectionCensoredName = "collectionCensoredName"
    static let collectionExplicitness = "collectionExplicitness"
    static let artworkUrl100 = "artworkUrl100"
    static let collectionArtistName = "collectionArtistName"
    static let currency = "currency"
    static let wrapperType = "wrapperType"
    static let trackNumber = "trackNumber"
    static let collectionViewUrl = "collectionViewUrl"
    static let collectionName = "collectionName"
    static let artistName = "artistName"
    static let trackCensoredName = "trackCensoredName"
    static let collectionPrice = "collectionPrice"
    static let trackCount = "trackCount"
    static let releaseDate = "releaseDate"
    static let artistId = "artistId"
    static let primaryGenreName = "primaryGenreName"
    static let trackExplicitness = "trackExplicitness"
    static let collectionId = "collectionId"
    static let trackName = "trackName"
    static let trackHdRentalPrice = "trackHdRentalPrice"
    static let hasITunesExtras = "hasITunesExtras"
    static let collectionHdPrice = "collectionHdPrice"
    static let trackRentalPrice = "trackRentalPrice"
    static let trackPrice = "trackPrice"
    static let artistViewUrl = "artistViewUrl"
    static let trackTimeMillis = "trackTimeMillis"
    static let country = "country"
  }

  // MARK: Properties
  public var kind: String?
  public var trackId: Int64?
  public var trackHdPrice: Float?
  public var contentAdvisoryRating: String?
  public var discCount: Int?
  public var isStreamable: Bool? = false
  public var artworkUrl30: String?
  public var artworkUrl60: String?
  public var previewUrl: String?
  public var discNumber: Int?
  public var trackViewUrl: String?
  public var collectionCensoredName: String?
  public var collectionExplicitness: String?
  public var artworkUrl100: String?
  public var collectionArtistName: String?
  public var currency: String?
  public var wrapperType: String?
  public var trackNumber: Int?
  public var collectionViewUrl: String?
  public var collectionName: String?
  public var artistName: String?
  public var trackCensoredName: String?
  public var collectionPrice: Float?
  public var trackCount: Int?
  public var releaseDate: String?
  public var artistId: Int64?
  public var primaryGenreName: String?
  public var trackExplicitness: String?
  public var collectionId: Int64?
  public var trackName: String?
  public var trackHdRentalPrice: Float?
  public var hasITunesExtras: Bool? = false
  public var collectionHdPrice: Float?
  public var trackRentalPrice: Float?
  public var trackPrice: Float?
  public var artistViewUrl: String?
  public var trackTimeMillis: Int64?
  public var country: String?

    
  public convenience init(object: Any) {
    self.init(json: R_JSON(object))
  }

    
  public required init(json: R_JSON) {
    kind = json[SerializationKeys.kind].string
    trackId = json[SerializationKeys.trackId].int64
    trackHdPrice = json[SerializationKeys.trackHdPrice].float
    contentAdvisoryRating = json[SerializationKeys.contentAdvisoryRating].string
    discCount = json[SerializationKeys.discCount].int
    isStreamable = json[SerializationKeys.isStreamable].boolValue
    artworkUrl30 = json[SerializationKeys.artworkUrl30].string
    artworkUrl60 = json[SerializationKeys.artworkUrl60].string
    previewUrl = json[SerializationKeys.previewUrl].string
    discNumber = json[SerializationKeys.discNumber].int
    trackViewUrl = json[SerializationKeys.trackViewUrl].string
    collectionCensoredName = json[SerializationKeys.collectionCensoredName].string
    collectionExplicitness = json[SerializationKeys.collectionExplicitness].string
    artworkUrl100 = json[SerializationKeys.artworkUrl100].string
    collectionArtistName = json[SerializationKeys.collectionArtistName].string
    currency = json[SerializationKeys.currency].string
    wrapperType = json[SerializationKeys.wrapperType].string
    trackNumber = json[SerializationKeys.trackNumber].int
    collectionViewUrl = json[SerializationKeys.collectionViewUrl].string
    collectionName = json[SerializationKeys.collectionName].string
    artistName = json[SerializationKeys.artistName].string
    trackCensoredName = json[SerializationKeys.trackCensoredName].string
    collectionPrice = json[SerializationKeys.collectionPrice].float
    trackCount = json[SerializationKeys.trackCount].int
    releaseDate = json[SerializationKeys.releaseDate].string
    artistId = json[SerializationKeys.artistId].int64
    primaryGenreName = json[SerializationKeys.primaryGenreName].string
    trackExplicitness = json[SerializationKeys.trackExplicitness].string
    collectionId = json[SerializationKeys.collectionId].int64
    trackName = json[SerializationKeys.trackName].string
    trackHdRentalPrice = json[SerializationKeys.trackHdRentalPrice].float
    hasITunesExtras = json[SerializationKeys.hasITunesExtras].boolValue
    collectionHdPrice = json[SerializationKeys.collectionHdPrice].float
    trackRentalPrice = json[SerializationKeys.trackRentalPrice].float
    trackPrice = json[SerializationKeys.trackPrice].float
    artistViewUrl = json[SerializationKeys.artistViewUrl].string
    trackTimeMillis = json[SerializationKeys.trackTimeMillis].int64
    country = json[SerializationKeys.country].string
  }

    
    
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = kind { dictionary[SerializationKeys.kind] = value }
    if let value = trackId { dictionary[SerializationKeys.trackId] = value }
    if let value = trackHdPrice { dictionary[SerializationKeys.trackHdPrice] = value }
    if let value = contentAdvisoryRating { dictionary[SerializationKeys.contentAdvisoryRating] = value }
    if let value = discCount { dictionary[SerializationKeys.discCount] = value }
    dictionary[SerializationKeys.isStreamable] = isStreamable
    if let value = artworkUrl30 { dictionary[SerializationKeys.artworkUrl30] = value }
    if let value = artworkUrl60 { dictionary[SerializationKeys.artworkUrl60] = value }
    if let value = previewUrl { dictionary[SerializationKeys.previewUrl] = value }
    if let value = discNumber { dictionary[SerializationKeys.discNumber] = value }
    if let value = trackViewUrl { dictionary[SerializationKeys.trackViewUrl] = value }
    if let value = collectionCensoredName { dictionary[SerializationKeys.collectionCensoredName] = value }
    if let value = collectionExplicitness { dictionary[SerializationKeys.collectionExplicitness] = value }
    if let value = artworkUrl100 { dictionary[SerializationKeys.artworkUrl100] = value }
    if let value = collectionArtistName { dictionary[SerializationKeys.collectionArtistName] = value }
    if let value = currency { dictionary[SerializationKeys.currency] = value }
    if let value = wrapperType { dictionary[SerializationKeys.wrapperType] = value }
    if let value = trackNumber { dictionary[SerializationKeys.trackNumber] = value }
    if let value = collectionViewUrl { dictionary[SerializationKeys.collectionViewUrl] = value }
    if let value = collectionName { dictionary[SerializationKeys.collectionName] = value }
    if let value = artistName { dictionary[SerializationKeys.artistName] = value }
    if let value = trackCensoredName { dictionary[SerializationKeys.trackCensoredName] = value }
    if let value = collectionPrice { dictionary[SerializationKeys.collectionPrice] = value }
    if let value = trackCount { dictionary[SerializationKeys.trackCount] = value }
    if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
    if let value = artistId { dictionary[SerializationKeys.artistId] = value }
    if let value = primaryGenreName { dictionary[SerializationKeys.primaryGenreName] = value }
    if let value = trackExplicitness { dictionary[SerializationKeys.trackExplicitness] = value }
    if let value = collectionId { dictionary[SerializationKeys.collectionId] = value }
    if let value = trackName { dictionary[SerializationKeys.trackName] = value }
    if let value = trackHdRentalPrice { dictionary[SerializationKeys.trackHdRentalPrice] = value }
    dictionary[SerializationKeys.hasITunesExtras] = hasITunesExtras
    if let value = collectionHdPrice { dictionary[SerializationKeys.collectionHdPrice] = value }
    if let value = trackRentalPrice { dictionary[SerializationKeys.trackRentalPrice] = value }
    if let value = trackPrice { dictionary[SerializationKeys.trackPrice] = value }
    if let value = artistViewUrl { dictionary[SerializationKeys.artistViewUrl] = value }
    if let value = trackTimeMillis { dictionary[SerializationKeys.trackTimeMillis] = value }
    if let value = country { dictionary[SerializationKeys.country] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.kind = aDecoder.decodeObject(forKey: SerializationKeys.kind) as? String
    self.trackId = aDecoder.decodeObject(forKey: SerializationKeys.trackId) as? Int64
    self.trackHdPrice = aDecoder.decodeObject(forKey: SerializationKeys.trackHdPrice) as? Float
    self.contentAdvisoryRating = aDecoder.decodeObject(forKey: SerializationKeys.contentAdvisoryRating) as? String
    self.discCount = aDecoder.decodeObject(forKey: SerializationKeys.discCount) as? Int
    self.isStreamable = aDecoder.decodeBool(forKey: SerializationKeys.isStreamable)
    self.artworkUrl30 = aDecoder.decodeObject(forKey: SerializationKeys.artworkUrl30) as? String
    self.artworkUrl60 = aDecoder.decodeObject(forKey: SerializationKeys.artworkUrl60) as? String
    self.previewUrl = aDecoder.decodeObject(forKey: SerializationKeys.previewUrl) as? String
    self.discNumber = aDecoder.decodeObject(forKey: SerializationKeys.discNumber) as? Int
    self.trackViewUrl = aDecoder.decodeObject(forKey: SerializationKeys.trackViewUrl) as? String
    self.collectionCensoredName = aDecoder.decodeObject(forKey: SerializationKeys.collectionCensoredName) as? String
    self.collectionExplicitness = aDecoder.decodeObject(forKey: SerializationKeys.collectionExplicitness) as? String
    self.artworkUrl100 = aDecoder.decodeObject(forKey: SerializationKeys.artworkUrl100) as? String
    self.collectionArtistName = aDecoder.decodeObject(forKey: SerializationKeys.collectionArtistName) as? String
    self.currency = aDecoder.decodeObject(forKey: SerializationKeys.currency) as? String
    self.wrapperType = aDecoder.decodeObject(forKey: SerializationKeys.wrapperType) as? String
    self.trackNumber = aDecoder.decodeObject(forKey: SerializationKeys.trackNumber) as? Int
    self.collectionViewUrl = aDecoder.decodeObject(forKey: SerializationKeys.collectionViewUrl) as? String
    self.collectionName = aDecoder.decodeObject(forKey: SerializationKeys.collectionName) as? String
    self.artistName = aDecoder.decodeObject(forKey: SerializationKeys.artistName) as? String
    self.trackCensoredName = aDecoder.decodeObject(forKey: SerializationKeys.trackCensoredName) as? String
    self.collectionPrice = aDecoder.decodeObject(forKey: SerializationKeys.collectionPrice) as? Float
    self.trackCount = aDecoder.decodeObject(forKey: SerializationKeys.trackCount) as? Int
    self.releaseDate = aDecoder.decodeObject(forKey: SerializationKeys.releaseDate) as? String
    self.artistId = aDecoder.decodeObject(forKey: SerializationKeys.artistId) as? Int64
    self.primaryGenreName = aDecoder.decodeObject(forKey: SerializationKeys.primaryGenreName) as? String
    self.trackExplicitness = aDecoder.decodeObject(forKey: SerializationKeys.trackExplicitness) as? String
    self.collectionId = aDecoder.decodeObject(forKey: SerializationKeys.collectionId) as? Int64
    self.trackName = aDecoder.decodeObject(forKey: SerializationKeys.trackName) as? String
    self.trackHdRentalPrice = aDecoder.decodeObject(forKey: SerializationKeys.trackHdRentalPrice) as? Float
    self.hasITunesExtras = aDecoder.decodeBool(forKey: SerializationKeys.hasITunesExtras)
    self.collectionHdPrice = aDecoder.decodeObject(forKey: SerializationKeys.collectionHdPrice) as? Float
    self.trackRentalPrice = aDecoder.decodeObject(forKey: SerializationKeys.trackRentalPrice) as? Float
    self.trackPrice = aDecoder.decodeObject(forKey: SerializationKeys.trackPrice) as? Float
    self.artistViewUrl = aDecoder.decodeObject(forKey: SerializationKeys.artistViewUrl) as? String
    self.trackTimeMillis = aDecoder.decodeObject(forKey: SerializationKeys.trackTimeMillis) as? Int64
    self.country = aDecoder.decodeObject(forKey: SerializationKeys.country) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(kind, forKey: SerializationKeys.kind)
    aCoder.encode(trackId, forKey: SerializationKeys.trackId)
    aCoder.encode(trackHdPrice, forKey: SerializationKeys.trackHdPrice)
    aCoder.encode(contentAdvisoryRating, forKey: SerializationKeys.contentAdvisoryRating)
    aCoder.encode(discCount, forKey: SerializationKeys.discCount)
    aCoder.encode(isStreamable, forKey: SerializationKeys.isStreamable)
    aCoder.encode(artworkUrl30, forKey: SerializationKeys.artworkUrl30)
    aCoder.encode(artworkUrl60, forKey: SerializationKeys.artworkUrl60)
    aCoder.encode(previewUrl, forKey: SerializationKeys.previewUrl)
    aCoder.encode(discNumber, forKey: SerializationKeys.discNumber)
    aCoder.encode(trackViewUrl, forKey: SerializationKeys.trackViewUrl)
    aCoder.encode(collectionCensoredName, forKey: SerializationKeys.collectionCensoredName)
    aCoder.encode(collectionExplicitness, forKey: SerializationKeys.collectionExplicitness)
    aCoder.encode(artworkUrl100, forKey: SerializationKeys.artworkUrl100)
    aCoder.encode(collectionArtistName, forKey: SerializationKeys.collectionArtistName)
    aCoder.encode(currency, forKey: SerializationKeys.currency)
    aCoder.encode(wrapperType, forKey: SerializationKeys.wrapperType)
    aCoder.encode(trackNumber, forKey: SerializationKeys.trackNumber)
    aCoder.encode(collectionViewUrl, forKey: SerializationKeys.collectionViewUrl)
    aCoder.encode(collectionName, forKey: SerializationKeys.collectionName)
    aCoder.encode(artistName, forKey: SerializationKeys.artistName)
    aCoder.encode(trackCensoredName, forKey: SerializationKeys.trackCensoredName)
    aCoder.encode(collectionPrice, forKey: SerializationKeys.collectionPrice)
    aCoder.encode(trackCount, forKey: SerializationKeys.trackCount)
    aCoder.encode(releaseDate, forKey: SerializationKeys.releaseDate)
    aCoder.encode(artistId, forKey: SerializationKeys.artistId)
    aCoder.encode(primaryGenreName, forKey: SerializationKeys.primaryGenreName)
    aCoder.encode(trackExplicitness, forKey: SerializationKeys.trackExplicitness)
    aCoder.encode(collectionId, forKey: SerializationKeys.collectionId)
    aCoder.encode(trackName, forKey: SerializationKeys.trackName)
    aCoder.encode(trackHdRentalPrice, forKey: SerializationKeys.trackHdRentalPrice)
    aCoder.encode(hasITunesExtras, forKey: SerializationKeys.hasITunesExtras)
    aCoder.encode(collectionHdPrice, forKey: SerializationKeys.collectionHdPrice)
    aCoder.encode(trackRentalPrice, forKey: SerializationKeys.trackRentalPrice)
    aCoder.encode(trackPrice, forKey: SerializationKeys.trackPrice)
    aCoder.encode(artistViewUrl, forKey: SerializationKeys.artistViewUrl)
    aCoder.encode(trackTimeMillis, forKey: SerializationKeys.trackTimeMillis)
    aCoder.encode(country, forKey: SerializationKeys.country)
  }

}
