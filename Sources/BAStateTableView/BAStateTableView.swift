import UIKit
import Foundation

//MARK: - PROTOCOL VISIBLE CELL
fileprivate protocol ListSkeletonable {
    func ba_visibleContentViews()->[UIView]
}

//MARK: - STATE TABLEVIEW
public enum BATableViewState {
    case loading(indicatorWidth: CGFloat = 100,
        indicatorHeight: CGFloat = 100,
        indicatorColor: UIColor = UIColor.gray,
        backgroundColor: UIColor = UIColor.white)
    case customLoadingView
    case skeletonLoading
    case emptyData
    case availableData
    case unknown
    
    func description() -> String {
        switch self {
        case .loading(_, _, _, _):
            return "loading"
        case .customLoadingView:
            return "customLoadingView"
        case .skeletonLoading:
            return "skeletonLoading"
        case .emptyData:
            return "emptyData"
        case .availableData:
            return "availableData"
        case .unknown:
            return "unknown"
        }
    }
}

@IBDesignable
public class BAStateTableView: UITableView, ListSkeletonable {
    //MARK: CURRENT STATE
    public var currentState: BATableViewState = .unknown {
        didSet {
            switch currentState {
            case .availableData:
                isUserInteractionEnabled = true
                isScrollEnabled = true
            default:
                isUserInteractionEnabled = false
                isScrollEnabled = false
            }
        }
    }
    
    //MARK: LOADING VIEW
    open var ba_loadingView: UIView?
    
    //MARK: EMPTY VIEW
    open var ba_emptyView: UIView?
    
    //MARK: DEFAULT CONFIG SKELETON
    open lazy var config: SkeletonConfig = SkeletonConfig(colors: SkeletonGradient(baseColor: #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)).colors, gradientDirection: .leftRight, animationDuration: 1.5)
    
    //MARK: - SET STATE
    public func setState(_ state: BATableViewState) {
        //Note: - Avoid repeat dialing
        guard currentState.description() != state.description() else { return}
        
        currentState = state
        
        removeAllSubviews()
        
        switch state {
        case .loading(let indicatorWidth, let indicatorHeight, let indicatorColor, let backgroundColor):
            configureStateLoading(indicatorWidth: indicatorWidth,
                                  indicatorHeight: indicatorHeight,
                                  indicatorColor: indicatorColor,
                                  backgroundColor: backgroundColor)
            guard isSkeletonActive else { return }
            SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                self?.skeletonStatus = .off
                self?.reloadData()
            }
        case .customLoadingView:
            configureStateCustomLoading()
            guard isSkeletonActive else { return }
            SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                self?.skeletonStatus = .off
                self?.reloadData()
            }
        case .emptyData:
            configureStateEmptyView()
            guard isSkeletonActive else { return }
            SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                self?.skeletonStatus = .off
                self?.reloadData()
            }
        case .skeletonLoading:
            reloadData()
            skeletonStatus = .on
            SkeletonLoader.addLoaderTo(self, config: config)
        case .availableData:
            if isSkeletonActive {
                reloadData()
                SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                    self?.skeletonStatus = .off
                    self?.reloadData()
                }
            } else {
                reloadData()
            }
        default:
            break
        }
    }
    
    //MARK: - CONFIGURE STATE
    private func configureStateLoading(indicatorWidth: CGFloat, indicatorHeight: CGFloat, indicatorColor: UIColor, backgroundColor: UIColor) {
        ba_loadingView = UIView()
        guard let loadingView = ba_loadingView else { return }
        
        loadingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        loadingView.tag = 111
        loadingView.backgroundColor = backgroundColor

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight))
        loadingIndicator.color = indicatorColor
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        self.insertSubview(loadingView, at: Int.max)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureStateCustomLoading() {
        guard let customLoadingView = ba_loadingView else { return }
        
        customLoadingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        customLoadingView.tag = 112
        
        self.insertSubview(customLoadingView, at: Int.max)
    }
    
    private func configureStateEmptyView() {
        guard let emptyView = ba_emptyView else { return }
        
        emptyView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        emptyView.tag = 113
        
        self.insertSubview(emptyView, at: Int.max)
    }
    
    //MARK: - REMOVE SUBVIEWS
    private func removeAllSubviews() {
        for s in self.subviews {
            if s.tag == 111 || s.tag == 112 || s.tag == 113 {
                s.removeFromSuperview()
            }
        }
    }
    
    //MARK: - VISIBLE CELLS
    fileprivate func ba_visibleContentViews()->[UIView] {
        return (self.visibleCells as NSArray).value(forKey: "contentView") as! [UIView]
    }
}

//MARK: - OBJECT FUNC SKELETON LOADER
fileprivate class SkeletonLoader: NSObject {
    static func addLoaderToViews(_ views : [UIView], config: SkeletonConfig) {
        views.forEach { $0.ba_addSkeletonLoader(config: config) }
    }
    
    static func removeLoaderFromViews(_ views: [UIView], config: SkeletonConfig, completion: (()->Void)?) {
        let group = DispatchGroup()
        
        views.forEach {
            group.enter()
            $0.ba_removeSkeletonLoader(config: config) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion?()
        }
    }
    
    public static func addLoaderTo(_ list : ListSkeletonable, config: SkeletonConfig) {
        self.addLoaderToViews(list.ba_visibleContentViews(), config: config)
    }
    
    public static func removeLoaderFrom(_ list : ListSkeletonable, config: SkeletonConfig, completion: (()->Void)?) {
        self.removeLoaderFromViews(list.ba_visibleContentViews(), config: config) {
            completion?()
        }
    }
}

extension UIView {
    fileprivate func ba_addSkeletonLoader(config: SkeletonConfig) {
        self.subviews.forEach { (v) in
            if v.isSkeletonable {
                if v.subviews.contains(where: {$0.isSkeletonable}) {
                    v.ba_addSkeletonLoader(config: config)
                } else {
                    v.createSkeletonAnimation(config: config)
                }
            }
        }
    }
    
    private func createSkeletonAnimation(config: SkeletonConfig) {
        let gradientView = GradientView(frame: self.bounds)
        self.skeletonCornerRadius = self.skeletonCornerRadius != 0 ? self.skeletonCornerRadius : Float(self.layer.cornerRadius)
        gradientView.layer.cornerRadius = CGFloat(self.skeletonCornerRadius)
        gradientView.layer.maskedCorners = CACornerMask(rawValue: self.layer.maskedCorners.rawValue)
        gradientView.clipsToBounds = true
        gradientView.gradientLayer.colors = config.colors
        gradientView.startSkeletonAnimation(config: config)
        
        switch config.transitionShow {
        case .crossDissolve(let duration):
            UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.insertSkeletonAnimation(gradientView: gradientView)
            }, completion: nil)
        default:
            self.insertSkeletonAnimation(gradientView: gradientView)
        }
    }
    
    private func insertSkeletonAnimation(gradientView: GradientView) {
        self.defaultCornerRadius = self.layer.cornerRadius
        self.layer.cornerRadius = CGFloat(self.skeletonCornerRadius)
        self.clipsToBounds = true
        if let view = self as? UIButton {
            view.titleLabel?.alpha = 0
        }
        self.insertSubview(gradientView, at: Int(UInt32.max))
    }
    
    fileprivate func ba_removeSkeletonLoader(config: SkeletonConfig, completion: (()->Void)?) {
        let group = DispatchGroup()
        let subview = self.getAllSubviewsSkeletonable()
    
        subview.forEach { (view) in
            guard let gradientView = view.subviews.first(where: {$0 is GradientView}) as? GradientView else { return }

            switch config.transitionHide {
            case .crossDissolve(let duration):
                group.enter()
                UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve], animations: {
                    self.removeSkeletonAnimation(view: view, gradientView: gradientView)
                }, completion: { (_) in
                    group.leave()
                })
            default:
                
                removeSkeletonAnimation(view: view, gradientView: gradientView)
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
    
    private func removeSkeletonAnimation(view: UIView, gradientView: GradientView) {
        gradientView.stopSkeletonAnimation()
        gradientView.removeFromSuperview()
        view.layer.cornerRadius = CGFloat(view.defaultCornerRadius)
        view.clipsToBounds = true
        
        guard let view = view as? UIButton else { return }
        view.titleLabel?.alpha = 1
    }
    
    private class func getAllSubviewsSkeletonable<T: UIView>(from parentView: UIView) -> [T] {
        return parentView.subviews.flatMap { subView -> [T] in
            guard subView.isSkeletonable else { return [] }
            var result = getAllSubviewsSkeletonable(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
    
    private func getAllSubviewsSkeletonable<T: UIView>() -> [T] { return UIView.getAllSubviewsSkeletonable(from: self) as [T] }
}
