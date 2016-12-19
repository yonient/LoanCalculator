//
//  LoanInfoTableViewCell.swift
//  LoanCalculator
//
//  Created by Kenneth Zhang on 2016/9/9.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import UIKit
import SnapKit

class LoanInfoTableViewCell: UITableViewCell {

    var infoInput: UITextField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(infoInput)
        infoInput.snp.makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(self.contentView).dividedBy(2.8)
            make.height.equalTo(self.contentView).dividedBy(1.7)
        }
        infoInput.textAlignment = .right
        infoInput.borderStyle = .roundedRect
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
