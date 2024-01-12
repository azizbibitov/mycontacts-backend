//
//  UserViewModel.swift
//  MyContacts
//
//  Created by Aziz Bibitov on 06.01.2024.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User?

    func fetchUser() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "http://localhost:5002/api/users/current") else {
            print("Invalid URL or authToken not found")
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                
                let jsonString = String(data: data, encoding: .utf8)
                print("Received User: \(jsonString ?? "")")
                let decodedUser = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.user = decodedUser
                }
            } catch {
                print("Error decoding user: \(error)")
            }
        }.resume()
    }
}
