//
//  HomeNavigationBar.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/12.
//

import SwiftUI

private let kLableWidth: CGFloat = 60
private let kButtonHeight: CGFloat = 24

struct HomeNavigationBar: View {
    @Binding var leftPercent: CGFloat //0 for Left , 1 for Right
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Button (action: {
                print("Click camera button")
            }) {
                Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: kButtonHeight , height: kButtonHeight)
                        .padding(.horizontal , 15)
                        .padding(.top , 5)
                        .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack(spacing: 3) {
                HStack(spacing: 0) {
                    Text("推荐")
                        .bold()
                        .frame(width: kLableWidth , height: kButtonHeight)
                        .padding(.top, 5)
                        .opacity(Double(1 - leftPercent * 0.5))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.leftPercent = 0
                            }
                        }
                    
                    Spacer()
                    
                    Text("热门")
                        .bold()
                        .frame(width: kLableWidth , height: kButtonHeight)
                        .padding(.top, 5)
                        .opacity(Double(0.5 + leftPercent*0.5))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.leftPercent = 1
                            }
                        }
                    
                }
                .font(.system(size: 20))
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.orange)
                        .frame(width: 30, height: 4)
                        // --- 补充下面这一行逻辑 ---
                        // 默认在左边，我们要先让它移动到这个 GeometryReader 的中心，再应用你的 offset 逻辑
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        // -----------------------
                        .offset(x: geometry.size.width * (self.leftPercent - 0.5) + kLableWidth * (0.5 - self.leftPercent))
                }
                .frame(height: 6)
            }
            .frame(width: UIScreen.main.bounds.width * 0.5)//Vstack宽度
            
            Spacer()
            
            Button (action: {
                print("Click add button")
            }) {
                Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: kButtonHeight , height: kButtonHeight)
                        .padding(.horizontal , 15)
                        .padding(.top , 5)
                        .foregroundColor(.orange)
            }
            
        }
        .frame(width: UIScreen.main.bounds.width)
    }

}

#Preview {
    HomeNavigationBar(leftPercent: .constant(0))
}
