public import ISO_3166

extension RFC_5646.LanguageTag {

    public enum Region: Sendable, Equatable, Hashable {

        case alpha2(ISO_3166.Alpha2)

        case numeric(ISO_3166.Numeric)

        case area(Area)

        case reserved(String)
    }
}

extension RFC_5646.LanguageTag.Region: CustomStringConvertible {
    public var description: String {
        switch self {
        case .alpha2(let code):
            return code.value

        case .numeric(let code):
            return code.value

        case .area(let code):
            return code.value

        case .reserved(let code):
            return code
        }
    }
}

extension RFC_5646.LanguageTag.Region {

    static let reservedCodes: Set<String> = [
        "AC", "CP", "CQ", "DG", "EA", "EU", "EZ", "IC", "TA", "UN",
        "AN", "BU", "CS", "DD", "FX", "NT", "SU", "TP", "YD", "YU", "ZR",
        "AA", "ZZ",
    ]

    static func isReserved(_ code: String) -> Bool {
        guard code.count == 2, code.allSatisfy({ $0.isASCII && $0.isUppercase }) else {
            return false
        }
        if reservedCodes.contains(code) {
            return true
        }
        return code.first == "X" || (code.first == "Q" && code.last.map { $0 >= "M" } == true)
    }
}
