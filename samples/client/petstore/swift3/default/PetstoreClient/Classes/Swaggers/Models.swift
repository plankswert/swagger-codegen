// Models.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return source.int32Value as! T;
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.int64Value as! T;
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        } 

        // Decoder for [AdditionalPropertiesClass]
        Decoders.addDecoder(clazz: [AdditionalPropertiesClass].self) { (source: AnyObject) -> [AdditionalPropertiesClass] in
            return Decoders.decode(clazz: [AdditionalPropertiesClass].self, source: source)
        }
        // Decoder for AdditionalPropertiesClass
        Decoders.addDecoder(clazz: AdditionalPropertiesClass.self) { (source: AnyObject) -> AdditionalPropertiesClass in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = AdditionalPropertiesClass()
            instance.mapProperty = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map_property"] as AnyObject?)
            instance.mapOfMapProperty = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map_of_map_property"] as AnyObject?)
            return instance
        }


        // Decoder for [Animal]
        Decoders.addDecoder(clazz: [Animal].self) { (source: AnyObject) -> [Animal] in
            return Decoders.decode(clazz: [Animal].self, source: source)
        }
        // Decoder for Animal
        Decoders.addDecoder(clazz: Animal.self) { (source: AnyObject) -> Animal in
            let sourceDictionary = source as! [AnyHashable: Any]
            // Check discriminator to support inheritance
            if let discriminator = sourceDictionary["className"] as? String, discriminator != "Animal"{
                return Decoders.decode(clazz: Animal.self, discriminator: discriminator, source: source)
            }

            let instance = Animal()
            instance.className = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?)
            instance.color = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["color"] as AnyObject?)
            return instance
        }


        // Decoder for [AnimalFarm]
        Decoders.addDecoder(clazz: [AnimalFarm].self) { (source: AnyObject) -> [AnimalFarm] in
            return Decoders.decode(clazz: [AnimalFarm].self, source: source)
        }
        // Decoder for AnimalFarm
        Decoders.addDecoder(clazz: AnimalFarm.self) { (source: AnyObject) -> AnimalFarm in
            let sourceArray = source as! [AnyObject]
            return sourceArray.map({ Decoders.decode(clazz: Animal.self, source: $0) })
        }


        // Decoder for [ApiResponse]
        Decoders.addDecoder(clazz: [ApiResponse].self) { (source: AnyObject) -> [ApiResponse] in
            return Decoders.decode(clazz: [ApiResponse].self, source: source)
        }
        // Decoder for ApiResponse
        Decoders.addDecoder(clazz: ApiResponse.self) { (source: AnyObject) -> ApiResponse in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ApiResponse()
            instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"] as AnyObject?)
            instance.type = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?)
            instance.message = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["message"] as AnyObject?)
            return instance
        }


        // Decoder for [ArrayOfArrayOfNumberOnly]
        Decoders.addDecoder(clazz: [ArrayOfArrayOfNumberOnly].self) { (source: AnyObject) -> [ArrayOfArrayOfNumberOnly] in
            return Decoders.decode(clazz: [ArrayOfArrayOfNumberOnly].self, source: source)
        }
        // Decoder for ArrayOfArrayOfNumberOnly
        Decoders.addDecoder(clazz: ArrayOfArrayOfNumberOnly.self) { (source: AnyObject) -> ArrayOfArrayOfNumberOnly in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ArrayOfArrayOfNumberOnly()
            instance.arrayArrayNumber = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["ArrayArrayNumber"] as AnyObject?)
            return instance
        }


        // Decoder for [ArrayOfNumberOnly]
        Decoders.addDecoder(clazz: [ArrayOfNumberOnly].self) { (source: AnyObject) -> [ArrayOfNumberOnly] in
            return Decoders.decode(clazz: [ArrayOfNumberOnly].self, source: source)
        }
        // Decoder for ArrayOfNumberOnly
        Decoders.addDecoder(clazz: ArrayOfNumberOnly.self) { (source: AnyObject) -> ArrayOfNumberOnly in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ArrayOfNumberOnly()
            instance.arrayNumber = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["ArrayNumber"] as AnyObject?)
            return instance
        }


        // Decoder for [ArrayTest]
        Decoders.addDecoder(clazz: [ArrayTest].self) { (source: AnyObject) -> [ArrayTest] in
            return Decoders.decode(clazz: [ArrayTest].self, source: source)
        }
        // Decoder for ArrayTest
        Decoders.addDecoder(clazz: ArrayTest.self) { (source: AnyObject) -> ArrayTest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ArrayTest()
            instance.arrayOfString = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["array_of_string"] as AnyObject?)
            instance.arrayArrayOfInteger = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["array_array_of_integer"] as AnyObject?)
            instance.arrayArrayOfModel = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["array_array_of_model"] as AnyObject?)
            return instance
        }


        // Decoder for [Cat]
        Decoders.addDecoder(clazz: [Cat].self) { (source: AnyObject) -> [Cat] in
            return Decoders.decode(clazz: [Cat].self, source: source)
        }
        // Decoder for Cat
        Decoders.addDecoder(clazz: Cat.self) { (source: AnyObject) -> Cat in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Cat()
            instance.className = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?)
            instance.color = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["color"] as AnyObject?)
            instance.declawed = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["declawed"] as AnyObject?)
            return instance
        }


        // Decoder for [Category]
        Decoders.addDecoder(clazz: [Category].self) { (source: AnyObject) -> [Category] in
            return Decoders.decode(clazz: [Category].self, source: source)
        }
        // Decoder for Category
        Decoders.addDecoder(clazz: Category.self) { (source: AnyObject) -> Category in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Category()
            instance.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            return instance
        }


        // Decoder for [Client]
        Decoders.addDecoder(clazz: [Client].self) { (source: AnyObject) -> [Client] in
            return Decoders.decode(clazz: [Client].self, source: source)
        }
        // Decoder for Client
        Decoders.addDecoder(clazz: Client.self) { (source: AnyObject) -> Client in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Client()
            instance.client = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["client"] as AnyObject?)
            return instance
        }


        // Decoder for [Dog]
        Decoders.addDecoder(clazz: [Dog].self) { (source: AnyObject) -> [Dog] in
            return Decoders.decode(clazz: [Dog].self, source: source)
        }
        // Decoder for Dog
        Decoders.addDecoder(clazz: Dog.self) { (source: AnyObject) -> Dog in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Dog()
            instance.className = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?)
            instance.color = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["color"] as AnyObject?)
            instance.breed = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["breed"] as AnyObject?)
            return instance
        }


        // Decoder for [EnumArrays]
        Decoders.addDecoder(clazz: [EnumArrays].self) { (source: AnyObject) -> [EnumArrays] in
            return Decoders.decode(clazz: [EnumArrays].self, source: source)
        }
        // Decoder for EnumArrays
        Decoders.addDecoder(clazz: EnumArrays.self) { (source: AnyObject) -> EnumArrays in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = EnumArrays()
            if let justSymbol = sourceDictionary["just_symbol"] as? String { 
                instance.justSymbol = EnumArrays.JustSymbol(rawValue: (justSymbol))
            }
            
            if let arrayEnum = sourceDictionary["array_enum"] as? [String] { 
                instance.arrayEnum  = arrayEnum.map ({ EnumArrays.ArrayEnum(rawValue: $0)! })
            }
            
            return instance
        }


        // Decoder for [EnumClass]
        Decoders.addDecoder(clazz: [EnumClass].self) { (source: AnyObject) -> [EnumClass] in
            return Decoders.decode(clazz: [EnumClass].self, source: source)
        }
        // Decoder for EnumClass
        Decoders.addDecoder(clazz: EnumClass.self) { (source: AnyObject) -> EnumClass in
            if let source = source as? String {
                if let result = EnumClass(rawValue: source) {
                    return result
                }
            }
            fatalError("Source \(source) is not convertible to enum type EnumClass: Maybe swagger file is insufficient")
        }


        // Decoder for [EnumTest]
        Decoders.addDecoder(clazz: [EnumTest].self) { (source: AnyObject) -> [EnumTest] in
            return Decoders.decode(clazz: [EnumTest].self, source: source)
        }
        // Decoder for EnumTest
        Decoders.addDecoder(clazz: EnumTest.self) { (source: AnyObject) -> EnumTest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = EnumTest()
            if let enumString = sourceDictionary["enum_string"] as? String { 
                instance.enumString = EnumTest.EnumString(rawValue: (enumString))
            }
            
            if let enumInteger = sourceDictionary["enum_integer"] as? Int32 { 
                instance.enumInteger = EnumTest.EnumInteger(rawValue: (enumInteger))
            }
            
            if let enumNumber = sourceDictionary["enum_number"] as? Double { 
                instance.enumNumber = EnumTest.EnumNumber(rawValue: (enumNumber))
            }
            
            return instance
        }


        // Decoder for [FormatTest]
        Decoders.addDecoder(clazz: [FormatTest].self) { (source: AnyObject) -> [FormatTest] in
            return Decoders.decode(clazz: [FormatTest].self, source: source)
        }
        // Decoder for FormatTest
        Decoders.addDecoder(clazz: FormatTest.self) { (source: AnyObject) -> FormatTest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = FormatTest()
            instance.integer = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["integer"] as AnyObject?)
            instance.int32 = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["int32"] as AnyObject?)
            instance.int64 = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["int64"] as AnyObject?)
            instance.number = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["number"] as AnyObject?)
            instance.float = Decoders.decodeOptional(clazz: Float.self, source: sourceDictionary["float"] as AnyObject?)
            instance.double = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["double"] as AnyObject?)
            instance.string = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["string"] as AnyObject?)
            instance.byte = Decoders.decodeOptional(clazz: Data.self, source: sourceDictionary["byte"] as AnyObject?)
            instance.binary = Decoders.decodeOptional(clazz: Data.self, source: sourceDictionary["binary"] as AnyObject?)
            instance.date = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["date"] as AnyObject?)
            instance.dateTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["dateTime"] as AnyObject?)
            instance.uuid = Decoders.decodeOptional(clazz: UUID.self, source: sourceDictionary["uuid"] as AnyObject?)
            instance.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?)
            return instance
        }


        // Decoder for [HasOnlyReadOnly]
        Decoders.addDecoder(clazz: [HasOnlyReadOnly].self) { (source: AnyObject) -> [HasOnlyReadOnly] in
            return Decoders.decode(clazz: [HasOnlyReadOnly].self, source: source)
        }
        // Decoder for HasOnlyReadOnly
        Decoders.addDecoder(clazz: HasOnlyReadOnly.self) { (source: AnyObject) -> HasOnlyReadOnly in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = HasOnlyReadOnly()
            instance.bar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bar"] as AnyObject?)
            instance.foo = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["foo"] as AnyObject?)
            return instance
        }


        // Decoder for [List]
        Decoders.addDecoder(clazz: [List].self) { (source: AnyObject) -> [List] in
            return Decoders.decode(clazz: [List].self, source: source)
        }
        // Decoder for List
        Decoders.addDecoder(clazz: List.self) { (source: AnyObject) -> List in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = List()
            instance._123List = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["123-list"] as AnyObject?)
            return instance
        }


        // Decoder for [MapTest]
        Decoders.addDecoder(clazz: [MapTest].self) { (source: AnyObject) -> [MapTest] in
            return Decoders.decode(clazz: [MapTest].self, source: source)
        }
        // Decoder for MapTest
        Decoders.addDecoder(clazz: MapTest.self) { (source: AnyObject) -> MapTest in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = MapTest()
            instance.mapMapOfString = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map_map_of_string"] as AnyObject?)
            if let mapOfEnumString = sourceDictionary["map_of_enum_string"] as? [String:String] { //TODO: handle enum map scenario
            }
            
            return instance
        }


        // Decoder for [MixedPropertiesAndAdditionalPropertiesClass]
        Decoders.addDecoder(clazz: [MixedPropertiesAndAdditionalPropertiesClass].self) { (source: AnyObject) -> [MixedPropertiesAndAdditionalPropertiesClass] in
            return Decoders.decode(clazz: [MixedPropertiesAndAdditionalPropertiesClass].self, source: source)
        }
        // Decoder for MixedPropertiesAndAdditionalPropertiesClass
        Decoders.addDecoder(clazz: MixedPropertiesAndAdditionalPropertiesClass.self) { (source: AnyObject) -> MixedPropertiesAndAdditionalPropertiesClass in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = MixedPropertiesAndAdditionalPropertiesClass()
            instance.uuid = Decoders.decodeOptional(clazz: UUID.self, source: sourceDictionary["uuid"] as AnyObject?)
            instance.dateTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["dateTime"] as AnyObject?)
            instance.map = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map"] as AnyObject?)
            return instance
        }


        // Decoder for [Model200Response]
        Decoders.addDecoder(clazz: [Model200Response].self) { (source: AnyObject) -> [Model200Response] in
            return Decoders.decode(clazz: [Model200Response].self, source: source)
        }
        // Decoder for Model200Response
        Decoders.addDecoder(clazz: Model200Response.self) { (source: AnyObject) -> Model200Response in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Model200Response()
            instance.name = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["name"] as AnyObject?)
            instance._class = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["class"] as AnyObject?)
            return instance
        }


        // Decoder for [Name]
        Decoders.addDecoder(clazz: [Name].self) { (source: AnyObject) -> [Name] in
            return Decoders.decode(clazz: [Name].self, source: source)
        }
        // Decoder for Name
        Decoders.addDecoder(clazz: Name.self) { (source: AnyObject) -> Name in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Name()
            instance.name = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["name"] as AnyObject?)
            instance.snakeCase = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["snake_case"] as AnyObject?)
            instance.property = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["property"] as AnyObject?)
            instance._123Number = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["123Number"] as AnyObject?)
            return instance
        }


        // Decoder for [NumberOnly]
        Decoders.addDecoder(clazz: [NumberOnly].self) { (source: AnyObject) -> [NumberOnly] in
            return Decoders.decode(clazz: [NumberOnly].self, source: source)
        }
        // Decoder for NumberOnly
        Decoders.addDecoder(clazz: NumberOnly.self) { (source: AnyObject) -> NumberOnly in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = NumberOnly()
            instance.justNumber = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["JustNumber"] as AnyObject?)
            return instance
        }


        // Decoder for [Order]
        Decoders.addDecoder(clazz: [Order].self) { (source: AnyObject) -> [Order] in
            return Decoders.decode(clazz: [Order].self, source: source)
        }
        // Decoder for Order
        Decoders.addDecoder(clazz: Order.self) { (source: AnyObject) -> Order in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Order()
            instance.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            instance.petId = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["petId"] as AnyObject?)
            instance.quantity = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["quantity"] as AnyObject?)
            instance.shipDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["shipDate"] as AnyObject?)
            if let status = sourceDictionary["status"] as? String { 
                instance.status = Order.Status(rawValue: (status))
            }
            
            instance.complete = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["complete"] as AnyObject?)
            return instance
        }


        // Decoder for [Pet]
        Decoders.addDecoder(clazz: [Pet].self) { (source: AnyObject) -> [Pet] in
            return Decoders.decode(clazz: [Pet].self, source: source)
        }
        // Decoder for Pet
        Decoders.addDecoder(clazz: Pet.self) { (source: AnyObject) -> Pet in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Pet()
            instance.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            instance.category = Decoders.decodeOptional(clazz: Category.self, source: sourceDictionary["category"] as AnyObject?)
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            instance.photoUrls = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["photoUrls"] as AnyObject?)
            instance.tags = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["tags"] as AnyObject?)
            if let status = sourceDictionary["status"] as? String { 
                instance.status = Pet.Status(rawValue: (status))
            }
            
            return instance
        }


        // Decoder for [ReadOnlyFirst]
        Decoders.addDecoder(clazz: [ReadOnlyFirst].self) { (source: AnyObject) -> [ReadOnlyFirst] in
            return Decoders.decode(clazz: [ReadOnlyFirst].self, source: source)
        }
        // Decoder for ReadOnlyFirst
        Decoders.addDecoder(clazz: ReadOnlyFirst.self) { (source: AnyObject) -> ReadOnlyFirst in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ReadOnlyFirst()
            instance.bar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bar"] as AnyObject?)
            instance.baz = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["baz"] as AnyObject?)
            return instance
        }


        // Decoder for [Return]
        Decoders.addDecoder(clazz: [Return].self) { (source: AnyObject) -> [Return] in
            return Decoders.decode(clazz: [Return].self, source: source)
        }
        // Decoder for Return
        Decoders.addDecoder(clazz: Return.self) { (source: AnyObject) -> Return in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Return()
            instance._return = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["return"] as AnyObject?)
            return instance
        }


        // Decoder for [SpecialModelName]
        Decoders.addDecoder(clazz: [SpecialModelName].self) { (source: AnyObject) -> [SpecialModelName] in
            return Decoders.decode(clazz: [SpecialModelName].self, source: source)
        }
        // Decoder for SpecialModelName
        Decoders.addDecoder(clazz: SpecialModelName.self) { (source: AnyObject) -> SpecialModelName in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = SpecialModelName()
            instance.specialPropertyName = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["$special[property.name]"] as AnyObject?)
            return instance
        }


        // Decoder for [Tag]
        Decoders.addDecoder(clazz: [Tag].self) { (source: AnyObject) -> [Tag] in
            return Decoders.decode(clazz: [Tag].self, source: source)
        }
        // Decoder for Tag
        Decoders.addDecoder(clazz: Tag.self) { (source: AnyObject) -> Tag in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Tag()
            instance.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            return instance
        }


        // Decoder for [User]
        Decoders.addDecoder(clazz: [User].self) { (source: AnyObject) -> [User] in
            return Decoders.decode(clazz: [User].self, source: source)
        }
        // Decoder for User
        Decoders.addDecoder(clazz: User.self) { (source: AnyObject) -> User in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = User()
            instance.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            instance.username = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?)
            instance.firstName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.email = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["email"] as AnyObject?)
            instance.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?)
            instance.phone = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["phone"] as AnyObject?)
            instance.userStatus = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["userStatus"] as AnyObject?)
            return instance
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}
