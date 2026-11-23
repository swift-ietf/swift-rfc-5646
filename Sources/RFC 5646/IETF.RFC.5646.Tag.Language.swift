public import ISO_639

extension IETF.RFC.`5646`.Tag {

    public enum Language: Sendable, Equatable, Hashable {

        case iso639(ISO.`639`.LanguageCode)

        case reserved(String)
    }
}

extension IETF.RFC.`5646`.Tag.Language: CustomStringConvertible {
    public var description: String {
        switch self {
        case .iso639(let code):
            return code.description

        case .reserved(let code):
            return code
        }
    }
}
