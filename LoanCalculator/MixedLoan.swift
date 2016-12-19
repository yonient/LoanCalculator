//
//  MixedLoan.swift
//  LoanCalculator
//
//  Created by Kenneth Zhang on 2016/9/12.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import Foundation

class MixedLoan {
    
    var fund : FundLoan
    var commer: CommerLoan
    
    init(fund: FundLoan, commer: CommerLoan) {
        self.fund = fund
        self.commer = commer
    }
    
    func calculateMonthInterest() -> [Int:[Double]] {
        let fundMonthInterest = fund.calculateMonthInterest()
        let commerMonthInterest = commer.calculateMonthInterest()
        var payment = [Int:[Double]]()
        payment[0] = [0,0]
        payment[0]?[0] = (fundMonthInterest[0]?[0])! + (commerMonthInterest[0]?[0])!
        if commer.totalMonths() >= fund.totalMonths() {
            for i in 1...fund.totalMonths() {
                payment[i+1] = [0,0]
                payment[i+1]?[0] = (fundMonthInterest[i+1]?[0])! + (commerMonthInterest[i+1]?[0])!
                payment[i+1]?[1] = (fundMonthInterest[i+1]?[1])! + (commerMonthInterest[i+1]?[1])!
            }
        }
        if commer.totalMonths() >= fund.totalMonths()+1 {
            for i in fund.totalMonths()+1...commer.totalMonths() {
                payment[i+1] = commerMonthInterest[i+1]
            }
        }
        return payment
    }
    
    func calculateMonthPayment() -> Double {
        return fund.calculateMonthPayment() + commer.calculateMonthPayment()
    }
    
    func totalInterest() -> Double {
        return fund.totalInterest() + commer.totalInterest()
    }
    
    func totalPayment() -> Double {
        return fund.totalPayment() + commer.totalPayment()
    }

}
