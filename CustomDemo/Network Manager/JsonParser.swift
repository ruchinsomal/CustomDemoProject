//
//  JsonParser.swift
//  CustomDemo
//
//  Created by Ruchin Somal on 17/09/17.
//  Copyright © 2017 Ruchin Somal. All rights reserved.
//

import Foundation

// MARK: - Error

///Error domain
public let DomainError: String = "R_JSON_Error_Main"

///Error code
public let ErrorUnsupportedType: Int = 999
public let ErrorIndexOutOfBounds: Int = 900
public let ErrorWrongType: Int = 901
public let ErrorNotExist: Int = 500
public let ErrorInvalidR_JSON: Int = 490

// MARK: - R_JSON Type

/*
 R_JSON's type definitions.
 
 See http://www.json.org
 */
public enum Type :Int{
    
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

// MARK: - R_JSON Base
public struct R_JSON {
    
    /**
     Creates a R_JSON using the data.
     
     - parameter data:  The NSData used to convert to R_JSON.Top level object in data is an NSArray or NSDictionary
     - parameter opt:   The R_JSON serialization reading options. `.AllowFragments` by default.
     - parameter error: The NSErrorPointer used to return the error. `nil` by default.
     
     - returns: The created R_JSON
     */
    public init(data:Data, options opt: JSONSerialization.ReadingOptions = .allowFragments, error: NSErrorPointer = nil) {
        do {
            let object: Any = try JSONSerialization.jsonObject(with: data, options: opt)
            self.init(object)
        } catch let aError as NSError {
            if error != nil {
                error?.pointee = aError
            }
            self.init(NSNull())
        }
    }
    
    /**
     Creates a R_JSON from R_JSON string
     - parameter string: Normal R_JSON string like '{"a":"b"}'
     
     - returns: The created R_JSON
     */
    public static func parse(_ string:String) -> R_JSON {
        return string.data(using: String.Encoding.utf8)
            .flatMap{ R_JSON(data: $0) } ?? R_JSON(NSNull())
    }
    
    /**
     Creates a R_JSON using the object.
     
     - parameter object:  The object must have the following properties: All objects are NSString/String, NSNumber/Int/Float/Double/Bool, NSArray/Array, NSDictionary/Dictionary, or NSNull; All dictionary keys are NSStrings/String; NSNumbers are not NaN or infinity.
     
     - returns: The created R_JSON
     */
    public init(_ object: Any) {
        self.object = object
    }
    
    /**
     Creates a R_JSON from a [R_JSON]
     
     - parameter R_JSONArray: A Swift array of R_JSON objects
     
     - returns: The created R_JSON
     */
    public init(_ R_JSONArray:[R_JSON]) {
        self.init(R_JSONArray.map { $0.object })
    }
    
    /**
     Creates a R_JSON from a [String: R_JSON]
     
     - parameter R_JSONDictionary: A Swift dictionary of R_JSON objects
     
     - returns: The created R_JSON
     */
    public init(_ R_JSONDictionary:[String: R_JSON]) {
        var dictionary = [String: Any](minimumCapacity: R_JSONDictionary.count)
        for (key, R_JSON) in R_JSONDictionary {
            dictionary[key] = R_JSON.object
        }
        self.init(dictionary)
    }
    
    /// Private object
    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String : Any] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawNumber: NSNumber = 0
    fileprivate var rawNull: NSNull = NSNull()
    fileprivate var rawBool: Bool = false
    /// Private type
    fileprivate var _type: Type = .null
    /// prviate error
    fileprivate var _error: NSError? = nil
    
    /// Object in R_JSON
    public var object: Any {
        get {
            switch self.type {
            case .array:
                return self.rawArray
            case .dictionary:
                return self.rawDictionary
            case .string:
                return self.rawString
            case .number:
                return self.rawNumber
            case .bool:
                return self.rawBool
            default:
                return self.rawNull
            }
        }
        set {
            _error = nil
            switch newValue {
            case let number as NSNumber:
                if number.isBool {
                    _type = .bool
                    self.rawBool = number.boolValue
                } else {
                    _type = .number
                    self.rawNumber = number
                }
            case  let string as String:
                _type = .string
                self.rawString = string
            case  _ as NSNull:
                _type = .null
            case let array as [R_JSON]:
                _type = .array
                self.rawArray = array.map { $0.object }
            case let array as [Any]:
                _type = .array
                self.rawArray = array
            case let dictionary as [String : Any]:
                _type = .dictionary
                self.rawDictionary = dictionary
            default:
                _type = .unknown
                _error = NSError(domain: DomainError, code: ErrorUnsupportedType, userInfo: [NSLocalizedDescriptionKey: "It is a unsupported type"])
            }
        }
    }
    
    /// R_JSON type
    public var type: Type { get { return _type } }
    
    /// Error in R_JSON
    public var error: NSError? { get { return self._error } }
    
    /// The static null R_JSON
    @available(*, unavailable, renamed:"null")
    public static var nullR_JSON: R_JSON { get { return null } }
    public static var null: R_JSON { get { return R_JSON(NSNull()) } }
}

public enum R_JSONIndex:Comparable
{
    case array(Int)
    case dictionary(DictionaryIndex<String, R_JSON>)
    case null
}

public func ==(lhs: R_JSONIndex, rhs: R_JSONIndex) -> Bool
{
    switch (lhs, rhs)
    {
    case (.array(let left), .array(let right)):
        return left == right
    case (.dictionary(let left), .dictionary(let right)):
        return left == right
    case (.null, .null): return true
    default:
        return false
    }
}

public func <(lhs: R_JSONIndex, rhs: R_JSONIndex) -> Bool
{
    switch (lhs, rhs)
    {
    case (.array(let left), .array(let right)):
        return left < right
    case (.dictionary(let left), .dictionary(let right)):
        return left < right
    default:
        return false
    }
}


extension R_JSON: Collection
{
    
    public typealias Index = R_JSONIndex
    
    public var startIndex: Index
    {
        switch type
        {
        case .array:
            return .array(rawArray.startIndex)
        case .dictionary:
            return .dictionary(dictionaryValue.startIndex)
        default:
            return .null
        }
    }
    
    public var endIndex: Index
    {
        switch type
        {
        case .array:
            return .array(rawArray.endIndex)
        case .dictionary:
            return .dictionary(dictionaryValue.endIndex)
        default:
            return .null
        }
    }
    
    public func index(after i: Index) -> Index
    {
        switch i
        {
        case .array(let idx):
            return .array(rawArray.index(after: idx))
        case .dictionary(let idx):
            return .dictionary(dictionaryValue.index(after: idx))
        default:
            return .null
        }
        
    }
    
    public subscript (position: Index) -> (String, R_JSON)
    {
        switch position
        {
        case .array(let idx):
            return (String(idx), R_JSON(self.rawArray[idx]))
        case .dictionary(let idx):
            return dictionaryValue[idx]
        default:
            return ("", R_JSON.null)
        }
    }
    
    
}

// MARK: - Subscript

/**
 *  To mark both String and Int can be used in subscript.
 */

public enum R_JSONKey
{
    case index(Int)
    case key(String)
}

public protocol R_JSONSubscriptType {
    var r_jsonKey:R_JSONKey { get }
}

extension Int: R_JSONSubscriptType {
    public var r_jsonKey:R_JSONKey {
        return R_JSONKey.index(self)
    }
}

extension String: R_JSONSubscriptType {
    public var r_jsonKey:R_JSONKey {
        return R_JSONKey.key(self)
    }
}

extension R_JSON {
    
    /// If `type` is `.Array`, return R_JSON whose object is `array[index]`, otherwise return null R_JSON with error.
    fileprivate subscript(index index: Int) -> R_JSON {
        get {
            if self.type != .array {
                var r = R_JSON.null
                r._error = self._error ?? NSError(domain: DomainError, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] failure, It is not an array"])
                return r
            } else if index >= 0 && index < self.rawArray.count {
                return R_JSON(self.rawArray[index])
            } else {
                var r = R_JSON.null
                r._error = NSError(domain: DomainError, code:ErrorIndexOutOfBounds , userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] is out of bounds"])
                return r
            }
        }
        set {
            if self.type == .array {
                if self.rawArray.count > index && newValue.error == nil {
                    self.rawArray[index] = newValue.object
                }
            }
        }
    }
    
    /// If `type` is `.Dictionary`, return R_JSON whose object is `dictionary[key]` , otherwise return null R_JSON with error.
    fileprivate subscript(key key: String) -> R_JSON {
        get {
            var r = R_JSON.null
            if self.type == .dictionary {
                if let o = self.rawDictionary[key] {
                    r = R_JSON(o)
                } else {
                    r._error = NSError(domain: DomainError, code: ErrorNotExist, userInfo: [NSLocalizedDescriptionKey: "Dictionary[\"\(key)\"] does not exist"])
                }
            } else {
                r._error = self._error ?? NSError(domain: DomainError, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Dictionary[\"\(key)\"] failure, It is not an dictionary"])
            }
            return r
        }
        set {
            if self.type == .dictionary && newValue.error == nil {
                self.rawDictionary[key] = newValue.object
            }
        }
    }
    
    /// If `sub` is `Int`, return `subscript(index:)`; If `sub` is `String`,  return `subscript(key:)`.
    fileprivate subscript(sub sub: R_JSONSubscriptType) -> R_JSON {
        get {
            switch sub.r_jsonKey {
            case .index(let index): return self[index: index]
            case .key(let key): return self[key: key]
            }
        }
        set {
            switch sub.r_jsonKey {
            case .index(let index): self[index: index] = newValue
            case .key(let key): self[key: key] = newValue
            }
        }
    }
    
    /**
     Find a R_JSON in the complex data structures by using array of Int and/or String as path.
     
     - parameter path: The target R_JSON's path. Example:
     
     let R_JSON = R_JSON[data]
     let path = [9,"list","person","name"]
     let name = R_JSON[path]
     
     The same as: let name = R_JSON[9]["list"]["person"]["name"]
     
     - returns: Return a R_JSON found by the path or a null R_JSON with error
     */
    public subscript(path: [R_JSONSubscriptType]) -> R_JSON {
        get {
            return path.reduce(self) { $0[sub: $1] }
        }
        set {
            switch path.count {
            case 0:
                return
            case 1:
                self[sub:path[0]].object = newValue.object
            default:
                var aPath = path; aPath.remove(at: 0)
                var nextR_JSON = self[sub: path[0]]
                nextR_JSON[aPath] = newValue
                self[sub: path[0]] = nextR_JSON
            }
        }
    }
    
    /**
     Find a R_JSON in the complex data structures by using array of Int and/or String as path.
     
     - parameter path: The target R_JSON's path. Example:
     
     let name = R_JSON[9,"list","person","name"]
     
     The same as: let name = R_JSON[9]["list"]["person"]["name"]
     
     - returns: Return a R_JSON found by the path or a null R_JSON with error
     */
    public subscript(path: R_JSONSubscriptType...) -> R_JSON {
        get {
            return self[path]
        }
        set {
            self[path] = newValue
        }
    }
}

// MARK: - LiteralConvertible

extension R_JSON: Swift.ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value as Any)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value as Any)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value as Any)
    }
}

extension R_JSON: Swift.ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value as Any)
    }
}

extension R_JSON: Swift.ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value as Any)
    }
}

extension R_JSON: Swift.ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value as Any)
    }
}

extension R_JSON: Swift.ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any)...) {
        let array = elements
        self.init(dictionaryLiteral: array)
    }
    
    public init(dictionaryLiteral elements: [(String, Any)]) {
        let R_JSONFromDictionaryLiteral: ([String : Any]) -> R_JSON = { dictionary in
            let initializeElement = Array(dictionary.keys).flatMap { key -> (String, Any)? in
                if let value = dictionary[key] {
                    return (key, value)
                }
                return nil
            }
            return R_JSON(dictionaryLiteral: initializeElement)
        }
        
        var dict = [String : Any](minimumCapacity: elements.count)
        
        for element in elements {
            let elementToSet: Any
            if let R_JSON = element.1 as? R_JSON {
                elementToSet = R_JSON.object
            } else if let R_JSONArray = element.1 as? [R_JSON] {
                elementToSet = R_JSON(R_JSONArray).object
            } else if let dictionary = element.1 as? [String : Any] {
                elementToSet = R_JSONFromDictionaryLiteral(dictionary).object
            } else if let dictArray = element.1 as? [[String : Any]] {
                let R_JSONArray = dictArray.map { R_JSONFromDictionaryLiteral($0) }
                elementToSet = R_JSON(R_JSONArray).object
            } else {
                elementToSet = element.1
            }
            dict[element.0] = elementToSet
        }
        
        self.init(dict)
    }
}

extension R_JSON: Swift.ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Any...) {
        self.init(elements as Any)
    }
}

extension R_JSON: Swift.ExpressibleByNilLiteral {
    
    @available(*, deprecated, message: "use R_JSON.null instead")
    public init(nilLiteral: ()) {
        self.init(NSNull() as Any)
    }
}

// MARK: - Raw

extension R_JSON: Swift.RawRepresentable {
    
    public init?(rawValue: Any) {
        if R_JSON(rawValue).type == .unknown {
            return nil
        } else {
            self.init(rawValue)
        }
    }
    
    public var rawValue: Any {
        return self.object
    }
    
    public func rawData(options opt: JSONSerialization.WritingOptions = JSONSerialization.WritingOptions(rawValue: 0)) throws -> Data {
        guard JSONSerialization.isValidJSONObject(self.object) else {
            throw NSError(domain: DomainError, code: ErrorInvalidR_JSON, userInfo: [NSLocalizedDescriptionKey: "R_JSON is invalid"])
        }
        
        return try JSONSerialization.data(withJSONObject: self.object, options: opt)
    }
    
    public func rawString(_ encoding: String.Encoding = String.Encoding.utf8, options opt: JSONSerialization.WritingOptions = .prettyPrinted) -> String? {
        switch self.type {
        case .array, .dictionary:
            do {
                let data = try self.rawData(options: opt)
                return String(data: data, encoding: encoding)
            } catch _ {
                return nil
            }
        case .string:
            return self.rawString
        case .number:
            return self.rawNumber.stringValue
        case .bool:
            return self.rawBool.description
        case .null:
            return "null"
        default:
            return nil
        }
    }
}

// MARK: - Printable, DebugPrintable

extension R_JSON: Swift.CustomStringConvertible, Swift.CustomDebugStringConvertible {
    
    public var description: String {
        if let string = self.rawString(options:.prettyPrinted) {
            return string
        } else {
            return "unknown"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - Array

extension R_JSON {
    
    //Optional [R_JSON]
    public var array: [R_JSON]? {
        get {
            if self.type == .array {
                return self.rawArray.map{ R_JSON($0) }
            } else {
                return nil
            }
        }
    }
    
    //Non-optional [R_JSON]
    public var arrayValue: [R_JSON] {
        get {
            return self.array ?? []
        }
    }
    
    //Optional [AnyObject]
    public var arrayObject: [Any]? {
        get {
            switch self.type {
            case .array:
                return self.rawArray
            default:
                return nil
            }
        }
        set {
            if let array = newValue {
                self.object = array as Any
            } else {
                self.object = NSNull()
            }
        }
    }
}

// MARK: - Dictionary

extension R_JSON {
    
    //Optional [String : R_JSON]
    public var dictionary: [String : R_JSON]? {
        if self.type == .dictionary {
            var d = [String : R_JSON](minimumCapacity: rawDictionary.count)
            for (key, value) in rawDictionary {
                d[key] = R_JSON(value)
            }
            return d
        } else {
            return nil
        }
    }
    
    //Non-optional [String : R_JSON]
    public var dictionaryValue: [String : R_JSON] {
        return self.dictionary ?? [:]
    }
    
    //Optional [String : AnyObject]
    public var dictionaryObject: [String : Any]? {
        get {
            switch self.type {
            case .dictionary:
                return self.rawDictionary
            default:
                return nil
            }
        }
        set {
            if let v = newValue {
                self.object = v as Any
            } else {
                self.object = NSNull()
            }
        }
    }
}

// MARK: - Bool

extension R_JSON { // : Swift.Bool
    
    //Optional bool
    public var bool: Bool? {
        get {
            switch self.type {
            case .bool:
                return self.rawBool
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.object = newValue as Bool
            } else {
                self.object = NSNull()
            }
        }
    }
    
    //Non-optional bool
    public var boolValue: Bool {
        get {
            switch self.type {
            case .bool:
                return self.rawBool
            case .number:
                return self.rawNumber.boolValue
            case .string:
                return self.rawString.caseInsensitiveCompare("true") == .orderedSame
            default:
                return false
            }
        }
        set {
            self.object = newValue
        }
    }
}

// MARK: - String

extension R_JSON {
    
    //Optional string
    public var string: String? {
        get {
            switch self.type {
            case .string:
                return self.object as? String
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.object = NSString(string:newValue)
            } else {
                self.object = NSNull()
            }
        }
    }
    
    //Non-optional string
    public var stringValue: String {
        get {
            switch self.type {
            case .string:
                return self.object as? String ?? ""
            case .number:
                return self.rawNumber.stringValue
            case .bool:
                return (self.object as? Bool).map { String($0) } ?? ""
            default:
                return ""
            }
        }
        set {
            self.object = NSString(string:newValue)
        }
    }
}

// MARK: - Number
extension R_JSON {
    
    //Optional number
    public var number: NSNumber? {
        get {
            switch self.type {
            case .number:
                return self.rawNumber
            case .bool:
                return NSNumber(value: self.rawBool ? 1 : 0)
            default:
                return nil
            }
        }
        set {
            self.object = newValue ?? NSNull()
        }
    }
    
    //Non-optional number
    public var numberValue: NSNumber {
        get {
            switch self.type {
            case .string:
                let decimal = NSDecimalNumber(string: self.object as? String)
                if decimal == NSDecimalNumber.notANumber {  // indicates parse error
                    return NSDecimalNumber.zero
                }
                return decimal
            case .number:
                return self.object as? NSNumber ?? NSNumber(value: 0)
            case .bool:
                return NSNumber(value: self.rawBool ? 1 : 0)
            default:
                return NSNumber(value: 0.0)
            }
        }
        set {
            self.object = newValue
        }
    }
}

//MARK: - Null
extension R_JSON {
    
    public var null: NSNull? {
        get {
            switch self.type {
            case .null:
                return self.rawNull
            default:
                return nil
            }
        }
        set {
            self.object = NSNull()
        }
    }
    public func exists() -> Bool{
        if let errorValue = error, errorValue.code == ErrorNotExist ||
            errorValue.code == ErrorIndexOutOfBounds ||
            errorValue.code == ErrorWrongType {
            return false
        }
        return true
    }
}

//MARK: - URL
extension R_JSON {
    
    //Optional URL
    public var URL: URL? {
        get {
            switch self.type {
            case .string:
                if let encodedString_ = self.rawString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    // We have to use `Foundation.URL` otherwise it conflicts with the variable name.
                    return Foundation.URL(string: encodedString_)
                } else {
                    return nil
                }
            default:
                return nil
            }
        }
        set {
            self.object = newValue?.absoluteString as Any
        }
    }
}

// MARK: - Int, Double, Float, Int8, Int16, Int32, Int64

extension R_JSON {
    
    public var double: Double? {
        get {
            return self.number?.doubleValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object = NSNull()
            }
        }
    }
    
    public var doubleValue: Double {
        get {
            return self.numberValue.doubleValue
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var float: Float? {
        get {
            return self.number?.floatValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object = NSNull()
            }
        }
    }
    
    public var floatValue: Float {
        get {
            return self.numberValue.floatValue
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var int: Int?
    {
        get
        {
            return self.number?.intValue
        }
        set
        {
            if let newValue = newValue
            {
                self.object = NSNumber(value: newValue)
            } else
            {
                self.object = NSNull()
            }
        }
    }
    
    public var intValue: Int {
        get {
            return self.numberValue.intValue
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var uInt: UInt? {
        get {
            return self.number?.uintValue
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object = NSNull()
            }
        }
    }
    
    public var uIntValue: UInt {
        get {
            return self.numberValue.uintValue
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var int8: Int8? {
        get {
            return self.number?.int8Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var int8Value: Int8 {
        get {
            return self.numberValue.int8Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var uInt8: UInt8? {
        get {
            return self.number?.uint8Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var uInt8Value: UInt8 {
        get {
            return self.numberValue.uint8Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var int16: Int16? {
        get {
            return self.number?.int16Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var int16Value: Int16 {
        get {
            return self.numberValue.int16Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var uInt16: UInt16? {
        get {
            return self.number?.uint16Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var uInt16Value: UInt16 {
        get {
            return self.numberValue.uint16Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var int32: Int32? {
        get {
            return self.number?.int32Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var int32Value: Int32 {
        get {
            return self.numberValue.int32Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var uInt32: UInt32? {
        get {
            return self.number?.uint32Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var uInt32Value: UInt32 {
        get {
            return self.numberValue.uint32Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var int64: Int64? {
        get {
            return self.number?.int64Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var int64Value: Int64 {
        get {
            return self.numberValue.int64Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
    
    public var uInt64: UInt64? {
        get {
            return self.number?.uint64Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }
    
    public var uInt64Value: UInt64 {
        get {
            return self.numberValue.uint64Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
}

//MARK: - Comparable
extension R_JSON : Swift.Comparable {}

public func ==(lhs: R_JSON, rhs: R_JSON) -> Bool {
    
    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber == rhs.rawNumber
    case (.string, .string):
        return lhs.rawString == rhs.rawString
    case (.bool, .bool):
        return lhs.rawBool == rhs.rawBool
    case (.array, .array):
        return lhs.rawArray as NSArray == rhs.rawArray as NSArray
    case (.dictionary, .dictionary):
        return lhs.rawDictionary as NSDictionary == rhs.rawDictionary as NSDictionary
    case (.null, .null):
        return true
    default:
        return false
    }
}

public func <=(lhs: R_JSON, rhs: R_JSON) -> Bool {
    
    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber <= rhs.rawNumber
    case (.string, .string):
        return lhs.rawString <= rhs.rawString
    case (.bool, .bool):
        return lhs.rawBool == rhs.rawBool
    case (.array, .array):
        return lhs.rawArray as NSArray == rhs.rawArray as NSArray
    case (.dictionary, .dictionary):
        return lhs.rawDictionary as NSDictionary == rhs.rawDictionary as NSDictionary
    case (.null, .null):
        return true
    default:
        return false
    }
}

public func >=(lhs: R_JSON, rhs: R_JSON) -> Bool {
    
    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber >= rhs.rawNumber
    case (.string, .string):
        return lhs.rawString >= rhs.rawString
    case (.bool, .bool):
        return lhs.rawBool == rhs.rawBool
    case (.array, .array):
        return lhs.rawArray as NSArray == rhs.rawArray as NSArray
    case (.dictionary, .dictionary):
        return lhs.rawDictionary as NSDictionary == rhs.rawDictionary as NSDictionary
    case (.null, .null):
        return true
    default:
        return false
    }
}

public func >(lhs: R_JSON, rhs: R_JSON) -> Bool {
    
    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber > rhs.rawNumber
    case (.string, .string):
        return lhs.rawString > rhs.rawString
    default:
        return false
    }
}

public func <(lhs: R_JSON, rhs: R_JSON) -> Bool {
    
    switch (lhs.type, rhs.type) {
    case (.number, .number):
        return lhs.rawNumber < rhs.rawNumber
    case (.string, .string):
        return lhs.rawString < rhs.rawString
    default:
        return false
    }
}

private let trueNumber = NSNumber(value: true)
private let falseNumber = NSNumber(value: false)
private let trueObjCType = String(cString: trueNumber.objCType)
private let falseObjCType = String(cString: falseNumber.objCType)

// MARK: - NSNumber: Comparable

extension NSNumber {
    var isBool:Bool {
        get {
            let objCType = String(cString: self.objCType)
            if (self.compare(trueNumber) == .orderedSame && objCType == trueObjCType) || (self.compare(falseNumber) == .orderedSame && objCType == falseObjCType){
                return true
            } else {
                return false
            }
        }
    }
}

func ==(lhs: NSNumber, rhs: NSNumber) -> Bool {
    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) == .orderedSame
    }
}

func !=(lhs: NSNumber, rhs: NSNumber) -> Bool {
    return !(lhs == rhs)
}

func <(lhs: NSNumber, rhs: NSNumber) -> Bool {
    
    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) == .orderedAscending
    }
}

func >(lhs: NSNumber, rhs: NSNumber) -> Bool {
    
    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) == ComparisonResult.orderedDescending
    }
}

func <=(lhs: NSNumber, rhs: NSNumber) -> Bool {
    
    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) != .orderedDescending
    }
}

func >=(lhs: NSNumber, rhs: NSNumber) -> Bool {
    
    switch (lhs.isBool, rhs.isBool) {
    case (false, true):
        return false
    case (true, false):
        return false
    default:
        return lhs.compare(rhs) != .orderedAscending
    }
}
