public import ISO_639

extension RFC_5646.LanguageTag {
    /// Language subtag per RFC 5646
    ///
    /// RFC 5646 allows 2-8 letter language subtags:
    /// - 2-3 letters: ISO 639 codes (most common)
    /// - 4-8 letters: Reserved ranges (rare)
    public enum Language: Sendable, Equatable, Hashable {
        /// ISO 639 language code (2-3 letters)
        case iso639(ISO_639.LanguageCode)

        /// Reserved language code (4-8 letters, not in ISO 639)
        /// Used for private use ranges like "qaa"-"qtz" or registered extensions
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
