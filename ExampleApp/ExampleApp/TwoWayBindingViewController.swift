//
//  TwoWayBindingViewController.swift
//  ExampleApp
//
//  Created by Jesse Farless on 11/29/16.
//  Copyright © 2016 RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftUtilities
import RxCocoa

class TwoWayBindingViewController : UITableViewController {

    @IBOutlet weak var textFieldCell: TwoWayBindingTextFieldCell!
    @IBOutlet weak var subjectCell: TwoWayBindingTextFieldWithButtonCell!
    
    private let disposeBag = DisposeBag()
    private let variable = Variable("initial Subject value")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Two-way bind the UITextField and the Variable
        _ = textFieldCell.textField.rx.textInput <-> variable

        // Update the Variable's UITextField
        variable.asDriver()
            .drive(subjectCell.textField.rx.text)
            .addDisposableTo(disposeBag)

        // Finalize and save new Variable value when user taps button
        subjectCell.button.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let text = self?.subjectCell.textField.text else { return }
                self?.variable.value = text
            })
            .addDisposableTo(disposeBag)
    }
    
}
