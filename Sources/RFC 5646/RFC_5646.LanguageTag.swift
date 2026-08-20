// RFC_5646.LanguageTag.swift
// RFC 5646
//
// Language tag type per RFC 5646

import ASCII_Primitives
public import ISO_15924
import ISO_3166
import ISO_639
import Standard_Library_Extensions

extension RFC_5646 {
    /// Language tag per RFC 5646 (RFC 5646)
    ///
    /// A refined type representing a well-formed RFC 5646 language tag.
    ///
    /// ## Structure
    ///
    /// Language tags consist of subtags separated by hyphens in this order:
    /// 1. **language** (required): 2-3 letter ISO 639 code
    /// 2. **script** (optional): 4-letter ISO 15924 code
    /// 3. **region** (optional): 2-letter ISO 3166 or 3-digit code
    /// 4. **variant** (optional): Registered variant subtags
    /// 5. **extension** (optional): Single character + subtags
    /// 6. **privateuse** (optional): "x-" followed by subtags
    ///
    /// ## Normalization
    ///
    /// Tags are normalized to canonical case:
    /// - Language: lowercase ("en")
    /// - Script: Titlecase ("Latn")
    /// - Region: UPPERCASE ("US")
    ///
    /// ## Examples
    ///
    /// ```swift
    /// let en = try LanguageTag("en")                    // English
    /// let enUS = try LanguageTag("en-US")              // English (United States)
    /// let zhHans = try LanguageTag("zh-Hans")          // Chinese (Simplified)
    /// let zhHansCN = try LanguageTag("zh-Hans-CN")     // Chinese (Simplified, China)
    /// let srLatnRS = try LanguageTag("sr-Latn-RS")     // Serbian (Latin, Serbia)
    /// ```
    public struct LanguageTag: Sendable, Equatable, Hashable {
        /// The canonical language tag string
        public let value: String

        /// Primary language subtag
        ///
        /// Either an ISO 639 code (2-3 letters) or a reserved code (4-8 letters)
        public let language: Language

        /// Script subtag (ISO 15924), if present
        public let script: ISO_15924.Alpha4?

        /// Region subtag (ISO 3166), if present
        public let region: Region?

        /// Variant subtags, if present
        public let variants: [String]

        /// Extension subtags, if present
        public let extensions: [Extension]

        /// Private use subtags, if present
        public let privateUse: [String]

        /// Creates a language tag from a string (partial function)
        ///
        /// Validates and normalizes the tag according to RFC 5646 rules.
        ///
        /// - Parameter value: Language tag string (for example, "en-US")
        /// - Throws: `RFC_5646.Error` if invalid
        public init(_ value: some StringProtocol) throws(RFC_5646.Error) {
            let trimmed = String(value.trimming(where: { $0 == " " || $0 == "\t" }))
            guard !trimmed.isEmpty else {
                throw RFC_5646.Error.emptyTag
            }

            // Split into subtags at byte level
            let subtags: [String] = {
                let bytes = Array(trimmed.utf8)
                var result: [String] = []
                var start = 0
                bytes.indices.forEach { idx in
                    if bytes[idx] == 0x2D {  // '-'
                        result.append(String(decoding: bytes[start..<idx], as: UTF8.self))
                        start = idx &+ 1
                    }
                }
                result.append(String(decoding: bytes[start..<bytes.count], as: UTF8.self))
                return result
            }()
            guard !subtags.isEmpty else {
                throw RFC_5646.Error.emptyTag
            }

            var index = 0

            // Parse language (required)
            guard index < subtags.count else {
                throw RFC_5646.Error.missingLanguageSubtag
            }
            let languageSubtag = try Self.parseLanguage(subtags[index])
            index += 1

            // Parse script (optional)
            var scriptSubtag: ISO_15924.Alpha4?
            if index < subtags.count, Self.looksLikeScript(subtags[index]) {
                scriptSubtag = try Self.parseScript(subtags[index])
                index += 1
            }

            // Parse region (optional)
            var regionSubtag: Region?
            if index < subtags.count, Self.looksLikeRegion(subtags[index]) {
                regionSubtag = try Self.parseRegion(subtags[index])
                index += 1
            }

            // Parse variants (optional, multiple allowed)
            var variantSubtags: [String] = []
            while index < subtags.count, Self.isVariant(subtags[index]) {
                let variant = try Self.parseVariant(subtags[index])
                // Check for duplicates
                if variantSubtags.contains(variant) {
                    throw RFC_5646.Error.duplicateVariant(variant)
                }
                variantSubtags.append(variant)
                index += 1
            }

            // Parse extensions (optional, multiple allowed)
            var extensionSubtags: [Extension] = []
            var seenSingletons = Set<Character>()
            while index < subtags.count, Self.isExtensionSingleton(subtags[index]) {
                guard let singleton = subtags[index].lowercased().first else {
                    throw RFC_5646.Error.invalidExtension(subtags[index])
                }

                // Check for duplicate singleton
                if seenSingletons.contains(singleton) {
                    throw RFC_5646.Error.duplicateExtensionSingleton(singleton)
                }
                seenSingletons.insert(singleton)

                index += 1
                var extensionValues: [String] = []

                // Collect extension values until next singleton or end
                while index < subtags.count,
                    !Self.isExtensionSingleton(subtags[index]),
                    !Self.isPrivateUseSingleton(subtags[index])
                {
                    extensionValues.append(subtags[index])
                    index += 1
                }

                // Extensions must have at least one value
                guard !extensionValues.isEmpty else {
                    throw RFC_5646.Error.invalidExtension(String(singleton))
                }

                extensionSubtags.append(Extension(singleton: singleton, values: extensionValues))
            }

            // Parse private use (optional)
            var privateUseSubtags: [String] = []
            if index < subtags.count, Self.isPrivateUseSingleton(subtags[index]) {
                index += 1  // skip 'x'
                while index < subtags.count {
                    privateUseSubtags.append(subtags[index])
                    index += 1
                }
            }

            // Ensure all subtags were consumed
            guard index == subtags.count else {
                throw RFC_5646.Error.invalidSubtagOrder(String(value))
            }

            // Build canonical form
            var canonical = languageSubtag.description
            if let script = scriptSubtag {
                canonical += "-\(script.value)"
            }
            if let region = regionSubtag {
                // RFC 5646 convention: regions are uppercase
                canonical += "-\(region.description.uppercased())"
            }
            for variant in variantSubtags {
                canonical += "-\(variant)"
            }
            for ext in extensionSubtags {
                canonical += "-\(ext.singleton)"
                for val in ext.values {
                    canonical += "-\(val)"
                }
            }
            if !privateUseSubtags.isEmpty {
                canonical += "-x"
                for val in privateUseSubtags {
                    canonical += "-\(val)"
                }
            }

            self.value = canonical
            self.language = languageSubtag
            self.script = scriptSubtag
            self.region = regionSubtag
            self.variants = variantSubtags
            self.extensions = extensionSubtags
            self.privateUse = privateUseSubtags
        }
    }
}

// MARK: - Parsing Helpers

extension RFC_5646.LanguageTag {
    /// Parses and validates language subtag
    private static func parseLanguage(_ subtag: String) throws(RFC_5646.Error) -> Language {
        let normalized = subtag.lowercased()

        // Must be 2-8 ASCII letters
        guard normalized.count >= 2, normalized.count <= 8 else {
            throw RFC_5646.Error.invalidLanguageSubtag(subtag)
        }

        guard normalized.allSatisfy({ $0.ascii.isLetter }) else {
            throw RFC_5646.Error.invalidCharacters(subtag)
        }

        // Try to parse as ISO 639 code (2-3 letters)
        if normalized.count == 2 || normalized.count == 3 {
            do throws(ISO_639.Error) {
                let iso639Code = try ISO_639.LanguageCode(normalized)
                return .iso639(iso639Code)
            } catch {
                // Fall through to reserved code handling
            }
        }

        // 4-8 letters or invalid ISO 639 code: treat as reserved
        return .reserved(normalized)
    }

    /// Parses and validates script subtag
    private static func parseScript(_ subtag: String) throws(RFC_5646.Error) -> ISO_15924.Alpha4 {
        do throws(ISO_15924.Alpha4.Error) {
            return try ISO_15924.Alpha4(subtag)
        } catch {
            throw RFC_5646.Error.invalidScriptSubtag(subtag)
        }
    }

    /// Parses and validates region subtag
    private static func parseRegion(_ subtag: String) throws(RFC_5646.Error) -> Region {
        // Try alpha-2 first
        if subtag.count == 2 {
            do throws(ISO_3166.Alpha2.Error) {
                let alpha2 = try ISO_3166.Alpha2(subtag)
                return .alpha2(alpha2)
            } catch {
                throw RFC_5646.Error.invalidRegionSubtag(subtag)
            }
        }

        // Try numeric
        if subtag.count == 3 {
            do throws(ISO_3166.Numeric.Error) {
                let numeric = try ISO_3166.Numeric(subtag)
                return .numeric(numeric)
            } catch {
                throw RFC_5646.Error.invalidRegionSubtag(subtag)
            }
        }

        throw RFC_5646.Error.invalidRegionSubtag(subtag)
    }

    /// Parses and validates variant subtag
    private static func parseVariant(_ subtag: String) throws(RFC_5646.Error) -> String {
        let normalized = subtag.lowercased()

        // Variant must be 5-8 alphanumeric starting with letter,
        // or 4-8 alphanumeric starting with digit
        let startsWithDigit = normalized.first?.ascii.isDigit ?? false
        let minLength = startsWithDigit ? 4 : 5
        let maxLength = 8

        guard normalized.count >= minLength, normalized.count <= maxLength else {
            throw RFC_5646.Error.invalidSubtagLength(
                subtag,
                expected: "\(minLength)-\(maxLength) characters"
            )
        }

        guard normalized.allSatisfy({ $0.isASCII && ($0.isLetter || $0.isNumber) }) else {
            throw RFC_5646.Error.invalidCharacters(subtag)
        }

        return normalized
    }

    /// Checks if subtag looks like a script (4 ASCII letters)
    /// This is a structural check only - validation happens in parseScript
    private static func looksLikeScript(_ subtag: String) -> Bool {
        subtag.count == 4 && subtag.allSatisfy { $0.ascii.isLetter }
    }

    /// Checks if subtag looks like a region (2 ASCII letters or 3 digits)
    /// This is a structural check only - validation happens in parseRegion
    private static func looksLikeRegion(_ subtag: String) -> Bool {
        (subtag.count == 2 && subtag.allSatisfy { $0.ascii.isLetter })
            || (subtag.count == 3 && subtag.allSatisfy { $0.ascii.isDigit })
    }

    /// Checks if subtag is a variant
    private static func isVariant(_ subtag: String) -> Bool {
        let startsWithDigit = subtag.first?.ascii.isDigit ?? false
        let minLength = startsWithDigit ? 4 : 5
        return subtag.count >= minLength && subtag.count <= 8
            && subtag.allSatisfy { $0.isASCII && ($0.isLetter || $0.isNumber) }
    }

    /// Checks if subtag is an extension singleton (single char, not 'x')
    private static func isExtensionSingleton(_ subtag: String) -> Bool {
        subtag.count == 1 && subtag.lowercased() != "x" && (subtag.first?.isASCII ?? false)
            && (subtag.first?.isLetter ?? false || subtag.first?.isNumber ?? false)
    }

    /// Checks if subtag is private use singleton ('x')
    private static func isPrivateUseSingleton(_ subtag: String) -> Bool {
        subtag.lowercased() == "x"
    }
}

// MARK: - String Representation

extension RFC_5646.LanguageTag: CustomStringConvertible {
    public var description: String { value }
}

// MARK: - Codable

extension RFC_5646.LanguageTag: Codable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string)
    }
}
