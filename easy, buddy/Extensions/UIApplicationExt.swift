//
//  UIApplication.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
