//
//  HomeView.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/12.
//

import SwiftUI

struct HomeView: View {
    @State var leftPercent: CGFloat = 0
/*
子View可以访问到父View的elem，例如：在该demo中<Post>可以访问<PostCell>中的elem；
环境对象作用：
        没有环境对象： A 传给 B，B 传给 C，C 传给 D（非常繁琐）。
        使用环境对象： A 将数据放入“环境”，D 直接从“环境”中抓取（跳过 B 和 C）。
当子View change 一个参数 ， 父view以及他的子view全部改变该参数值
*/
    var body: some View {
        // 2. 建议使用 NavigationStack (iOS 16+)，或者保持 NavigationView
        NavigationStack {
            GeometryReader { geometry in
                HScrollViewController(
                    pageWidth: geometry.size.width,
                    contentSize: CGSize(width: geometry.size.width * 2, height: geometry.size.height),
                    leftPercent: self.$leftPercent)
                {
                    HStack(spacing: 0) {
                        PostListView(category: .recommend)
                            .frame(width: geometry.size.width)
                        PostListView(category: .hot)
                            .frame(width: geometry.size.width)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .ignoresSafeArea(edges: .bottom)
            // --- 核心修改点 ---
            .navigationBarHidden(true) // 隐藏系统默认的标题栏
            // 使用自定义的顶部导航栏
            .safeAreaInset(edge: .top) {
                HomeNavigationBar(leftPercent: $leftPercent)
            }
        }
    }
    
}
#Preview {
    HomeView().environmentObject(UserData.testData)
}
