//
//  PageControl.swift
//  PageControl
//
//  Created by Guang Lei on 2019/4/29.
//  Copyright © 2019 Guang Lei. All rights reserved.
//

import UIKit
import SnapKit

class PageControl: UIView {
    
    var titles: [String] = [] {
        didSet {
            clearUI()
            loadUI()
        }
    }
    var selectedColor = UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var unselectedColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    var selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    var unselectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    var bottomLineHeight = 3
    var bottomLineCornerRadius: CGFloat = 2
    var bottomLineBottomMargin = 4
    var selectedIndex = 0 {
        didSet {
            updateUI()
        }
    }
    
    var indexChanged: ((Int) -> Void)?
    
    private var stackView = UIStackView()
    private var buttons: [UIButton] = []
    private var bottomLine = UIView()
    
    private var bottomLineWidthConstraint: Constraint?
    private var bottomLineCenterXConstraint: Constraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func updateUI() {
        guard !buttons.isEmpty else {
            return
        }
        UIView.performWithoutAnimation {
            for (index, button) in buttons.enumerated() {
                if index == selectedIndex {
                    button.setTitleColor(selectedColor, for: .normal)
                } else {
                    button.setTitleColor(unselectedColor, for: .normal)
                }
            }
            layoutIfNeeded()
        }
        
        bottomLineWidthConstraint?.deactivate()
        bottomLineCenterXConstraint?.deactivate()
        bottomLine.snp.makeConstraints { (make) in
            bottomLineWidthConstraint = make.width.equalTo(buttons[selectedIndex].titleLabel?.snp.width ?? 0).constraint
            bottomLineCenterXConstraint = make.centerX.equalTo(buttons[selectedIndex].snp.centerX).constraint
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    private func loadUI() {
        guard !titles.isEmpty else {
            return
        }
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        bottomLine.backgroundColor = selectedColor
        bottomLine.layer.cornerRadius = bottomLineCornerRadius
        addSubview(bottomLine)
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(bottomLineHeight)
            make.bottom.equalToSuperview().offset(-bottomLineBottomMargin)
            self.bottomLineWidthConstraint = make.width.equalTo(buttons[selectedIndex].titleLabel?.snp.width ?? 0).constraint
            self.bottomLineCenterXConstraint = make.centerX.equalTo(buttons[selectedIndex].snp.centerX).constraint
        }
    }
    
    private func clearUI() {
        buttons.removeAll()
        for button in buttons {
            button.removeFromSuperview()
        }
        selectedIndex = 0
    }
    
    @objc private func clickButton(_ button: UIButton) {
        if let clickedIndex = buttons.firstIndex(of: button) {
            let oldSelectedIndex = selectedIndex
            selectedIndex = clickedIndex
            if oldSelectedIndex != selectedIndex {
                indexChanged?(selectedIndex)
            }
        }
    }
}
