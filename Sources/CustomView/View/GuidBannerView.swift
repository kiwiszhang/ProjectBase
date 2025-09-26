//
//  GuidBannerView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/9/17.
//

struct GuidBannerItem {
    let date: String
    let title: String
    let comment: String
}

/**
 功能：
1. 自动轮播cell
2. 中间cell可以放大
3. 可以设置pageControl指示器
4.左右滑动可以居中
5.点击cell可以回调
 
 let comtents = [
     GuidBannerItem(date: "June 26,2025", title: L10n.helpfulForTaxs, comment: L10n.exportingReportsFor),
     GuidBannerItem(date: "June 23,2025", title: L10n.efficient, comment: L10n.noMoreManual),
     GuidBannerItem(date: "June 28,2025", title: L10n.fastAndSimple, comment: L10n.superIntuitive),
 ]
 lazy var banner = GuidBannerView(frame: CGRect(x: 0, y: 0, width: kkScreenWidth, height: 112.h),items: comtents).backgroundColor(.clear)
 banner.startAutoScroll()
 banner.didSelectItem = { index, item in
     print("点击了第 \(index) 个 item: \(item.title)")
 }
 */


// MARK: - FlowLayout: 居中 + 缩放
final class CenterSnapFlowLayout: UICollectionViewFlowLayout {
    var activeDistance: CGFloat = 220
    var zoomFactor: CGFloat = 0.09
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 24.w
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrs = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes }),
              let cv = collectionView else { return nil }
        
        let centerX = cv.contentOffset.x + cv.bounds.width / 2
        for a in attrs {
            let distance = abs(a.center.x - centerX)
            if distance < activeDistance {
                let normalized = (activeDistance - distance)/activeDistance
                let zoom = 1 + zoomFactor * normalized
                a.transform = CGAffineTransform(scaleX: zoom, y: zoom)
                a.zIndex = Int(zoom * 10)
            } else {
                a.transform = .identity
                a.zIndex = 0
            }
        }
        return attrs
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView,
              let layoutAttrs = super.layoutAttributesForElements(in: cv.bounds) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        let proposedCenterX = proposedContentOffset.x + cv.bounds.width/2
        var candidate: UICollectionViewLayoutAttributes?
        for attr in layoutAttrs {
            if candidate == nil { candidate = attr; continue }
            if abs(attr.center.x - proposedCenterX) < abs(candidate!.center.x - proposedCenterX) {
                candidate = attr
            }
        }
        guard let c = candidate else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        let newOffsetX = c.center.x - cv.bounds.width/2
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
}
// MARK: - GuidBannerView
final class GuidBannerView: UIView {
    private var items: [GuidBannerItem]
    private var timer: Timer?
    private var autoScrollInterval: TimeInterval = 3.0 // 默认 3 秒
    /// 点击回调
    var didSelectItem: ((Int, GuidBannerItem) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = CenterSnapFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14.w
        layout.itemSize = CGSize(width: kkScreenWidth - 100.w, height: bounds.height)
        let sideInset = (kkScreenWidth - layout.itemSize.width) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        cv.isPagingEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.clipsToBounds = false
        cv.register(GuidBannerViewCell.self, forCellWithReuseIdentifier: "GuidBannerViewCell")
        return cv
    }()

    private let pageControl = UIPageControl().hidden(true)
    private var totalItems: Int { items.count * 3 }
    private var currentIndex: Int {
        let center = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2,
                             y: collectionView.bounds.height/2)
        if let ip = collectionView.indexPathForItem(at: center) {
            return ip.item % items.count
        }
        return 0
    }

    init(frame: CGRect, items: [GuidBannerItem], autoScrollInterval: TimeInterval = 3.0) {
        self.items = items
        self.autoScrollInterval = autoScrollInterval
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(pageControl)
        pageControl.numberOfPages = items.count
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        pageControl.frame = CGRect(x: 0, y: bounds.height - 30, width: bounds.width, height: 20)

        let itemWidth = kkScreenWidth - 100.w
        let sideInset = (bounds.width - itemWidth) / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        if items.count > 1 {
            // 滚动到第二组的第二个 cell
            let start = IndexPath(item: items.count + 1, section: 0)
            collectionView.scrollToItem(at: start, at: .centeredHorizontally, animated: false)
        }
        
        startAutoScroll()
    }


    // MARK: - 自动滚动
    func startAutoScroll() {
        stopAutoScroll()
        guard autoScrollInterval > 0 else { return }
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { [weak self] _ in
            self?.scrollToNext()
        }
    }

    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    private func scrollToNext() {
        let next = IndexPath(item: currentIndex + items.count + 1, section: 0)
        collectionView.scrollToItem(at: next, at: .centeredHorizontally, animated: true)
    }

}

// MARK: - DataSource / Delegate
extension GuidBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int { totalItems }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "GuidBannerViewCell", for: indexPath) as! GuidBannerViewCell
        let item = items[indexPath.item % items.count]
        cell.configure(with: item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let index = indexPath.item % items.count
            let item = items[index]
            didSelectItem?(index, item)
            // 点击后滚动到中间
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    // ✅ 手动滑动开始：停止定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }

    // ✅ 手动滑动结束：重新计时 3 秒后自动滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetIfNeeded()
        pageControl.currentPage = currentIndex
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            startAutoScroll()
//        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        resetIfNeeded()
        pageControl.currentPage = currentIndex
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = round((offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing)
        offset = CGPoint(x: index * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0)
        targetContentOffset.pointee = offset
    }

    private func resetIfNeeded() {
        let index = currentIndex
        let target = IndexPath(item: index + items.count, section: 0)
        collectionView.scrollToItem(at: target, at: .centeredHorizontally, animated: false)
    }
}

//1111111111111111111111111111
//111111111111
// MARK: - Cell
class GuidBannerViewCell: SuperCollectionViewCell {
    private let imageView = UIImageView().image(Asset.guidStar.image)
    private var containerView = UIView().backgroundColor(kkColorFromHex("ECF2F1")).cornerRadius(16.h)
    private var dateLab = UILabel().text("June 26,2025").hnFont(size: 12.h, weight: .regular).color(kkColorFromHex("A4A9B1")).rightAligned()
    private var titleLab = UILabel().text(L10n.helpfulForTaxs).hnFont(size: 16.h, weight: .medium).color(kkColorFromHex("202124"))
    private var subTitle = UILabel().text(L10n.exportingReportsFor).hnFont(size: 14.h, weight: .regular).color(kkColorFromHex("5B5F65")).lines(0)
    override func setUpUI() {
        contentView.addSubView(containerView)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = false
        containerView.clipsToBounds = false
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.h)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(0.w)
            make.right.equalToSuperview().offset(-0.w)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(24.h)
            make.width.equalTo(136.w)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        containerView.addChildView([dateLab,titleLab,subTitle])
        dateLab.snp.makeConstraints { make in
            make.width.equalTo(88.w)
            make.height.equalTo(20.h)
            make.top.equalToSuperview().offset(20.h)
            make.right.equalToSuperview().offset(-10.w)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11.w)
            make.height.equalTo(20.h)
            make.right.equalTo(dateLab.snp.left)
            make.top.equalToSuperview().offset(20.h)
        }
        subTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.w)
            make.right.equalToSuperview().offset(-10.w)
            make.top.equalTo(titleLab.snp.bottom).offset(8.h)
        }
    }
    
    func configure(with comtent: GuidBannerItem) {
        titleLab.text(comtent.title)
        subTitle.text(comtent.comment)
        dateLab.text(comtent.date)
    }
}
