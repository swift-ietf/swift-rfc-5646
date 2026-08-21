extension RFC_5646.LanguageTag {

    public struct Extension: Sendable, Equatable, Hashable {

        public let singleton: Character

        public let values: [String]
    }
}
