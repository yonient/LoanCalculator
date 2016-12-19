//
//  TabBarController.swift
//  LoanCalculator
//
//  Created by Kenneth Zhang on 16/9/4.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import UIKit

class LoanTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let commerLoan = CommerLoanViewController()
        let commerNav = UINavigationController(rootViewController: commerLoan)
        
        let fundLoan = FundLoanViewController()
        let fundNav = UINavigationController(rootViewController: fundLoan)
        
        let mixedLoan = MixedLaonViewController()
        let mixedNav = UINavigationController(rootViewController: mixedLoan)
        
        commerNav.tabBarItem = UITabBarItem(title: "商业贷款", image: #imageLiteral(resourceName: "commercial"), tag: 0)
        fundNav.tabBarItem = UITabBarItem(title: "公积金贷款", image: #imageLiteral(resourceName: "fund"), tag: 1)
        mixedNav.tabBarItem = UITabBarItem(title: "组合贷款", image: #imageLiteral(resourceName: "mixed"), tag: 2)
        
        self.viewControllers = [commerNav, fundNav, mixedNav]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
