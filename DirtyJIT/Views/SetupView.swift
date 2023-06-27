//  SetupView.swift
//  DirtyJIT
//
//  Created by Yuri Anokhin on 03.03.2023.
// ty ChatGPT

import SwiftUI

struct SetupView: View {
    @Environment(\.dismiss) var dismiss
    let jit = JIT.shared
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Welcome!")) {
                    Text("DirtyJIT is an app that enables JIT by exploiting the MacDirtyCow (CVE-2022-46689) vulnerability in macOS, which also works on iOS. It can be used with apps, emulators, or any software that requires JIT (e.g., PojavLauncher, DolphiniOS). Follow these setup steps to use this app on your device.")
                }
                
                Section(header: Text("Step 1")) {
                    Text("Download the latest .zip file from the link below then extract the contents to a place you like. We will need this later.")
                    Button("Go to Link") {
                        UIApplication.shared.open(URL(string: "https://github.com/haxi0/WDBDDISSH/releases")!)
                    }
                    .buttonStyle(LinkButtonStyle())
                }
                
                Section(header: Text("Step 2")) {
                    Text("Download the file from the link below. It should appear in Settings. Install it, disconnect your phone from your PC if you haven't yet and then reboot your device.")
                    Button("Install Profile") {
                        UIApplication.shared.open(URL(string: "https://cdn.discordapp.com/attachments/985930068188602394/1081214719534301255/cert.pem")!)
                    }
                    .buttonStyle(LinkButtonStyle())
                }
                
                Section(header: Text("Step 3")) {
                    Text("After rebooting, press the button below to replace iPhoneDebug.pem with cert.pem. Make sure you are NOT connected to a PC!")
                    Button("Replace File") {
                        jit.replaceDebug()
                    }
                    .buttonStyle(DangerButtonStyle())
                }
                
                Section(header: Text("Step 4")) {
                    Text("After replacing the file, connect your device to your PC. Run the commands below to mount the image from the first step (The correct developer disk image should match your iOS version, for example the folder that ends with 16.1 matches for iOS versions 16.1, 16.1.1, 16.1.2). Make sure you have ideviceimagemounter installed and you are in the folder where you downloaded those files. If the commands don't work, disconnect and reboot your phone, replace the certificate again, and then try again (Step 3).")
                    VStack {
                        Text("ideviceimagemounter DeveloperDiskImageModified_YourVersionHere.dmg DeveloperDiskImageModified_YourVersionHere.dmg.signature")
                            .font(.custom("Menlo", size: 15))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .textSelection(.enabled)
                    .background (
                        Color.black
                            .cornerRadius(5)
                    )
                }
                
                Section(header: Text("Step 5")) {
                    Text("Congratulations! If you haven't encountered any errors, you have finished the setup. Please note that after rebooting, you still need to repeat steps 3 and 4. Otherwise, you are good to go and you can click the dismiss button. If you have any questions or encountered some errors, ask for help in our Discord server.")
                    Button("Go to Discord Server") {
                        UIApplication.shared.open(URL(string: "https://dsc.gg/haxi0sm")!)
                    }
                    .buttonStyle(LinkButtonStyle())
                }
            }
            .navigationTitle("Setup")
            .environment(\.defaultMinListRowHeight, 50)
        }
        .interactiveDismissDisabled()
        
        Button("Dismiss") {
            close()
        }
        .buttonStyle(DangerButtonStyle())
        .padding()
    }

    func close() {
        dismiss()
    }
}
