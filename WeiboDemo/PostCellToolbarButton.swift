//
//  PostCellToolbarButton.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/11.
//

import SwiftUI

struct PostCellToolbarButton: View {
    let image: String
    let text: String
    let color: Color
    let action:() -> Void // closure闭包
      
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                //用系统图片
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18 , height: 18)
                Text(text)
                    .font(.system(size: 15))
            }
        }
        .foregroundColor(color)
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    PostCellToolbarButton(image: "heart", text: "点赞", color: .red) {
        print("点赞")
    }
}
