//
//  Extensions.swift
//  NetflixClone
//
//  Created by John Erick Santos on 3/6/2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
