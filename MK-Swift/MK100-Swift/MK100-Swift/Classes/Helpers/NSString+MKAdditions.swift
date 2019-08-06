//
//  NSString+MKAdditions.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/5.
//  Copyright © 2019 txooo. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let str = self.cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str, strLen, result)
        
        var hash = String()
        
        for i in 0..<digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deallocate()
        return hash
    }
}
