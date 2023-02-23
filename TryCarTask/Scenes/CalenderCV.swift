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
    @State var startDate = "From"
    @State var endDate = "To"
    @State var range = [""]
    
    var body: some View {
        VStack(spacing: 30) {
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
            
           Text("\(startDate) - \(endDate)")
            
            MyCalendar(first: { firstDate in
                
                self.startDate = firstDate
                
            }, last: { lastData in
                
                self.endDate = lastData
                
            }, range: { range in
                
                self.range = range
                
            }).frame(minWidth: 200, minHeight: 320).padding(.leading, 5)

            Spacer()
        }
        .padding()
        
    }
}

struct MyCalendar: UIViewControllerRepresentable {
    
    var first: (String) -> Void
    var last: (String)-> Void
    var range: ([String]) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyCalendar>) -> MyCalendarController {
        let calendar = MyCalendarController(first: first,last: last,range: range)
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
