//
//  LongWeekEndTableCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class LongWeekEndTableCell: UITableViewCell {

    var holidays = [Holiday]() {
        didSet {
            longWeekEndTableView.reloadData()
        }
    }

    @IBOutlet weak var longWeekEndTableView: UITableView!
    @IBOutlet weak var shadowView: OuterShadowView!

    override func awakeFromNib() {
        super.awakeFromNib()

        longWeekEndTableView.dataSource = self
        longWeekEndTableView.delegate = self

        shadowView.innerView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }
}

extension LongWeekEndTableCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (holidays.count + 2)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekEndTopDecorationTableCell", for: indexPath) as? WeekEndTopDecorationTableCell else {
                fatalError("WeekEndTopDecorationTableCell not found")
            }

            return cell
        }

        if indexPath.row == (holidays.count + 1) {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekEndBottomDecorationTableCell", for: indexPath) as? WeekEndBottomDecorationTableCell else {
                fatalError("WeekEndBottomDecorationTableCell not found")
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekEndTableCell", for: indexPath) as? WeekEndTableCell else {
            fatalError("WeekEndTableCell not found")
        }

        cell.populate(with: holidays[(indexPath.row - 1)])
        return cell
    }
}

extension LongWeekEndTableCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(forRowAt: indexPath)
    }

    private func height(forRowAt indexPath: IndexPath) -> CGFloat {
        if [0, (holidays.count + 1)].contains(indexPath.row) {
            return CGFloat(WeekEndTopDecorationTableCell.cellHeight)
        }
        return CGFloat(WeekEndTableCell.cellHeight)
    }
}
