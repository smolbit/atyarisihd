//
//  ContentView.swift
//  AT YARIŞI HD — Yatay Hipodrom · Kayan Kamera · Bulut Parallaksı
//
//  iOS 16+ · SwiftUI · 100 At Havuzu · Light Mode
//

import SwiftUI
import UIKit

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

enum AppState { case padock, racing, result, bankrupt }

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
    var yOffset: CGFloat = 0       // boom efektleri için
    var runBob: CGFloat = 0        // koşu animasyonu için
    var rotation: Double = 0
    var emojiOverride: String? = nil
    var gallopPhase: Int = 0       // 0/1 — koşu animasyon karesi

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
    var worldX: Double    // bulut katmanındaki x (0..1)
    var y: CGFloat        // gökyüzü içinde y
    var scale: CGFloat
    var parallax: Double  // kameraya göre kayma oranı (0..1)
    var emoji: String
}

// MARK: - GAME ENGINE

final class GameEngine: ObservableObject {
    @Published var state: AppState = .padock
    @Published var balance: Double = 100.0
    @Published var debt: Double = 0.0
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
    @Published var cameraProgress: Double = 0   // 0..1 — kamera ilerleyişi

    private var timer: Timer?
    private let raceDuration: Double = 14.0
    private var lastCommentaryTime: Double = -10

    private static let boomReasonsByKind: [Horse.BoomKind: [String]] = [
        .spin: ["kendi etrafında döndü, jokey fenalaştı!","midyeciyi gördü, dans etmeye başladı!","kuyruğunu kovalamaya kalktı!","yere bayrak diktiğini sandı!","şampiyonluk turunu önden attı!"],
        .reverse: ["jokeyini atıp sosisli standına daldı!","ters yöne döndü, kantine gitti!","anneanesini özledi, ahıra koşuyor!","şehirlerarası otobüsü kovalıyor!","tribündeki eski sevgilisini gördü, geri döndü!"],
        .faint: ["duraklayıp simit yedi!","kalp krizi geçirdi!","WiFi şifresini hatırlamaya çalıştı!","vergi denetimine takıldı!","selfie çekmek için durdu!","asgari ücreti hesaplamaya başladı!","boşandığını yeni hatırladı!","Tefeci Rıza'yı tribünde gördü, dondu kaldı!"]
    ]
    private static let liveCommentary: [String] = [
        "Toz duman birbirine girdi!","İnanılmaz bir mücadele!","Seyirciler ayakta!","Bahisçi terliyor!","Bu nasıl bir koşu kardeşim!","Tribünler çıldırdı, bayrak indi!","Tefeci Rıza tribünde notlar alıyor...","Veteriner sahaya çağrıldı!","Spiker mikrofonu fırlattı, yine aldı!","Bir at öne çıktı, sonra geri düştü!","Çamur uçuşuyor, ekran bulanık!","Pist hakemi acil çay molasına çıktı!"
    ]

    init() {
        drawRaceField()
        generateClouds()
    }

    deinit { timer?.invalidate() }

    func generateClouds() {
        let emojis = ["☁️","☁️","🌤️","☁️"]
        var arr: [CloudSprite] = []
        // 9 bulut, dağıtık
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

    func selectHorse(_ id: UUID) { selectedHorseId = id }
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
                // Bitirenler de hafif sallansın
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

            // Koşu animasyonu: dikey bob + dönüşümlü kare
            arr[i].runBob = CGFloat(sin(raceTime * 18 + lane * 2.1)) * 1.8
            let phaseDouble = (raceTime * 10 + lane).truncatingRemainder(dividingBy: 2)
            arr[i].gallopPhase = phaseDouble < 1 ? 0 : 1
        }

        horses = arr

        // Kamera: liderin ilerleyişini takip et (sadece patlayanları sayma)
        let leader = horses.filter { !$0.willBoom }.max(by: { $0.progress < $1.progress })
        let target = leader?.progress ?? 0
        // Hafif takip lerp
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
        } else {
            didWin = false; lastGross = 0; lastDebtPayment = 0; lastNetReceived = 0
        }
        raceFinished = true; raceCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
            self?.state = .result
        }
    }

    func nextRound() {
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
        balance += 250; debt += 375; drawRaceField()
        if betAmount < 5 { betAmount = 5 }
        if betAmount > balance { betAmount = balance }
        commentator = "Tefeci Rıza parayı verdi. Şimdi koş bakalım..."
        state = .padock
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
                case .padock:   PadockView()
                case .racing:   RaceTrackView()
                case .result:   ResultView()
                case .bankrupt: BankruptView()
                }
            }
            .environmentObject(engine)
        }
        .preferredColorScheme(.light)
        .onAppear {
            OrientationController.set(.portrait)
            if engine.balance < 5 { engine.state = .bankrupt }
        }
        .onChange(of: engine.state) { newState in
            if newState == .racing {
                OrientationController.set(.landscapeRight)
            } else {
                OrientationController.set(.portrait)
            }
        }
    }
}

// MARK: - HEADER (dikey ekranlarda)

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

struct PadockView: View {
    @EnvironmentObject var engine: GameEngine
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            HStack {
                Text("// PADOK //")
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .foregroundColor(Theme.grassDark)
                Spacer()
                Text("100 ATLIK HAVUZ · 8 KOŞAR")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.inkSoft)
            }
            .padding(.horizontal, 14).padding(.vertical, 6)
            .background(Theme.sand.opacity(0.5))

            ScrollView {
                VStack(spacing: 6) {
                    ForEach(engine.horses) { h in
                        HorseRow(horse: h, isSelected: h.id == engine.selectedHorseId) {
                            engine.selectHorse(h.id)
                        }
                    }
                }
                .padding(.horizontal, 8).padding(.vertical, 8)
            }
            BetPanelView()
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
                // Tam ekran hipodrom
                HippodromeScene(size: geo.size)
                    .environmentObject(engine)

                // Spiker (üstte yüzer)
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
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.grassDark.opacity(0.6), lineWidth: 1)
        )
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

// MARK: - HİPODROM SAHNESİ (gökyüzü + zemin + atlar)

struct HippodromeScene: View {
    @EnvironmentObject var engine: GameEngine
    let size: CGSize

    var body: some View {
        let viewW = size.width
        let viewH = size.height
        // Dünya genişliği: 3x ekran (uzun pist hissi)
        let worldW = viewW * 3.0
        // Kamera kayması (px): leader'ın dünya üzerindeki konumu - ekranın yarısı
        let leaderX = engine.cameraProgress * (worldW - viewW)
        let cameraX = max(0, min(worldW - viewW, leaderX))

        // Gökyüzü ve zemin oranları
        let skyH = viewH * 0.42
        let groundH = viewH - skyH

        ZStack(alignment: .topLeading) {
            // 1) Gökyüzü gradyanı
            LinearGradient(
                colors: [Theme.skyTop, Theme.skyMid, Theme.skyHorizon],
                startPoint: .top, endPoint: .bottom
            )
            .frame(width: viewW, height: skyH)

            // 2) Bulutlar (parallaks katmanı)
            ZStack(alignment: .topLeading) {
                ForEach(engine.clouds) { cloud in
                    let cloudWorldX = cloud.worldX * worldW * 1.4 // bulut katmanı daha geniş
                    let cx = cloudWorldX - cameraX * cloud.parallax
                    // Sonsuz wrap: ekran dışına çıkanı diğer taraftan getir
                    let wrapped = wrap(cx, mod: viewW * 1.5)
                    Text(cloud.emoji)
                        .font(.system(size: 32 * cloud.scale))
                        .position(x: wrapped, y: cloud.y)
                        .opacity(0.9)
                }
            }
            .frame(width: viewW, height: skyH)
            .clipped()

            // 3) Güneş
            Circle()
                .fill(LinearGradient(colors: [Color.yellow.opacity(0.95), Color.orange.opacity(0.6)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(width: 38, height: 38)
                .position(x: viewW - 60, y: 36)

            // 4) Ufuk silüeti (tribün şeridi) — orta parallaks
            HorizonStrip(width: viewW, cameraX: cameraX, worldW: worldW)
                .frame(width: viewW, height: 14)
                .position(x: viewW / 2, y: skyH - 7)

            // 5) Zemin: pist
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(LinearGradient(
                        colors: [engine.trackSurface.primary, engine.trackSurface.secondary],
                        startPoint: .top, endPoint: .bottom
                    ))
                    .frame(width: viewW, height: groundH)

                // Pist (kayan, kamera ile)
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
        // Tribün şeridi — uzaktaki bayraklı çit
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
                // Çit direği
                let direk = CGRect(x: x + segW/2 - 1, y: h * 0.6, width: 2, height: h * 0.4)
                ctx.fill(Path(direk), with: .color(.black.opacity(0.55)))
                x += segW
                i += 1
            }
        }
    }
}

struct TrackArea: View {
    @EnvironmentObject var engine: GameEngine
    let size: CGSize
    let worldW: CGFloat
    let cameraX: CGFloat

    var body: some View {
        let viewW = size.width
        let h = size.height
        let laneCount = max(engine.horses.count, 1)
        let laneH = h / CGFloat(laneCount)
        let trackStartWorld: CGFloat = viewW * 0.10   // başlangıç kapısı dünya pozisyonu
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

            // Mesafe çubukları (her 100m işareti gibi)
            Canvas { ctx, size in
                let interval: CGFloat = viewW * 0.35
                var wx: CGFloat = trackStartWorld
                var n = 0
                while wx < trackEndWorld {
                    let sx = wx - cameraX
                    if sx > -10 && sx < size.width + 10 {
                        let r = CGRect(x: sx, y: 0, width: 1, height: size.height)
                        ctx.fill(Path(r), with: .color(.white.opacity(0.35)))
                        // Mesafe rakamı
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
            // Bitiş çizgisi (kareli)
            finishLine(at: trackEndWorld, cameraX: cameraX, h: h)

            // Şerit isim etiketleri (sol tarafta, sabit)
            VStack(spacing: 0) {
                ForEach(Array(engine.horses.enumerated()), id: \.element.id) { idx, horse in
                    HStack(spacing: 4) {
                        Text("\(idx + 1)")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(width: 14)
                            .background(horse.tier.color)
                            .cornerRadius(3)
                        Text(horse.name)
                            .font(.system(size: 9, weight: .heavy, design: .monospaced))
                            .foregroundColor(Theme.inkBlack)
                            .lineLimit(1).minimumScaleFactor(0.7)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .frame(height: laneH, alignment: .center)
                    .background(Color.white.opacity(0.55))
                }
            }
            .frame(width: 88, height: h)

            // Atlar (dünya konumlu)
            ForEach(Array(engine.horses.enumerated()), id: \.element.id) { idx, horse in
                let worldX = trackStartWorld + trackLen * CGFloat(horse.progress)
                let sx = worldX - cameraX
                let cy = CGFloat(idx) * laneH + laneH / 2
                // Gölge
                Ellipse()
                    .fill(Color.black.opacity(0.18))
                    .frame(width: 26, height: 6)
                    .position(x: sx, y: cy + 12)
                // At
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
                .overlay(
                    Rectangle()
                        .stroke(Color.black.opacity(0.6), lineWidth: 1)
                )
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

#Preview {
    ContentView()
}
