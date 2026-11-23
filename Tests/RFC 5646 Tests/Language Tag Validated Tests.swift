import ISO_3166
import ISO_639
import Testing

@testable import RFC_5646

enum `Language Tag Validated Tests` {}

extension `Language Tag Validated Tests` {
    @Suite
    struct `Language tag from validated subtags` {
        @Test
        func `a language alone equals the parsed tag`() throws {
            #expect(IETF.RFC.`5646`.Tag(language: ISO.`639`.Alpha2.ab) == (try IETF.RFC.`5646`.Tag("ab")))
        }

        @Test
        func `a language with a region equals the parsed tag`() throws {
            #expect(IETF.RFC.`5646`.Tag(language: ISO.`639`.Alpha2.en, region: ISO.`3166`.Alpha2.au) == (try IETF.RFC.`5646`.Tag("en-AU")))
        }

        @Test
        func `a reserved language equals the parsed tag`() throws {
            #expect(IETF.RFC.`5646`.Tag(language: .reserved("bh")) == (try IETF.RFC.`5646`.Tag("bh")))
        }
    }
}
