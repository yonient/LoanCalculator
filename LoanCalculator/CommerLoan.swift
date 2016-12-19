//
//  CommerLoan.swift
//  LoanCalculator
//
//  Created by Kenneth Zhang on 16/9/5.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import Foundation

class CommerLoan: BaseLoan {
    
    var type: LoanType
    
    init(year: Int, money: Int, rate: Double, type: LoanType, startDate: Date) {
        self.type = type
        super.init(year: year, money: money, rate: rate, startDate: startDate)
    }
    
    func calculateMonthInterest() -> [Int:[Double]] {
        let totalMoney = Double(money) * 10000
        let months = totalMonths()
        let monthRate = rate/1200
        var payment = [Int:[Double]]()
        switch type {
        case .EqualPayment:
            payment[0] = [calculateMonthPayment()]
            let subEra = pow((1+monthRate), Double(months))
            for i in 1...months {
                let monthEra = pow((1+monthRate), Double(i-1))
                let monthInterest = totalMoney * monthRate * (subEra - monthEra) / ( subEra - 1 )
                let monthPrincipal = totalMoney * monthRate * monthEra / ( subEra - 1 )
                payment[i+1] = [monthInterest, monthPrincipal]
            }
            break
        case .EqualPrincipal:
            let monthPrincipal = totalMoney / Double(months)
            payment[0] = [monthPrincipal]
            for i in 1...months {
                let monthPayment = monthPrincipal + (totalMoney - monthPrincipal * Double(i-1)) * monthRate
                let monthInterest = (totalMoney - monthPrincipal * Double(i-1)) * monthRate
                payment[i+1] = [monthPayment, monthInterest]
            }
            break
        }
        return payment
    }
    
    func divideMonth() -> [String] {
        var date = startDate
        var divide = [String]()
        let months = totalMonths()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年MM月"
        switch type {
        case .EqualPayment:
            divide.append("月还款额（元）")
            divide.append("期数")
            break
        case .EqualPrincipal:
            divide.append("月还本金（元）")
            divide.append("期数")
            break
        }
        for i in 1...months {
            let thisMonth: String = "第\(i)期 - " + formatter.string(from: date)
            divide.append(thisMonth)
            date = Date(timeInterval: 2592000, since: date)
        }
        return divide
    }

    func monthsType() -> String {
        switch type {
        case .EqualPayment:
            return "利息/本金（元）"
        case .EqualPrincipal:
            return "还款/利息（元）"
        }
    }
    
    func calculateMonthPayment() -> Double {
        let totalMoney = Double(money) * 10000
        let months = totalMonths()
        let monthRate = rate/1200
        let subEra = pow((1+monthRate), Double(months))
        let monthPayment = totalMoney * monthRate * subEra / ( subEra - 1 )
        return monthPayment
    }
    
    func totalInterest() -> Double {
        let totalMoney = Double(money) * 10000
        let months = totalMonths()
        let monthRate = rate/1200
        var total: Double
        switch type {
        case .EqualPayment:
            total = calculateMonthPayment() * Double(months) - totalMoney
            break
        case .EqualPrincipal:
            let subEra1 = monthRate * (totalMoney / Double(months)) * (Double(months) - 1) / 2
            total = Double(months) * (totalMoney * monthRate - subEra1 + totalMoney / Double(months)) - totalMoney
            break
        }
        return total
    }
    
    func totalPayment() -> Double {
        let totalMoney = Double(money) * 10000
        return totalMoney + totalInterest()
    }
}
