//
//  SettingsView.swift
//  DirtyJIT
//
//  Created by Анохин Юрий on 05.03.2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var firstTime: Bool
    let jit = JIT.shared
    
    var body: some View {
        List {
            Section(header: Text("Options")) {
                Button("Replace iPhoneDebug.pem") {
                    UIApplication.shared.confirmAlert(title: "Warning", body: "This will replace the default certificate with a custom one to allow mounting the custom DeveloperDiskImage.", onOK: {
                        jit.replaceDebug()
                    }, noCancel: false)
                }
            }
            
            Section {
                Button("Show Instructions again") {
                    firstTime = true
                }
                .foregroundColor(.red)
                .font(.headline.weight(.bold))
                
                Button("Reset All") {
                    UIApplication.shared.confirmAlert(title: "Warning", body: "This means you will reset ALL user data, do you want to continue?", onOK: {
                        UIApplication.shared.alert(title: "Loading", body: "Please wait...", withButton: false)
                        
                        if let bundleID = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }, noCancel: false)
                }
                .foregroundColor(.red)
                .font(.headline.weight(.bold))
            }
            
            Section(header: Text("Credits")) {
                creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/87825638?v=4"), name: "verygenericname", description: "Known as Nathan, big brainer, made the method")
                
                creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/85764897?v=4"), name: "haxi0", description: "Made the app, instructions")
                
                creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/87151697?v=4"), name: "BomberFish", description: "ApplicationManager, app icon")
                
                creditView(imageURL: URL(string: "https://avatars.githubusercontent.com/u/52459150?v=4"), name: "sourcelocation", description: "TextField++")
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func creditView(imageURL: URL?, name: String, description: String) -> some View {
        HStack {
            AsyncImage(url: imageURL, content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 35, maxHeight: 35)
                    .cornerRadius(20)
            }, placeholder: {
                ProgressView()
                    .frame(maxWidth: 35, maxHeight: 35)
            })
            
            VStack(alignment: .leading) {
                Button(name) {
                    if let url = URL(string: "https://github.com/\(name)") {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
