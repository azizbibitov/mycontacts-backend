//
//  UserView.swift
//  MyContacts
//
//  Created by Aziz Bibitov on 06.01.2024.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    @AppStorage("authToken") var authToken: String = ""

    var body: some View {
        List {
            Section(header: Text("User Information")) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue) // You can change the color as needed

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Username:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(viewModel.user?.username ?? "N/A")
                                .font(.headline)
                        }
                    }
                    Divider()

                    HStack {
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue) // You can change the color as needed

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(viewModel.user?.email ?? "N/A")
                                .font(.headline)
                        }
                    }
                    // Add other user information as needed
                }
            }

            Section(header: Text("Actions")) {
                Button(action: {
                    logout()
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Profile")
        .onAppear {
            viewModel.fetchUser()
        }
    }

    private func logout() {
        // Clear authToken from UserDefaults
        authToken = ""
    }
}

