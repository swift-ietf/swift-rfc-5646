import ASCII_Primitives
public import ISO_15924
import ISO_3166
import ISO_639
import Standard_Library_Extensions

extension RFC_5646 {

    public struct LanguageTag: Sendable, Equatable, Hashable {

        public let value: String

        public let language: Language

        public let script: ISO_15924.Alpha4?

        public let region: Region?

        public let variants: [String]

        public let extensions: [Extension]

        public let privateUse: [String]

        public init(_ value: some StringProtocol) throws(RFC_5646.Error) {
            let trimmed = String(value.trimming(where: { $0 == " " || $0 == "\t" }))
            guard !trimmed.isEmpty else {
                throw RFC_5646.Error.emptyTag
            }

            let subtags: [String] = {
                let bytes = Array(trimmed.utf8)
                var result: [String] = []
                var start = 0
                bytes.indices.forEach { idx in
                    if bytes[idx] == 0x2D {
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

            guard index < subtags.count else {
                throw RFC_5646.Error.missingLanguageSubtag
            }
            let languageSubtag = try Self.parseLanguage(subtags[index])
            index += 1

            var scriptSubtag: ISO_15924.Alpha4?
            if index < subtags.count, Self.looksLikeScript(subtags[index]) {
                scriptSubtag = try Self.parseScript(subtags[index])
                index += 1
            }

            var regionSubtag: Region?
            if index < subtags.count, Self.looksLikeRegion(subtags[index]) {
                regionSubtag = try Self.parseRegion(subtags[index])
                index += 1
            }

            var variantSubtags: [String] = []
            while index < subtags.count, Self.isVariant(subtags[index]) {
                let variant = try Self.parseVariant(subtags[index])

                if variantSubtags.contains(variant) {
                    throw RFC_5646.Error.duplicateVariant(variant)
                }
                variantSubtags.append(variant)
                index += 1
            }

            var extensionSubtags: [Extension] = []
            var seenSingletons = Set<Character>()
            while index < subtags.count, Self.isExtensionSingleton(subtags[index]) {
                guard let singleton = subtags[index].lowercased().first else {
                    throw RFC_5646.Error.invalidExtension(subtags[index])
                }

                if seenSingletons.contains(singleton) {
                    throw RFC_5646.Error.duplicateExtensionSingleton(singleton)
                }
                seenSingletons.insert(singleton)

                index += 1
                var extensionValues: [String] = []

                while index < subtags.count,
                    !Self.isExtensionSingleton(subtags[index]),
                    !Self.isPrivateUseSingleton(subtags[index])
                {
                    extensionValues.append(subtags[index])
                    index += 1
                }

                guard !extensionValues.isEmpty else {
                    throw RFC_5646.Error.invalidExtension(String(singleton))
                }

                extensionSubtags.append(Extension(singleton: singleton, values: extensionValues))
            }

            var privateUseSubtags: [String] = []
            if index < subtags.count, Self.isPrivateUseSingleton(subtags[index]) {
                index += 1
                while index < subtags.count {
                    privateUseSubtags.append(subtags[index])
                    index += 1
                }
            }

            guard index == subtags.count else {
                throw RFC_5646.Error.invalidSubtagOrder(String(value))
            }

            var canonical = languageSubtag.description
            if let script = scriptSubtag {
                canonical += "-\(script.value)"
            }
            if let region = regionSubtag {

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

extension RFC_5646.LanguageTag {

    private static func parseLanguage(_ subtag: String) throws(RFC_5646.Error) -> Language {
        let normalized = subtag.lowercased()

        guard normalized.count >= 2, normalized.count <= 8 else {
            throw RFC_5646.Error.invalidLanguageSubtag(subtag)
        }

        guard normalized.allSatisfy({ $0.ascii.isLetter }) else {
            throw RFC_5646.Error.invalidCharacters(subtag)
        }

        if normalized.count == 2 || normalized.count == 3 {
            do throws(ISO_639.Error) {
                let iso639Code = try ISO_639.LanguageCode(normalized)
                return .iso639(iso639Code)
            } catch {

            }
        }

        return .reserved(normalized)
    }

    private static func parseScript(_ subtag: String) throws(RFC_5646.Error) -> ISO_15924.Alpha4 {
        do throws(ISO_15924.Alpha4.Error) {
            return try ISO_15924.Alpha4(subtag)
        } catch {
            throw RFC_5646.Error.invalidScriptSubtag(subtag)
        }
    }

    private static func parseRegion(_ subtag: String) throws(RFC_5646.Error) -> Region {

        if subtag.count == 2 {
            do throws(ISO_3166.Alpha2.Error) {
                let alpha2 = try ISO_3166.Alpha2(subtag)
                return .alpha2(alpha2)
            } catch {
                throw RFC_5646.Error.invalidRegionSubtag(subtag)
            }
        }

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

    private static func parseVariant(_ subtag: String) throws(RFC_5646.Error) -> String {
        let normalized = subtag.lowercased()

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

    private static func looksLikeScript(_ subtag: String) -> Bool {
        subtag.count == 4 && subtag.allSatisfy { $0.ascii.isLetter }
    }

    private static func looksLikeRegion(_ subtag: String) -> Bool {
        (subtag.count == 2 && subtag.allSatisfy { $0.ascii.isLetter })
            || (subtag.count == 3 && subtag.allSatisfy { $0.ascii.isDigit })
    }

    private static func isVariant(_ subtag: String) -> Bool {
        let startsWithDigit = subtag.first?.ascii.isDigit ?? false
        let minLength = startsWithDigit ? 4 : 5
        return subtag.count >= minLength && subtag.count <= 8
            && subtag.allSatisfy { $0.isASCII && ($0.isLetter || $0.isNumber) }
    }

    private static func isExtensionSingleton(_ subtag: String) -> Bool {
        subtag.count == 1 && subtag.lowercased() != "x" && (subtag.first?.isASCII ?? false)
            && (subtag.first?.isLetter ?? false || subtag.first?.isNumber ?? false)
    }

    private static func isPrivateUseSingleton(_ subtag: String) -> Bool {
        subtag.lowercased() == "x"
    }
}

extension RFC_5646.LanguageTag: CustomStringConvertible {
    public var description: String { value }
}

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
