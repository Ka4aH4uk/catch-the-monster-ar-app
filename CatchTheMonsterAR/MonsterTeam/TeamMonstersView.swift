//
//  TeamMonstersView.swift
//  CatchTheMonsterAR
//

import SwiftUI

struct TeamMonstersView: View {
    @EnvironmentObject var monstersViewModel: MonstersViewModel
    @State private var selectedMonster: Monster? = nil
    
    var body: some View {
        ZStack {
            Image("3")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                if monstersViewModel.capturedMonsters.isEmpty {
                    Image("team")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 3.0, height: UIScreen.main.bounds.width / 3.0)
                    Text("Ой, ой! Похоже, у вас еще нет пойманных монстров в команде!")
                        .font(.title2)
                        .foregroundColor(Color.skyBlue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(monstersViewModel.capturedMonsters) { monster in
                                MonsterCell(monster: monster)
                                    .onTapGesture {
                                        selectedMonster = monster
                                    }
                                Divider()
                                    .padding(.horizontal, 30)
                            }
                        }
                    }
                }
            }
            .onAppear {
                monstersViewModel.loadCapturedMonsters()
            }
            .navigationBarTitle("Моя команда")
            .sheet(item: $selectedMonster) { monster in
                MonsterDescriptionView(monster: monster)
                    .presentationDetents([.height(320)])
            }
        }
    }
}

struct TeamMonstersView_Previews: PreviewProvider {
    static var previews: some View {
        TeamMonstersView()
            .environmentObject(MonstersViewModel())
    }
}
