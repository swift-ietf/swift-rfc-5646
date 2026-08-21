import Standard_Library_Extensions

extension RFC_5646 {

    public enum Error: Swift.Error, Sendable, Equatable {

        case emptyTag

        case missingLanguageSubtag

        case invalidLanguageSubtag(String)

        case invalidScriptSubtag(String)

        case invalidRegionSubtag(String)

        case invalidVariantSubtag(String)

        case duplicateVariant(String)

        case invalidExtension(String)

        case duplicateExtensionSingleton(Character)

        case invalidPrivateUse(String)

        case invalidSubtagOrder(String)

        case invalidCharacters(String)

        case invalidSubtagLength(String, expected: String)
    }
}
