//
//  WeiboDemoApp.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/8.
//

import SwiftUI

@main
struct WeiboDemoApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            //项目启动页
            HomeView().environmentObject(UserData())
        }
    }
}
