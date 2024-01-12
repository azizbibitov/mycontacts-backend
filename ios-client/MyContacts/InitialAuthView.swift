//
//  InitialAuthView.swift
//  MyContacts
//
//  Created by Aziz Bibitov on 06.01.2024.
//

import SwiftUI

struct InitialAuthView: View {
    
    @AppStorage("authToken") var authToken: String = ""
    
    var body: some View {
        if authToken.isEmpty {
            LoginRegistrationView()
        }else{
            MainTabView()
        }
    }
}
