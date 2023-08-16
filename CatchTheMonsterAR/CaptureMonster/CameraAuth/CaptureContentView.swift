//
//  CaptureContentView.swift
//  CatchTheMonsterAR
//
//  Created by Ka4aH on 07.07.2023.
//

import SwiftUI

struct CaptureContentView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @StateObject private var monstersViewModel = MonstersViewModel()
    @StateObject private var cameraAuthorizationViewModel = CameraAuthorizationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch cameraAuthorizationViewModel.authorizationStatus {
                case .notDetermined:
                    CameraAuthorizationRequestView()
                        .onAppear {
                            cameraAuthorizationViewModel.requestCameraAccess()
                        }
                case .denied:
                    NoCameraPermissionView()
                case .authorized:
                    CaptureMonsterView()
                        .environmentObject(monstersViewModel)
                default:
                    Text("Unknown status")
                }
            }
        }
        .environmentObject(cameraAuthorizationViewModel)
    }
}

struct CaptureContentView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureContentView()
    }
}
