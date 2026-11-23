import Foundation
import ISO_15924
import ISO_3166
import ISO_639
import Testing

@testable import RFC_5646

enum `RFC5646 Tests` {}

extension `RFC5646 Tests` {
    @Suite
    struct `RFC 5646 Language Tags` {
        @Suite
        struct Unit {

            @Test
            func `Tag: Simple language codes`() throws {
                let en = try IETF.RFC.`5646`.Tag("en")
                #expect(en.value == "en")
                #expect(en.language.description == "en")
                #expect(en.script == nil)
                #expect(en.region == nil)
                #expect(en.variants.isEmpty)
                #expect(en.extensions.isEmpty)
                #expect(en.privateUse.isEmpty)

                let fr = try IETF.RFC.`5646`.Tag("fr")
                #expect(fr.language.description == "fr")

                let de = try IETF.RFC.`5646`.Tag("de")
                #expect(de.language.description == "de")
            }

            @Test
            func `Tag: Case normalization for language`() throws {
                let en1 = try IETF.RFC.`5646`.Tag("en")
                let en2 = try IETF.RFC.`5646`.Tag("EN")
                let en3 = try IETF.RFC.`5646`.Tag("En")
                #expect(en1.language.description == "en")
                #expect(en2.language.description == "en")
                #expect(en3.language.description == "en")
                #expect(en1 == en2)
                #expect(en2 == en3)
            }

            @Test
            func `Tag: Language with alpha-2 region`() throws {
                let enUS = try IETF.RFC.`5646`.Tag("en-US")
                #expect(enUS.value == "en-US")
                #expect(enUS.language.description == "en")
                #expect(enUS.script == nil)
                #expect(enUS.region == .alpha2(try ISO.`3166`.Alpha2("US")))

                let frFR = try IETF.RFC.`5646`.Tag("fr-FR")
                #expect(frFR.language.description == "fr")
                #expect(frFR.region == .alpha2(try ISO.`3166`.Alpha2("FR")))

                let deDE = try IETF.RFC.`5646`.Tag("de-DE")
                #expect(deDE.language.description == "de")
                #expect(deDE.region == .alpha2(try ISO.`3166`.Alpha2("DE")))
            }

            @Test
            func `Tag: Language with numeric region`() throws {
                let en840 = try IETF.RFC.`5646`.Tag("en-840")
                #expect(en840.language.description == "en")
                #expect(en840.region == .numeric(try ISO.`3166`.Numeric("840")))
            }

            @Test
            func `Tag: Language with UN M.49 area region`() throws {
                let es419 = try IETF.RFC.`5646`.Tag("es-419")
                #expect(es419.value == "es-419")
                #expect(es419.region == .area(try IETF.RFC.`5646`.Tag.Region.Area("419")))

                let en001 = try IETF.RFC.`5646`.Tag("en-001")
                #expect(en001.region == .area(try IETF.RFC.`5646`.Tag.Region.Area("001")))

                #expect(throws: IETF.RFC.`5646`.Error.invalidRegionSubtag("999")) {
                    try IETF.RFC.`5646`.Tag("en-999")
                }
            }

            @Test
            func `Tag: Language with a reserved region in the IANA registry`() throws {
                let enDG = try IETF.RFC.`5646`.Tag("en-dg")
                #expect(enDG.value == "en-DG")
                #expect(enDG.region == .reserved("DG"))

                #expect(try IETF.RFC.`5646`.Tag("sq-XK").region == .reserved("XK"))
                #expect(try IETF.RFC.`5646`.Tag("en-QM").region == .reserved("QM"))
                #expect(try IETF.RFC.`5646`.Tag("en-ZZ").region == .reserved("ZZ"))
                #expect(try IETF.RFC.`5646`.Tag("de-DD").region == .reserved("DD"))
            }

            @Test
            func `Tag: Case normalization for region`() throws {
                let enUS1 = try IETF.RFC.`5646`.Tag("en-US")
                let enUS2 = try IETF.RFC.`5646`.Tag("en-us")
                let enUS3 = try IETF.RFC.`5646`.Tag("EN-us")
                #expect(enUS1.value == "en-US")
                #expect(enUS2.value == "en-US")
                #expect(enUS3.value == "en-US")
            }

            @Test
            func `Tag: Language with script`() throws {
                let zhHans = try IETF.RFC.`5646`.Tag("zh-Hans")
                #expect(zhHans.value == "zh-Hans")
                #expect(zhHans.language.description == "zh")
                #expect(zhHans.script == ISO.`15924`.Alpha4.Hans)
                #expect(zhHans.region == nil)

                let zhHant = try IETF.RFC.`5646`.Tag("zh-Hant")
                #expect(zhHant.script == ISO.`15924`.Alpha4.Hant)

                let srCyrl = try IETF.RFC.`5646`.Tag("sr-Cyrl")
                #expect(srCyrl.language.description == "sr")
                #expect(srCyrl.script == ISO.`15924`.Alpha4.Cyrl)
            }

            @Test
            func `Tag: Case normalization for script`() throws {
                let zh1 = try IETF.RFC.`5646`.Tag("zh-Hans")
                let zh2 = try IETF.RFC.`5646`.Tag("zh-HANS")
                let zh3 = try IETF.RFC.`5646`.Tag("zh-hans")
                #expect(zh1.script?.value == "Hans")
                #expect(zh2.script?.value == "Hans")
                #expect(zh3.script?.value == "Hans")
            }

            @Test
            func `Tag: Language with script and region`() throws {
                let zhHansCN = try IETF.RFC.`5646`.Tag("zh-Hans-CN")
                #expect(zhHansCN.value == "zh-Hans-CN")
                #expect(zhHansCN.language.description == "zh")
                #expect(zhHansCN.script == ISO.`15924`.Alpha4.Hans)
                #expect(zhHansCN.region == .alpha2(try ISO.`3166`.Alpha2("CN")))

                let zhHantTW = try IETF.RFC.`5646`.Tag("zh-Hant-TW")
                #expect(zhHantTW.script == ISO.`15924`.Alpha4.Hant)
                #expect(zhHantTW.region == .alpha2(try ISO.`3166`.Alpha2("TW")))

                let srLatnRS = try IETF.RFC.`5646`.Tag("sr-Latn-RS")
                #expect(srLatnRS.language.description == "sr")
                #expect(srLatnRS.script == ISO.`15924`.Alpha4.Latn)
                #expect(srLatnRS.region == .alpha2(try ISO.`3166`.Alpha2("RS")))
            }

            @Test
            func `Tag: Language with variant`() throws {
                let deCH1996 = try IETF.RFC.`5646`.Tag("de-CH-1996")
                #expect(deCH1996.language.description == "de")
                #expect(deCH1996.region == .alpha2(try ISO.`3166`.Alpha2("CH")))
                #expect(deCH1996.variants == ["1996"])

                let enUSposix = try IETF.RFC.`5646`.Tag("en-US-posix")
                #expect(enUSposix.language.description == "en")
                #expect(enUSposix.region == .alpha2(try ISO.`3166`.Alpha2("US")))
                #expect(enUSposix.variants == ["posix"])
            }

            @Test
            func `Tag: Multiple variants`() throws {
                let tag = try IETF.RFC.`5646`.Tag("sl-rozaj-biske")
                #expect(tag.language.description == "sl")
                #expect(tag.variants == ["rozaj", "biske"])
            }

            @Test
            func `Tag: Language with extension`() throws {
                let tag = try IETF.RFC.`5646`.Tag("en-US-u-ca-gregory")
                #expect(tag.language.description == "en")
                #expect(tag.region == .alpha2(try ISO.`3166`.Alpha2("US")))
                #expect(tag.extensions.count == 1)
                #expect(tag.extensions[0].singleton == "u")
                #expect(tag.extensions[0].values == ["ca", "gregory"])
            }

            @Test
            func `Tag: Multiple extensions`() throws {
                let tag = try IETF.RFC.`5646`.Tag("en-US-u-ca-gregory-t-ja")
                #expect(tag.extensions.count == 2)
                #expect(tag.extensions[0].singleton == "u")
                #expect(tag.extensions[0].values == ["ca", "gregory"])
                #expect(tag.extensions[1].singleton == "t")
                #expect(tag.extensions[1].values == ["ja"])
            }

            @Test
            func `Tag: Language with private use`() throws {
                let tag = try IETF.RFC.`5646`.Tag("en-US-x-internal")
                #expect(tag.language.description == "en")
                #expect(tag.region == .alpha2(try ISO.`3166`.Alpha2("US")))
                #expect(tag.privateUse == ["internal"])
            }

            @Test
            func `Tag: Multiple private use subtags`() throws {
                let tag = try IETF.RFC.`5646`.Tag("en-x-foo-bar-baz")
                #expect(tag.language.description == "en")
                #expect(tag.privateUse == ["foo", "bar", "baz"])
            }

            @Test
            func `Tag: Private use with valid language`() throws {

                let tag = try IETF.RFC.`5646`.Tag("en-x-private")
                #expect(tag.language.description == "en")
                #expect(tag.privateUse == ["private"])
            }

            @Test
            func `Tag: Complex tag with all components`() throws {
                let tag = try IETF.RFC.`5646`.Tag("zh-Hans-CN-rozaj-u-ca-chinese-x-private")
                #expect(tag.language.description == "zh")
                #expect(tag.script == ISO.`15924`.Alpha4.Hans)
                #expect(tag.region == .alpha2(try ISO.`3166`.Alpha2("CN")))
                #expect(tag.variants == ["rozaj"])
                #expect(tag.extensions.count == 1)
                #expect(tag.extensions[0].singleton == "u")
                #expect(tag.extensions[0].values == ["ca", "chinese"])
                #expect(tag.privateUse == ["private"])
            }

            @Test
            func `Tag: String conversion`() throws {
                let tag = try IETF.RFC.`5646`.Tag("zh-Hans-CN")
                #expect(tag.description == "zh-Hans-CN")
                #expect(String(describing: tag) == "zh-Hans-CN")
            }

            @Test
            func `Tag: Equality`() throws {
                let en1 = try IETF.RFC.`5646`.Tag("en-US")
                let en2 = try IETF.RFC.`5646`.Tag("EN-us")
                #expect(en1 == en2)
                #expect(en1.hashValue == en2.hashValue)

                let zh = try IETF.RFC.`5646`.Tag("zh-Hans")
                #expect(en1 != zh)
            }

            @Test
            func `Tag: Accepts Substring for zero-copy parsing`() throws {

                let fullText = "prefix-en-US-suffix"
                let substring = fullText.dropFirst(7).dropLast(7)

                let tag = try IETF.RFC.`5646`.Tag(substring)
                #expect(tag.value == "en-US")
                #expect(tag.language.description == "en")
                #expect(tag.region == .alpha2(try ISO.`3166`.Alpha2("US")))
            }

            @Test
            func `Tag: Accepts String slices`() throws {

                let text = "zh-Hans-CN"
                let range = text.startIndex..<text.endIndex
                let slice = text[range]

                let tag = try IETF.RFC.`5646`.Tag(slice)
                #expect(tag.value == "zh-Hans-CN")
                #expect(tag.language.description == "zh")
                #expect(tag.script == ISO.`15924`.Alpha4.Hans)
                #expect(tag.region == .alpha2(try ISO.`3166`.Alpha2("CN")))
            }

            @Test
            func `Tag: StringProtocol preserves backward compatibility`() throws {

                let tag1 = try IETF.RFC.`5646`.Tag("en-GB")
                #expect(tag1.value == "en-GB")

                let stringVar: String = "fr-FR"
                let tag2 = try IETF.RFC.`5646`.Tag(stringVar)
                #expect(tag2.value == "fr-FR")
            }
        }

        @Suite
        struct `Edge Case` {

            @Test
            func `Tag: Duplicate variant throws`() {
                #expect(throws: IETF.RFC.`5646`.Error.duplicateVariant("1996")) {
                    try IETF.RFC.`5646`.Tag("de-CH-1996-1996")
                }
            }

            @Test
            func `Tag: Duplicate extension singleton throws`() {
                #expect(throws: IETF.RFC.`5646`.Error.duplicateExtensionSingleton("u")) {
                    try IETF.RFC.`5646`.Tag("en-u-ca-gregory-u-nu-thai")
                }
            }

            @Test
            func `Tag: Empty tag throws`() {
                #expect(throws: IETF.RFC.`5646`.Error.emptyTag) {
                    try IETF.RFC.`5646`.Tag("")
                }

                #expect(throws: IETF.RFC.`5646`.Error.emptyTag) {
                    try IETF.RFC.`5646`.Tag("   ")
                }
            }

            @Test
            func `Tag: Invalid language subtag`() {
                #expect(throws: IETF.RFC.`5646`.Error.invalidCharacters("e1")) {
                    try IETF.RFC.`5646`.Tag("e1")
                }

                #expect(throws: IETF.RFC.`5646`.Error.invalidLanguageSubtag("e")) {
                    try IETF.RFC.`5646`.Tag("e")
                }
            }

            @Test
            func `Tag: Invalid script subtag`() throws {

                #expect(throws: IETF.RFC.`5646`.Error.invalidScriptSubtag("Xxxx")) {
                    try IETF.RFC.`5646`.Tag("en-Xxxx")
                }

                #expect(throws: IETF.RFC.`5646`.Error.invalidSubtagOrder("en-Lat")) {
                    try IETF.RFC.`5646`.Tag("en-Lat")
                }

                let tag = try IETF.RFC.`5646`.Tag("en-latnn")
                #expect(tag.variants == ["latnn"])
            }

            @Test
            func `Tag: Invalid region subtag`() {

                #expect(throws: IETF.RFC.`5646`.Error.invalidSubtagOrder("en-USA")) {
                    try IETF.RFC.`5646`.Tag("en-USA")
                }

                #expect(throws: IETF.RFC.`5646`.Error.invalidExtension("u")) {
                    try IETF.RFC.`5646`.Tag("en-u")
                }

                #expect(throws: IETF.RFC.`5646`.Error.invalidRegionSubtag("UK")) {
                    try IETF.RFC.`5646`.Tag("en-UK")
                }

                #expect(throws: IETF.RFC.`5646`.Error.invalidRegionSubtag("QL")) {
                    try IETF.RFC.`5646`.Tag("en-QL")
                }
            }
        }

        @Suite
        struct Integration {

            @Test
            func `Tag: Codable round-trip`() throws {
                let original = try IETF.RFC.`5646`.Tag("zh-Hans-CN")
                let encoder = JSONEncoder()
                let data = try encoder.encode(original)
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(IETF.RFC.`5646`.Tag.self, from: data)
                #expect(decoded == original)
                #expect(decoded.value == "zh-Hans-CN")
            }

            @Test
            func `Tag: Real world examples`() throws {

                _ = try IETF.RFC.`5646`.Tag("en")
                _ = try IETF.RFC.`5646`.Tag("en-US")
                _ = try IETF.RFC.`5646`.Tag("en-GB")
                _ = try IETF.RFC.`5646`.Tag("en-AU")
                _ = try IETF.RFC.`5646`.Tag("en-CA")

                _ = try IETF.RFC.`5646`.Tag("zh")
                _ = try IETF.RFC.`5646`.Tag("zh-Hans")
                _ = try IETF.RFC.`5646`.Tag("zh-Hant")
                _ = try IETF.RFC.`5646`.Tag("zh-Hans-CN")
                _ = try IETF.RFC.`5646`.Tag("zh-Hant-TW")
                _ = try IETF.RFC.`5646`.Tag("zh-Hant-HK")

                _ = try IETF.RFC.`5646`.Tag("sr")
                _ = try IETF.RFC.`5646`.Tag("sr-Cyrl")
                _ = try IETF.RFC.`5646`.Tag("sr-Latn")
                _ = try IETF.RFC.`5646`.Tag("sr-Cyrl-RS")
                _ = try IETF.RFC.`5646`.Tag("sr-Latn-RS")

                _ = try IETF.RFC.`5646`.Tag("ja")
                _ = try IETF.RFC.`5646`.Tag("ja-JP")
                _ = try IETF.RFC.`5646`.Tag("ko")
                _ = try IETF.RFC.`5646`.Tag("ko-KR")
                _ = try IETF.RFC.`5646`.Tag("ar")
                _ = try IETF.RFC.`5646`.Tag("ar-SA")
                _ = try IETF.RFC.`5646`.Tag("he")
                _ = try IETF.RFC.`5646`.Tag("he-IL")
            }
        }
    }
}
