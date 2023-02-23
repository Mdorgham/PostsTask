//
//  CalenderCV.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 22/02/2023.
//

import SwiftUI
import UIKit
import FSCalendar
import MOLH
import JTAppleCalendar

struct CalenderCV: View {
    
    @State var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            HStack (alignment: .lastTextBaseline) {
                Spacer()
                Button {
                    MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
                    MOLH.reset()
                    
                } label: {
                    if MOLHLanguage.currentAppleLanguage() == "en" {
                        Text("AR")
                    }else {
                        Text("EN")
                    }
                    
                }
                .frame(width: 40,height: 40)
            }
           
            MyCalendar().frame(minWidth: 200, minHeight: 320).padding(.leading, 5)

            Spacer()
        }
        .padding()
        
    }
}

//struct CalendarViewRepresentable: UIViewRepresentable {
//
//    typealias UIViewType = FSCalendar
//    @Binding var selectedDate: Date
//    fileprivate var calendar = FSCalendar()
//    fileprivate var cal = Calendar(identifier: .gregorian)
//    let locale = MOLHLanguage.currentAppleLanguage()
//
//    func makeUIView(context: Context) -> FSCalendar {
//
//        calendar.delegate = context.coordinator
//        calendar.dataSource = context.coordinator
//        calendar.firstWeekday = 1
//        calendar.semanticContentAttribute = .forceRightToLeft
//        calendar.locale = NSLocale(localeIdentifier: "ar-AE") as Locale
//        calendar.allowsMultipleSelection = true
//
//
//        return calendar
//    }
//
//    func updateUIView(_ uiView: FSCalendar, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject,
//                       FSCalendarDelegate, FSCalendarDataSource {
//        var parent: CalendarViewRepresentable
//
//        init(_ parent: CalendarViewRepresentable) {
//            self.parent = parent
//        }
//    }
//}

struct MyCalendar: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyCalendar>) -> MyCalendarController {
        let calendar: MyCalendarController = .init()
        return calendar
    }

    func updateUIViewController(_ calendar: MyCalendarController, context: UIViewControllerRepresentableContext<MyCalendar>) {
        // MARK: - TODO
    }
}

struct CalenderCV_Previews: PreviewProvider {
    static var previews: some View {
        CalenderCV()
    }
}
