//
//  ContentView.swift
//  CatchTheMonsterAR
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @StateObject private var monstersViewModel = MonstersViewModel()
    @StateObject private var cameraAuthorizationViewModel = CameraAuthorizationViewModel()

    var body: some View {
        NavigationView {
            VStack {
                switch locationViewModel.authorizationStatus {
                case .notDetermined:
                    LocationRequestView()
                case .restricted, .denied:
                    NoLocationPermissionView()
                case .authorizedAlways, .authorizedWhenInUse:
                    MapMonstersView()
                        .environmentObject(monstersViewModel)
                        .environmentObject(cameraAuthorizationViewModel)
                default:
                    Text("Unknown status")
                }
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocationViewModel())
    }
}
