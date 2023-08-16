//
//  MonstersViewModel.swift
//  CatchTheMonsterAR
//

import CoreLocation
import UIKit

final class MonstersViewModel: ObservableObject {
    @Published var monsters: [Monster] = []
    @Published var capturedMonsters: [Monster] = []
    @Published var isShowingCaptureMonsterView = false
    var userCoordinate: CLLocationCoordinate2D?
    private var isInitialMonstersGenerated = false
    private var timer: Timer?
    private var isTimerRunning = false
    private var lastUpdatedTime: Date?
    private let updateInterval: TimeInterval = 5 * 60 /// 5 минут
    
    // Массив для хранения изображений монстров
    let monsterImages: [UIImage] = [
        UIImage(named: "giganticus"),
        UIImage(named: "grizl"),
        UIImage(named: "risus"),
        UIImage(named: "malorum"),
        UIImage(named: "zorg"),
        UIImage(named: "vulgaris")
    ].map { $0 ?? UIImage() }
    
    // Словарь для хранения описаний монстров
    let monsterDescriptions: [String: String] = [
        "Giganticus": "Giganticus - это колоссальный монстр, который превосходит в размерах все остальные существа в игре. Его огромное тело покрыто массивной броней, способной выдерживать самые сильные атаки. Он известен своей силой и неудержимой яростью в битвах. Гигантизм исходит из его древних генетических особенностей, делающих его одним из самых сильных существ в этом мире.",
        "Grizl": "Grizl - это злобный монстр с острыми зубами и грозными когтями. Его кожный покров позволяет ему прекрасно смешиваться с окружающей средой и выслеживать свою добычу. Grizl - хищник, всегда находящийся в состоянии боевой готовности. Он известен своими быстрыми и смертельными атаками, а его рык способен напугать самых смелых противников.",
        "Risus": "Risus - монстр, который ведет себя как комедиант. У него чувство юмора просто зашкаливает, и он прекрасно знает, как разыграть своих соперников. При виде Risusa все начинают смеяться. Но не смотрите на него как на шутника - он умело использует свои навыки для запутывания противников и захвата их в сети своих шуток.",
        "Malorum": "Malorum - это монстр, воплощающий зло и тьму. Его темная сущность отражается в его крыльях и грустных глазах. Malorum может контролировать тени и использовать их в своих атаках. Он питается страхом людей и поглощает их энергию. Его сила и безжалостность делают его одним из наиболее опасных и жутких существ в этой вселенной.",
        "Zorg": "Zorg - это загадочный и могущественный монстр. Он обладает неизвестным происхождением и силой, превосходящей все, что известно в игровом мире. Zorg является стражем древних знаний и считается хранителем баланса сил. Его жизненная сила вселяет трепет и его действия загадочны и необъяснимы. Битва с Zorgом - это испытание судьбы.",
        "Vulgaris": "Vulgaris - монстр с ярким и эксцентричным характером. Он обожает показывать свою яркую расцветку и разнообразные украшения. У Vulgaris большие и страшные клыки, но его дружелюбное поведение делает его более милым, чем опасным. Он всегда готов на приключения и новые забавы."
    ]
    
    // Метод для генерации начального списка монстров на карте
    func generateInitialMonsters(with userCoordinate: CLLocationCoordinate2D) {
        guard !isInitialMonstersGenerated else { return }
        
        monsters = (0...30).map { _ in
            generateRandomMonster(with: userCoordinate)
        }
        
        isInitialMonstersGenerated = true
        setupNicknameMonster()
    }
    
    // Метод для генерации случайного монстра
    private func generateRandomMonster(with userCoordinate: CLLocationCoordinate2D) -> Monster {
        let randomCoordinate = generateRandomCoordinate(from: userCoordinate)
        let randomImage = monsterImages.randomElement() ?? UIImage()
        let randomLevel = Int.random(in: 5...20)
        let monsterName = getMonsterName(for: randomImage)
        let randomDescription = monsterDescriptions[monsterName] ?? ""
        
        return Monster(name: monsterName, image: randomImage, level: randomLevel, coordinate: randomCoordinate, description: randomDescription)
    }
    
    // Метод для установки никнейма монстра на основе изображения
    private func setupNicknameMonster() {
        for index in 0..<monsters.count {
            let monster = monsters[index]
            if let imageIndex = monsterImages.firstIndex(of: monster.image) {
                monsters[index].name = getMonsterName(for: monsterImages[imageIndex])
            }
        }
    }
    
    // Метод для получения никнейма монстра на основе изображения
    private func getMonsterName(for image: UIImage) -> String {
        switch image {
        case monsterImages[0]:
            return "Giganticus"
        case monsterImages[1]:
            return "Grizl"
        case monsterImages[2]:
            return "Risus"
        case monsterImages[3]:
            return "Malorum"
        case monsterImages[4]:
            return "Zorg"
        case monsterImages[5]:
            return "Vulgaris"
        default:
            return ""
        }
    }
    
    // Метод для запуска обновления списка монстров на карте
    func startUpdatingMonsters(with userCoordinate: CLLocationCoordinate2D?) {
        self.userCoordinate = userCoordinate
        
        guard let userCoordinate = userCoordinate else { return }
        
        generateInitialMonsters(with: userCoordinate)
        
        if !isTimerRunning {
            startTimer(with: userCoordinate)
            isTimerRunning = true
        }
    }
    
    // Метод для запуска таймера для обновления списка монстров
    private func startTimer(with userCoordinate: CLLocationCoordinate2D) {
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.updateMonstersIfNeeded()
        }
    }
    
    private func updateMonstersIfNeeded() {
        guard let lastUpdatedTime = lastUpdatedTime else {
            updateMonsters()
            return
        }
        
        if Date().timeIntervalSince(lastUpdatedTime) >= updateInterval {
            updateMonsters()
        }
    }
    
    // Метод для обновления списка монстров на карте
    private func updateMonsters() {
        timer?.invalidate() /// Остановить таймер перед обновлением списка монстров
        
        // Удаление 20% монстров
        monsters = monsters.filter { _ in
            Int.random(in: 1...100) > 20
        }
        
        // Добавление 6 случайных монстров в радиусе 1 км от пользователя
        addRandomMonsters(with: userCoordinate ?? CLLocationCoordinate2D())
        
        // Обновление времени последнего обновления
        lastUpdatedTime = Date()
        
        setupNicknameMonster()
        startTimer(with: userCoordinate ?? CLLocationCoordinate2D()) /// Запустить таймер после обновления списка монстров
    }
    
    // Метод для обновления расстояний до монстров от пользователя
    private func updateDistancesToUser(from userCoordinate: CLLocationCoordinate2D) {
        for index in monsters.indices {
            let monsterLocation = CLLocation(latitude: monsters[index].coordinate.latitude, longitude: monsters[index].coordinate.longitude)
            let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
            monsters[index].distanceToUser = monsterLocation.distance(from: userLocation)
        }
    }
    
    // Метод для удаления случайных монстров из списка
    private func removeRandomMonsters() {
        monsters = monsters.filter { _ in
            Int.random(in: 1...100) > 20
        }
    }
    
    // Метод для добавления случайных монстров в список
    private func addRandomMonsters(with userCoordinate: CLLocationCoordinate2D) {
        for _ in 0..<6 {
            monsters.append(generateRandomMonster(with: userCoordinate))
        }
    }
    
    // Метод для генерации случайных координат в радиусе 1 километра от пользователя
    private func generateRandomCoordinate(from userCoordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let radiusInMeters: Double = 1000 /// Радиус в метрах
        let distance = Double.random(in: 0...radiusInMeters)
        let angle = Double.random(in: 0...(2 * Double.pi))
        
        let earthRadius = 6371000.0 /// Радиус Земли
        
        let lat1 = userCoordinate.latitude * Double.pi / 180
        let lon1 = userCoordinate.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distance / earthRadius) + cos(lat1) * sin(distance / earthRadius) * cos(angle))
        let lon2 = lon1 + atan2(sin(angle) * sin(distance / earthRadius) * cos(lat1), cos(distance / earthRadius) - sin(lat1) * sin(lat2))
        
        let newLatitude = lat2 * 180 / Double.pi
        let newLongitude = lon2 * 180 / Double.pi
        
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
    
    // Метод для обновления координат пользователя и расстояний до монстров при перемещении пользователя на карте
    func updateUserCoordinate(_ coordinate: CLLocationCoordinate2D) {
        userCoordinate = coordinate
        updateDistancesToUser(from: coordinate)
    }
    
    // Метод для удаления выбранного монстра из списка монстров на карте
    func captureMonster(at index: Int) {
        guard index >= 0 && index < monsters.count else {
            return
        }
        
        monsters.remove(at: index)
    }
    
    // Метод для сохранения пойманного монстра
    func addMonsterToTeam(_ monster: Monster) {
        capturedMonsters.append(monster)
        saveCapturedMonsters()
    }
    
    // Метод для сохранения списка пойманных монстров в UserDefaults
    func saveCapturedMonsters() {
        let data = try? JSONEncoder().encode(capturedMonsters)
        UserDefaults.standard.set(data, forKey: "capturedMonsters")
    }
    
    // Метод для загрузки списка пойманных монстров из UserDefaults
    func loadCapturedMonsters() {
        if let data = UserDefaults.standard.data(forKey: "capturedMonsters"),
           let decodedMonsters = try? JSONDecoder().decode([Monster].self, from: data) {
            capturedMonsters = decodedMonsters
        }
    }
}
