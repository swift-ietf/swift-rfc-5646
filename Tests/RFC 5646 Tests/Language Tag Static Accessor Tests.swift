import Testing

@testable import RFC_5646

enum `Language Tag Static Accessor Tests` {}

extension `Language Tag Static Accessor Tests` {
    @Suite
    struct `A language tag named by its ISO 639-1 code` {
        @Test
        func `equals the tag parsed from the code`() throws {
            #expect(IETF.RFC.`5646`.LanguageTag.nl == (try IETF.RFC.`5646`.LanguageTag("nl")))
            #expect(IETF.RFC.`5646`.LanguageTag.en == (try IETF.RFC.`5646`.LanguageTag("en")))
            #expect(IETF.RFC.`5646`.LanguageTag.`is` == (try IETF.RFC.`5646`.LanguageTag("is")))
        }

        @Test
        func `reads by its member name where a tag is expected`() {
            let tags: [IETF.RFC.`5646`.LanguageTag] = [.nl, .en]
            #expect(tags.map(\.value) == ["nl", "en"])
        }
    }
}
