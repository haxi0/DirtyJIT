//
//  AppsView.swift
//  DirtyJIT
//
//  Created by Анохин Юрий on 05.03.2023.
//

import SwiftUI

struct AppsView: View {
    @Binding var searchText: String
    let apps: [SBApp]
    let appsManager = ApplicationManager.shared
    let jit = JIT.shared
    
    var body: some View {
        List(apps.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { app in
            HStack {
                if let image = UIImage(contentsOfFile: app.bundleURL.appendingPathComponent(app.pngIconPaths.first ?? "").path) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .cornerRadius(10)
                } else {
                    Image("DefaultIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    Text(app.name)
                        .font(.headline)
                    
                    Text(app.bundleIdentifier)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .onTapGesture {
                let title = "We will now try to enable JIT on \(app.name) ⚠️"
                let message = "Make sure you replaced the iPhoneDebug.pem (in Settings), mounted the developer disk image, the app is opened in the background so we can find its PID, and is signed with a free developer certificate!"
                let onOK: () -> Void = {
                    UIApplication.shared.alert(title: "Please wait", body: "Enabling JIT...", withButton: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIApplication.shared.dismissAlert(animated: false)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // free dev acc checker
                            if !jit.bundleIDCheck(app.bundleIdentifier) {
                                UIApplication.shared.confirmAlert(title: "Uh-oh! ⚠️", body: "While enabling JIT on the app there appeared to be less than 3 dots. This could mean that the app was signed not using a free developer certificate (AltStore, Sideloadly), which will lead to a crash and you won't have JIT enabled on the app. Do you want to continue?", onOK: {
                                    jit.enableJIT(pidApp: String(jit.getPIDplist(bundleID: app.bundleIdentifier)!))
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        appsManager.openApp(app.bundleIdentifier)
                                    }
                                }, noCancel: false)
                                print("AAA OH NO!!!!!!")
                            } else {
                                jit.enableJIT(pidApp: String(jit.getPIDplist(bundleID: app.bundleIdentifier)!))
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    appsManager.openApp(app.bundleIdentifier)
                                }
                            }
                        }
                    }
                }
                UIApplication.shared.confirmAlert(title: title, body: message, onOK: onOK, noCancel: false)
            }
        }
        .environment(\.defaultMinListRowHeight, 50)
    }
}

