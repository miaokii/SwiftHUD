//
//  HUD+Loading.swift
//  SwiftHUD
//
//  Created by yoctech on 2024/1/18.
//

import UIKit

extension HUD {
    class func loading(type: LoadingIndicatorType = .lineSpinFadeLoader, title: String? = nil, detail: String? = nil, onView: UIView? = nil) {
        
        let loadingView = LoadingIndicatorView.init(frame: .init(x: 0, y: 0, width: 30, height: 30), type: type)
        loadingView.startAnimation()
        HUD.show(.labelCustomView(view: loadingView, title: title, detail: detail), onView: onView)
    }
}
