//
//  UIFont+preferredBoldFont.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/21/22.
//

import Foundation
import UIKit

extension UIFont {
	// UIFont.preferredFont(forTextStyle:) but bold!
	static func preferredBoldFont(forTextStyle: UIFont.TextStyle) -> UIFont {
		let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: forTextStyle)
		
		return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor, size: 0.0)
	}
}
