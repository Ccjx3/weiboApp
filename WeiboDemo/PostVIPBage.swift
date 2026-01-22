//
//  PostVIPBage.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/8.
//

import SwiftUI

struct PostVIPBage: View {
    //如果是VIP才显示Bage
    var vip : Bool
    
    var body: some View {
        Group {
            if vip {
                Text("V")
                    .bold()
                    .font(.system(size: 11))
                    .frame(width: 15 , height: 15)
                    .foregroundColor(.yellow)
                    .background(Color.red)
                    .clipShape(Circle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 7.5)
                            .stroke(Color.white,lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    PostVIPBage(vip : true)
}
