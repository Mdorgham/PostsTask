//
//  CalendarController.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 22/02/2023.
//

import Foundation
import UIKit
import FSCalendar
import MOLH

class MyCalendarController: UIViewController {
    
    let secondary = UIColor(hex: 0xE0B355)
    let primary = UIColor(hex: 0x5530A5)
    let tersiary = UIColor(hex: 0xE7EEEF)
    let black = UIColor(hex: 0x1c1d1d)
    let white = UIColor(hex: 0xfefffe)
    let gray = UIColor(hex: 0xaaaaab)
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    
    init(first: ((String) -> Void)? = nil,
         last: ((String) -> Void)? = nil,
         range: (([String]) -> Void)? = nil) {
        self.first = first
        self.last = last
        self.range = range
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("I'm leaving: DocumentPreviewViewController")
    }
    
    var first: (((String) -> Void))?
    var last: (((String) -> Void))?
    var range: ((([String]) -> Void))?
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
   
    fileprivate weak var calendar: FSCalendar!
    
    override func loadView() {
        let width: CGFloat = UIScreen.main.bounds.width - 40
        let frame: CGRect  = .init(x: 0, y: 0, width: width, height: 300)
        let view:  UIView  = .init(frame: frame)
        self.view = view
        
        let calendar: FSCalendar = .init(frame: frame)
        calendar.allowsMultipleSelection = false
        calendar.dataSource = self
        calendar.delegate = self
        
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.contentView.layer.cornerRadius = 10
        calendar.calendarHeaderView.backgroundColor = self.white
        calendar.calendarWeekdayView.backgroundColor = self.white
        calendar.appearance.headerTitleColor = self.primary
        calendar.appearance.weekdayTextColor = self.primary
        calendar.locale = NSLocale(localeIdentifier: MOLHLanguage.currentAppleLanguage()) as Locale
        calendar.firstWeekday = 1
        calendar.allowsMultipleSelection = true
        calendar.appearance.eventSelectionColor = self.primary
        calendar.appearance.eventDefaultColor = self.primary
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        
        calendar.appearance.todaySelectionColor = self.secondary
        calendar.appearance.selectionColor = self.primary
        calendar.appearance.todayColor = self.secondary
        
        calendar.appearance.titleWeekendColor = self.gray
        calendar.appearance.titleDefaultColor = self.black

        calendar.appearance.headerTitleFont = UIFont(name: "Optima-ExtraBlack", size: 15)
        calendar.appearance.weekdayFont = UIFont(name: "Chalkduster", size: 12)
        calendar.appearance.titleFont = UIFont(name: "MarkerFelt-Thin", size: 12)
        calendar.swipeToChooseGesture.isEnabled = true
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        scopeGesture.delegate = self
        calendar.addGestureRecognizer(scopeGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.scope = .month
        self.calendar.select(Date.init())
        self.calendar.accessibilityIdentifier = "calendar"
    }
}

extension MyCalendarController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        
        // nothing selected:
           if firstDate == nil {
               firstDate = date
               datesRange = [firstDate!]
               // selected first date
               
               print("datesRange contains: \(datesRange!)")
               
               self.first?(formatter.string(from: firstDate!))
               
               return
           }
           
           // only first date is selected:
           if firstDate != nil && lastDate == nil {
               // handle the case of if the last date is less than the first date:
               if date <= firstDate! {
                   calendar.deselect(firstDate!)
                   firstDate = date
                   datesRange = [firstDate!]
                   
                   print("datesRange contains: \(datesRange!)")
                   
                   return
               }
               
               let range = datesRange(from: firstDate!, to: date)

               lastDate = range.last
               
               for d in range {
                   calendar.select(d)
               }
               
               datesRange = range
               // selected last date
               
               print("datesRange contains: \(datesRange!)")
               
               self.last?(formatter.string(from: lastDate!))
               return
           }
           
           // both are selected:
           if firstDate != nil && lastDate != nil {
               for d in calendar.selectedDates {
                   calendar.deselect(d)
               }
               
               lastDate = nil
               firstDate = nil
               self.first?("From")
               self.last?("To")
               
               datesRange = []
               // delete selection if selected any
               print("datesRange contains: \(datesRange!)")
           }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            self.first?("From")
            self.last?("To")
            // delete selection on deselect
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
        // first date selected and deselected
        if firstDate == date {
            calendar.deselect(date)
            lastDate = nil
            firstDate = nil
            self.first?("From")
            self.last?("To")
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    func convertDate(_ date: String) -> String {

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
       
        let today =  dateFormatter1.string(from: Date())
        
        
        if (today == convertDateFormatter(date: date)) {
            let currentTime = convertDateToTime(date: date)
            print(currentTime)
            return "Today, \(currentTime)"
        }else {
            
            return convertDateFormatter(date: date)
        }
        
    }
}

extension MyCalendarController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.view.layoutIfNeeded()
    }
}

extension MyCalendarController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        debugPrint("UIGestureRecognizer")
        return true
    }
}

extension UIColor {
    static func parse(_ hex: UInt32, alpha: Double = 1.0) -> UIColor {
        let red   = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(hex & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
