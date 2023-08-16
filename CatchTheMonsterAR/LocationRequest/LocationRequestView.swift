//
//  StartView.swift
//  CatchTheMonsterAR
//

import SwiftUI

struct LocationRequestView: View {
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Image("1")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                logo()
                    .opacity(0.7)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(""),
                message: Text("Для того, чтобы мы могли показать вас и ваших ближайших соседей-монстров, нам необходимо разрешение на доступ к вашей геопозиции. Не волнуйтесь, мы не позволим никому атаковать вас!"),
                dismissButton: .default(Text("Разрешить"), action: {
                    locationViewModel.requestPermission()
                })
            )
        }
        .onAppear {
            showAlert = true
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
