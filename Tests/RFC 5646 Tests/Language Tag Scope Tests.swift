import Testing

@testable import RFC_5646

enum `Language Tag Scope Tests` {}

extension `Language Tag Scope Tests` {
    @Suite
    struct `Language tag scope` {
        @Test(arguments: ["x-whatever", "x-a-b", "i-klingon", "en-GB-oed"])
        func `only langtag is supported, so private-use-only and irregular grandfathered tags are refused`(_ text: String) {
            #expect(throws: IETF.RFC.`5646`.Error.self) {
                try IETF.RFC.`5646`.Tag(text)
            }
        }

        @Test
        func `a langtag with a private-use suffix is supported`() throws {
            #expect(try IETF.RFC.`5646`.Tag("en-x-whatever").language == IETF.RFC.`5646`.Tag("en").language)
        }
    }
}
