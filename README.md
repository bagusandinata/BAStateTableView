BAStateTableView developed for developers when they get confused in tableview state management for set loading data, empty data, and available data.

![alt text](https://github.com/bagusandinata/BAStateTableView/blob/master/Assets/Demo%20BAStateTableView.gif?raw=true)

## :star2: Feature
- [x] State Loading
- [x] State Empty Data
- [x] State Available Data
- [x] Basic Loading View
- [x] Custom Loading View
- [x] Skeleton Loading View

## :calling: Installation
#### Using Swift Package Manager
Once you have your Swift package set up, adding `BAStateTableView` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`
```
dependencies: [
    .package(url: "https://github.com/bagusandinata/BAStateTableView.git", from: "1.0.6")
]
```

## :hotsprings: How to use
**1.** Set custom class `BAStateTableView` in UITableView IB/Storyboards.

![alt text](https://github.com/bagusandinata/BAStateTableView/blob/master/Assets/Screen%20Shot%202020-08-23%20at%2017.00.48.png?raw=true)

**2.** Import `BAStateTableView` in proper place.

```
import BAStateTableView
```

**3.** Using state basic loading.
##### Default basic loading

```
tableView.setState(.loading())
```

##### Custom basic loading

```
tableView.setState(.loading(indicatorWidth: 100, indicatorHeight: 100, indicatorColor: .gray, backgroundColor: .white))
```

**4.** Using state custom loading.

```
tableView.ba_loadingView = UIView.nib(withType: CustomLoadingView.self)
tableView.setState(.customLoadingView)
```

**5.** Using state skeleton loading.

##### Please set view skeletonable active in cell

##### * Using code:

```
view.isSkeletonable = true
view.skeletonCornerRadius = 10 (Optional)
```

##### * Using IB/Storyboards::

![alt text](https://github.com/bagusandinata/BAStateTableView/blob/master/Assets/Screen%20Shot%202020-08-23%20at%2017.02.57.png?raw=true)

##### You can setup custom skeleton animation

```
tableView.config = SkeletonConfig(colors: SkeletonGradient(baseColor: .gray).colors, gradientDirection: .leftRight, animationDuration: 1.5, transitionShow: .none, transitionHide: .crossDissolve(2.5))
```

##### When you use skeleton loading set UITableViewDataSource

```
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch (tableView as! BAStateTableView).currentState {
        case .availableData:
            return data.count
        case .skeletonLoading:
            return 10
        default:
            return 0
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(with: ExampleCell.self, indexPath: indexPath)!
        
    switch (tableView as! BAStateTableView).currentState {
        case .availableData:
            cell.labelExample.text = data.exampleText
            return cell
        default:
            return cell
    }
}
```

**6.** Using state custom empty data.

```
tableView.ba_emptyView = UIView.nib(withType: EmptyView.self)
tableView.setState(.emptyData)
```

**7.** Using state custom available data.

```
tableView.setState(.availableData)
```
