//
//  CaptureMonsterView.swift
//  CatchTheMonsterAR
//

import SwiftUI
import CoreLocation
import ARKit

struct CaptureMonsterView: View {
    @EnvironmentObject var monstersViewModel: MonstersViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    let monster: Monster
    
    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var aimOffset = CGSize.zero
    @State private var isImageCatchHimAnimating = false
    @State private var isDescriptionMonsterAnimating = false
    
    var body: some View {
        ZStack {
            if ARWorldTrackingConfiguration.isSupported {
                ARViewContainer(monster: monster)
                    .ignoresSafeArea()
            } else {
                Text("ARKit is not supported on this device.")
                    .foregroundColor(.red)
            }
            
            VStack {
                VStack {
                    HStack {
                        VStack {
                            Capsule()
                                .fill(Color.darkBlue.opacity(0.6))
                                .frame(width: 180, height: 70)
                                .overlay {
                                    HStack {
                                        Image(uiImage: monster.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .padding(5)
                                        
                                        VStack(alignment: .leading) {
                                            Text(monster.name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.trailing,5)
                                            Text("Уровень: \(monster.level)")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                    }
                                }
                        }
                        .opacity(isDescriptionMonsterAnimating ? 1 : 0)
                        .offset(y: CGFloat(isDescriptionMonsterAnimating ? 0 : -200))
                        .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.5), value: isDescriptionMonsterAnimating)
                        .padding()
                    }
                }
                .frame(width: 180, height: 70)
                .padding(.bottom, 20)
                
                Image("catch-him")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .opacity(isImageCatchHimAnimating ? 0.9 : 0)
                    .scaleEffect(isImageCatchHimAnimating ? 2.2 : 1.0)
                    .animation(isImageCatchHimAnimating ? .interpolatingSpring(stiffness: 170, damping: 8, initialVelocity: 10).delay(0.5) : .easeInOut(duration: 0.5), value: isImageCatchHimAnimating)
                    .padding(.top, 20)
                Spacer()
                
                Image("aim")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .opacity(0.8)
                    .offset(aimOffset)
                Spacer()
                
                Button(action: {
                    tryToCaptureMonster()
                    animateAim()
                }) {
                    ZStack {
                        Capsule()
                            .fill(Color.darkBlue.opacity(0.6))
                            .frame(width: 280, height: 60)
                        Text("Попробовать поймать")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            setupCapture()
        }
        .alert(isPresented: $isShowingAlert) {
            switch alertTitle {
            case "Ура!":
                return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Вернуться на карту")) {
                    returnToMapView()
                })
            case "Монстр убежал!":
                return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    returnToMapView()
                })
            default:
                return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func setupCapture() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            catchHim()
            animateAim()
        }
        isDescriptionMonsterAnimating = true
    }
    
    private func tryToCaptureMonster() {
        let randomChance = Int.random(in: 1...100)
        
        if randomChance <= 20 {
            monstersViewModel.addMonsterToTeam(monster)
            alertTitle = "Ура!"
            alertMessage = "Вы поймали монстра \(monster.name) в свою команду"
        } else if randomChance <= 50 {
            alertTitle = "Монстр убежал!"
            alertMessage = ""
        } else {
            alertTitle = "Не вышло:("
            alertMessage = "Попробуйте поймать еще раз!"
        }
        
        isShowingAlert = true
    }
    
    private func returnToMapView() {
        monstersViewModel.isShowingCaptureMonsterView = false
    }
    
    private func animateAim() {
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            aimOffset = CGSize(
                width: CGFloat.random(in: -50...50),
                height: CGFloat.random(in: -50...50)
            )
        }
    }
    
    private func catchHim() {
        isImageCatchHimAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isImageCatchHimAnimating.toggle()
        }
    }
}

struct CaptureMonsterView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureMonsterView(monster: Monster(name: "Giganticus", image: UIImage(named: "giganticus") ?? UIImage(), level: 6, coordinate: CLLocationCoordinate2D(), description: ""))
    }
}
