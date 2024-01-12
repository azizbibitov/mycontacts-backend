import SwiftUI

struct LoginRegistrationView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var registrationViewModel = RegistrationViewModel()
    @State private var isLoginActive = true
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoginActive {
                    LoginView(isLoginActive: $isLoginActive, loginViewModel: loginViewModel)
                        .navigationTitle("Login")
                } else {
                    RegistrationView(isLoginActive: $isLoginActive, registrationViewModel: registrationViewModel)
                        .navigationTitle("Registration")
                }
            }
        }
    }
}


struct LoginView: View {
    @Binding var isLoginActive: Bool
    @ObservedObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack {
            Text("MyContacts")
                .font(.largeTitle)
                .padding()
            
            Text("Welcome to the App!")
                .font(.title)
                .padding()
            
            TextField("Email", text: $loginViewModel.email)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $loginViewModel.password)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()
            
            Button(action: {
                loginViewModel.login()
            }) {
                Text("Login")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Text("Don't have an account?")
                .foregroundColor(.gray)
            Button(action: {
                withAnimation {
                    isLoginActive.toggle()
                }
            }) {
                Text("Register here")
            }
        }
        .padding()
    }
}


struct RegistrationView: View {
    @Binding var isLoginActive: Bool
    @ObservedObject var registrationViewModel: RegistrationViewModel
    
    var body: some View {
        VStack {
            Text("MyContacts")
                .font(.largeTitle)
                .padding()
            
            Text("Create a New Account")
                .font(.title)
                .padding()
            
            TextField("Username", text: $registrationViewModel.username)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()
            
            TextField("Email", text: $registrationViewModel.email)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $registrationViewModel.password)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()
            
            Button(action: {
                registrationViewModel.register()
            }) {
                Text("Register")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Text("Already have an account?")
                .foregroundColor(.gray)
            Button(action: {
                withAnimation {
                    isLoginActive.toggle()
                }
            }) {
                Text("Login here")
            }
        }
        .padding()
    }
}


struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}
