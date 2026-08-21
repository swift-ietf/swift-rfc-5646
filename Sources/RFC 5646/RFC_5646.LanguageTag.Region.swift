public import ISO_3166

extension RFC_5646.LanguageTag {

    public enum Region: Sendable, Equatable, Hashable {

        case alpha2(ISO_3166.Alpha2)

        case numeric(ISO_3166.Numeric)
    }
}

extension RFC_5646.LanguageTag.Region: CustomStringConvertible {
    public var description: String {
        switch self {
        case .alpha2(let code):
            return code.value

        case .numeric(let code):
            return code.value
        }
    }
}
