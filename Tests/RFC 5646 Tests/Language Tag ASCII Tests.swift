import Testing

@testable import RFC_5646

enum `Language Tag ASCII Tests` {}

extension `Language Tag ASCII Tests` {
    @Suite
    struct `Language tag ASCII input` {
        @Test(arguments: ["\u{212A}o", "en-GB-ro\u{212A}aj", "\u{212A}O-KR"])
        func `a Kelvin sign that lowercases to k is refused`(_ text: String) {
            #expect(throws: IETF.RFC.`5646`.Error.self) {
                try IETF.RFC.`5646`.Tag(text)
            }
        }

        @Test
        func `ASCII tags in any case still parse`() throws {
            _ = try IETF.RFC.`5646`.Tag("KO-kr")
            _ = try IETF.RFC.`5646`.Tag("en-GB-rokaj")
        }
    }
}
