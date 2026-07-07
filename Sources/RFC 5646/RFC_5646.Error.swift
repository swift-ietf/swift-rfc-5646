// RFC_5646.Error.swift
// RFC 5646
//
// Error types for RFC 5646 validation

import Standard_Library_Extensions

extension RFC_5646 {
    /// Errors that can occur when parsing or validating RFC 5646 language tags
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Tag is empty or contains only whitespace
        case emptyTag

        /// Language subtag is missing (required)
        case missingLanguageSubtag

        /// Language subtag is invalid
        case invalidLanguageSubtag(String)

        /// Script subtag is invalid (must be 4 ASCII letters)
        case invalidScriptSubtag(String)

        /// Region subtag is invalid (must be 2 ASCII letters or 3 digits)
        case invalidRegionSubtag(String)

        /// Variant subtag is invalid
        case invalidVariantSubtag(String)

        /// Duplicate variant subtag
        case duplicateVariant(String)

        /// Extension singleton is invalid or repeated
        case invalidExtension(String)

        /// Duplicate extension singleton
        case duplicateExtensionSingleton(Character)

        /// Private use subtag is invalid
        case invalidPrivateUse(String)

        /// Subtags are not in the correct order per RFC 5646
        case invalidSubtagOrder(String)

        /// Subtag contains invalid characters
        case invalidCharacters(String)

        /// Subtag length is invalid
        case invalidSubtagLength(String, expected: String)
    }
}
