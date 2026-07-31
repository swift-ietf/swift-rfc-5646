public import ISO_3166

extension RFC_5646.LanguageTag {
    /// Region subtag (ISO 3166 alpha-2 or numeric)
    public enum Region: Sendable, Equatable, Hashable {
        /// 2-letter ISO 3166-1 alpha-2 code
        case alpha2(ISO_3166.Alpha2)

        /// 3-digit ISO 3166-1 numeric code (or UN M.49 code)
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
