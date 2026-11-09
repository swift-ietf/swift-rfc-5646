extension RFC_5646.LanguageTag.Region {

    public struct Area: Sendable, Equatable, Hashable {

        public let value: String

        public init(_ value: some StringProtocol) throws(RFC_5646.Error) {
            let code = String(value)
            guard Self.codes.contains(code) else {
                throw RFC_5646.Error.invalidRegionSubtag(code)
            }
            self.value = code
        }
    }
}

extension RFC_5646.LanguageTag.Region.Area {

    static let codes: Set<String> = [
        "001", "002", "003", "005", "009", "011", "013", "014", "015", "017",
        "018", "019", "021", "029", "030", "034", "035", "039", "053", "054",
        "057", "061", "142", "143", "145", "150", "151", "154", "155", "202",
        "419",
    ]
}

extension RFC_5646.LanguageTag.Region.Area: CustomStringConvertible {
    public var description: String { value }
}
