import SwiftUI
import UIKit
import CoreText

enum Palette {
    static let paper = Color(hex: 0xF3E6C8)
    static let paperShadow = Color(hex: 0xE4D4B0)
    static let ink = Color(hex: 0x1C1612)
    static let inkMuted = Color(hex: 0x483C30)
    static let felt = Color(hex: 0x1F5C43)
    static let oak = Color(hex: 0x8B5A2B)
    static let oakLight = Color(hex: 0xC4A574)
    static let oakDark = Color(hex: 0x56361C)
    static let teamRed = Color(hex: 0xC23B32)
    static let teamBlue = Color(hex: 0x2B5F8A)
    static let brass = Color(hex: 0xC9A227)
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum AppFont {
    static func score(_ size: CGFloat) -> Font {
        custom(["Anton-Regular", "Anton"], size: size, fallback: .black)
    }

    static func display(_ size: CGFloat) -> Font {
        custom(["Oswald-Bold", "Oswald"], size: size, fallback: .bold)
    }

    static func caption(_ size: CGFloat) -> Font {
        custom(["Oswald-SemiBold", "Oswald-Bold", "Oswald"], size: size, fallback: .semibold)
    }

    private static func custom(_ names: [String], size: CGFloat, fallback: Font.Weight) -> Font {
        BundledFonts.register()
        for name in names {
            if UIFont(name: name, size: size) != nil {
                return .custom(name, size: size)
            }
        }
        return .system(size: size, weight: fallback, design: .default).width(.condensed)
    }
}

enum BundledFonts {
    static func register() {
        _ = registration
    }

    private static let registration: Bool = {
        let files = [
            "Anton-Regular",
            "Oswald-Regular",
            "Oswald-SemiBold",
            "Oswald-Bold",
        ]
        for file in files {
            guard let url = Bundle.main.url(forResource: file, withExtension: "ttf") else {
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        return true
    }()
}
