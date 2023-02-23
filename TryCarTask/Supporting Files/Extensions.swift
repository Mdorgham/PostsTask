//
//  Extensions.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 22/02/2023.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}

extension CGColor {

    class func colorWithHex(hex: Int) -> CGColor {

        return UIColor(hex: hex).cgColor

    }

}

func convertDateFormatter(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"//this your string date format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//    dateFormatter.locale = Locale(identifier: "US")
    let convertedDate = dateFormatter.date(from: date)

    guard dateFormatter.date(from: date) != nil else {
        assert(false, "no date from string")
        return ""
    }

    dateFormatter.dateFormat = "dd/MM/yyyy"///this is what you want to convert format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp
}

func convertDateToTime(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"//this your string date format
    dateFormatter.timeZone = NSTimeZone(name: "en_US_POSIX") as TimeZone?
//    dateFormatter.locale = Locale(identifier: "EG")
    let convertedDate = dateFormatter.date(from: date)

    guard dateFormatter.date(from: date) != nil else {
        assert(false, "no date from string")
        return ""
    }

    dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
    dateFormatter.timeZone = NSTimeZone(name: "en_US_POSIX") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp
}
