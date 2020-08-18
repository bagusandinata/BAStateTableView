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
    case availableData(reloadData: Bool = true)
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
                isScrollEnabled = true
            default:
                isScrollEnabled = false
            }
        }
    }
    
    //MARK: LOADING VIEW
    open var loadingView: UIView?
    
    //MARK: EMPTY VIEW
    open var emptyView: UIView?
    
    //MARK: DEFAULT CONFIG SKELETON
    open lazy var config: SkeletonConfig = SkeletonConfig(colors: SkeletonGradient(baseColor: #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)).colors, gradientDirection: .leftRight, animationDuration: 1.0)
    
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
        case .customLoadingView:
            configureStateCustomLoading()
            guard isSkeletonActive else { return }
            SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                self?.skeletonStatus = .off
            }
        case .emptyData:
            configureStateEmptyView()
            guard isSkeletonActive else { return }
            SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                self?.skeletonStatus = .off
            }
        case .skeletonLoading:
            reloadData()
            skeletonStatus = .on
            SkeletonLoader.addLoaderTo(self, config: config)
        case .availableData(let reload):
            if isSkeletonActive {
                SkeletonLoader.removeLoaderFrom(self, config: config) { [weak self] in
                    self?.skeletonStatus = .off
                    guard reload else { return }
                    self?.reloadData()
                }
            } else {
                guard reload else { return }
                reloadData()
            }
        default:
            break
        }
    }
    
    //MARK: - CONFIGURE STATE
    private func configureStateLoading(indicatorWidth: CGFloat, indicatorHeight: CGFloat, indicatorColor: UIColor, backgroundColor: UIColor) {
        loadingView = UIView()
        guard let loadingView = loadingView else { return }
        
        loadingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        loadingView.tag = 111
        loadingView.backgroundColor = backgroundColor

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight))
        loadingIndicator.color = indicatorColor
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        self.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureStateCustomLoading() {
        guard let customLoadingView = loadingView else { return }
        
        customLoadingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        customLoadingView.tag = 112
        
        self.addSubview(customLoadingView)
    }
    
    private func configureStateEmptyView() {
        guard let emptyView = emptyView else { return }
        
        emptyView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        emptyView.tag = 113
        
        self.addSubview(emptyView)
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
        let subview = self.getAllSubviews()
        subview.forEach { (view) in
            if view.isSkeletonable {
                let gradientView = GradientView(frame: view.bounds)
                gradientView.layer.cornerRadius = CGFloat(view.skeletonCornerRadius)
                gradientView.clipsToBounds = true
                gradientView.gradientLayer.colors = config.colors
                gradientView.startSkeletonAnimation(config: config)
                
                switch config.transition {
                case .crossDissolve(let duration):
                    UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve], animations: {
                        view.addSubview(gradientView)
                    }, completion: { (_) in
                        view.defaultCornerRadius = view.layer.cornerRadius
                        view.layer.cornerRadius = CGFloat(view.skeletonCornerRadius)
                        view.clipsToBounds = true
                    })
                default:
                    view.addSubview(gradientView)
                    view.defaultCornerRadius = view.layer.cornerRadius
                    view.layer.cornerRadius = CGFloat(view.skeletonCornerRadius)
                    view.clipsToBounds = true
                }
            }
        }
    }
    
    fileprivate func ba_removeSkeletonLoader(config: SkeletonConfig, completion: (()->Void)?) {
        let group = DispatchGroup()
        let subview = self.getAllSubviews()
        subview.forEach { (view) in
            if view.isSkeletonable {
                view.subviews.forEach { (v) in
                    guard let gradientView = v as? GradientView else { return }
                    
                    switch config.transition {
                    case .crossDissolve(let duration):
                        group.enter()
                        UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve], animations: {
                            gradientView.stopSkeletonAnimation()
                            gradientView.removeFromSuperview()
                        }, completion: { (_) in
                            view.layer.cornerRadius = CGFloat(view.defaultCornerRadius)
                            view.clipsToBounds = true
                            group.leave()
                        })
                    default:
                        gradientView.stopSkeletonAnimation()
                        gradientView.removeFromSuperview()
                        view.layer.cornerRadius = CGFloat(view.defaultCornerRadius)
                        view.clipsToBounds = true
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
}
