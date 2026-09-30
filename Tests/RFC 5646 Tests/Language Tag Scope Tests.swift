import Testing

@testable import RFC_5646

@Suite
struct `Language tag scope` {
    @Test(arguments: ["x-whatever", "x-a-b", "i-klingon", "en-GB-oed"])
    func `only langtag is supported, so private-use-only and irregular grandfathered tags are refused`(_ text: String) {
        #expect(throws: RFC_5646.Error.self) {
            try RFC_5646.LanguageTag(text)
        }
    }

    @Test
    func `a langtag with a private-use suffix is supported`() throws {
        #expect(try RFC_5646.LanguageTag("en-x-whatever").language == RFC_5646.LanguageTag("en").language)
    }
}
