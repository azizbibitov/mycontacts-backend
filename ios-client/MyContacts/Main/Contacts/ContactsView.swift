//
//  ContactsView.swift
//  MyContacts
//
//  Created by Aziz Bibitov on 06.01.2024.
//

import SwiftUI

struct ContactsView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @State private var isAddingContact = false
    @State private var newContactName = ""
    @State private var newContactEmail = ""
    @State private var newContactPhone = ""
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.contacts, id: \._id) { contact in
                    NavigationLink(destination: ContactDetailView(viewModel: viewModel, contact: contact)) {
                        ContactRow(contact: contact)
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteContact(viewModel.contacts[indexSet.first!])
                }
            }
            .refreshable {
                fetchContacts()
            }
            .navigationTitle("Contacts")
            .navigationBarItems(
                trailing: Button(action: {
                    isAddingContact = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isAddingContact) {
                NewContactView(
                    name: $newContactName,
                    email: $newContactEmail,
                    phone: $newContactPhone,
                    createContactAction: {
                        viewModel.createContact(
                            name: newContactName,
                            email: newContactEmail,
                            phone: newContactPhone
                        )
                        isAddingContact = false
                    }
                )
            }
            .overlay(EmptyContactsOverlay(isAddingContact: $isAddingContact, hasContacts: !viewModel.contacts.isEmpty, isLoading: isLoading))
            .onAppear {
                fetchContacts()
            }
        }
    }

    private func fetchContacts() {
        isLoading = true
        viewModel.fetchContacts {
            isLoading = false
        }
    }
}

struct EmptyContactsOverlay: View {
    @Binding var isAddingContact: Bool
    var hasContacts: Bool
    var isLoading: Bool

    var body: some View {
        if isAddingContact || hasContacts {
            Color.clear
        } else {
            VStack {
                Spacer()
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2) // Adjust the scale if needed
                        .padding(.bottom, 20)
                } else {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    Text("Add Your Contacts")
                        .font(.title)
                        .foregroundColor(.gray)
                }

             
                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}


struct ContactRow: View {
    let contact: Contact

    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.name ?? "")
                .font(.headline)
            Text(contact.email ?? "")
                .font(.subheadline)
            Text(contact.phone ?? "")
                .font(.subheadline)
        }
        .padding(8)
    }
}

struct ContactDetailView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @State private var editedName: String
    @State private var editedEmail: String
    @State private var editedPhone: String
    let contact: Contact

    init(viewModel: ContactsViewModel, contact: Contact) {
        self.viewModel = viewModel
        self.contact = contact
        self._editedName = State(initialValue: contact.name ?? "")
        self._editedEmail = State(initialValue: contact.email ?? "")
        self._editedPhone = State(initialValue: contact.phone ?? "")
    }

    var body: some View {
        VStack {
            Text("Contact Details")
                .font(.largeTitle)
                .padding(.bottom, 20)

            ContactField(title: "Name", value: $editedName)
            ContactField(title: "Email", value: $editedEmail)
            ContactField(title: "Phone", value: $editedPhone)

            Button(action: {
                viewModel.updateContact(
                    contactId: contact._id ?? "",
                    updatedName: editedName,
                    updatedEmail: editedEmail,
                    updatedPhone: editedPhone
                )
            }) {
                Text("Update")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .navigationBarTitle("Contact Details", displayMode: .inline)
        .padding()
    }
}

struct ContactField: View {
    let title: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)

            TextField("", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())

        }
    }
}



struct NewContactView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var phone: String
    var createContactAction: () -> Void

    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Phone", text: $phone)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                createContactAction()
                name = ""
                email = ""
                phone = ""
            }) {
                Text("Create")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
