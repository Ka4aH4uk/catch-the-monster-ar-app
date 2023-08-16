//
//  ARCaptureMonsterViewContainer.swift
//  CatchTheMonsterAR
//

import SwiftUI
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let monster: Monster
    
    func makeUIView(context: Context) -> ARSCNView {
        guard ARWorldTrackingConfiguration.isSupported else {
            print("ARKit is not supported on this device.")
            return ARSCNView()
        }

        let arView = ARSCNView(frame: .zero)
        
        // Настройка параметров просмотра дополненной реальности
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        
        // Добавляем монстра в AR-сцену
        let monsterNode = createMonsterNode()
        arView.scene.rootNode.addChildNode(monsterNode)
        
        arView.showsStatistics = false
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
       //
    }
    
    private func createMonsterNode() -> SCNNode {
        let monsterNode = SCNNode()
        
        let monsterImage = monster.image
        
        // Получение пропорций изображения монстра
        let imageAspectRatio = monsterImage.size.width / monsterImage.size.height
        
        // Создание геометрии монстра
        let monsterWidth: CGFloat = 0.8
        let monsterHeight: CGFloat = monsterWidth / imageAspectRatio /// Вычисление высоты монстра с учетом пропорций
        
        let monsterPlane = SCNPlane(width: monsterWidth, height: monsterHeight)
        monsterPlane.firstMaterial?.diffuse.contents = monsterImage
      
        // Создание узла для плоскости монстра
        let monsterPlaneNode = SCNNode(geometry: monsterPlane)
        
        // Позиционирование монстра в окружении
        let monsterHeightAboveGround: Float = -1.0 /// Высота монстра над землей
        let distanceFromDevice: Float = -2.5 /// Расстояние от устройства до монстра

        monsterPlaneNode.position = SCNVector3(x: 0, y: monsterHeightAboveGround, z: distanceFromDevice)
        
        monsterPlane.firstMaterial?.isDoubleSided = true
        monsterPlane.firstMaterial?.diffuse.intensity = 0.8
        
        monsterNode.addChildNode(monsterPlaneNode)

        // Создание текста
        let monsterTexts = ["Grrr! Argh!", "Watch out!", "Boooooooooo!", "Roarr! Run!", "Raaaaaahh!"]
        let randomText = monsterTexts.randomElement() ?? ""
        
        let textMonster = SCNText(string: randomText, extrusionDepth: 0.1)
        textMonster.firstMaterial?.diffuse.contents = UIColor.darkText
        textMonster.font = .goodDogPlain(size: 21)
        textMonster.flatness = 0.1

        let textNode = SCNNode(geometry: textMonster)
        textNode.scale = SCNVector3(0.009, 0.009, 0.009)
        textNode.position = SCNVector3(x: -0.19, y: -0.46, z: -2.5)

        textNode.eulerAngles.z = Float.pi / 40 /// Поворот текста

        textMonster.firstMaterial?.diffuse.intensity = 0.8

        monsterNode.addChildNode(textNode)
        
        // Создание диалогового окна
        let dialogPlane = SCNPlane(width: 1.0, height: 0.65)
        dialogPlane.firstMaterial?.diffuse.contents = UIImage(named: "dialog")
                
        let dialogPlaneNode = SCNNode(geometry: dialogPlane)
        dialogPlaneNode.position = SCNVector3(x: 0.1, y: -0.4, z: -2.5)
        
        dialogPlane.firstMaterial?.isDoubleSided = true
        dialogPlane.firstMaterial?.diffuse.intensity = 0.8
        
        monsterNode.addChildNode(dialogPlaneNode)

        return monsterNode
    }
}
