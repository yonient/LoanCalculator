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

class MixedLaonViewController: UIViewController {
    
    var infoTableView: UITableView!
    var commerLoan: CommerLoan!
    var fundLoan: FundLoan!
    var mixedLoan: MixedLoan!
    var dataSource: [String] = ["公积金贷款总额(万元)","公积金贷款时长(年)","公积金贷款利率(%)","商业贷款总额(万元)","商业贷款时长(年)","商业贷款利率(%)","商业贷款利率倍数","起始时间","还款类型"]
    var dataSource2: [String] = ["还款总额（元）","利息总额（元）"]
    var dataSource3: [String] = [String]()
    var tableData: [[String]] = [[String]]()
    var loanTypeSegment: UISegmentedControl!
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "混合贷款"
        
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
        for i in 0...6 {
            cellPath.append(IndexPath(row: i, section: 0))
        }
        for i in 0...6 {
            cell.append((infoTableView.cellForRow(at: cellPath[i]) as? LoanInfoTableViewCell)!)
        }
        fundLoan = FundLoan(year: Int(cell[1].infoInput.text!)!, money: Int(cell[0].infoInput.text!)!, rate:  Double(cell[2].infoInput.text!)!, type: getLoanTypeFromSegment(), startDate: datePicker.date)
        commerLoan = CommerLoan(year: Int(cell[4].infoInput.text!)!, money: Int(cell[3].infoInput.text!)!, rate: Double(cell[5].infoInput.text!)! * Double(cell[6
            ].infoInput.text!)!, type: getLoanTypeFromSegment(), startDate: datePicker.date)
        mixedLoan = MixedLoan(fund: fundLoan, commer: commerLoan)
        if tableData.count > 1 {
            fundLoan = FundLoan(year: Int(cell[1].infoInput.text!)!, money: Int(cell[0].infoInput.text!)!, rate:  Double(cell[2].infoInput.text!)!, type: getLoanTypeFromSegment(), startDate: datePicker.date)
            commerLoan = CommerLoan(year: Int(cell[4].infoInput.text!)!, money: Int(cell[3].infoInput.text!)!, rate: Double(cell[5].infoInput.text!)! * Double(cell[6
                ].infoInput.text!)!, type: getLoanTypeFromSegment(), startDate: datePicker.date)
            mixedLoan = MixedLoan(fund: fundLoan, commer: commerLoan)
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
            mixedLoan.commer.type = getLoanTypeFromSegment()
            mixedLoan.fund.type = getLoanTypeFromSegment()
            dataSource3 = commerLoan.divideMonth()
            infoTableView.reloadData()
        }
    }
    
    func getLoanTypeFromSegment() ->  LoanType {
        if loanTypeSegment.selectedSegmentIndex == 0 {
            return .EqualPayment
        }
        return .EqualPrincipal
    }
    
    func updateDatePicker(sender: AnyObject) {
        let dateCellPath: IndexPath = IndexPath(row: 7, section: 0)
        let dateCell = infoTableView.cellForRow(at: dateCellPath) as? LoanInfoTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年MM月"
        let startMonth = dateFormatter.string(from: datePicker.date)
        dateCell?.infoInput.text = startMonth
    }
}

extension MixedLaonViewController: UITableViewDelegate {
    
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

extension MixedLaonViewController: UITableViewDataSource {
    
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
            if indexPath.row == tableData[indexPath.section].count - 1 {
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
                    if indexPath.row == 6 {
                        cell?.infoInput.text = "1"
                    }
                    Alamofire.request("http://yzo.me/rate.php").responseJSON { response in
                        if let jsonDic = response.result.value as? NSDictionary {
                            if indexPath.row == 5 {
                                let commerRate = jsonDic.object(forKey: "commercial") as? NSDictionary
                                cell?.infoInput.text = "\(commerRate?.object(forKey: "最新利率") as! Double)"
                            } else if indexPath.row == 2 {
                                let commerRate = jsonDic.object(forKey: "fund") as? NSDictionary
                                cell?.infoInput.text = "\(commerRate?.object(forKey: "最新利率") as! Double)"
                            }
                        }
                    }
                    if indexPath.row == 7 {
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
            let monthsPayment = mixedLoan.calculateMonthInterest()
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
                cell?.info.text = String(format: "%.2f", mixedLoan.totalPayment())
                break
            case 1:
                cell?.info.text = String(format: "%.2f", mixedLoan.totalInterest())
                break
            default:
                break
            }
            
            return cell!
        }
    }
    
}

extension MixedLaonViewController: UITextFieldDelegate {
    
    func dismissKeyBoard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 6 {
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
