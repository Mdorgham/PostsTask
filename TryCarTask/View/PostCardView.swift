//
//  PostCardView.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import SwiftUI

struct PostCardView: View {
    var title: String
    var type: String
    var isFavourite: Bool
    var completion: () -> Void
    
    
    var body: some View {

        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.indigo)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text(type)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Button {
                        completion()
                        
                    } label: {
                        if isFavourite {
                            Image(systemName: "heart.fill")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        }else {
                            Image(systemName: "heart")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        }
                    }
                }
            }.padding()
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
        
        
    }
    struct CardModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
        }
        
    }
}


