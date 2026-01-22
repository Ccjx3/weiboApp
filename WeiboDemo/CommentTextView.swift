//
//  CommentTextView.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/15.
//

import SwiftUI

/*
将UIkit View封装成SwiftUI的View
*/

struct CommentTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    let beginEdittingOnAppear: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.backgroundColor = .systemGray6
        view.font = .systemFont(ofSize: 18)
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = context.coordinator
        view.text = text
        
        // 💡 修改点 3：设置键盘收回模式为“交互式” (interactive)
        //这就是解决你说的“滑动不一致”的关键：它允许用户通过向下滑动文字内容来同步收起键盘
        view.keyboardDismissMode = .interactive
        
        // 💡 修改点 4：设置键盘随拖拽消失
        // 如果你想让它更像微博，这行代码必不可少
        view.alwaysBounceVertical = true // 即使内容不多也能产生滑动效果，触发键盘收起
        
        //调整减速速率
        view.isScrollEnabled = true
        // 💡 修改点 5：自动弹出键盘
        // 这样进入评论页面时，键盘会直接弹起，不需要手动点一下
        view.becomeFirstResponder()
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        //功能：只要第一次点开评论的时候才自动进入编辑状态，否则则由拖动控制
        if  beginEdittingOnAppear,
            !context.coordinator.disBecomeFirstResponder,
            uiView.window != nil,
            !uiView.isFirstResponder { //并且当前不是第一响应者
                uiView.becomeFirstResponder()
                context.coordinator.disBecomeFirstResponder = true
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CommentTextView
        var disBecomeFirstResponder: Bool = false
        init(_ view: CommentTextView) { parent = view }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

#Preview {
    CommentTextView(text: .constant(""), beginEdittingOnAppear: true)
}
