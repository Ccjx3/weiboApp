//
//  PostDetailView.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/12.
//

import SwiftUI
import BBSwiftUIKit


struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        BBTableView(0...10) { i in
            if i == 0 {
                PostCell(post: post)
            } else {
                HStack {
                    Text("评论\(i)").padding()
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .listStyle(.plain) // 💡 这一行最关键：强制使用平铺样式，去掉圆角卡片感
        .navigationBarTitle("详情", displayMode: .inline)//只显示inline
    }
}

#Preview {
    let userData = UserData.testData
    PostDetailView(post: userData.recommendPostList.list[0]).environmentObject(userData)
}
