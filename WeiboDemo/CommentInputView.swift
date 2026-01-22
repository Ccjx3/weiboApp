//
//  CommentInputView.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/15.
//

import SwiftUI

struct CommentInputView: View {
    let post:Post
    
    //创建一个属性，从environment中，取出presentationMode的信息
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userData: UserData
    
//    @ObservedObject private var keyboardPesonder = KeyboardResponder()
    
    @State private var text: String = ""
    
    @State private var showEmptyTextHUD: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CommentTextView(text: $text, beginEdittingOnAppear: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 0) {
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("取消").padding()
                }
                
                Spacer()
                
                Button {//trimmingXXX过滤文本输入的空白和回车
                    if self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        self.showEmptyTextHUD = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showEmptyTextHUD = false
                        }
                        return
                    }
                    print(self.text)
                    var post = self.post
                    post.commentCount += 1
                    self.userData.update(post)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("发送").padding()
                }
            }
            .font(.system(size: 18))
            .foregroundColor(.black)
        }
        .overlay {	
            Text("评论不能为空")
                .scaleEffect(showEmptyTextHUD ? 1 : 0.5)
                .animation(.easeInOut)
                .opacity(showEmptyTextHUD ? 1 : 0)
                .animation(.spring(dampingFraction: 0.5))
        }
    }
}

#Preview {
    CommentInputView(post: UserData.testData.recommendPostList.list[0])
}
