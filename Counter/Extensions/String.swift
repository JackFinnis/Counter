//
//  String.swift
//  Counter
//
//  Created by Jack Finnis on 20/05/2023.
//

import Foundation

extension String {
    var urlEncoded: String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
