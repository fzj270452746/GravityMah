import UIKit

final class TutorialViewController: UIViewController {

    private struct Page {
        let icon: String   // SF Symbol
        let title: String
        let body: String
        let detail: String
    }

    private let pages: [Page] = [
        Page(icon: "hand.tap.fill",
             title: "Reshape The Board",
             body: "Swap adjacent tiles to change the structure of the entire board.",
             detail: "Each move is about setting up what falls next, not just making one instant match."),
        Page(icon: "arrow.down.circle.fill",
             title: "Gravity Resolves",
             body: "After every clear, gravity pulls tiles down and rebuilds the puzzle space.",
             detail: "Triplets clear matching numbers. Sequences clear consecutive numbers like 3-4-5."),
        Page(icon: "bolt.fill",
             title: "Plan For Chains",
             body: "The best moves create falls, chains, bombs, and special setups in one sequence.",
             detail: "Watch for anchors that block columns, bombs that burst nearby tiles, and wilds that complete any run."),
    ]

    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var prevBtn: UIButton!
    private var nextBtn: UIButton!
    private var currentPage = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.bg
        buildHeader()
        buildScroll()
        buildFooter()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutPageCards()
    }

    // MARK: - Build

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
        titleLabel.text      = "HOW TO PLAY"
        titleLabel.font      = UIFont(name: "AvenirNext-Heavy", size: 22)
        titleLabel.textColor = Palette.text
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.tag = 88
        view.addSubview(titleLabel)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backBtn.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
        ])
    }

    private func buildScroll() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled          = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate                 = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let header = view.viewWithTag(88)!
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
        ])
    }

    private func buildFooter() {
        pageControl = UIPageControl()
        pageControl.numberOfPages    = pages.count
        pageControl.currentPage      = 0
        pageControl.currentPageIndicatorTintColor = Palette.accent
        pageControl.pageIndicatorTintColor        = UIColor(white: 0, alpha: 0.15)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        prevBtn = makeNavButton(title: "‹  Prev", tag: 0)
        nextBtn = makeNavButton(title: "Next  ›", tag: 1)
        prevBtn.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        view.addSubview(prevBtn)
        view.addSubview(nextBtn)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),

            prevBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            prevBtn.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -8),
            prevBtn.widthAnchor.constraint(equalToConstant: 100),
            prevBtn.heightAnchor.constraint(equalToConstant: 40),

            nextBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextBtn.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -8),
            nextBtn.widthAnchor.constraint(equalToConstant: 100),
            nextBtn.heightAnchor.constraint(equalToConstant: 40),
        ])

        updateNavButtons()
    }

    private func makeNavButton(title: String, tag: Int) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 15)
        btn.setTitleColor(Palette.accent, for: .normal)
        btn.setTitleColor(UIColor(white: 0, alpha: 0.2), for: .disabled)
        btn.backgroundColor = UIColor(white: 0, alpha: 0.06)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.tag = tag
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }

    private var cardsLaidOut = false

    private func layoutPageCards() {
        let w = scrollView.bounds.width
        let h = scrollView.bounds.height
        guard w > 0, h > 0 else { return }

        if cardsLaidOut {
            // Re-layout on rotation / size change
            for (i, sub) in scrollView.subviews.enumerated() {
                sub.frame = CGRect(x: CGFloat(i) * w + 20, y: 10, width: w - 40, height: h - 20)
            }
            scrollView.contentSize = CGSize(width: w * CGFloat(pages.count), height: h)
            let x = CGFloat(currentPage) * w
            scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
            return
        }

        cardsLaidOut = true
        for (i, page) in pages.enumerated() {
            let card = buildCard(page: page, width: w - 40, height: h - 20)
            card.frame = CGRect(x: CGFloat(i) * w + 20, y: 10, width: w - 40, height: h - 20)
            scrollView.addSubview(card)
        }
        scrollView.contentSize = CGSize(width: w * CGFloat(pages.count), height: h)
    }

    private func buildCard(page: Page, width: CGFloat, height: CGFloat) -> UIView {
        let card = UIView()
        card.backgroundColor    = UIColor(white: 1, alpha: 0.7)
        card.layer.cornerRadius = 24
        card.layer.borderWidth  = 1
        card.layer.borderColor  = UIColor(white: 0, alpha: 0.07).cgColor

        let iconBg = UIView()
        iconBg.backgroundColor    = Palette.accent.withAlphaComponent(0.1)
        iconBg.layer.cornerRadius = 36
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(iconBg)

        let iconView = UIImageView()
        let cfg = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        iconView.image = UIImage(systemName: page.icon, withConfiguration: cfg)?
            .withTintColor(Palette.accent, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)

        let titleLbl = UILabel()
        titleLbl.text      = page.title
        titleLbl.font      = UIFont(name: "AvenirNext-Heavy", size: 24)
        titleLbl.textColor = Palette.text
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLbl)

        let bodyLbl = UILabel()
        bodyLbl.text          = page.body
        bodyLbl.font          = UIFont(name: "AvenirNext-Medium", size: 16)
        bodyLbl.textColor     = Palette.text
        bodyLbl.textAlignment = .center
        bodyLbl.numberOfLines = 0
        bodyLbl.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(bodyLbl)

        let detailLbl = UILabel()
        detailLbl.text          = page.detail
        detailLbl.font          = UIFont(name: "AvenirNext-Regular", size: 13)
        detailLbl.textColor     = Palette.subtext
        detailLbl.textAlignment = .center
        detailLbl.numberOfLines = 0
        detailLbl.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(detailLbl)

        NSLayoutConstraint.activate([
            iconBg.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconBg.topAnchor.constraint(equalTo: card.topAnchor, constant: 44),
            iconBg.widthAnchor.constraint(equalToConstant: 72),
            iconBg.heightAnchor.constraint(equalToConstant: 72),

            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 36),
            iconView.heightAnchor.constraint(equalToConstant: 36),

            titleLbl.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            titleLbl.topAnchor.constraint(equalTo: iconBg.bottomAnchor, constant: 24),
            titleLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),

            bodyLbl.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            bodyLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 16),
            bodyLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            bodyLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),

            detailLbl.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            detailLbl.topAnchor.constraint(equalTo: bodyLbl.bottomAnchor, constant: 16),
            detailLbl.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            detailLbl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
        ])

        return card
    }

    // MARK: - Actions

    @objc private func goBack() {
        Harbinger.shared.vibrate(.light)
        dismiss(animated: true)
    }

    @objc private func prevPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
        scrollToCurrentPage()
    }

    @objc private func nextPage() {
        guard currentPage < pages.count - 1 else { dismiss(animated: true); return }
        currentPage += 1
        scrollToCurrentPage()
    }

    private func scrollToCurrentPage() {
        let x = CGFloat(currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        pageControl.currentPage = currentPage
        updateNavButtons()
        Harbinger.shared.vibrate(.light)
    }

    private func updateNavButtons() {
        prevBtn.isEnabled = currentPage > 0
        let isLast = currentPage == pages.count - 1
        nextBtn.setTitle(isLast ? "Done" : "Next  ›", for: .normal)
    }
}

// MARK: - UIScrollViewDelegate

extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        currentPage = page
        pageControl.currentPage = page
        updateNavButtons()
    }
}
