//
//  TwoWayBindingTests.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/25/16.
//  Copyright © 2016 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwiftUtilities
import RxSwift
import RxCocoa
#if os(macOS)
    import Cocoa
    typealias TextView = NSTextView
    extension NSTextView {
        var text: String {
            set { self.string = newValue }
            get { return self.string ?? "" }
        }
    }
#else
    import UIKit
    typealias TextView = UITextView
#endif

class TwoWayBindingTests: XCTestCase {

    func testOverwritesTextViewWithSubjectValue() {
        let textView = TextView()
        textView.text = "overwritten text in text view"
        let variable = Variable<String>("initial subject value")
        
        _ = textView.rx.textInput <-> variable
        
        XCTAssertEqual(variable.value, "initial subject value")
        XCTAssertEqual(textView.text, "initial subject value")
    }
    
    func testTextViewUpdatesSubjectValue() {
        let textView = TextView()
        let variable = Variable<String>("initial subject value")

        _ = textView.rx.textInput <-> variable

        // See comments at the end of the file
        let exp = expectation(description: "correct text")
        _ = variable.asObservable()
            .subscribe(onNext: { text in
                if text == "new text view text" {
                    exp.fulfill()
                }
            })

        textView.text = "new text view text"

        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssertEqual(variable.value, "new text view text")
        XCTAssertEqual(textView.text, "new text view text")
    }

}

/*
 Why XCTestExpectation is being used (unfortunately):
 
 In order to test two-way binding of a UITextInput, we need to
 test a concrete class: UITextField, UITextView, or a custom one.
 Each has their own pros and cons.

 UITextField:
 In order for `textField.rx.textInput.text` to output elements
 while in tests, UIKit needs a bit of manual help. We have to
 perform the control event manually, ie.:
     textField.text = "some next text"
     textField.sendActions(for: UIControlEvents.valueChanged)
 However, not even that works while in tests, so we have to
 *really* do it manually:
     textField.text = "some next text"
     let target = textField.allTargets.first! as NSObject
     let action = textField.actions(forTarget: target,
                                    forControlEvent: .valueChanged)!
                           .first!
     let selector = NSSelectorFromString(action)
     target.perform(selector, with: textField)
 Now UITextField is finally emitting a next element. However,
 there are still problems while in tests. For example,
  `beginningOfDocument` is `nil`. There might be some way to coax
 it further, but it seems like a pretty invasive solution as it is.
 
 UITextView:
 The only issue with `textView.rx.textInput.text` is that it's
 observing on the main queue *asynchronously*. The simplest
 solution, that I see, is to use XCTestExpectation. It's not ideal,
 but it's surely better than the problems posed by `UITextField`.

 Custom class used for tests (something like `TestTextView`):
 The requirements for this protocol are immense. There's a lot
 to implement, and it would thus be much more invasive and brittle.
 
 Note: If someone has any insight or ideas, let me know or submit
 a PR. Maybe there's a way to get `UITextField` to emit simply and
 with correct attributes. Maybe there's a way to more simply handle
 the async behavior that comes with using `UITextView`. ¯\_(ツ)_/¯
*/
