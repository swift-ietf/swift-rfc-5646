import Testing

@testable import RFC_5646

@Suite
struct `Language tag ASCII input` {
    @Test(arguments: ["\u{212A}o", "en-GB-ro\u{212A}aj", "\u{212A}O-KR"])
    func `a Kelvin sign that lowercases to k is refused`(_ text: String) {
        #expect(throws: RFC_5646.Error.self) {
            try RFC_5646.LanguageTag(text)
        }
    }

    @Test
    func `ASCII tags in any case still parse`() throws {
        _ = try RFC_5646.LanguageTag("KO-kr")
        _ = try RFC_5646.LanguageTag("en-GB-rokaj")
    }
}
