//
//  JIT.swift
//  DirtyJIT
//
//  Created by Анохин Юрий on 03.03.2023.
//

import Foundation
import UIKit

class JIT {
    static var shared = JIT()
    
    func replaceDebug() {
        do {
            let fileData = try Data(contentsOf: Bundle.main.url(forResource: "cert", withExtension: "pem")!)
            overwriteFileWithDataImpl(originPath: "/System/Library/Lockdown/iPhoneDebug.pem", backupName: "iPhoneDebug.pem", replacementData: fileData)
            UIApplication.shared.alert(title: "Done", body: "Successfully replaced the certificate, you may safely connect your phone to your PC now.", withButton: true)
        } catch {
            UIApplication.shared.alert(title: "Error", body: "Failed to replace iPhoneDebug.pem with the cert.pem!", withButton: true)
        }
    }
    
    func getPIDplist(bundleID: String) -> Int? {
        let plistPath = "/var/mobile/Library/Preferences/com.apple.dasd.dock.persistence.plist"
        
        guard let plistData = FileManager.default.contents(atPath: plistPath),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: nil) as? [String: Any],
              let applicationProcessIdentifiers = plist["applicationProcessIdentifiers"] as? [String: Int],
              let key = applicationProcessIdentifiers.keys.first(where: { $0 == bundleID }),
              let value = applicationProcessIdentifiers[key]
        else {
            return nil
        }
        
        return value
    }
    
    func bundleIDCheck(_ string: String) -> Bool {
        let dotCount = string.components(separatedBy: ".").count - 1
        return dotCount > 2
    }

    
    func enableJIT(pidApp: String) {
        let pid = pidApp
        let args: [String] = [pid]
        let argc = args.count
        
        let argv = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: argc + 1)
        defer {
            argv.deallocate()
        }
        
        for i in 0 ..< argc {
            argv[i+1] = strdup(args[i])
        }
        
        jit(Int32(argc+1), argv)
    }
}
