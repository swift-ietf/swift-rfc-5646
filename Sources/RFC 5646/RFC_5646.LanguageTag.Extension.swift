extension RFC_5646.LanguageTag {
    /// Extension subtag (singleton + values)
    public struct Extension: Sendable, Equatable, Hashable {
        /// Single character singleton (0-9, a-z except 'x')
        public let singleton: Character

        /// Extension values
        public let values: [String]
    }
}
