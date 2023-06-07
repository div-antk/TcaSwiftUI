//
//  UserRow.swift
//  TcaSwiftUI
//
//  Created by Takuya Ando on 2023/06/08.
//

import SwiftUI

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .padding()
            Spacer()
            Text(user.login)
                .padding()
            Spacer()
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: User.mockUser)
    }
}
