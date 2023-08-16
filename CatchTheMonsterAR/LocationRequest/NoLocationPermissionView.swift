//
//  NoLocationPermissionView.swift
//  CatchTheMonsterAR
//

import SwiftUI
import CoreLocation

struct NoLocationPermissionView: View {
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Image("2")
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
                message: Text("О нет! Мы не смогли определить ваше местоположение на карте! Позвольте нам найти вас. Откройте настройки вашего устройства и установите нужные параметры, разрешив доступ к определению местоположения. Тогда мы сможем найти вас и ближаших монстров!"),
                dismissButton: .default(Text("Перейти к настройкам"), action: {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                })
            )
        }
        .onAppear {
            showAlert = true
        }
    }
}

struct NoLocationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NoLocationPermissionView()
    }
}
