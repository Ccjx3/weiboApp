//
//  PostListView.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/11.
//

import SwiftUI
import BBSwiftUIKit
import Foundation

struct PostListView: View {
    let category: PostListCategory
    
    //@EnvironmentObject：会自动从父View的环境对象里面找到这个值
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        BBTableView(userData.postList(for: category).list) { post in
            NavigationLink(destination: PostDetailView(post: post)) {
                PostCell(post: post)
            }
            .buttonStyle(OriginalButtonStyle())//解决buttonStyle不同问题
        }
        .bb_setupRefreshControl{ control in
            control.attributedTitle = NSAttributedString(string: "加载中...")
        }
        .bb_pullDownToRefresh(isRefreshing: $userData.isRefreshing) {
            self.userData.refreshPostlist(for: self.category)
        }
        .bb_pullUpToLoadMore(bottomSpace: 30) {
            self.userData.loadMorePostList(for: self.category)
        }
        .bb_reloadData($userData.reloadData)
        .onAppear {
            self.userData.loadPostListIfNeeded(for: self.category)
        }
        .overlay(
            Text(userData.loadingErrorText)
                .bold()
                .frame(width: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .opacity(0.8)
                )
                .animation(nil)
                    .scaleEffect(userData.showLoading ? 1 : 0.5)
                .animation(.easeInOut)
                    .opacity(userData.showLoading ? 1 : 0)
                .animation(.spring(dampingFraction: 0.5))
        )
    }
}

#Preview {
    NavigationView {
        PostListView(category: .recommend)
            .navigationBarTitle("Title")
            .navigationBarHidden(true)
    }
    .environmentObject(UserData.testData)
}
