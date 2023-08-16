//
//  NoCameraPermissionView.swift
//  CatchTheMonsterAR
//

import SwiftUI

struct NoCameraPermissionView: View {
    @EnvironmentObject var cameraAuthorizationViewModel: CameraAuthorizationViewModel
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Image("4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
                Image("no-camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 4.0, height: UIScreen.main.bounds.width / 4.0)
        }
        .onAppear {
            showAlert = true
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(""),
                message: Text("Упс! Монстр не может показаться без доступа к камере. Дайте-ка нам разрешение на использование камеры, перейдя в настройки вашего устройства и установив правильные параметры. Вскоре вы сможете увидеть весь этот монструозный беспредел!"),
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
    }
}

struct NoCameraPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NoCameraPermissionView()
            .environmentObject(CameraAuthorizationViewModel())
    }
}
