public import ISO_15924
public import ISO_3166
public import ISO_639

extension RFC_5646.LanguageTag {

    public init(
        language: Language,
        script: ISO_15924.Alpha4? = nil,
        region: Region? = nil
    ) {
        var canonical = language.description
        if let script {
            canonical += "-\(script.value)"
        }
        if let region {
            canonical += "-\(region.description.uppercased())"
        }
        self.value = canonical
        self.language = language
        self.script = script
        self.region = region
        self.variants = []
        self.extensions = []
        self.privateUse = []
    }

    public init(language alpha2: ISO_639.Alpha2, region: ISO_3166.Alpha2? = nil) {
        self.init(
            language: .iso639(ISO_639.LanguageCode(alpha2: alpha2, alpha3: ISO_639.Alpha3(alpha2))),
            region: region.map { .alpha2($0) }
        )
    }
}
