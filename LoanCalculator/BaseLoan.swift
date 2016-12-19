//
//  BaseLoan.swift
//  LoanCalculator
//
//  Created by Kenneth Zhang on 16/9/5.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import Foundation

class BaseLoan {
    
    var year: Int
    var money: Int
    var rate: Double
    var startDate: Date
    
    init(year: Int, money: Int, rate: Double, startDate: Date) {
        self.year = year
        self.money = money
        self.rate = rate
        self.startDate = startDate
    }
    
    func totalMonths() -> Int {
        return year * 12
    }
    
}
