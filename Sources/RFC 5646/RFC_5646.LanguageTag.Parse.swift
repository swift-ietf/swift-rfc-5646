public import Parser_Primitives

extension RFC_5646.LanguageTag {

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
    public typealias Body = Never

    @inlinable
    public func parse(_ input: inout Input) -> Output {
        var subtags: [Input] = []

        while input.startIndex < input.endIndex {

            let subtagStart = input.startIndex
            var idx = input.startIndex
            while idx < input.endIndex {
                let byte = input[idx]
                let isAlphaNum =
                    (byte >= 0x41 && byte <= 0x5A)
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
