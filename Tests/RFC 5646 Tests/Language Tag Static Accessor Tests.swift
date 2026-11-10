import Testing

@testable import RFC_5646

enum `Language Tag Static Accessor Tests` {}

extension `Language Tag Static Accessor Tests` {
    @Suite
    struct `A language tag named by its ISO 639-1 code` {
        @Test
        func `equals the tag parsed from the code`() throws {
            #expect(RFC_5646.LanguageTag.nl == (try RFC_5646.LanguageTag("nl")))
            #expect(RFC_5646.LanguageTag.en == (try RFC_5646.LanguageTag("en")))
            #expect(RFC_5646.LanguageTag.`is` == (try RFC_5646.LanguageTag("is")))
        }

        @Test
        func `reads by its member name where a tag is expected`() {
            let tags: [RFC_5646.LanguageTag] = [.nl, .en]
            #expect(tags.map(\.value) == ["nl", "en"])
        }
    }
}
