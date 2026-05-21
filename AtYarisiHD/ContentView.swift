import SwiftUI
import UIKit
import GameKit
import Combine
import UserNotifications

// MARK: - TEMA

enum Theme {
    static let bg          = Color(red: 0.98, green: 0.98, blue: 0.95)
    static let card        = Color.white
    static let line        = Color(red: 0.83, green: 0.83, blue: 0.80)
    static let grass       = Color(red: 0.30, green: 0.62, blue: 0.30)
    static let grassDark   = Color(red: 0.16, green: 0.42, blue: 0.20)
    static let sand        = Color(red: 0.93, green: 0.85, blue: 0.66)
    static let sandDark    = Color(red: 0.80, green: 0.68, blue: 0.45)
    static let inkBlack    = Color(red: 0.08, green: 0.10, blue: 0.10)
    static let inkSoft     = Color(red: 0.30, green: 0.32, blue: 0.32)
    static let accentRed   = Color(red: 0.78, green: 0.20, blue: 0.20)
    static let accentGold  = Color(red: 0.85, green: 0.62, blue: 0.13)
    static let goodGreen   = Color(red: 0.10, green: 0.50, blue: 0.20)
    static let skyTop      = Color(red: 0.55, green: 0.78, blue: 0.95)
    static let skyMid      = Color(red: 0.78, green: 0.90, blue: 0.98)
    static let skyHorizon  = Color(red: 0.92, green: 0.95, blue: 0.98)
}

// MARK: - ENUMS

enum HorseTier: Int, CaseIterable {
    case bionic = 1, glassFuse, diesel, bipolar, scrap, clerk, timeBomb, trash
    var label: String {
        switch self {
        case .bionic:    return "BİYONİK"
        case .glassFuse: return "CAM FİŞEK"
        case .diesel:    return "DİZEL"
        case .bipolar:   return "BİPOLAR"
        case .scrap:     return "HURDA"
        case .clerk:     return "MEMUR"
        case .timeBomb:  return "SAATLİ BOMBA"
        case .trash:     return "TAM SİKKO"
        }
    }
    var tagline: String {
        switch self {
        case .bionic:    return "Kusursuz · Az kazandırır"
        case .glassFuse: return "Çok hızlı · Kondisyonsuz"
        case .diesel:    return "Yavaş başlar · Bitiriş kralı"
        case .bipolar:   return "Şansa göre uçar/sürünür"
        case .scrap:     return "Eski şampiyon · Sakat riski"
        case .clerk:     return "Ortalama · Kaosta yükselir"
        case .timeBomb:  return "Hızlı · %20 patlama riski"
        case .trash:     return "Çöp · Mucize bekleyene"
        }
    }
    var color: Color {
        switch self {
        case .bionic:    return Color(red: 0.05, green: 0.45, blue: 0.65)
        case .glassFuse: return Color(red: 0.75, green: 0.20, blue: 0.50)
        case .diesel:    return Color(red: 0.10, green: 0.50, blue: 0.20)
        case .bipolar:   return Color(red: 0.45, green: 0.20, blue: 0.65)
        case .scrap:     return Color(red: 0.80, green: 0.45, blue: 0.10)
        case .clerk:     return Color(red: 0.35, green: 0.35, blue: 0.40)
        case .timeBomb:  return Color(red: 0.80, green: 0.15, blue: 0.15)
        case .trash:     return Color(red: 0.50, green: 0.35, blue: 0.20)
        }
    }
}

// Feature 4 + Cheat system
enum AppState { case padock, racing, result, bankrupt, hardGameOver, cheatingCaught }

// MARK: - HİLE SİSTEMİ

enum CheatType: CaseIterable, Identifiable {
    case energyDrink   // L1 Hafif Hile — Enerji İçeceği
    case laserGrip     // L2 Orta Hile  — Lazer Tutma
    case shoeSabotage  // L3 Ağır Hile  — Nal Sökme

    var id: Self { self }

    var emoji: String {
        switch self {
        case .energyDrink:  return "⚡"
        case .laserGrip:    return "🔫"
        case .shoeSabotage: return "🔧"
        }
    }
    var label: String {
        switch self {
        case .energyDrink:  return "L1 · Enerji İçeceği"
        case .laserGrip:    return "L2 · Lazer Tutma"
        case .shoeSabotage: return "L3 · Nal Sökme"
        }
    }
    var effectLabel: String {
        switch self {
        case .energyDrink:  return "+%15 hız"
        case .laserGrip:    return "şans taban +30"
        case .shoeSabotage: return "2 rakip patlar"
        }
    }
    /// Per-cheat catch probability
    var catchRisk: Double {
        switch self {
        case .energyDrink:  return 0.10
        case .laserGrip:    return 0.25
        case .shoeSabotage: return 0.15
        }
    }
    var riskLabel: String {
        switch self {
        case .energyDrink:  return "%10 risk"
        case .laserGrip:    return "%25 risk"
        case .shoeSabotage: return "%15 risk"
        }
    }
    var penaltyLabel: String {
        switch self {
        case .energyDrink:  return "Bahis + %15 bakiye müsadere"
        case .laserGrip:    return "Bahis + 500 ₺ ceza"
        case .shoeSabotage: return "Anlık HARD GAME OVER"
        }
    }
}

enum TrackSurface: CaseIterable {
    case grass, sand
    var primary: Color {
        switch self {
        case .grass: return Color(red: 0.32, green: 0.62, blue: 0.30)
        case .sand:  return Color(red: 0.93, green: 0.85, blue: 0.66)
        }
    }
    var secondary: Color {
        switch self {
        case .grass: return Color(red: 0.22, green: 0.50, blue: 0.22)
        case .sand:  return Color(red: 0.80, green: 0.68, blue: 0.45)
        }
    }
    var laneLine: Color {
        switch self {
        case .grass: return Color.white.opacity(0.75)
        case .sand:  return Color.white.opacity(0.65)
        }
    }
    var label: String {
        switch self {
        case .grass: return "ÇİM"
        case .sand:  return "KUM"
        }
    }
}

// MARK: - 100 AT KATALOĞU

struct HorseTemplate {
    let name: String
    let tier: HorseTier
}

enum HorseCatalog {
    static let all: [HorseTemplate] = {
        var arr: [HorseTemplate] = []
        for n in tier1 { arr.append(HorseTemplate(name: n, tier: .bionic)) }
        for n in tier2 { arr.append(HorseTemplate(name: n, tier: .glassFuse)) }
        for n in tier3 { arr.append(HorseTemplate(name: n, tier: .diesel)) }
        for n in tier4 { arr.append(HorseTemplate(name: n, tier: .bipolar)) }
        for n in tier5 { arr.append(HorseTemplate(name: n, tier: .scrap)) }
        for n in tier6 { arr.append(HorseTemplate(name: n, tier: .clerk)) }
        for n in tier7 { arr.append(HorseTemplate(name: n, tier: .timeBomb)) }
        for n in tier8 { arr.append(HorseTemplate(name: n, tier: .trash)) }
        return arr
    }()
    static let tier1 = ["Demir Yumruk","Çelik Tayfun","Robocop Recep","Titanyum Tülay","Biyonik Beyhan","Süper Ayşe","Nükleer Naci","Kurşungeçirmez Kemal","Termal Tezcan","Kuantum Kazım","Lazer Levent","Atom Atilla"]
    static let tier2 = ["Cam Kemik Cemil","Şişe Bacak Şenol","Porselen Pelin","Frajil Ferdi","Kristal Kerem","Patlamaya Hazır Pakize","Mumdan Murat","Tüy Sıklet Tülin","Buz Bebek Bahar","Sırça Köşk Selim","Yufka Yürek Yıldız","Anemik Aykut","Narin Nesrin"]
    static let tier3 = ["Traktör Talat","Kamyon Kazım","Dizel Davut","Mazot Mahmut","Yakıt Yusuf","İnatçı İrfan","Tank Turgut","Buldozer Bedri","Lokomotif Lütfü","Vinç Vahit","Mazgal Macit","Halatçı Halil"]
    static let tier4 = ["Pazartesi Sendromu","Ay Hali Aysel","Ruh Hali Recep","Bipolar Bedirhan","Manik Mert","Kararsız Kemal","Düşüncesiz Dündar","Kaprisli Kadriye","Mevsim Geçişi Metin","PMS Perihan","Hormon Hasan","Sinir Krizi Sıtkı","Stres Topu Sevgi"]
    static let tier5 = ["Hurdacı Hüsnü","Paslı Paşa","Yamuk Yılmaz","Çürük Çetin","Eskici Erol","Sökük Sabri","Emekli Emin","Antika Asaf","Müzelik Müfit","Kontak Kaçıran Kasım","Yağ Sızdıran Yaşar","Tornistan Tarık"]
    static let tier6 = ["Memur Mehmet","Mesai Bekleyen Mesut","Maaş Günü Mahir","Mobbing Mağduru Murat","Vasat Vural","Ortalama Orhan","Sıradan Süleyman","9-5 Şener","Kadrolu Kadir","Sicil Amiri Selim","Bütçe Bülent","Promosyon Pelin","Komisyon Cengiz"]
    static let tier7 = ["Saatli Bomba","Fitilli Faruk","Dinamit Dursun","Bombacı Bahattin","Patlayan Pamuk","Tehlikeli Tahsin","Volkan Vedat","Magma Macit","TNT Tuncay","Nitro Nazım","Termit Tekin","Roket Rıdvan"]
    static let tier8 = ["Ücretsiz Stajyer","Asgari Ümit","Borçlu Burhan","İşsiz İlhami","Zar Zor Zafer","Üç Kuruş Şükrü","Kıytırık Kazım","Eyvallah Eşref","Hibrit Hıdır","Sıfır Faiz Sıtkı","Topal Tosun","Aksak Ayhan","Yaralı Yakup"]
}

// MARK: - MODEL

struct Horse: Identifiable, Equatable {
    let id = UUID()
    var lane: Int
    var name: String
    var tier: HorseTier
    var speed: Int
    var health: Int
    var stability: Int
    var reliability: Int
    var odds: Double

    var willBoom: Bool = false
    var boomAtProgress: Double = 2.0
    var boomReason: String = ""
    var boomKind: BoomKind = .spin
    var finalScore: Double = 0
    var placement: Int = 0

    var progress: Double = 0
    var hasBoomed: Bool = false
    var yOffset: CGFloat = 0
    var runBob: CGFloat = 0
    var rotation: Double = 0
    var emojiOverride: String? = nil
    var gallopPhase: Int = 0

    var baseAsset: Double {
        Double(speed) * 0.40 + Double(health) * 0.25
            + Double(stability) * 0.20 + Double(reliability) * 0.15
    }
    var boomChance: Double { Double(100 - reliability) * 0.20 }

    enum BoomKind { case spin, reverse, faint }
}

// MARK: - BULUTLAR (parallaks)

struct CloudSprite: Identifiable {
    let id = UUID()
    var worldX: Double
    var y: CGFloat
    var scale: CGFloat
    var parallax: Double
    var emoji: String
}

// MARK: - GAME ENGINE
// Feature 1: Persistent storage via Combine sinks → UserDefaults
// Feature 2: Statistics tracking
// Feature 5: Game Center authentication & leaderboard

private let kBalance       = "gy_balance"
private let kDebt          = "gy_debt"
private let kTotalWins     = "gy_totalWins"
private let kTotalLosses   = "gy_totalLosses"
private let kMoneyWon      = "gy_totalMoneyWon"
private let kMoneyLost     = "gy_totalMoneyLost"
private let kBiggestWin    = "gy_biggestWin"
private let kBiggestLoss   = "gy_biggestLoss"
private let kInvest0       = "gy_invest_0"
private let kInvest1       = "gy_invest_1"
private let kInvest2       = "gy_invest_2"
private let kInvest3       = "gy_invest_3"
private let kLastClaim     = "gy_lastClaim"

final class GameEngine: ObservableObject {
    // Feature 1: Published + Combine-persisted
    @Published var balance: Double
    @Published var debt: Double

    // Feature 2: Stats
    @Published var totalWins: Int
    @Published var totalLosses: Int
    @Published var totalMoneyWon: Double
    @Published var totalMoneyLost: Double
    @Published var biggestWin: Double
    @Published var biggestLoss: Double

    @Published var state: AppState = .padock
    @Published var horses: [Horse] = []
    @Published var selectedHorseId: UUID? = nil
    @Published var betAmount: Double = 5.0
    @Published var commentator: String = "Padoka hoş geldin. Atını seç, bahsini koy."

    @Published var raceTime: Double = 0
    @Published var raceFinished: Bool = false
    @Published var didWin: Bool = false
    @Published var lastBet: Double = 0
    @Published var lastGross: Double = 0
    @Published var lastDebtPayment: Double = 0
    @Published var lastNetReceived: Double = 0
    @Published var raceCount: Int = 0

    @Published var trackSurface: TrackSurface = .grass
    @Published var clouds: [CloudSprite] = []
    @Published var cameraProgress: Double = 0

    // Cheat system
    @Published var selectedCheat: CheatType? = nil
    @Published var caughtCheating: Bool = false

    // Investment Office
    @Published var investmentOwned: [Bool] = [false, false, false, false]
    @Published var lastInvestmentClaim: Date = .distantPast

    private var timer: Timer?
    private let raceDuration: Double = 14.0
    private var lastCommentaryTime: Double = -10
    // Combine cancellables for persistence
    private var cancellables = Set<AnyCancellable>()

    private static let boomReasonsByKind: [Horse.BoomKind: [String]] = [
        .spin: ["kendi etrafında döndü, jokey fenalaştı!","midyeciyi gördü, dans etmeye başladı!","kuyruğunu kovalamaya kalktı!","yere bayrak diktiğini sandı!","şampiyonluk turunu önden attı!"],
        .reverse: ["jokeyini atıp sosisli standına daldı!","ters yöne döndü, kantine gitti!","anneanesini özledi, ahıra koşuyor!","şehirlerarası otobüsü kovalıyor!","tribündeki eski sevgilisini gördü, geri döndü!"],
        .faint: ["duraklayıp simit yedi!","kalp krizi geçirdi!","WiFi şifresini hatırlamaya çalıştı!","vergi denetimine takıldı!","selfie çekmek için durdu!","asgari ücreti hesaplamaya başladı!","boşandığını yeni hatırladı!","Tefeci Rıza'yı tribünde gördü, dondu kaldı!"]
    ]
    private static let liveCommentary: [String] = [
        "Toz duman birbirine girdi!","İnanılmaz bir mücadele!","Seyirciler ayakta!","Bahisçi terliyor!","Bu nasıl bir koşu kardeşim!","Tribünler çıldırdı, bayrak indi!","Tefeci Rıza tribünde notlar alıyor...","Veteriner sahaya çağrıldı!","Spiker mikrofonu fırlattı, yine aldı!","Bir at öne çıktı, sonra geri düştü!","Çamur uçuşuyor, ekran bulanık!","Pist hakemi acil çay molasına çıktı!"
    ]

    init() {
        // Feature 1: Load persisted values
        let ud = UserDefaults.standard
        let savedBalance = ud.double(forKey: kBalance)
        balance        = savedBalance > 0 ? savedBalance : 100.0
        debt           = max(0, ud.double(forKey: kDebt))
        totalWins      = ud.integer(forKey: kTotalWins)
        totalLosses    = ud.integer(forKey: kTotalLosses)
        totalMoneyWon  = ud.double(forKey: kMoneyWon)
        totalMoneyLost = ud.double(forKey: kMoneyLost)
        biggestWin     = ud.double(forKey: kBiggestWin)
        biggestLoss    = ud.double(forKey: kBiggestLoss)

        drawRaceField()
        generateClouds()

        // Feature 1: Persist changes via Combine
        $balance.dropFirst().sink       { ud.set($0, forKey: kBalance) }.store(in: &cancellables)
        $debt.dropFirst().sink          { ud.set($0, forKey: kDebt) }.store(in: &cancellables)
        $totalWins.dropFirst().sink     { ud.set($0, forKey: kTotalWins) }.store(in: &cancellables)
        $totalLosses.dropFirst().sink   { ud.set($0, forKey: kTotalLosses) }.store(in: &cancellables)
        $totalMoneyWon.dropFirst().sink { ud.set($0, forKey: kMoneyWon) }.store(in: &cancellables)
        $totalMoneyLost.dropFirst().sink{ ud.set($0, forKey: kMoneyLost) }.store(in: &cancellables)
        $biggestWin.dropFirst().sink    { ud.set($0, forKey: kBiggestWin) }.store(in: &cancellables)
        $biggestLoss.dropFirst().sink   { ud.set($0, forKey: kBiggestLoss) }.store(in: &cancellables)

        // Investment Office: load persisted state
        investmentOwned = [
            ud.bool(forKey: kInvest0),
            ud.bool(forKey: kInvest1),
            ud.bool(forKey: kInvest2),
            ud.bool(forKey: kInvest3)
        ]
        if let d = ud.object(forKey: kLastClaim) as? Date { lastInvestmentClaim = d }

        $investmentOwned.dropFirst().sink { arr in
            ud.set(arr[0], forKey: kInvest0); ud.set(arr[1], forKey: kInvest1)
            ud.set(arr[2], forKey: kInvest2); ud.set(arr[3], forKey: kInvest3)
        }.store(in: &cancellables)
        $lastInvestmentClaim.dropFirst().sink { ud.set($0, forKey: kLastClaim) }.store(in: &cancellables)

        // Feature 5: Game Center
        authenticateGameCenter()
    }

    deinit { timer?.invalidate() }

    // MARK: Feature 4: Hard reset (wipes all game data)
    func hardReset() {
        let ud = UserDefaults.standard
        [kBalance, kDebt, kTotalWins, kTotalLosses,
         kMoneyWon, kMoneyLost, kBiggestWin, kBiggestLoss,
         kInvest0, kInvest1, kInvest2, kInvest3, kLastClaim].forEach { ud.removeObject(forKey: $0) }
        balance = 100.0; debt = 0.0
        totalWins = 0; totalLosses = 0
        totalMoneyWon = 0; totalMoneyLost = 0
        biggestWin = 0; biggestLoss = 0
        raceCount = 0; betAmount = 5
        selectedCheat = nil; caughtCheating = false
        investmentOwned = [false, false, false, false]
        lastInvestmentClaim = .distantPast
        drawRaceField()
        commentator = "Padoka hoş geldin. Atını seç, bahsini koy."
        state = .padock
    }

    // MARK: Feature 5: Game Center
    func authenticateGameCenter() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] _, _ in
            if GKLocalPlayer.local.isAuthenticated {
                self?.submitScoreToLeaderboard(balance: self?.balance ?? 100)
            }
        }
    }

    func submitScoreToLeaderboard(balance: Double) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        GKLeaderboard.submitScore(
            Int(balance), context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: ["grp.highest_balance"]
        ) { _ in }
    }

    // MARK: - Race field

    func generateClouds() {
        let emojis = ["☁️","☁️","🌤️","☁️"]
        var arr: [CloudSprite] = []
        for i in 0..<9 {
            let parallax = Double.random(in: 0.15...0.55)
            arr.append(CloudSprite(
                worldX: Double(i) / 9.0 + Double.random(in: -0.03...0.03),
                y: CGFloat.random(in: 8...60),
                scale: CGFloat.random(in: 0.85...1.45),
                parallax: parallax,
                emoji: emojis.randomElement() ?? "☁️"
            ))
        }
        clouds = arr
    }

    func drawRaceField() {
        var arr: [Horse] = []
        let pool = HorseCatalog.all
        for tier in HorseTier.allCases {
            let cands = pool.filter { $0.tier == tier }
            if let t = cands.randomElement() {
                let s = makeStats(for: tier)
                let o = makeOdds(for: tier)
                arr.append(Horse(lane: arr.count, name: t.name, tier: tier,
                                 speed: s.0, health: s.1, stability: s.2, reliability: s.3,
                                 odds: o))
            }
        }
        arr.shuffle()
        for i in arr.indices { arr[i].lane = i }
        horses = arr
        selectedHorseId = nil
    }

    private func makeStats(for tier: HorseTier) -> (Int, Int, Int, Int) {
        switch tier {
        case .bionic:    return (Int.random(in: 90...100), Int.random(in: 90...100), Int.random(in: 90...100), 100)
        case .glassFuse: return (Int.random(in: 95...100), Int.random(in: 20...40), 50, 40)
        case .diesel:    return (60, 95, 90, 90)
        case .bipolar:   return (75, 50, 10, 60)
        case .scrap:     return (80, 20, 40, 20)
        case .clerk:     return (50, 50, 50, 50)
        case .timeBomb:  return (85, 50, 20, 0)
        case .trash:     return (Int.random(in: 10...20), Int.random(in: 10...20), Int.random(in: 10...20), Int.random(in: 10...20))
        }
    }
    private func makeOdds(for tier: HorseTier) -> Double {
        let r: ClosedRange<Double>
        switch tier {
        case .bionic: r = 1.1...1.3; case .glassFuse: r = 3...5; case .diesel: r = 6...8
        case .bipolar: r = 10...15;  case .scrap: r = 20...30;   case .clerk: r = 35...50
        case .timeBomb: r = 60...80; case .trash: r = 100...150
        }
        return (Double.random(in: r) * 10).rounded() / 10
    }

    func selectHorse(_ id: UUID) { selectedHorseId = id; selectedCheat = nil }
    func selectCheat(_ cheat: CheatType?) { selectedCheat = cheat }
    func setBet(_ a: Double) {
        var b = a
        if b > balance { b = balance }
        if b < 5 { b = 5 }
        if b > balance { b = balance }
        betAmount = b
    }
    func adjustBet(_ d: Double) { setBet(betAmount + d) }
    func allIn() { if balance >= 5 { betAmount = balance } }
    var canPlaceBet: Bool {
        selectedHorseId != nil && betAmount >= 5 && betAmount <= balance && balance >= 5
    }

    func placeBetAndStart() {
        guard canPlaceBet else { return }
        balance -= betAmount
        lastBet = betAmount
        trackSurface = TrackSurface.allCases.randomElement() ?? .grass
        generateClouds()
        cameraProgress = 0
        preCalculateRace()
        raceTime = 0
        raceFinished = false
        commentator = "🏁 GONG! Atlar çıktı!"
        lastCommentaryTime = -10
        state = .racing
        startTimer()
    }

    private func preCalculateRace() {
        var arr = horses
        for i in arr.indices {
            arr[i].progress = 0; arr[i].hasBoomed = false
            arr[i].yOffset = 0; arr[i].rotation = 0
            arr[i].runBob = 0; arr[i].emojiOverride = nil; arr[i].gallopPhase = 0

            let roll = Double.random(in: 0..<100)
            if roll < arr[i].boomChance {
                arr[i].willBoom = true
                arr[i].boomAtProgress = Double.random(in: 0.18...0.85)
                let kinds: [Horse.BoomKind] = [.spin, .reverse, .faint]
                let k = kinds.randomElement() ?? .spin
                arr[i].boomKind = k
                arr[i].boomReason = Self.boomReasonsByKind[k]?.randomElement() ?? "yarış dışı kaldı!"
                arr[i].finalScore = -1 - Double.random(in: 0...0.5)
            } else {
                arr[i].willBoom = false
                arr[i].boomAtProgress = 2.0
                arr[i].finalScore = arr[i].baseAsset * 0.5 + Double.random(in: 1...100) * 0.5
            }
        }

        // Cheat: per-cheat effect applied pre-race; caught status locked in now
        caughtCheating = false
        if let cheat = selectedCheat,
           let selId = selectedHorseId,
           let idx = arr.firstIndex(where: { $0.id == selId }) {
            switch cheat {
            case .energyDrink:
                // +15% to selected horse's final score
                if arr[idx].finalScore > 0 { arr[idx].finalScore *= 1.15 }
            case .laserGrip:
                // RNG luck floor: ensure minimum score of baseAsset*0.5 + 30
                if arr[idx].finalScore > 0 {
                    let floor = arr[idx].baseAsset * 0.5 + 30.0
                    arr[idx].finalScore = max(arr[idx].finalScore, floor)
                }
            case .shoeSabotage:
                // Force top 2 non-selected opponents to boom
                let opponents = arr.indices
                    .filter { arr[$0].id != selId && !arr[$0].willBoom }
                    .sorted { arr[$0].finalScore > arr[$1].finalScore }
                for ti in opponents.prefix(2) {
                    arr[ti].willBoom = true
                    arr[ti].boomAtProgress = Double.random(in: 0.35...0.75)
                    let k = [Horse.BoomKind.spin, .reverse, .faint].randomElement() ?? .spin
                    arr[ti].boomKind = k
                    arr[ti].boomReason = Self.boomReasonsByKind[k]?.randomElement() ?? "yarış dışı kaldı!"
                    arr[ti].finalScore = -1 - Double.random(in: 0...0.5)
                }
            }
            // Per-cheat catch risk
            caughtCheating = Double.random(in: 0..<1) < cheat.catchRisk
        }

        let sorted = arr.sorted { $0.finalScore > $1.finalScore }
        var pm: [UUID: Int] = [:]
        for (i, h) in sorted.enumerated() { pm[h.id] = i + 1 }
        for i in arr.indices { arr[i].placement = pm[arr[i].id] ?? 8 }
        horses = arr
    }

    private func startTimer() {
        timer?.invalidate()
        let dt = 1.0 / 30.0
        let t = Timer(timeInterval: dt, repeats: true) { [weak self] _ in
            self?.tick(dt: dt)
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick(dt: Double) {
        raceTime += dt
        var arr = horses
        var booming: String? = nil

        let nonBoomSorted = arr.filter { !$0.willBoom }.sorted { $0.placement < $1.placement }
        let nonBoomCount = max(1, nonBoomSorted.count)

        for i in arr.indices {
            if arr[i].willBoom && arr[i].hasBoomed {
                animateBoomedHorse(&arr[i])
                continue
            }
            if arr[i].progress >= 1.0 {
                arr[i].runBob = CGFloat(sin(raceTime * 18 + Double(arr[i].lane) * 2.1)) * 0.8
                continue
            }

            let targetDuration: Double
            if arr[i].willBoom {
                targetDuration = raceDuration * arr[i].boomAtProgress + 0.4
            } else {
                let rank = (nonBoomSorted.firstIndex(where: { $0.id == arr[i].id }) ?? 0) + 1
                let frac: Double = nonBoomCount > 1 ? Double(rank - 1) / Double(nonBoomCount - 1) : 0
                targetDuration = raceDuration * (0.85 + 0.15 * frac)
            }
            let base = min(1.0, raceTime / targetDuration)
            let lane = Double(arr[i].lane)
            let damp = 1.0 - base
            let wiggle =
                sin(raceTime * 2.3 + lane * 1.7) * 0.055 * damp
                + sin(raceTime * 1.05 + lane * 0.6) * 0.035 * damp
                + Double.random(in: -0.008...0.008) * damp
            var candidate = base + wiggle

            if arr[i].willBoom {
                if candidate >= arr[i].boomAtProgress {
                    candidate = arr[i].boomAtProgress
                    if !arr[i].hasBoomed {
                        arr[i].hasBoomed = true
                        arr[i].progress = arr[i].boomAtProgress
                        booming = "💥 BOOM! \(arr[i].name) \(arr[i].boomReason)"
                        lastCommentaryTime = raceTime
                        continue
                    }
                }
            }
            candidate = max(candidate, arr[i].progress)
            candidate = min(candidate, 1.0)
            arr[i].progress = candidate

            arr[i].runBob = CGFloat(sin(raceTime * 18 + lane * 2.1)) * 1.8
            let phaseDouble = (raceTime * 10 + lane).truncatingRemainder(dividingBy: 2)
            arr[i].gallopPhase = phaseDouble < 1 ? 0 : 1
        }

        horses = arr

        let leader = horses.filter { !$0.willBoom }.max(by: { $0.progress < $1.progress })
        let target = leader?.progress ?? 0
        cameraProgress += (target - cameraProgress) * 0.15

        if let b = booming { commentator = b } else { updateLiveCommentary() }
        let allDone = arr.allSatisfy { ($0.progress >= 1.0) || $0.hasBoomed }
        if allDone || raceTime > raceDuration * 1.20 { finishRace() }
    }

    private func animateBoomedHorse(_ h: inout Horse) {
        switch h.boomKind {
        case .spin:
            h.rotation += 18
            h.emojiOverride = "🐎"
            h.yOffset = 0; h.runBob = 0
        case .reverse:
            h.progress = max(0.0, h.progress - 0.0035)
            h.rotation = 180
            h.emojiOverride = "🐎"
            h.yOffset = CGFloat(sin(raceTime * 6 + Double(h.lane))) * 4
            h.runBob = 0
        case .faint:
            h.rotation = 90
            h.emojiOverride = "💥"
            h.yOffset = CGFloat(sin(raceTime * 8 + Double(h.lane))) * 5
            h.runBob = 0
        }
    }

    private func updateLiveCommentary() {
        guard raceTime - lastCommentaryTime > 2.6 else { return }
        let leader = horses.filter { !$0.hasBoomed }.max(by: { $0.progress < $1.progress })
        let r = Int.random(in: 0...2)
        if r == 0, let l = leader { commentator = "👉 Önde \(l.name)!" }
        else { commentator = Self.liveCommentary.randomElement() ?? "Yarış kızıştı!" }
        lastCommentaryTime = raceTime
    }

    // Feature 2: Statistics update helper
    private func recordStats(won: Bool, netAmount: Double) {
        if won {
            totalWins += 1
            totalMoneyWon += netAmount
            if netAmount > biggestWin { biggestWin = netAmount }
        } else {
            totalLosses += 1
            totalMoneyLost += netAmount
            if netAmount > biggestLoss { biggestLoss = netAmount }
        }
    }

    private func finishRace() {
        timer?.invalidate(); timer = nil
        var arr = horses
        for i in arr.indices where !arr[i].willBoom { arr[i].progress = 1.0 }
        horses = arr
        let winner = horses.first(where: { $0.placement == 1 })
        if let w = winner { commentator = "🏆 KAZANAN: \(w.name)! Ödemeler yapılıyor..." }

        if let selId = selectedHorseId,
           let my = horses.first(where: { $0.id == selId }),
           my.placement == 1, !my.willBoom {
            didWin = true
            let gross = lastBet * my.odds
            let netProfit = gross - lastBet
            var dp: Double = 0
            if debt > 0 {
                dp = min(debt, netProfit * 0.5)
                debt -= dp
                if debt < 0.01 { debt = 0 }
            }
            let recv = gross - dp
            lastGross = gross; lastDebtPayment = dp; lastNetReceived = recv
            balance += recv
            // Feature 2: record win stat (net profit = recv - bet)
            recordStats(won: true, netAmount: recv - lastBet)
        } else {
            didWin = false; lastGross = 0; lastDebtPayment = 0; lastNetReceived = 0
            // Feature 2: record loss stat
            recordStats(won: false, netAmount: lastBet)
        }

        // Feature 5: Submit score after balance change
        submitScoreToLeaderboard(balance: balance)

        raceFinished = true; raceCount += 1

        // Cheat caught? → per-cheat penalty (no uniform ban screen anymore)
        if let cheat = selectedCheat, caughtCheating {
            switch cheat {
            case .energyDrink:
                // Lose bet (already deducted) + 15% of remaining balance seized
                let seized = (balance * 0.15).rounded(.up)
                balance = max(0, balance - seized)
                commentator = String(format: "🚨 DOPİNG TESPİT EDİLDİ! %.1f ₺ müsadere edildi!", seized)
                selectedCheat = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
                    guard let s = self else { return }
                    s.state = s.balance < 5 ? .bankrupt : .result
                }
                return
            case .laserGrip:
                // Lose bet + Rıza slaps 500 ₺ fine
                let fine = min(balance, 500.0)
                balance = max(0, balance - fine)
                commentator = String(format: "🚨 LAZER TESPİT EDİLDİ! Rıza %.1f ₺ kesti!", fine)
                selectedCheat = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
                    guard let s = self else { return }
                    s.state = s.balance < 5 ? .bankrupt : .result
                }
                return
            case .shoeSabotage:
                // Immediate hard game over, debt slammed to 1000
                debt = max(debt, 1000.0)
                commentator = "🚨 NAL SÖKME TESPİT EDİLDİ! Tefeci Rıza devreye girdi!"
                selectedCheat = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
                    self?.state = .hardGameOver
                }
                return
            }
        }

        // Reset cheat selection for next round
        selectedCheat = nil

        // Feature 4: Route to hardGameOver if debt ≥ 1000
        let nextState: AppState = debt >= 1000.0 ? .hardGameOver : .result
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
            self?.state = nextState
        }
    }

    func nextRound() {
        selectedCheat = nil; caughtCheating = false
        drawRaceField()
        if balance < 5 { state = .bankrupt; return }
        if betAmount > balance { betAmount = balance }
        if betAmount < 5 { betAmount = 5 }
        commentator = "Padoka hoş geldin. Atını seç, bahsini koy."
        state = .padock
    }

    func shovelManure() {
        balance += 5; drawRaceField(); betAmount = 5
        commentator = "Sırtın ağrıdı, 5 ₺ kazandın. Şansını dene!"
        state = .padock
    }

    func takeLoanShark() {
        balance += 250; debt += 375
        if betAmount < 5 { betAmount = 5 }
        if betAmount > balance { betAmount = balance }
        // Feature 4: Hard game over if debt hits 1000+
        if debt >= 1000.0 {
            commentator = "Tefeci Rıza pisti devraldı. Borç 1000 ₺'yi geçti!"
            drawRaceField()
            state = .hardGameOver
            return
        }
        drawRaceField()
        commentator = "Tefeci Rıza parayı verdi. Şimdi koş bakalım..."
        state = .padock
    }

    // MARK: - Yatırım Ofisi

    static let investmentCosts:  [Double] = [250, 1_000, 5_000, 25_000]
    static let investmentIncome: [Double] = [25,  75,    250,   1_000]
    static let investmentNames:  [String] = [
        "Seyisler Derneği",
        "Hipodrom Tostçusu",
        "Ganyan Bayii İmtiyazı",
        "Hipodrom Gizli Ortağı"
    ]

    var totalInvestmentIncome: Double {
        investmentOwned.enumerated()
            .compactMap { i, owned in owned ? Self.investmentIncome[i] : nil }
            .reduce(0, +)
    }
    var hasAnyInvestment: Bool { investmentOwned.contains(true) }
    var canClaimInvestment: Bool {
        hasAnyInvestment && Date().timeIntervalSince(lastInvestmentClaim) >= 12 * 3600
    }
    var nextClaimDate: Date { lastInvestmentClaim.addingTimeInterval(12 * 3600) }

    func buyInvestment(_ index: Int) {
        guard index < 4, !investmentOwned[index] else { return }
        let cost = Self.investmentCosts[index]
        guard balance >= cost else { return }
        balance -= cost
        var arr = investmentOwned
        arr[index] = true
        investmentOwned = arr
    }

    func claimInvestment() {
        guard canClaimInvestment else { return }
        let income = totalInvestmentIncome
        balance += income
        lastInvestmentClaim = Date()
        scheduleInvestmentNotification()
    }

    func scheduleInvestmentNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            center.removePendingNotificationRequests(withIdentifiers: ["invest_ready"])
            let content = UNMutableNotificationContent()
            content.title = "At Yarışı HD"
            content.body = "Pasif gelirlerin hazır! Rıza Baba görmeden gel ve topla!"
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 12 * 3600, repeats: false)
            let req = UNNotificationRequest(identifier: "invest_ready", content: content, trigger: trigger)
            center.add(req) { _ in }
        }
    }
}

// MARK: - ANA EKRAN

struct ContentView: View {
    @StateObject private var engine = GameEngine()

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            Group {
                switch engine.state {
                case .padock:         PadockView()
                case .racing:         RaceTrackView()
                case .result:         ResultView()
                case .bankrupt:       BankruptView()
                case .hardGameOver:   HardGameOverView()
                case .cheatingCaught: CheatingCaughtView()
                }
            }
            .environmentObject(engine)
        }
        .preferredColorScheme(.light)
        .onAppear {
            OrientationController.set(.portrait)
            // Feature 4: restore hard game over state on launch
            if engine.debt >= 1000.0 { engine.state = .hardGameOver; return }
            if engine.balance < 5 { engine.state = .bankrupt }
        }
        .onChange(of: engine.state) { newState in
            if newState == .racing {
                OrientationController.set(.landscape)
            } else {
                OrientationController.set(.portrait)
            }
        }
    }
}

// MARK: - HEADER

struct HeaderView: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text("BAKİYE")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
                Text(String(format: "%.1f ₺", engine.balance))
                    .font(.system(size: 22, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.grassDark)
            }
            Spacer(minLength: 4)
            VStack(spacing: 0) {
                Text("🐎  AT YARIŞI HD")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundColor(Theme.inkBlack)
                Text("hipodrom · bahis · kaos")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
            }
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 2) {
                Text(engine.debt > 0 ? "RIZA'YA BORÇ" : "BORÇ YOK")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
                Text(String(format: "%.1f ₺", engine.debt))
                    .font(.system(size: 22, weight: .heavy, design: .monospaced))
                    .foregroundColor(engine.debt > 0 ? Theme.accentRed : Theme.inkSoft.opacity(0.5))
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .background(Theme.card)
        .overlay(Rectangle().frame(height: 1).foregroundColor(Theme.line), alignment: .bottom)
    }
}

// MARK: - PADOK
// Feature 2 & 5: Stats and Leaderboard buttons

struct PadockView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var showStats = false           // Feature 2
    @State private var showLeaderboard = false     // Feature 5

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()

            HStack(spacing: 8) {
                Text("// PADOK //")
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.grassDark)
                Spacer()

                // Feature 2: Stats button
                Button(action: { showStats = true }) {
                    HStack(spacing: 3) {
                        Text("🐎").font(.system(size: 11))
                        Text("İSTATİSTİK")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .fixedSize()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 5)
                    .background(Theme.grassDark)
                    .cornerRadius(5)
                }

                // Feature 5: Leaderboard button
                Button(action: { showLeaderboard = true }) {
                    HStack(spacing: 3) {
                        Text("🏆").font(.system(size: 11))
                        Text("LİDER TABLOSU")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .fixedSize()
                    }
                    .foregroundColor(Theme.inkBlack)
                    .padding(.horizontal, 8).padding(.vertical, 5)
                    .background(Theme.accentGold.opacity(0.18))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.accentGold, lineWidth: 1.5))
                    .cornerRadius(5)
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 6)
            .background(Theme.sand.opacity(0.5))

            ScrollView {
                VStack(spacing: 6) {
                    InvestmentOfficeView()
                        .padding(.horizontal, 8).padding(.top, 8)
                    ForEach(engine.horses) { h in
                        HorseRow(horse: h, isSelected: h.id == engine.selectedHorseId) {
                            engine.selectHorse(h.id)
                        }
                    }
                }
                .padding(.horizontal, 8).padding(.vertical, 8)
            }
            // Cheat panel appears after horse is selected
            if engine.selectedHorseId != nil {
                CheatPanelView()
            }
            BetPanelView()
        }
        // Feature 2: Stats sheet
        .sheet(isPresented: $showStats) {
            StatsView().environmentObject(engine)
        }
        // Feature 5: Game Center leaderboard sheet
        .sheet(isPresented: $showLeaderboard) {
            GameCenterView()
        }
    }
}

struct HorseRow: View {
    let horse: Horse
    let isSelected: Bool
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(horse.tier.color.opacity(0.15)).frame(width: 38, height: 38)
                    Text("🐎").font(.system(size: 22))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(horse.name)
                        .font(.system(size: 14, weight: .heavy, design: .monospaced))
                        .foregroundColor(Theme.inkBlack).lineLimit(1).minimumScaleFactor(0.85)
                    HStack(spacing: 6) {
                        Text("[\(horse.tier.label)]")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(horse.tier.color)
                        Text(horse.tier.tagline)
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(Theme.inkSoft).lineLimit(1)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.1fx", horse.odds))
                        .font(.system(size: 18, weight: .heavy, design: .monospaced))
                        .foregroundColor(Theme.accentGold)
                    HStack(spacing: 4) {
                        StatBadge(label: "H", value: horse.speed)
                        StatBadge(label: "C", value: horse.health)
                        StatBadge(label: "D", value: horse.stability)
                        StatBadge(label: "G", value: horse.reliability)
                    }
                }
            }
            .padding(.horizontal, 10).padding(.vertical, 9)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Theme.grass.opacity(0.10) : Theme.card))
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Theme.grassDark : Theme.line, lineWidth: isSelected ? 2 : 1))
        }
        .buttonStyle(.plain)
    }
}

struct StatBadge: View {
    let label: String; let value: Int
    var color: Color {
        if value >= 80 { return Theme.goodGreen }
        if value >= 50 { return Theme.accentGold }
        if value >= 25 { return Color(red: 0.85, green: 0.45, blue: 0.10) }
        return Theme.accentRed
    }
    var body: some View {
        Text("\(label):\(value)")
            .font(.system(size: 9, weight: .heavy, design: .monospaced))
            .foregroundColor(color)
            .padding(.horizontal, 4).padding(.vertical, 2)
            .background(color.opacity(0.12)).cornerRadius(3)
    }
}

struct BetPanelView: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("BAHİS")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
                Spacer()
                Text(String(format: "%.1f ₺", engine.betAmount))
                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.accentGold)
            }
            HStack(spacing: 5) {
                BetButton("-50") { engine.adjustBet(-50) }
                BetButton("-10") { engine.adjustBet(-10) }
                BetButton("-5")  { engine.adjustBet(-5) }
                BetButton("+5")  { engine.adjustBet(5) }
                BetButton("+10") { engine.adjustBet(10) }
                BetButton("+50") { engine.adjustBet(50) }
                Button(action: { engine.allIn() }) {
                    Text("KASAYI BAS")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 8)
                        .background(Theme.accentRed).cornerRadius(4)
                }
            }
            Button(action: { engine.placeBetAndStart() }) {
                Text(label)
                    .font(.system(size: 16, weight: .heavy, design: .monospaced))
                    .frame(maxWidth: .infinity).padding(.vertical, 13)
                    .background(engine.canPlaceBet ? Theme.grassDark : Theme.line)
                    .foregroundColor(engine.canPlaceBet ? .white : Theme.inkSoft)
                    .cornerRadius(6)
            }
            .disabled(!engine.canPlaceBet)
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Theme.card)
        .overlay(Rectangle().frame(height: 1).foregroundColor(Theme.line), alignment: .top)
    }
    private var label: String {
        if engine.balance < 5 { return "BAKİYE YETERSİZ" }
        if engine.selectedHorseId == nil { return "ÖNCE AT SEÇ!" }
        return "▶ YARIŞA BAŞLA!"
    }
}

struct BetButton: View {
    let label: String; let action: () -> Void
    init(_ l: String, action: @escaping () -> Void) { self.label = l; self.action = action }
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .heavy, design: .monospaced))
                .frame(maxWidth: .infinity, minHeight: 28)
                .foregroundColor(Theme.inkBlack).background(Theme.sand)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.sandDark, lineWidth: 1))
                .cornerRadius(4)
        }
    }
}

// MARK: - YATAY YARIŞ PİSTİ (HD)

struct RaceTrackView: View {
    @EnvironmentObject var engine: GameEngine

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            ZStack(alignment: .topLeading) {
                HippodromeScene(size: geo.size)
                    .environmentObject(engine)

                VStack {
                    HStack {
                        SpikerOverlay()
                            .environmentObject(engine)
                            .frame(maxWidth: isLandscape ? geo.size.width * 0.55 : .infinity)
                        Spacer(minLength: 6)
                        BetInfoChip().environmentObject(engine)
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, isLandscape ? 8 : 14)
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .statusBarHidden(true)
    }
}

struct SpikerOverlay: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Text("📢").font(.system(size: 11))
                Text("SPİKER · CANLI")
                    .font(.system(size: 9, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.grassDark)
                Text(String(format: "%02d. KOŞU", engine.raceCount + 1))
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
                Spacer()
                Text(engine.trackSurface.label == "ÇİM" ? "🌱 ÇİM PİSTİ" : "🏜 KUM PİSTİ")
                    .font(.system(size: 9, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.inkBlack)
                    .padding(.horizontal, 5).padding(.vertical, 2)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(3)
            }
            Text(engine.commentator)
                .font(.system(size: 13, weight: .heavy, design: .monospaced))
                .foregroundColor(Theme.inkBlack)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.88)))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.grassDark.opacity(0.6), lineWidth: 1))
    }
}

struct BetInfoChip: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        if let id = engine.selectedHorseId,
           let h = engine.horses.first(where: { $0.id == id }) {
            VStack(alignment: .trailing, spacing: 1) {
                Text(h.name)
                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                    .foregroundColor(h.tier.color).lineLimit(1)
                Text(String(format: "%.1f ₺ × %.1fx", engine.lastBet, h.odds))
                    .font(.system(size: 10, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.accentGold)
                Text(String(format: "BAKİYE %.1f ₺", engine.balance))
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
            }
            .padding(.horizontal, 8).padding(.vertical, 5)
            .background(Color.white.opacity(0.88))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.line, lineWidth: 1))
            .cornerRadius(6)
        }
    }
}

// MARK: - HİPODROM SAHNESİ

struct HippodromeScene: View {
    @EnvironmentObject var engine: GameEngine
    let size: CGSize

    var body: some View {
        let viewW = size.width
        let viewH = size.height
        let worldW = viewW * 3.0
        let leaderX = engine.cameraProgress * (worldW - viewW)
        let cameraX = max(0, min(worldW - viewW, leaderX))
        let skyH = viewH * 0.42
        let groundH = viewH - skyH

        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [Theme.skyTop, Theme.skyMid, Theme.skyHorizon],
                startPoint: .top, endPoint: .bottom
            )
            .frame(width: viewW, height: skyH)

            ZStack(alignment: .topLeading) {
                ForEach(engine.clouds) { cloud in
                    let cloudWorldX = cloud.worldX * worldW * 1.4
                    let cx = cloudWorldX - cameraX * cloud.parallax
                    let wrapped = wrap(cx, mod: viewW * 1.5)
                    Text(cloud.emoji)
                        .font(.system(size: 32 * cloud.scale))
                        .position(x: wrapped, y: cloud.y)
                        .opacity(0.9)
                }
            }
            .frame(width: viewW, height: skyH)
            .clipped()

            Circle()
                .fill(LinearGradient(colors: [Color.yellow.opacity(0.95), Color.orange.opacity(0.6)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(width: 38, height: 38)
                .position(x: viewW - 60, y: 36)

            HorizonStrip(width: viewW, cameraX: cameraX, worldW: worldW)
                .frame(width: viewW, height: 14)
                .position(x: viewW / 2, y: skyH - 7)

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(LinearGradient(
                        colors: [engine.trackSurface.primary, engine.trackSurface.secondary],
                        startPoint: .top, endPoint: .bottom
                    ))
                    .frame(width: viewW, height: groundH)

                TrackArea(size: CGSize(width: viewW, height: groundH),
                          worldW: worldW, cameraX: cameraX)
                    .environmentObject(engine)
            }
            .offset(y: skyH)
        }
        .frame(width: viewW, height: viewH)
    }

    private func wrap(_ x: CGFloat, mod m: CGFloat) -> CGFloat {
        let r = x.truncatingRemainder(dividingBy: m)
        return r < 0 ? r + m : r
    }
}

struct HorizonStrip: View {
    let width: CGFloat
    let cameraX: CGFloat
    let worldW: CGFloat
    var body: some View {
        Canvas { ctx, size in
            let parallax: CGFloat = 0.55
            let offset = cameraX * parallax
            let segW: CGFloat = 18
            var x: CGFloat = -offset.truncatingRemainder(dividingBy: segW)
            var i = 0
            while x < size.width {
                let h = size.height
                let bayrakRect = CGRect(x: x, y: 0, width: segW - 2, height: h * 0.6)
                let col: Color = (i % 2 == 0)
                    ? Color(red: 0.78, green: 0.20, blue: 0.20)
                    : Color(red: 0.95, green: 0.95, blue: 0.95)
                ctx.fill(Path(bayrakRect), with: .color(col.opacity(0.85)))
                let direk = CGRect(x: x + segW/2 - 1, y: h * 0.6, width: 2, height: h * 0.4)
                ctx.fill(Path(direk), with: .color(.black.opacity(0.55)))
                x += segW
                i += 1
            }
        }
    }
}

// MARK: - TRACK AREA
// Feature 3: Dynamic Island / notch clearance in landscape (.padding(.leading, 50) on lane labels)

struct TrackArea: View {
    @EnvironmentObject var engine: GameEngine
    let size: CGSize
    let worldW: CGFloat
    let cameraX: CGFloat

    // Feature 3: leading inset to clear Dynamic Island / notch in landscape
    private let diSafeInset: CGFloat = 50

    var body: some View {
        let viewW = size.width
        let h = size.height
        let laneCount = max(engine.horses.count, 1)
        let laneH = h / CGFloat(laneCount)
        let trackStartWorld: CGFloat = viewW * 0.10
        let trackEndWorld: CGFloat = worldW - viewW * 0.10
        let trackLen = trackEndWorld - trackStartWorld

        ZStack(alignment: .topLeading) {
            // Şerit çizgileri
            ForEach(0...laneCount, id: \.self) { i in
                Rectangle()
                    .fill(engine.trackSurface.laneLine)
                    .frame(width: viewW, height: 1)
                    .offset(y: CGFloat(i) * laneH)
            }

            // Mesafe çubukları
            Canvas { ctx, size in
                let interval: CGFloat = viewW * 0.35
                var wx: CGFloat = trackStartWorld
                var n = 0
                while wx < trackEndWorld {
                    let sx = wx - cameraX
                    if sx > -10 && sx < size.width + 10 {
                        let r = CGRect(x: sx, y: 0, width: 1, height: size.height)
                        ctx.fill(Path(r), with: .color(.white.opacity(0.35)))
                        let txt = Text("\(n*100)m")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(.black.opacity(0.45))
                        ctx.draw(txt, at: CGPoint(x: sx + 12, y: size.height - 8))
                    }
                    wx += interval
                    n += 1
                }
            }
            .frame(width: viewW, height: h)
            .allowsHitTesting(false)

            // Başlangıç kapısı
            startingGate(at: trackStartWorld, cameraX: cameraX, h: h)
            // Bitiş çizgisi
            finishLine(at: trackEndWorld, cameraX: cameraX, h: h)

            // Feature 3: Şerit isim etiketleri — Dynamic Island clearance
            VStack(spacing: 0) {
                ForEach(Array(engine.horses.enumerated()), id: \.element.id) { idx, horse in
                    let isMyHorse = horse.id == engine.selectedHorseId
                    HStack(spacing: 4) {
                        Text("\(idx + 1)")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(width: 18)
                            .background(horse.tier.color)
                            .cornerRadius(3)
                        Text(horse.name)
                            .font(.system(size: 13, weight: .heavy, design: .monospaced))
                            .foregroundColor(isMyHorse ? Theme.grassDark : Theme.inkBlack)
                            .lineLimit(1).minimumScaleFactor(0.6)
                        Spacer()
                    }
                    .padding(.leading, diSafeInset)
                    .padding(.trailing, 4)
                    .frame(height: laneH, alignment: .center)
                    .background(isMyHorse
                        ? Color(red: 0.75, green: 1.0, blue: 0.75).opacity(0.80)
                        : Color.white.opacity(0.55))
                }
            }
            .frame(width: diSafeInset + 106, height: h)

            // Atlar
            ForEach(Array(engine.horses.enumerated()), id: \.element.id) { idx, horse in
                let worldX = trackStartWorld + trackLen * CGFloat(horse.progress)
                let sx = worldX - cameraX
                let cy = CGFloat(idx) * laneH + laneH / 2
                Ellipse()
                    .fill(Color.black.opacity(0.18))
                    .frame(width: 26, height: 6)
                    .position(x: sx, y: cy + 12)
                Text(horse.emojiOverride ?? "🐎")
                    .font(.system(size: 22 + (horse.gallopPhase == 1 ? 1 : 0)))
                    .rotationEffect(.degrees(horse.rotation))
                    .scaleEffect(x: 1.0, y: horse.gallopPhase == 1 ? 0.94 : 1.0, anchor: .bottom)
                    .position(x: sx, y: cy + horse.yOffset + horse.runBob - 4)
            }
        }
        .frame(width: viewW, height: h)
        .clipped()
    }

    @ViewBuilder
    private func startingGate(at worldX: CGFloat, cameraX: CGFloat, h: CGFloat) -> some View {
        let sx = worldX - cameraX
        if sx > -30 && sx < (size.width + 30) {
            Rectangle()
                .fill(Color.white)
                .frame(width: 4, height: h)
                .overlay(Rectangle().stroke(Color.black.opacity(0.6), lineWidth: 1))
                .position(x: sx, y: h / 2)
            Text("BAŞ")
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 3).padding(.vertical, 1)
                .background(Theme.accentRed)
                .position(x: sx + 14, y: 8)
        }
    }

    @ViewBuilder
    private func finishLine(at worldX: CGFloat, cameraX: CGFloat, h: CGFloat) -> some View {
        let sx = worldX - cameraX
        if sx > -30 && sx < (size.width + 30) {
            Canvas { ctx, sz in
                let rows = max(1, Int(sz.height / 7))
                for i in 0..<rows {
                    let y = CGFloat(i) * 7
                    let c: Color = (i % 2 == 0) ? .white : .black
                    ctx.fill(Path(CGRect(x: 0, y: y, width: 6, height: 7)), with: .color(c))
                }
            }
            .frame(width: 6, height: h)
            .position(x: sx, y: h / 2)
            Text("BİTİŞ")
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 3).padding(.vertical, 1)
                .background(Theme.grassDark)
                .position(x: sx + 20, y: 8)
        }
    }
}

// MARK: - SONUÇ

struct ResultView: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        let winner = engine.horses.first(where: { $0.placement == 1 })
        let myHorse = engine.horses.first(where: { $0.id == engine.selectedHorseId })
        VStack(spacing: 14) {
            HeaderView()
            Spacer(minLength: 4)
            Text(engine.didWin ? "🎉 KAZANDIN! 🎉" : "💸 KAYBETTİN")
                .font(.system(size: 30, weight: .black, design: .monospaced))
                .foregroundColor(engine.didWin ? Theme.grassDark : Theme.accentRed)

            if let w = winner {
                VStack(spacing: 3) {
                    Text("🏆 KAZANAN AT")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.inkSoft)
                    Text(w.name)
                        .font(.system(size: 20, weight: .heavy, design: .monospaced))
                        .foregroundColor(Theme.accentGold)
                    Text("[\(w.tier.label)] · \(String(format: "%.1fx", w.odds))")
                        .font(.system(size: 11, weight: .heavy, design: .monospaced))
                        .foregroundColor(w.tier.color)
                }
                .padding(10).frame(maxWidth: .infinity)
                .background(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.accentGold, lineWidth: 1))
                .padding(.horizontal, 20)
            }

            if let mh = myHorse {
                VStack(spacing: 3) {
                    Text("SENİN ATIN")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.inkSoft)
                    Text(mh.name)
                        .font(.system(size: 16, weight: .heavy, design: .monospaced))
                        .foregroundColor(mh.tier.color)
                    if mh.willBoom {
                        Text("💥 PİSTTE PATLADI!")
                            .font(.system(size: 12, weight: .heavy, design: .monospaced))
                            .foregroundColor(Theme.accentRed)
                    } else {
                        Text("\(mh.placement). sırada bitti")
                            .font(.system(size: 12, weight: .heavy, design: .monospaced))
                            .foregroundColor(Theme.inkSoft)
                    }
                }
                .padding(10).frame(maxWidth: .infinity)
                .background(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.line, lineWidth: 1))
                .padding(.horizontal, 20)
            }

            VStack(spacing: 6) {
                if engine.didWin {
                    row("Bahis:", String(format: "%.1f ₺", engine.lastBet), Theme.inkBlack)
                    row("Brüt Ödeme:", String(format: "+%.1f ₺", engine.lastGross), Theme.goodGreen)
                    if engine.lastDebtPayment > 0 {
                        row("Rıza'nın %50 Vergisi:", String(format: "-%.1f ₺", engine.lastDebtPayment), Theme.accentRed)
                    }
                    Divider().background(Theme.line)
                    row("CEBE GİREN:", String(format: "+%.1f ₺", engine.lastNetReceived), Theme.grassDark, bold: true)
                } else {
                    row("Bahis:", String(format: "%.1f ₺", engine.lastBet), Theme.inkBlack)
                    row("Kayıp:", String(format: "-%.1f ₺", engine.lastBet), Theme.accentRed, bold: true)
                }
            }
            .padding(12).background(Theme.card)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.line, lineWidth: 1))
            .padding(.horizontal, 20)

            Spacer()
            Button(action: { engine.nextRound() }) {
                Text(engine.balance < 5 ? "▶ DEVAM" : "▶ YENİ KOŞU")
                    .font(.system(size: 17, weight: .heavy, design: .monospaced))
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Theme.grassDark).foregroundColor(.white).cornerRadius(6)
            }
            .padding(.horizontal, 20).padding(.bottom, 18)
        }
    }
    private func row(_ l: String, _ v: String, _ c: Color, bold: Bool = false) -> some View {
        HStack {
            Text(l).font(.system(size: bold ? 14 : 12, weight: bold ? .heavy : .semibold, design: .monospaced))
                .foregroundColor(Theme.inkBlack)
            Spacer()
            Text(v).font(.system(size: bold ? 16 : 13, weight: bold ? .black : .heavy, design: .monospaced))
                .foregroundColor(c)
        }
    }
}

// MARK: - İFLAS

struct BankruptView: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        VStack(spacing: 16) {
            HeaderView()
            Spacer()
            Text("💀 İFLAS 💀")
                .font(.system(size: 40, weight: .black, design: .monospaced))
                .foregroundColor(Theme.accentRed)
            VStack(spacing: 6) {
                Text("Cebinde 5 ₺ bile yok.")
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
                Text("Tribün soğuk, mide boş. Ne yapacaksın?")
                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.inkBlack)
            }
            .multilineTextAlignment(.center).padding(.horizontal, 24)

            VStack(spacing: 14) {
                Button(action: { engine.shovelManure() }) {
                    VStack(spacing: 4) {
                        Text("🪣 AMELELİK")
                            .font(.system(size: 18, weight: .black, design: .monospaced))
                        Text("+5.0 ₺ · Ahır kürekleyeceksin.")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(Theme.inkBlack.opacity(0.7))
                        Text("Onurun azıcık çiziklenir.")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Theme.inkSoft)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Theme.sand).foregroundColor(Theme.inkBlack)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.sandDark, lineWidth: 1))
                    .cornerRadius(10)
                }
                Button(action: { engine.takeLoanShark() }) {
                    VStack(spacing: 4) {
                        Text("🕴️ TEFECİ RIZA'YA GİT")
                            .font(.system(size: 18, weight: .black, design: .monospaced))
                        Text("+250.0 ₺ · Borç: 375.0 ₺ (%50 faiz)")
                            .font(.system(size: 11, weight: .heavy, design: .monospaced))
                            .foregroundColor(.white.opacity(0.95))
                        Text("Net kârının %50'si Rıza'ya akar.")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(LinearGradient(
                        colors: [Theme.accentRed, Color(red: 0.5, green: 0.05, blue: 0.05)],
                        startPoint: .top, endPoint: .bottom))
                    .foregroundColor(.white).cornerRadius(10)
                }
            }
            .padding(.horizontal, 24)
            Spacer()
            Text("« Ya kürek ya Rıza. Başka yol yok. »")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundColor(Theme.inkSoft).italic()
                .padding(.bottom, 18)
        }
    }
}

// MARK: - HİLE PANELİ

struct CheatPanelView: View {
    @EnvironmentObject var engine: GameEngine

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("🎭")
                    .font(.system(size: 13))
                Text("HİLE YAPMAK İSTER MİSİN?")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(Color(red: 0.55, green: 0.10, blue: 0.55))
                Spacer()
                Text("HİLE YAP · YAKALAN · ÖDE")
                    .font(.system(size: 8, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.accentRed)
                    .padding(.horizontal, 5).padding(.vertical, 2)
                    .background(Theme.accentRed.opacity(0.10))
                    .cornerRadius(3)
            }
            .padding(.horizontal, 12).padding(.top, 8).padding(.bottom, 6)

            // Clean play option
            CheatOptionRow(
                emoji: "😇",
                label: "Temiz Oyna",
                boostLabel: "hile yok",
                boostColor: Theme.goodGreen,
                isSelected: engine.selectedCheat == nil
            ) { engine.selectCheat(nil) }

            // Cheat options
            ForEach(CheatType.allCases) { cheat in
                CheatOptionRow(
                    emoji: cheat.emoji,
                    label: cheat.label,
                    boostLabel: "\(cheat.effectLabel) · \(cheat.riskLabel)",
                    boostColor: Color(red: 0.55, green: 0.10, blue: 0.55),
                    penaltyLabel: cheat.penaltyLabel,
                    isSelected: engine.selectedCheat == cheat
                ) { engine.selectCheat(cheat) }
            }
        }
        .background(Color(red: 0.98, green: 0.94, blue: 0.99))
        .overlay(
            VStack {
                Rectangle().frame(height: 1).foregroundColor(Color(red: 0.75, green: 0.55, blue: 0.78).opacity(0.5))
                Spacer()
            }
        )
    }
}

struct CheatOptionRow: View {
    let emoji: String
    let label: String
    let boostLabel: String
    let boostColor: Color
    var penaltyLabel: String = ""
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(isSelected ? "◉" : "○")
                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                    .foregroundColor(isSelected ? boostColor : Theme.inkSoft)
                Text(emoji).font(.system(size: 14))
                VStack(alignment: .leading, spacing: 1) {
                    Text(label)
                        .font(.system(size: 11, weight: isSelected ? .heavy : .regular, design: .monospaced))
                        .foregroundColor(isSelected ? Theme.inkBlack : Theme.inkSoft)
                        .lineLimit(1).minimumScaleFactor(0.8)
                    if isSelected && !penaltyLabel.isEmpty {
                        Text("⚠ \(penaltyLabel)")
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .foregroundColor(Theme.accentRed)
                            .lineLimit(1).minimumScaleFactor(0.7)
                    }
                }
                Spacer()
                Text(boostLabel)
                    .font(.system(size: 9, weight: .heavy, design: .monospaced))
                    .foregroundColor(boostColor)
                    .padding(.horizontal, 5).padding(.vertical, 2)
                    .background(boostColor.opacity(0.10))
                    .cornerRadius(3)
            }
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(isSelected ? boostColor.opacity(0.06) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - HİLEDEN YAKALANDIN EKRANI

struct CheatingCaughtView: View {
    @EnvironmentObject var engine: GameEngine

    var body: some View {
        ZStack {
            Color(red: 0.10, green: 0.05, blue: 0.12).ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()

                // Badge
                Text("🚨")
                    .font(.system(size: 80))
                    .padding(.bottom, 8)

                Text("HİLEDEN YAKALANDIN")
                    .font(.system(size: 26, weight: .black, design: .monospaced))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)

                VStack(spacing: 10) {
                    Text("BAHİSÇİLİKTEN MEN EDİLDİN")
                        .font(.system(size: 15, weight: .heavy, design: .monospaced))
                        .foregroundColor(Color(red: 1, green: 0.85, blue: 0.30))

                    Text("HİLE HURDA KÖTÜDÜR!")
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundColor(.red.opacity(0.85))
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(6)

                    Text("Sabri Abi tutanağı imzaladı.\nKayıtlardan silindin.")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)

                Spacer()

                Button(action: { engine.hardReset() }) {
                    Text("😔  özür dilerim sabri abi")
                        .font(.system(size: 16, weight: .black, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.60, green: 0.10, blue: 0.10))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 28)

                Text("« Tüm kayıtlar silinir. Sıfır. »")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.30))
                    .italic()
                    .padding(.top, 10)
                    .padding(.bottom, 28)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Feature 2: İSTATİSTİK EKRANI

struct StatsView: View {
    @EnvironmentObject var engine: GameEngine
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Modal header
            HStack {
                Text("📊 İSTATİSTİK")
                    .font(.system(size: 16, weight: .black, design: .monospaced))
                    .foregroundColor(Theme.inkBlack)
                Spacer()
                Button(action: { dismiss() }) {
                    Text("KAPAT")
                        .font(.system(size: 11, weight: .heavy, design: .monospaced))
                        .foregroundColor(Theme.accentRed)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Theme.accentRed.opacity(0.08))
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
            .background(Theme.card)
            .overlay(Rectangle().frame(height: 1).foregroundColor(Theme.line), alignment: .bottom)

            ScrollView {
                VStack(spacing: 8) {
                    let total = engine.totalWins + engine.totalLosses
                    let winRate = total > 0
                        ? Double(engine.totalWins) / Double(total) * 100
                        : 0.0

                    statRow("TOPLAM KOŞU",      "\(total)",         Theme.inkBlack)
                    statRow("GALİBİYET",        "\(engine.totalWins)",  Theme.goodGreen)
                    statRow("MAĞLUBİYET",       "\(engine.totalLosses)", Theme.accentRed)
                    statRow("GALİBİYET ORANI",  String(format: "%.1f%%", winRate),
                            winRate >= 50 ? Theme.goodGreen : Theme.accentRed)
                    Divider().padding(.vertical, 2)
                    statRow("TOPLAM NET KAZANÇ",  String(format: "+%.1f ₺", engine.totalMoneyWon),  Theme.goodGreen)
                    statRow("TOPLAM KAYIP",       String(format: "-%.1f ₺", engine.totalMoneyLost), Theme.accentRed)
                    statRow("EN BÜYÜK TEK KAZANÇ", String(format: "%.1f ₺", engine.biggestWin),     Theme.accentGold)
                    statRow("EN BÜYÜK TEK KAYIP",  String(format: "%.1f ₺", engine.biggestLoss),    Theme.accentRed)
                    Divider().padding(.vertical, 2)
                    statRow("BAKİYE",   String(format: "%.1f ₺", engine.balance), Theme.grassDark)
                    statRow("BORÇ",     String(format: "%.1f ₺", engine.debt),
                            engine.debt > 0 ? Theme.accentRed : Theme.inkSoft)
                }
                .padding(14)
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .preferredColorScheme(.light)
    }

    private func statRow(_ label: String, _ value: String, _ color: Color) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(Theme.inkSoft)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .heavy, design: .monospaced))
                .foregroundColor(color)
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Theme.card)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.line, lineWidth: 1))
        .cornerRadius(6)
    }
}

// MARK: - Feature 4: HARD GAME OVER

struct HardGameOverView: View {
    @EnvironmentObject var engine: GameEngine

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()

                // Rıza illustration
                Text("🕴️")
                    .font(.system(size: 90))
                    .padding(.bottom, 8)

                Text("OYUN BİTTİ")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(Theme.accentRed)
                    .padding(.bottom, 12)

                VStack(spacing: 8) {
                    Text("Tefeci Rıza pisti devraldı.")
                        .font(.system(size: 16, weight: .heavy, design: .monospaced))
                        .foregroundColor(Theme.inkBlack)
                    Text(String(format: "Toplam borç: %.1f ₺", engine.debt))
                        .font(.system(size: 14, weight: .heavy, design: .monospaced))
                        .foregroundColor(Theme.accentRed)
                    Text("Bundan sonrası senin bileceğin iş.")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(Theme.inkSoft)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .padding(.bottom, 32)

                Spacer()

                // Reset button
                Button(action: { engine.hardReset() }) {
                    Text("🔄 HERŞEYİ SIFIRLA")
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Theme.accentRed, Color(red: 0.50, green: 0.05, blue: 0.05)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 28)

                Text("« Tüm kayıtlar silinir. Taze başlangıç. »")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
                    .italic()
                    .padding(.top, 12)
                    .padding(.bottom, 28)
            }
        }
        .preferredColorScheme(.light)
    }
}

// MARK: - Feature 5: GAME CENTER

struct GameCenterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let vc = GKGameCenterViewController(
            leaderboardID: "grp.highest_balance",
            playerScope: .global,
            timeScope: .allTime
        )
        vc.gameCenterDelegate = context.coordinator
        return vc
    }
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: true)
        }
    }
}

// MARK: - YATIRIM OFİSİ

struct InvestmentOfficeView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var expanded: Bool = false
    @State private var now: Date = Date()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            // Header / toggle
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() } }) {
                HStack(spacing: 6) {
                    Text("💼").font(.system(size: 14))
                    Text("YATIRIM OFİSİ")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(Color(red: 0.10, green: 0.25, blue: 0.55))
                    Spacer()
                    if engine.hasAnyInvestment {
                        Text(String(format: "+%.0f ₺/12s", engine.totalInvestmentIncome))
                            .font(.system(size: 9, weight: .heavy, design: .monospaced))
                            .foregroundColor(Theme.goodGreen)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Theme.goodGreen.opacity(0.12)).cornerRadius(3)
                    }
                    Text(expanded ? "▲" : "▼")
                        .font(.system(size: 10, weight: .heavy, design: .monospaced))
                        .foregroundColor(Color(red: 0.10, green: 0.25, blue: 0.55))
                }
                .padding(.horizontal, 12).padding(.vertical, 9)
            }
            .buttonStyle(.plain)
            .background(Color(red: 0.90, green: 0.94, blue: 1.0))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.60, green: 0.75, blue: 1.0), lineWidth: 1))

            if expanded {
                VStack(spacing: 0) {
                    // Claim row
                    if engine.hasAnyInvestment {
                        HStack(spacing: 8) {
                            if engine.canClaimInvestment {
                                Button(action: { engine.claimInvestment() }) {
                                    Text(String(format: "💰 GELİRLERİ TOPLA  +%.0f ₺", engine.totalInvestmentIncome))
                                        .font(.system(size: 12, weight: .black, design: .monospaced))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity).padding(.vertical, 9)
                                        .background(Theme.goodGreen).cornerRadius(6)
                                }
                                .buttonStyle(.plain)
                            } else {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("⏱ Sıradaki gelir:")
                                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                                        .foregroundColor(Theme.inkSoft)
                                    Text(countdownString)
                                        .font(.system(size: 14, weight: .heavy, design: .monospaced))
                                        .foregroundColor(Color(red: 0.10, green: 0.25, blue: 0.55))
                                }
                                Spacer()
                                Text(String(format: "+%.0f ₺", engine.totalInvestmentIncome))
                                    .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                    .foregroundColor(Theme.accentGold)
                            }
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Color(red: 0.94, green: 0.97, blue: 1.0))
                        Divider()
                    }

                    // Investment tiers
                    ForEach(0..<4, id: \.self) { i in
                        investmentRow(i)
                        if i < 3 { Divider().padding(.leading, 12) }
                    }
                }
                .background(Color(red: 0.97, green: 0.98, blue: 1.0))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.60, green: 0.75, blue: 1.0), lineWidth: 1))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onReceive(ticker) { t in now = t }
    }

    @ViewBuilder
    private func investmentRow(_ i: Int) -> some View {
        let owned   = engine.investmentOwned[i]
        let cost    = GameEngine.investmentCosts[i]
        let income  = GameEngine.investmentIncome[i]
        let name    = GameEngine.investmentNames[i]
        let canBuy  = !owned && engine.balance >= cost

        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 11, weight: .heavy, design: .monospaced))
                    .foregroundColor(owned ? Color(red: 0.10, green: 0.25, blue: 0.55) : Theme.inkBlack)
                Text(owned
                     ? String(format: "+%.0f ₺ / 12 saat ✓", income)
                     : String(format: "Maliyet: %.0f ₺  →  +%.0f ₺/12s", cost, income))
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundColor(owned ? Theme.goodGreen : Theme.inkSoft)
            }
            Spacer()
            if owned {
                Text("✅")
                    .font(.system(size: 18))
            } else {
                Button(action: { engine.buyInvestment(i) }) {
                    Text(canBuy ? "SATIN AL" : "YETERSİZ")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(canBuy ? .white : Theme.inkSoft)
                        .padding(.horizontal, 8).padding(.vertical, 5)
                        .background(canBuy ? Color(red: 0.10, green: 0.25, blue: 0.55) : Theme.line)
                        .cornerRadius(5)
                }
                .buttonStyle(.plain)
                .disabled(!canBuy)
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
    }

    private var countdownString: String {
        let remaining = max(0, engine.nextClaimDate.timeIntervalSince(now))
        let h = Int(remaining) / 3600
        let m = (Int(remaining) % 3600) / 60
        let s = Int(remaining) % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}

// MARK: - PREVIEW

#Preview {
    ContentView()
}
