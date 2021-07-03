//
//  SignIn.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/11.
//

import ActivityIndicatorView
import SwiftUI

struct SignIn: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var proceedRegistrationFlow: Bool = false
    @State private var isLoading: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: SignUp().environmentObject(store),
                    isActive: $proceedRegistrationFlow
                ) {
                    EmptyView()
                }
                .isDetailLink(true)

                VStack {
                    TextFieldInput(value: $email, label: "メールアドレス", keyboardType: .emailAddress)
                        .padding(.bottom, 20)

                    SecureFieldInput(value: $password, label: "パスワード", keyboardType: .default)
                        .padding(.bottom, 20)

                    ActionButton(text: "ログイン", background: .primary) {
                        isLoading = true
                        store.signIn(email: email, password: password) { error in
                            self.errorAlert.appError(error)
                            self.isLoading = false
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
                .padding(.top, 30)
                .padding(.horizontal, 20)
            }
            .navigationBarTitle("ログイン", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                trailing: Button(action: {
                    proceedRegistrationFlow = true
                }) {
                    Text("会員登録")
                        .foregroundColor(Color.blue)
                        .fontWeight(.bold)
                }
            )
            .overlay(Group {
                if isLoading {
                    HUD(isLoading: $isLoading)
                }
            }, alignment: .center)
            .alert(isPresented: $errorAlert.isShowAlert) {
                Alert(title: Text(errorAlert.message))
            }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
