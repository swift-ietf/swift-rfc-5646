# swift-rfc-5646

Use this package when you need to check, store or compare a language tag such as `en-US` or `zh-Hans-CN` and want its subtags validated against ISO 639, ISO 15924 and ISO 3166. Start from `RFC_5646.LanguageTag`. To build a tag from codes you already hold, use `RFC_5646.LanguageTag.init(language:script:region:)`. For the language, script or region codes on their own, use swift-iso-639, swift-iso-15924 or swift-iso-3166.

## Laws

- Only the RFC 5646 `langtag` form is accepted. A tag that is only private use, such as `x-whatever`, and grandfathered tags such as `i-klingon` or `en-GB-oed` are refused.
- Spaces and tabs around the tag are trimmed. Any non-ASCII character is refused, including a Kelvin sign that would lowercase to `k`.
- `RFC_5646.LanguageTag.value` is written in canonical case: language and variants lowercase, script with an initial capital, region uppercase, extension singletons lowercase. Extension and private use subtags keep the case they were written in. `EN-us` and `en-US` give equal tags.
- A two or three letter language that ISO 639 knows is held as `RFC_5646.LanguageTag.Language.iso639(_:)`. Any other language of 2 to 8 letters is accepted and held as `RFC_5646.LanguageTag.Language.reserved(_:)`.
- A script must be a known ISO 15924 code, so `en-Xxxx` is refused. A two letter region must be an assigned ISO 3166 alpha-2 code, so `en-ZZ` is refused. A three digit region must be an ISO 3166 numeric country code or a UN M.49 area code in the IANA registry, such as 419 in `es-419`, so `en-999` is refused.
- A variant is 5 to 8 letters or digits, or 4 starting with a digit, and may appear only once, compared without case. An extension singleton other than `x` may appear only once and needs at least one subtag after it, each 2 to 8 letters or digits. Private use subtags are 1 to 8 letters or digits.
- A subtag in the wrong place, such as `en-USA` or `en-Lat`, fails as out of order rather than as an invalid region or script.
- A tag encodes as its canonical string and decodes through the same validation.
- A tag built from codes equals the tag parsed from the same text.
