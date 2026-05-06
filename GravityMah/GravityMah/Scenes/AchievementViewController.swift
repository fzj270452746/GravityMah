import UIKit

final class AchievementViewController: UIViewController {

    private let achievements = Achievement.all
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor    = Palette.bg
        tv.separatorColor     = UIColor(white: 0, alpha: 0.08)
        tv.separatorInset     = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        tv.rowHeight          = UITableView.automaticDimension
        tv.estimatedRowHeight = 72
        tv.register(AchievementCell.self, forCellReuseIdentifier: AchievementCell.id)
        tv.dataSource = self
        return tv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.bg
        buildHeader()
        buildTable()
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
        titleLabel.text      = "ACHIEVEMENTS"
        titleLabel.font      = UIFont(name: "AvenirNext-Heavy", size: 22)
        titleLabel.textColor = Palette.text
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let unlocked = Achievement.all.filter { $0.isUnlocked }.count
        let progLabel = UILabel()
        progLabel.text      = "\(unlocked) / \(Achievement.all.count) Unlocked"
        progLabel.font      = UIFont(name: "AvenirNext-Medium", size: 13)
        progLabel.textColor = Palette.subtext
        progLabel.textAlignment = .center
        progLabel.translatesAutoresizingMaskIntoConstraints = false
        progLabel.tag = 99
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
    }

    private func buildTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let progLabel = view.viewWithTag(99)!
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: progLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc private func goBack() {
        Harbinger.shared.vibrate(.light)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        achievements.count
    }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: AchievementCell.id, for: indexPath) as! AchievementCell
        cell.configure(achievement: achievements[indexPath.row])
        return cell
    }
}

// MARK: - AchievementCell

private final class AchievementCell: UITableViewCell {
    static let id = "AchievementCell"

    private let iconView  = UIImageView()
    private let titleLbl  = UILabel()
    private let descLbl   = UILabel()
    private let checkView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = .clear
        selectionStyle  = .none

        let iconBg = UIView()
        iconBg.layer.cornerRadius = 22
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconBg)

        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)

        titleLbl.font      = UIFont(name: "AvenirNext-Bold", size: 15)
        titleLbl.textColor = Palette.text
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)

        descLbl.font          = UIFont(name: "AvenirNext-Regular", size: 12)
        descLbl.textColor     = Palette.subtext
        descLbl.numberOfLines = 2
        descLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descLbl)

        checkView.contentMode = .scaleAspectFit
        checkView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkView)

        NSLayoutConstraint.activate([
            iconBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconBg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconBg.widthAnchor.constraint(equalToConstant: 44),
            iconBg.heightAnchor.constraint(equalToConstant: 44),

            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            titleLbl.leadingAnchor.constraint(equalTo: iconBg.trailingAnchor, constant: 12),
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            titleLbl.trailingAnchor.constraint(equalTo: checkView.leadingAnchor, constant: -8),

            descLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            descLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 3),
            descLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            descLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            checkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkView.widthAnchor.constraint(equalToConstant: 22),
            checkView.heightAnchor.constraint(equalToConstant: 22),
        ])

        // store iconBg ref via tag
        iconBg.tag = 77
    }

    func configure(achievement ach: Achievement) {
        let unlocked = ach.isUnlocked
        let iconBg   = contentView.viewWithTag(77)!

        let tint: UIColor = unlocked ? Palette.accent : UIColor(white: 0, alpha: 0.15)
        iconBg.backgroundColor = tint.withAlphaComponent(unlocked ? 0.12 : 0.06)

        let cfg  = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let color: UIColor = unlocked ? Palette.accent : UIColor(white: 0, alpha: 0.25)
        iconView.image = UIImage(systemName: ach.icon, withConfiguration: cfg)?
            .withTintColor(color, renderingMode: .alwaysOriginal)

        titleLbl.text      = ach.title
        titleLbl.textColor = unlocked ? Palette.text : UIColor(white: 0, alpha: 0.3)
        descLbl.text       = ach.desc
        descLbl.textColor  = unlocked ? Palette.subtext : UIColor(white: 0, alpha: 0.2)

        let checkCfg = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        if unlocked {
            checkView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: checkCfg)?
                .withTintColor(Palette.accent, renderingMode: .alwaysOriginal)
        } else {
            checkView.image = UIImage(systemName: "lock.fill", withConfiguration: checkCfg)?
                .withTintColor(UIColor(white: 0, alpha: 0.2), renderingMode: .alwaysOriginal)
        }
    }
}
