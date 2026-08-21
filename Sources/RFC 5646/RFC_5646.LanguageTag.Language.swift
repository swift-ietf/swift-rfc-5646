public import ISO_639

extension RFC_5646.LanguageTag {

    public enum Language: Sendable, Equatable, Hashable {

        case iso639(ISO_639.LanguageCode)

        case reserved(String)
    }
}

extension RFC_5646.LanguageTag.Language: CustomStringConvertible {
    public var description: String {
        switch self {
        case .iso639(let code):
            return code.description

        case .reserved(let code):
            return code
        }
    }
}
