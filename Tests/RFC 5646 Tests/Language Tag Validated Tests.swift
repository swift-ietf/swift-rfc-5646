import ISO_3166
import ISO_639
import Testing

@testable import RFC_5646

@Suite
struct `Language tag from validated subtags` {
    @Test
    func `a language alone equals the parsed tag`() throws {
        #expect(RFC_5646.LanguageTag(language: ISO_639.Alpha2.ab) == (try RFC_5646.LanguageTag("ab")))
    }

    @Test
    func `a language with a region equals the parsed tag`() throws {
        #expect(RFC_5646.LanguageTag(language: ISO_639.Alpha2.en, region: ISO_3166.Alpha2.au) == (try RFC_5646.LanguageTag("en-AU")))
    }

    @Test
    func `a reserved language equals the parsed tag`() throws {
        #expect(RFC_5646.LanguageTag(language: .reserved("bh")) == (try RFC_5646.LanguageTag("bh")))
    }
}
