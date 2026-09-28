import re

with open("Community Issue Reporter/Environment/EnvironmentValues.swift", "r") as f:
    content = f.read()

# Add a static function inside SettingsStore
func_str = """
    static func defaultDeviceLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        if preferredLanguage.hasPrefix("es") {
            return "es-419"
        }
        return "en"
    }
    
    init () {"""

content = content.replace("    init () {", func_str)

# Replace the specific hardcoded defaults
content = content.replace(
    'self.selectedLanguageCode = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? "es-419"',
    'self.selectedLanguageCode = UserDefaults.standard.string(forKey: "selectedLanguageCode") ?? SettingsStore.defaultDeviceLanguage()'
)

content = content.replace(
    '"selectedLanguageCode": "es-419",',
    '"selectedLanguageCode": SettingsStore.defaultDeviceLanguage(),'
)

with open("Community Issue Reporter/Environment/EnvironmentValues.swift", "w") as f:
    f.write(content)
