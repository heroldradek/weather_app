//
//  SectionTableViewCell.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }

    func setupUI(with title: String) {
        sectionLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sectionLabel.text = nil
    }
}
