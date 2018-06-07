//
//  FSCalendarRangeSelectionCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FSCalendar

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class FSCalendarRangeSelectionCell: FSCalendarCell {

    weak var selectionLayer: CAShapeLayer!

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.white.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        if let titleLabel = self.titleLabel {
            self.contentView.layer.insertSublayer(selectionLayer, below: titleLabel.layer)
        }
        self.selectionLayer = selectionLayer

        self.shapeLayer.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundView?.frame = self.bounds//.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds

        if selectionType == .middle {//&& false {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {//}&& false {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {//}&& false {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {//}|| (true && selectionType != .none) {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }

}


