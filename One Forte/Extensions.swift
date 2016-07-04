//
//  Extensions.swift
//  One Forte
//
//  Created by Jon Whitmore on 5/22/16.
//  Copyright © 2016 Jon Whitmore. All rights reserved.
//

import UIKit

func colorComponentFrom(string :String, start :Int, length :Int) -> Float {
    return 1.0
}

extension UIColor {
    
    convenience init(withHexString hexString :String) {
        let alpha, red, blue, green :Float
        alpha = 1.0;
        red   = colorComponentFrom(hexString, start: 0, length: 2)
        green = colorComponentFrom(hexString, start: 2, length: 2)
        blue  = colorComponentFrom(hexString, start: 4, length: 2)
        self.init(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
    }
    

    
//    + (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
//    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
//    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
//    unsigned hexComponent;
//    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
//    return hexComponent / 255.0;
 //   }
    
    
}
