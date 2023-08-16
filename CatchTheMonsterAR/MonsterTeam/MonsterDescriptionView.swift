//
//  MonsterDescriptionView.swift
//  CatchTheMonsterAR
//

import SwiftUI
import CoreLocation

struct MonsterDescriptionView: View {
    let monster: Monster
    
    var body: some View {
        ZStack {
            Image("5")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Image("logoCrop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .shadow(color: .black, radius: 3, x: 2, y: 2)
                    .padding(.top, 20)
                
                Text(monster.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .darkBlue, radius: 5, x: 2, y: 2)
                    .padding(10)
            }
        }
    }
}

struct MonsterDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        MonsterDescriptionView(monster: Monster(name: "Giganticus", image: UIImage(named: "giganticus") ?? UIImage(), level: 6, coordinate: CLLocationCoordinate2D(), description: "Giganticus - это колоссальный монстр, который превосходит в размерах все остальные существа в игре. Его огромное тело покрыто массивной броней, способной выдерживать самые сильные атаки. Он известен своей силой и неудержимой яростью в битвах. Гигантизм исходит из его древних генетических особенностей, делающих его одним из самых формидабельных существ в этом мире"))
    }
}
