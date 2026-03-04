//
//  RFC_5646.LanguageTag.Parse.swift
//  swift-rfc-5646
//
//  RFC 5646 language tag: subtag *("-" subtag)
//

public import Parser_Primitives

extension RFC_5646.LanguageTag {
    /// Parses an RFC 5646 language tag.
    ///
    /// `langtag = language ["-" script] ["-" region] *("-" variant) *("-" extension) ["-" privateuse]`
    ///
    /// Returns the raw subtags as hyphen-separated byte slices. Structural
    /// interpretation (which subtag is language vs script vs region) is
    /// left to the caller — BCP 47 uses subtag length and position to
    /// determine semantics.
    public struct Parse<Input: Collection.Slice.`Protocol`>: Sendable
    where Input: Sendable, Input.Element == UInt8 {
        @inlinable
        public init() {}
    }
}

extension RFC_5646.LanguageTag.Parse {
    public typealias Output = [Input]
}

extension RFC_5646.LanguageTag.Parse: Parser.`Protocol` {
    public typealias Failure = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        var subtags: [Input] = []

        while input.startIndex < input.endIndex {
            // Consume subtag (alphanumeric characters)
            let subtagStart = input.startIndex
            var idx = input.startIndex
            while idx < input.endIndex {
                let byte = input[idx]
                let isAlphaNum = (byte >= 0x41 && byte <= 0x5A)
                    || (byte >= 0x61 && byte <= 0x7A)
                    || (byte >= 0x30 && byte <= 0x39)
                guard isAlphaNum else { break }
                input.formIndex(after: &idx)
            }

            if idx > subtagStart {
                subtags.append(input[subtagStart..<idx])
            } else {
                break
            }

            // Expect '-' separator or end
            if idx < input.endIndex && input[idx] == 0x2D {
                input.formIndex(after: &idx)
                input = input[idx...]
            } else {
                input = input[idx...]
                break
            }
        }

        return subtags
    }
}
