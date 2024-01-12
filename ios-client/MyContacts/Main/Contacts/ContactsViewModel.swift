//
//  ContactsViewModel.swift
//  MyContacts
//
//  Created by Aziz Bibitov on 06.01.2024.
//

import Foundation

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []

    func fetchContacts(completion: @escaping () -> Void) {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "http://localhost:5002/api/contacts") else {
            print("Invalid URL or authToken not found")
            completion()
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching contacts: \(error?.localizedDescription ?? "Unknown error")")
                completion()
                return
            }

            do {
                let jsonString = String(data: data, encoding: .utf8)
                print("Received Contacts: \(jsonString ?? "")")
                
                let decodedContacts = try JSONDecoder().decode([Contact].self, from: data)
                DispatchQueue.main.async {
                    self.contacts = decodedContacts
                }
            } catch {
                print("Error decoding contacts: \(error)")
            }

            completion()
        }.resume()
    }


    func deleteContact(_ contact: Contact) {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "http://localhost:5002/api/contacts/\(contact._id ?? "")") else {
            print("Invalid URL or authToken not found for deleting contact")
            return
        }

        var deleteRequest = URLRequest(url: url)
        deleteRequest.httpMethod = "DELETE"
        deleteRequest.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: deleteRequest) { _, _, error in
            guard error == nil else {
                print("Error deleting contact: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                self.fetchContacts(completion: {})
            }
        }.resume()
    }
    
    func createContact(name: String, email: String, phone: String) {
           guard let authToken = UserDefaults.standard.string(forKey: "authToken"),
                 let url = URL(string: "http://localhost:5002/api/contacts") else {
               print("Invalid URL or authToken not found for creating contact")
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

           let newContact: [String: Any] = [
               "name": name,
               "email": email,
               "phone": phone
           ]

           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: newContact)
           } catch {
               print("Error serializing JSON: \(error)")
               return
           }

           URLSession.shared.dataTask(with: request) { _, _, error in
               guard error == nil else {
                   print("Error creating contact: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }

               // Fetch updated contacts after creating a new one
               self.fetchContacts(completion: {})
           }.resume()
       }
    
    func updateContact(contactId: String, updatedName: String, updatedEmail: String, updatedPhone: String) {
          guard let authToken = UserDefaults.standard.string(forKey: "authToken") else {
              print("Invalid authToken")
              return
          }

          let url = URL(string: "http://localhost:5002/api/contacts/\(contactId)")!
          var request = URLRequest(url: url)
          request.httpMethod = "PUT"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

          let parameters: [String: Any] = [
              "name": updatedName,
              "email": updatedEmail,
              "phone": updatedPhone
          ]

          do {
              request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
          } catch {
              print("Error serializing JSON: \(error)")
              return
          }

          URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data, error == nil else {
                  print("Error updating contact: \(error?.localizedDescription ?? "Unknown error")")
                  return
              }

              // You can handle the response if needed
              // For example, print the updated contact
              do {
                  let updatedContact = try JSONDecoder().decode(Contact.self, from: data)
                  self.fetchContacts(completion: {})
                  print("Updated Contact: \(updatedContact)")
              } catch {
                  print("Error decoding updated contact: \(error)")
              }
          }.resume()
      }
    
}
