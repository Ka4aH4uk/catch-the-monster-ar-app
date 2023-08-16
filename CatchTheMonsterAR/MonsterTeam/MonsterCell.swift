//
//  MonsterCell.swift
//  CatchTheMonsterAR
//

import SwiftUI
import CoreLocation

struct MonsterCell: View {
    let monster: Monster
    
    var body: some View {
        HStack {
            Image(uiImage: monster.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 110)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(monster.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Image(systemName: "info.bubble")
                        .foregroundColor(.white)
                        .padding(.bottom)
                }
                Text("Уровень монстра: \(monster.level)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(20)
        }
    }
}

struct MonsterCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("3")
                .edgesIgnoringSafeArea(.all)
            MonsterCell(monster: Monster(name: "Risus", image: UIImage(named: "risus") ?? UIImage(), level: 6, coordinate: CLLocationCoordinate2D(), description: ""))
        }
    }
}
