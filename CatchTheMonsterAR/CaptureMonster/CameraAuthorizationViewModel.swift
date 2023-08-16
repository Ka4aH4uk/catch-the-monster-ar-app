//
//  CameraAuthorizationViewModel.swift
//  CatchTheMonsterAR
//

import AVFoundation

class CameraAuthorizationViewModel: ObservableObject {
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    init() {
        checkCameraAuthorization()
    }
    
    func checkCameraAuthorization() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        self.authorizationStatus = authorizationStatus
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.authorizationStatus = granted ? .authorized : .denied
            }
        }
    }
}
