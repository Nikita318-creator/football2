import UIKit

extension UIColor {
    static let primary = UIColor(hex: "#F98806")
    static let success = UIColor(hex: "#1E6D0E")
    static let error = UIColor(hex: "#DD2727")
    static let textColor = UIColor(hex: "#201825")
    static let secondTextColor = UIColor(hex: "#6B5F73")
    static let activeColor = UIColor(hex: "#F98806")
    static let backgroundMain = UIColor(hex: "#F1EDE9")
        
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(red: 0.5, green: 0.5, blue: 0.5, alpha: alpha)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
