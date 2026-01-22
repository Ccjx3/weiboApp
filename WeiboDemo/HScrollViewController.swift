//
//  HScrollViewController.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/14.
//

import SwiftUI

// <>:范性
struct HScrollViewController<Content: View>: UIViewControllerRepresentable {
    let pageWidth: CGFloat
    let contentSize: CGSize
    let content: Content
    @Binding var leftPercent: CGFloat
    
    //构造函数
    init(pageWidth: CGFloat,
         contentSize: CGSize,
         leftPercent: Binding<CGFloat>,
         @ViewBuilder content: () -> Content) {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
        self._leftPercent = leftPercent //构造时给本文件内的_leftPercent赋值
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    /*UIViewControllerRepresentable协议中 规定 必须要实现的两个函数*/
    //实现makeUIViewController
    func makeUIViewController(context: Context) -> some UIViewController {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator // ?看不懂
        context.coordinator.scrollView = scrollView
        
        let vc = UIViewController() // vc是属于UIKit
        vc.view.addSubview(scrollView)
        
        // 将swiftUI的View 添加到 UIkit的 UIViewControler
        let host = UIHostingController(rootView: content)
        vc.addChild(host)
        scrollView.addSubview(host.view)
        host.didMove(toParent: vc)
        context.coordinator.host = host
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let scrollView = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: leftPercent * (contentSize.width - pageWidth), y: 0), animated: true)
        context.coordinator.host.view.frame = CGRect(origin: .zero, size: contentSize)
        
    }
    
    class Coordinator: NSObject,UIScrollViewDelegate {
        let parent: HScrollViewController
        var scrollView: UIScrollView!
        var host: UIHostingController<Content>!
        
        init(_ parent: HScrollViewController) {
            self.parent = parent
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation {
                parent.leftPercent = scrollView.contentOffset.x < parent.pageWidth * 0.5 ? 0 : 1
            }
        }
        
        
    }
}
