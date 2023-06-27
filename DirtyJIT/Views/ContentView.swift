//
//  ContentView.swift
//  DirtyJIT
//
//  Created by Анохин Юрий on 03.03.2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("firstTime") private var firstTime = true
    @State private var apps: [SBApp] = []
    @State private var searchText = ""
    @State private var presentAlert = false
    
    var body: some View {
        NavigationView {
            AppsView(searchText: $searchText, apps: apps)
                .navigationBarTitle("DirtyJIT", displayMode: .inline)
                .toolbar {
                    Button(action: {
                        if searchText.isEmpty == true {
                            presentAlert = true
                        } else {
                            searchText = ""
                        }
                    }) {
                        if searchText.isEmpty == true {
                            Image(systemName: "magnifyingglass")
                        } else {
                            Image(systemName: "delete.left")
                                .foregroundColor(.red)
                        }
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
        }
        .sheet(isPresented: $firstTime, content: { SetupView() })
        .onAppear {
            UIApplication.shared.alert(title: "Loading", body: "Please wait...", withButton: false)
            
            grant_full_disk_access { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIApplication.shared.dismissAlert(animated: false)
                
                do {
                    apps = try ApplicationManager.getApps()
                } catch {
                    UIApplication.shared.alert(title: "Error", body: error.localizedDescription, withButton: true)
                }
            }
        }
        .textFieldAlert(isPresented: $presentAlert) {
            TextFieldAlert(title: "Enter app name", message: "Search for the app you want to find, make sure you spell it right!", text: Binding($searchText))
        }
    }
}
