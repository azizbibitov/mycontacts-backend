//
//  MainTabView.swift
//  MyContacts
//
//  Created by Aziz Bibitov on 06.01.2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContactsView(viewModel: ContactsViewModel())
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Contacts")
                }
            
            UserView(viewModel: UserViewModel())
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("User")
                }
        }
    }
}

#Preview {
    MainTabView()
}
