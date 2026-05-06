import UIKit
import SpriteKit

// UIKit-based level-select screen with a native UICollectionView grid.
final class AtlasViewController: UIViewController {

    // Passed in from the caller so ArenaScene can inherit the same safe-area data.
    var safeAreaData: NSMutableDictionary = NSMutableDictionary()

    private let unlocked = Reliquary.shared.unlockedCount
    private let strata   = Codex.strata

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 12
        layout.minimumInteritemSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor    = Palette.bg
        cv.alwaysBounceVertical = true
        cv.register(LevelCell.self, forCellWithReuseIdentifier: LevelCell.id)
        cv.dataSource = self
        cv.delegate   = self
        return cv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.bg
        buildHeader()
        buildGrid()
    }

    // MARK: - Layout

    private func buildHeader() {
        let backBtn = UIButton(type: .system)
        backBtn.setTitle("‹", for: .normal)
        backBtn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 28)
        backBtn.setTitleColor(Palette.text, for: .normal)
        backBtn.backgroundColor = UIColor(white: 0, alpha: 0.08)
        backBtn.layer.cornerRadius = 18
        backBtn.clipsToBounds = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)

        let titleLabel = UILabel()
        titleLabel.text      = "SELECT LEVEL"
        titleLabel.font      = UIFont(name: "AvenirNext-Heavy", size: 22)
        titleLabel.textColor = Palette.text
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let progLabel = UILabel()
        progLabel.text      = "\(unlocked)/\(strata.count) Unlocked"
        progLabel.font      = UIFont(name: "AvenirNext-Medium", size: 13)
        progLabel.textColor = Palette.subtext
        progLabel.textAlignment = .center
        progLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progLabel)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backBtn.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),

            progLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
        ])

        // Store progLabel bottom so the grid can start below it
        progLabel.tag = 99
    }

    private func buildGrid() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        // Find the progress label by tag to anchor below it
        let progLabel = view.viewWithTag(99)!
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: progLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func goBack() {
        Harbinger.shared.vibrate(.light)
        dismiss(animated: true)
    }

    private func launch(stratum: Codex.Stratum) {
        Harbinger.shared.vibrate(.medium)
        guard let gateway = presentingViewController as? GatewayController else { return }
        let skView = gateway.skView!
        let arena  = ArenaScene(size: skView.bounds.size, stratum: stratum)
        arena.scaleMode = .resizeFill
        arena.userData  = safeAreaData
        dismiss(animated: false) {
            skView.presentScene(arena, transition: SKTransition.push(with: .left, duration: 0.35))
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AtlasViewController: UICollectionViewDataSource {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        strata.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: LevelCell.id, for: indexPath) as! LevelCell
        let stratum = strata[indexPath.item]
        cell.configure(stratum: stratum, locked: indexPath.item >= unlocked)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AtlasViewController: UICollectionViewDelegate {
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < unlocked else { return }
        launch(stratum: strata[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AtlasViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols: CGFloat = 3
        let spacing: CGFloat = 12
        let inset: CGFloat   = 16
        let total = cv.bounds.width - inset * 2 - spacing * (cols - 1)
        let side  = total / cols
        return CGSize(width: side, height: side * 1.15)
    }

    func collectionView(_ cv: UICollectionView,
                        layout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 16)
    }
}

// MARK: - LevelCell

private final class LevelCell: UICollectionViewCell {
    static let id = "LevelCell"

    private let bg        = UIView()
    private let numLabel  = UILabel()
    private let nameLabel = UILabel()
    private let starStack = UIStackView()
    private let lockView  = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        bg.layer.cornerRadius = 14
        bg.layer.borderWidth  = 1.5
        bg.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bg)

        numLabel.font      = UIFont(name: "AvenirNext-Heavy", size: 26)
        numLabel.textAlignment = .center
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(numLabel)

        let lockCfg = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        lockView.image       = UIImage(systemName: "lock.fill", withConfiguration: lockCfg)?
            .withTintColor(UIColor(white: 0, alpha: 0.25), renderingMode: .alwaysOriginal)
        lockView.contentMode = .scaleAspectFit
        lockView.isHidden    = true
        lockView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lockView)

        nameLabel.font      = UIFont(name: "AvenirNext-Medium", size: 11)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        starStack.axis         = .horizontal
        starStack.spacing      = 3
        starStack.alignment    = .center
        starStack.distribution = .fillEqually
        starStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starStack)

        for _ in 0..<3 {
            let l = UILabel()
            l.font      = UIFont(name: "AvenirNext-Bold", size: 12)
            l.textAlignment = .center
            starStack.addArrangedSubview(l)
        }

        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: contentView.topAnchor),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            numLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),

            lockView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lockView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            lockView.widthAnchor.constraint(equalToConstant: 28),
            lockView.heightAnchor.constraint(equalToConstant: 28),

            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: numLabel.bottomAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

            starStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            starStack.widthAnchor.constraint(equalToConstant: 52),
        ])
    }

    func configure(stratum: Codex.Stratum, locked: Bool) {
        if locked {
            bg.backgroundColor    = UIColor(white: 0, alpha: 0.05)
            bg.layer.borderColor  = UIColor(white: 0, alpha: 0.10).cgColor
            numLabel.isHidden     = true
            lockView.isHidden     = false
            nameLabel.text        = ""
            starStack.isHidden    = true
        } else {
            let tint = Palette.tint(for: (stratum.index % 9) + 1)
            bg.backgroundColor   = tint.withAlphaComponent(0.12)
            bg.layer.borderColor = tint.withAlphaComponent(0.5).cgColor
            numLabel.isHidden    = false
            lockView.isHidden    = true
            numLabel.text        = "\(stratum.index + 1)"
            numLabel.font        = UIFont(name: "AvenirNext-Heavy", size: 26)
            numLabel.textColor   = Palette.text
            nameLabel.text       = stratum.title
            nameLabel.textColor  = Palette.subtext
            starStack.isHidden   = false

            let stars = Reliquary.shared.stars(for: stratum.index)
            for (i, view) in starStack.arrangedSubviews.enumerated() {
                let l = view as! UILabel
                l.text      = i < stars ? "★" : "☆"
                l.textColor = i < stars ? UIColor(hex: "#E6B800") : UIColor(white: 0, alpha: 0.2)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.07) { self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.07) { self.transform = .identity }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.07) { self.transform = .identity }
    }
}
