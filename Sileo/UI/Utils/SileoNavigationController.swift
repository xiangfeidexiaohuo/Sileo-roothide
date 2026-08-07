//
//  SileoNavigationController.swift
//  Sileo
//
//  Created by CoolStar on 7/27/20.
//  Copyright © 2022 Sileo Team. All rights reserved.
//

import Foundation

class SileoNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        viewControllers.last
    }

    public var rootViewController: UIViewController?

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.rootViewController = rootViewController
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 强制 navigationBar 尊重 safe area 边距
        navigationBar.insetsLayoutMarginsFromSafeArea = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 确保每次布局后都设置 layoutMargins
        if navigationBar.layoutMargins.left < 16 {
            navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        // 递归查找大标题视图并调整位置
        adjustLargeTitlePosition(in: navigationBar)
    }

    private func adjustLargeTitlePosition(in view: UIView) {
        for subview in view.subviews {
            // 大标题容器视图的类名包含 "LargeTitle"
            let className = String(describing: type(of: subview))
            if className.contains("LargeTitle") {
                // 在大标题容器中设置 layoutMargins
                if subview.layoutMargins.left < 16 {
                    subview.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                }
                // 同时也检查其中的 UILabel
                adjustLargeTitleLabel(in: subview)
            }
            adjustLargeTitlePosition(in: subview)
        }
    }

    private func adjustLargeTitleLabel(in view: UIView) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                // 大标题字体通常 >= 24pt
                if label.font.pointSize >= 24 {
                    if label.frame.minX < 16 {
                        label.frame.origin.x = 16
                    }
                }
            }
            adjustLargeTitleLabel(in: subview)
        }
    }
}
