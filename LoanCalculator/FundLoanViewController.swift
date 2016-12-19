//
//  CommerLoanViewController.swift
//  LoanCalculator
//
//  Created by Kenneth Zhang on 16/9/4.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class FundLoanViewController: UIViewController {
    
    var infoTableView: UITableView!
    var commerLoan: FundLoan!
    var dataSource: [String] = ["贷款总额(万元)","贷款时长(年)","起始时间","贷款利率(%)","还款类型"]
    var dataSource2: [String] = ["还款总额（元）","利息总额（元）"]
    var dataSource3: [String] = [String]()
    var tableData: [[String]] = [[String]]()
    var loanTypeSegment: UISegmentedControl!
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "公积金贷款"
        
        tableData.append(dataSource)
        
        infoTableView = UITableView(frame: CGRect(), style: .grouped)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        self.view.addSubview(self.infoTableView)
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(20)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.centerX.equalTo(self.view)
        }
        infoTableView.allowsSelection = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculate() {
        var cellPath: [IndexPath] = [IndexPath]()
        var cell: [LoanInfoTableViewCell] = [LoanInfoTableViewCell]()
        for i in 0...3 {
            cellPath.append(IndexPath(row: i, section: 0))
        }
        for i in 0...3 {
            cell.append((infoTableView.cellForRow(at: cellPath[i]) as? LoanInfoTableViewCell)!)
        }
        commerLoan = FundLoan(year: Int(cell[1].infoInput.text!)!, money: Int(cell[0].infoInput.text!)!, rate: Double(cell[3].infoInput.text!)!, type: getLoanTypeFromSegment(), startDate: datePicker.date)
        if tableData.count > 1 {
            commerLoan = FundLoan(year: Int(cell[1].infoInput.text!)!, money: Int(cell[0].infoInput.text!)!, rate: Double(cell[3].infoInput.text!)!, type: getLoanTypeFromSegment(), startDate: datePicker.date)
            infoTableView.reloadData()
        } else {
            infoTableView.beginUpdates()
            infoTableView.insertSections([tableData.count], with: UITableViewRowAnimation.automatic)
            tableData.append(dataSource2)
            infoTableView.insertSections([tableData.count], with: UITableViewRowAnimation.automatic)
            dataSource3 = commerLoan.divideMonth()
            tableData.append(dataSource3)
            infoTableView.endUpdates()
        }
    }
    
    func changeLoanType() {
        if tableData.count > 1 {
            commerLoan.type = getLoanTypeFromSegment()
            dataSource3 = commerLoan.divideMonth()
            infoTableView.reloadData()
        }
    }
    
    func getLoanTypeFromSegment() -> LoanType {
        if loanTypeSegment.selectedSegmentIndex == 0 {
            return .EqualPayment
        }
        return .EqualPrincipal
    }
    
    func updateDatePicker(sender: AnyObject) {
        let dateCellPath: IndexPath = IndexPath(row: 2, section: 0)
        let dateCell = infoTableView.cellForRow(at: dateCellPath) as? LoanInfoTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年MM月"
        let startMonth = dateFormatter.string(from: datePicker.date)
        dateCell?.infoInput.text = startMonth
    }
}

extension FundLoanViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let contentView = UIView()
        if section == 0 {
            let calculateButton = UIButton()
            calculateButton.setTitle("计算", for: .normal)
            calculateButton.setTitleColor(.white, for: .normal)
            calculateButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
            contentView.addSubview(calculateButton)
            calculateButton.snp.makeConstraints { make in
                make.centerX.equalTo(contentView)
                make.centerY.equalTo(contentView)
                make.width.equalTo(100)
            }
            calculateButton.backgroundColor = UIColor(red: 46/255, green: 169/255, blue: 223/255, alpha: 1)
            calculateButton.layer.cornerRadius = 5
            calculateButton.layer.masksToBounds = true
        }
        return contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 15
    }
    
}

extension FundLoanViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cellReuseIdentifier = "LabelCell"
            if indexPath.row == 4 {
                var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
                    cell?.textLabel?.text = "\(tableData[indexPath.section][indexPath.row])"
                    loanTypeSegment = UISegmentedControl(items: ["等额本息","等额本金"])
                    loanTypeSegment.selectedSegmentIndex = 0
                    loanTypeSegment.addTarget(self, action: #selector(changeLoanType), for: .valueChanged)
                    cell?.accessoryView = loanTypeSegment
                }
                return cell!
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LoanInfoTableViewCell
                if cell == nil {
                    cell = LoanInfoTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
                    cell?.textLabel?.text = "\(tableData[indexPath.section][indexPath.row])"
                    cell?.infoInput.tag = indexPath.row
                    cell?.infoInput.delegate = self
                    cell?.infoInput.keyboardType = .decimalPad
                    if indexPath.row == 3 {
                        Alamofire.request("http://yzo.me/rate.php").responseJSON { response in
                            if let jsonDic = response.result.value as? NSDictionary {
                                let commerRate = jsonDic.object(forKey: "fund") as? NSDictionary
                                let latestRate = commerRate?.object(forKey: "最新利率") as! Double
                                print(latestRate)
                                cell?.infoInput.text = "\(latestRate)"
                            }
                        }
                    }
                    if indexPath.row == 2 {
                        datePicker = UIDatePicker()
                        let locale = Locale(identifier: "zh_CN")
                        datePicker.locale = locale
                        datePicker.datePickerMode = .date
                        datePicker.addTarget(self, action: #selector(updateDatePicker), for: .valueChanged)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY年MM月"
                        cell?.infoInput.text = dateFormatter.string(from: datePicker.date)
                        cell?.infoInput.inputView = datePicker
                    }
                }
                return cell!
            }
        case 2 :
            let cellReuseIdentifier = "LabelCell3"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LoanCalculateTableViewCell
            if cell == nil {
                cell = LoanCalculateTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
            }
            let monthsPayment = commerLoan.calculateMonthInterest()
            cell?.textLabel?.text = dataSource3[indexPath.row]
            cell?.textLabel?.font = UIFont(name: "Helvetica-Light", size: 15)
            if indexPath.row > 1 {
                cell?.info.text = String(format: "%.2f", (monthsPayment[indexPath.row]?[0])!) + "/" + String(format: "%.2f", (monthsPayment[indexPath.row]?[1])!)
            } else if indexPath.row == 1 {
                cell?.info.text = commerLoan.monthsType()
            } else {
                cell?.info.text = String(format: "%.2f", (monthsPayment[indexPath.row]?[0])!)
            }
            return cell!
        default :
            let cellReuseIdentifier = "LabelCell2"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LoanCalculateTableViewCell
            if cell == nil {
                cell = LoanCalculateTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
            }
            cell?.textLabel?.text = "\(tableData[indexPath.section][indexPath.row])"
            switch indexPath.row {
            case 0:
                cell?.info.text = String(format: "%.2f", commerLoan.totalPayment())
                break
            case 1:
                cell?.info.text = String(format: "%.2f", commerLoan.totalInterest())
                break
            default:
                break
            }
            
            return cell!
        }
    }
    
}

extension FundLoanViewController: UITextFieldDelegate {
    
    func dismissKeyBoard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 4 {
            if string.characters.count == 0 {
                return true
            }
            let text: NSString = (textField.text ?? "") as NSString
            let result = text.replacingCharacters(in: range, with: string)
            let inputPattern = "^[0,1].?[0-9]*$"
            let regex = NSPredicate(format: "SELF MATCHES %@", inputPattern)
            return regex.evaluate(with: result)
        }
        return true
    }

}
