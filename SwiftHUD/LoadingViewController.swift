//
//  LoadingViewController.swift
//  SwiftHUD
//
//  Created by yoctech on 2024/1/18.
//

import UIKit

class LoadingViewController: UIViewController {
    
    lazy var types = {
        LoadingIndicatorType.allCases
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let cols = 4
        let cellWidth = view.frame.width / CGFloat(cols)
        let cellHeight = cellWidth
        
        for (idx, type) in types.enumerated() {
            let x = CGFloat(idx % cols) * cellWidth
            let y = CGFloat(idx / cols) * cellHeight + 40
            
            let frame = CGRectMake(x, y, cellWidth, cellHeight)
            let loadingView = LoadingIndicatorView(frame: frame, type: type)
            
            let label = UILabel(frame: .init(x: frame.minX, y: y, width: cellHeight, height: 20))
            label.text = type.typeName
            label.font = .systemFont(ofSize: 11)
            label.adjustsFontSizeToFitWidth = true
            label.allowsDefaultTighteningForTruncation = true
            label.textColor = .white
            label.frame.origin.x += 5
            label.frame.origin.y += cellHeight - label.frame.size.height
            
            loadingView.padding = 20
            view.addSubview(loadingView)
            view.addSubview(label)
            
            loadingView.startAnimation()
        }
    }
}


