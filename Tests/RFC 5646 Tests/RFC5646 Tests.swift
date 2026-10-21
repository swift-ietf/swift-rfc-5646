import Foundation
import ISO_15924
import ISO_3166
import ISO_639
import Testing

@testable import RFC_5646

@Suite("RFC 5646 Language Tags")
struct RFC5646Tests {
    @Suite
    struct Unit {

        @Test
        func `LanguageTag: Simple language codes`() throws {
            let en = try RFC_5646.LanguageTag("en")
            #expect(en.value == "en")
            #expect(en.language.description == "en")
            #expect(en.script == nil)
            #expect(en.region == nil)
            #expect(en.variants.isEmpty)
            #expect(en.extensions.isEmpty)
            #expect(en.privateUse.isEmpty)

            let fr = try RFC_5646.LanguageTag("fr")
            #expect(fr.language.description == "fr")

            let de = try RFC_5646.LanguageTag("de")
            #expect(de.language.description == "de")
        }

        @Test
        func `LanguageTag: Case normalization for language`() throws {
            let en1 = try RFC_5646.LanguageTag("en")
            let en2 = try RFC_5646.LanguageTag("EN")
            let en3 = try RFC_5646.LanguageTag("En")
            #expect(en1.language.description == "en")
            #expect(en2.language.description == "en")
            #expect(en3.language.description == "en")
            #expect(en1 == en2)
            #expect(en2 == en3)
        }

        @Test
        func `LanguageTag: Language with alpha-2 region`() throws {
            let enUS = try RFC_5646.LanguageTag("en-US")
            #expect(enUS.value == "en-US")
            #expect(enUS.language.description == "en")
            #expect(enUS.script == nil)
            #expect(enUS.region == .alpha2(try ISO_3166.Alpha2("US")))

            let frFR = try RFC_5646.LanguageTag("fr-FR")
            #expect(frFR.language.description == "fr")
            #expect(frFR.region == .alpha2(try ISO_3166.Alpha2("FR")))

            let deDE = try RFC_5646.LanguageTag("de-DE")
            #expect(deDE.language.description == "de")
            #expect(deDE.region == .alpha2(try ISO_3166.Alpha2("DE")))
        }

        @Test
        func `LanguageTag: Language with numeric region`() throws {
            let en840 = try RFC_5646.LanguageTag("en-840")
            #expect(en840.language.description == "en")
            #expect(en840.region == .numeric(try ISO_3166.Numeric("840")))
        }

        @Test
        func `LanguageTag: Case normalization for region`() throws {
            let enUS1 = try RFC_5646.LanguageTag("en-US")
            let enUS2 = try RFC_5646.LanguageTag("en-us")
            let enUS3 = try RFC_5646.LanguageTag("EN-us")
            #expect(enUS1.value == "en-US")
            #expect(enUS2.value == "en-US")
            #expect(enUS3.value == "en-US")
        }

        @Test
        func `LanguageTag: Language with script`() throws {
            let zhHans = try RFC_5646.LanguageTag("zh-Hans")
            #expect(zhHans.value == "zh-Hans")
            #expect(zhHans.language.description == "zh")
            #expect(zhHans.script == ISO_15924.Alpha4.Hans)
            #expect(zhHans.region == nil)

            let zhHant = try RFC_5646.LanguageTag("zh-Hant")
            #expect(zhHant.script == ISO_15924.Alpha4.Hant)

            let srCyrl = try RFC_5646.LanguageTag("sr-Cyrl")
            #expect(srCyrl.language.description == "sr")
            #expect(srCyrl.script == ISO_15924.Alpha4.Cyrl)
        }

        @Test
        func `LanguageTag: Case normalization for script`() throws {
            let zh1 = try RFC_5646.LanguageTag("zh-Hans")
            let zh2 = try RFC_5646.LanguageTag("zh-HANS")
            let zh3 = try RFC_5646.LanguageTag("zh-hans")
            #expect(zh1.script?.value == "Hans")
            #expect(zh2.script?.value == "Hans")
            #expect(zh3.script?.value == "Hans")
        }

        @Test
        func `LanguageTag: Language with script and region`() throws {
            let zhHansCN = try RFC_5646.LanguageTag("zh-Hans-CN")
            #expect(zhHansCN.value == "zh-Hans-CN")
            #expect(zhHansCN.language.description == "zh")
            #expect(zhHansCN.script == ISO_15924.Alpha4.Hans)
            #expect(zhHansCN.region == .alpha2(try ISO_3166.Alpha2("CN")))

            let zhHantTW = try RFC_5646.LanguageTag("zh-Hant-TW")
            #expect(zhHantTW.script == ISO_15924.Alpha4.Hant)
            #expect(zhHantTW.region == .alpha2(try ISO_3166.Alpha2("TW")))

            let srLatnRS = try RFC_5646.LanguageTag("sr-Latn-RS")
            #expect(srLatnRS.language.description == "sr")
            #expect(srLatnRS.script == ISO_15924.Alpha4.Latn)
            #expect(srLatnRS.region == .alpha2(try ISO_3166.Alpha2("RS")))
        }

        @Test
        func `LanguageTag: Language with variant`() throws {
            let deCH1996 = try RFC_5646.LanguageTag("de-CH-1996")
            #expect(deCH1996.language.description == "de")
            #expect(deCH1996.region == .alpha2(try ISO_3166.Alpha2("CH")))
            #expect(deCH1996.variants == ["1996"])

            let enUSposix = try RFC_5646.LanguageTag("en-US-posix")
            #expect(enUSposix.language.description == "en")
            #expect(enUSposix.region == .alpha2(try ISO_3166.Alpha2("US")))
            #expect(enUSposix.variants == ["posix"])
        }

        @Test
        func `LanguageTag: Multiple variants`() throws {
            let tag = try RFC_5646.LanguageTag("sl-rozaj-biske")
            #expect(tag.language.description == "sl")
            #expect(tag.variants == ["rozaj", "biske"])
        }

        @Test
        func `LanguageTag: Language with extension`() throws {
            let tag = try RFC_5646.LanguageTag("en-US-u-ca-gregory")
            #expect(tag.language.description == "en")
            #expect(tag.region == .alpha2(try ISO_3166.Alpha2("US")))
            #expect(tag.extensions.count == 1)
            #expect(tag.extensions[0].singleton == "u")
            #expect(tag.extensions[0].values == ["ca", "gregory"])
        }

        @Test
        func `LanguageTag: Multiple extensions`() throws {
            let tag = try RFC_5646.LanguageTag("en-US-u-ca-gregory-t-ja")
            #expect(tag.extensions.count == 2)
            #expect(tag.extensions[0].singleton == "u")
            #expect(tag.extensions[0].values == ["ca", "gregory"])
            #expect(tag.extensions[1].singleton == "t")
            #expect(tag.extensions[1].values == ["ja"])
        }

        @Test
        func `LanguageTag: Language with private use`() throws {
            let tag = try RFC_5646.LanguageTag("en-US-x-internal")
            #expect(tag.language.description == "en")
            #expect(tag.region == .alpha2(try ISO_3166.Alpha2("US")))
            #expect(tag.privateUse == ["internal"])
        }

        @Test
        func `LanguageTag: Multiple private use subtags`() throws {
            let tag = try RFC_5646.LanguageTag("en-x-foo-bar-baz")
            #expect(tag.language.description == "en")
            #expect(tag.privateUse == ["foo", "bar", "baz"])
        }

        @Test
        func `LanguageTag: Private use with valid language`() throws {

            let tag = try RFC_5646.LanguageTag("en-x-private")
            #expect(tag.language.description == "en")
            #expect(tag.privateUse == ["private"])
        }

        @Test
        func `LanguageTag: Complex tag with all components`() throws {
            let tag = try RFC_5646.LanguageTag("zh-Hans-CN-rozaj-u-ca-chinese-x-private")
            #expect(tag.language.description == "zh")
            #expect(tag.script == ISO_15924.Alpha4.Hans)
            #expect(tag.region == .alpha2(try ISO_3166.Alpha2("CN")))
            #expect(tag.variants == ["rozaj"])
            #expect(tag.extensions.count == 1)
            #expect(tag.extensions[0].singleton == "u")
            #expect(tag.extensions[0].values == ["ca", "chinese"])
            #expect(tag.privateUse == ["private"])
        }

        @Test
        func `LanguageTag: String conversion`() throws {
            let tag = try RFC_5646.LanguageTag("zh-Hans-CN")
            #expect(tag.description == "zh-Hans-CN")
            #expect(String(describing: tag) == "zh-Hans-CN")
        }

        @Test
        func `LanguageTag: Equality`() throws {
            let en1 = try RFC_5646.LanguageTag("en-US")
            let en2 = try RFC_5646.LanguageTag("EN-us")
            #expect(en1 == en2)
            #expect(en1.hashValue == en2.hashValue)

            let zh = try RFC_5646.LanguageTag("zh-Hans")
            #expect(en1 != zh)
        }

        @Test
        func `LanguageTag: Accepts Substring for zero-copy parsing`() throws {

            let fullText = "prefix-en-US-suffix"
            let substring = fullText.dropFirst(7).dropLast(7)

            let tag = try RFC_5646.LanguageTag(substring)
            #expect(tag.value == "en-US")
            #expect(tag.language.description == "en")
            #expect(tag.region == .alpha2(try ISO_3166.Alpha2("US")))
        }

        @Test
        func `LanguageTag: Accepts String slices`() throws {

            let text = "zh-Hans-CN"
            let range = text.startIndex..<text.endIndex
            let slice = text[range]

            let tag = try RFC_5646.LanguageTag(slice)
            #expect(tag.value == "zh-Hans-CN")
            #expect(tag.language.description == "zh")
            #expect(tag.script == ISO_15924.Alpha4.Hans)
            #expect(tag.region == .alpha2(try ISO_3166.Alpha2("CN")))
        }

        @Test
        func `LanguageTag: StringProtocol preserves backward compatibility`() throws {

            let tag1 = try RFC_5646.LanguageTag("en-GB")
            #expect(tag1.value == "en-GB")

            let stringVar: String = "fr-FR"
            let tag2 = try RFC_5646.LanguageTag(stringVar)
            #expect(tag2.value == "fr-FR")
        }
    }

    @Suite
    struct `Edge Case` {

        @Test
        func `LanguageTag: Duplicate variant throws`() {
            #expect(throws: RFC_5646.Error.duplicateVariant("1996")) {
                try RFC_5646.LanguageTag("de-CH-1996-1996")
            }
        }

        @Test
        func `LanguageTag: Duplicate extension singleton throws`() {
            #expect(throws: RFC_5646.Error.duplicateExtensionSingleton("u")) {
                try RFC_5646.LanguageTag("en-u-ca-gregory-u-nu-thai")
            }
        }

        @Test
        func `LanguageTag: Empty tag throws`() {
            #expect(throws: RFC_5646.Error.emptyTag) {
                try RFC_5646.LanguageTag("")
            }

            #expect(throws: RFC_5646.Error.emptyTag) {
                try RFC_5646.LanguageTag("   ")
            }
        }

        @Test
        func `LanguageTag: Invalid language subtag`() {
            #expect(throws: RFC_5646.Error.invalidCharacters("e1")) {
                try RFC_5646.LanguageTag("e1")
            }

            #expect(throws: RFC_5646.Error.invalidLanguageSubtag("e")) {
                try RFC_5646.LanguageTag("e")
            }
        }

        @Test
        func `LanguageTag: Invalid script subtag`() throws {

            #expect(throws: RFC_5646.Error.invalidScriptSubtag("Xxxx")) {
                try RFC_5646.LanguageTag("en-Xxxx")
            }

            #expect(throws: RFC_5646.Error.invalidSubtagOrder("en-Lat")) {
                try RFC_5646.LanguageTag("en-Lat")
            }

            let tag = try RFC_5646.LanguageTag("en-latnn")
            #expect(tag.variants == ["latnn"])
        }

        @Test
        func `LanguageTag: Invalid region subtag`() {

            #expect(throws: RFC_5646.Error.invalidSubtagOrder("en-USA")) {
                try RFC_5646.LanguageTag("en-USA")
            }

            #expect(throws: RFC_5646.Error.invalidExtension("u")) {
                try RFC_5646.LanguageTag("en-u")
            }

            #expect(throws: RFC_5646.Error.invalidRegionSubtag("ZZ")) {
                try RFC_5646.LanguageTag("en-ZZ")
            }
        }
    }

    @Suite
    struct Integration {

        @Test
        func `LanguageTag: Codable round-trip`() throws {
            let original = try RFC_5646.LanguageTag("zh-Hans-CN")
            let encoder = JSONEncoder()
            let data = try encoder.encode(original)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(RFC_5646.LanguageTag.self, from: data)
            #expect(decoded == original)
            #expect(decoded.value == "zh-Hans-CN")
        }

        @Test
        func `LanguageTag: Real world examples`() throws {

            _ = try RFC_5646.LanguageTag("en")
            _ = try RFC_5646.LanguageTag("en-US")
            _ = try RFC_5646.LanguageTag("en-GB")
            _ = try RFC_5646.LanguageTag("en-AU")
            _ = try RFC_5646.LanguageTag("en-CA")

            _ = try RFC_5646.LanguageTag("zh")
            _ = try RFC_5646.LanguageTag("zh-Hans")
            _ = try RFC_5646.LanguageTag("zh-Hant")
            _ = try RFC_5646.LanguageTag("zh-Hans-CN")
            _ = try RFC_5646.LanguageTag("zh-Hant-TW")
            _ = try RFC_5646.LanguageTag("zh-Hant-HK")

            _ = try RFC_5646.LanguageTag("sr")
            _ = try RFC_5646.LanguageTag("sr-Cyrl")
            _ = try RFC_5646.LanguageTag("sr-Latn")
            _ = try RFC_5646.LanguageTag("sr-Cyrl-RS")
            _ = try RFC_5646.LanguageTag("sr-Latn-RS")

            _ = try RFC_5646.LanguageTag("ja")
            _ = try RFC_5646.LanguageTag("ja-JP")
            _ = try RFC_5646.LanguageTag("ko")
            _ = try RFC_5646.LanguageTag("ko-KR")
            _ = try RFC_5646.LanguageTag("ar")
            _ = try RFC_5646.LanguageTag("ar-SA")
            _ = try RFC_5646.LanguageTag("he")
            _ = try RFC_5646.LanguageTag("he-IL")
        }
    }
}
