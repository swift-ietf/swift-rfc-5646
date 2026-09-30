import Testing

@testable import RFC_5646

@Suite
struct `Language tag grammar boundaries` {
    @Test(arguments: [
        "en-", "-en", "en--US", "en-a", "en-x", "en-x-", "en-abcdefghi", "en-US-abc", "en-rozaj-ROZAJ", "en-a-bbb-a-ccc", "en-x-abcdefghi", "en-x-a!b",
    ])
    func `malformed tags are rejected`(_ tag: String) {
        #expect(throws: RFC_5646.Error.self) { try RFC_5646.LanguageTag(tag) }
    }

    @Test(arguments: ["en-1996", "de-CH-1901", "sl-rozaj-biske", "en-a-bbb-x-a-ccc", "en-Latn-US-valencia", "en-x-a-12345678"])
    func `well-formed edge tags are accepted`(_ tag: String) throws {
        _ = try RFC_5646.LanguageTag(tag)
    }
}
