//
//  MapViewController.swift
//  MapSearch
//

import Combine
import UIKit
import YandexMapsMobile

class MapViewController: UIViewController {
    // MARK: - Public methods
    var message = ""
    var locationPick: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Доставка"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let exitButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(exitTapped))
          
          navigationItem.leftBarButtonItem = exitButton
        
        mapView = YMKMapView(frame: view.frame)
        view.addSubview(mapView)

        map = mapView.mapWindow.map

        map.addCameraListener(with: mapCameraListener)

        searchViewModel.setupSubscriptions()

        setupSearchController()

        moveToStartPoint()
    }
    
    @objc
    func exitTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private methods

    private func moveToStartPoint() {
        map.move(with: Const.startPosition, animation: YMKAnimation(type: .smooth, duration: 0.5))
        searchViewModel.setVisibleRegion(with: map.visibleRegion)
    }

    private func setupSearchController() {
        self.searchBarController.searchResultsUpdater = self
        self.searchBarController.obscuresBackgroundDuringPresentation = true
        self.searchBarController.hidesNavigationBarDuringPresentation = false
        //self.searchBarController.searchBar.placeholder = "Введите адрес доставки"
        self.searchBarController.searchBar.tintColor = .black
        
        self.searchBarController.searchBar.searchTextField.textColor = .black
        self.searchBarController.searchBar.searchTextField.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        self.searchBarController.searchBar.barStyle = .black // Задает темный стиль

        // Получаем текстовое поле UISearchBar
        if let textField = self.searchBarController.searchBar.value(forKey: "searchField") as? UITextField {
            // Устанавливаем текст и цвет placeholder
            textField.attributedPlaceholder = NSAttributedString(string: "Введите адрес доставки", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
            //textField.font = R.Fonts.avenirBook(with: 14)
            textField.textColor = UIColor.black
        }

        self.navigationItem.searchController = searchBarController
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false

        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.showsBookmarkButton = false

        resultsTableController.tableView.delegate = self

        setupStateUpdates()
    }

    private func focusCamera(points: [YMKPoint], boundingBox: YMKBoundingBox) {
        print("FOCUS")
        
        if points.isEmpty {
            return
        }

        let position = points.count == 1
            ? YMKCameraPosition(
                target: points.first!,
                zoom: map.cameraPosition.zoom + 2.0,
                azimuth: map.cameraPosition.azimuth,
                tilt: map.cameraPosition.tilt
            )
            : map.cameraPosition(with: YMKGeometry(boundingBox: boundingBox))

        map.move(with: position, animation: YMKAnimation(type: .smooth, duration: 0.5))
      
        // Сохраняем координаты только если это не поисковый запрос
        if !searchBarController.isActive {
            UserSettings.userLocation?["latitude"] = "\(position.target.latitude)"
            UserSettings.userLocation?["longitude"] = "\(position.target.longitude)"
            
            print("UserLocation = \(UserSettings.userLocation ?? [:])")
            locationPick?()
            navigationController?.popViewController(animated: true)
        }
    }

    private func displaySearchResults(
        items: [SearchResponseItem],
        zoomToItems: Bool,
        itemsBoundingBox: YMKBoundingBox
    ) {
        map.mapObjects.clear()

        items.forEach { item in
            let image = UIImage(systemName: "circle.circle.fill")!
                .withTintColor(view.tintColor)
    
            let placemark = map.mapObjects.addPlacemark()
            placemark.geometry = item.point
            placemark.setViewWithView(YRTViewProvider(uiView: UIImageView(image: image)))

            placemark.userData = item.geoObject
            placemark.addTapListener(with: mapObjectTapListener)
        }
    }

    // MARK: - Private properties

    private var mapView: YMKMapView!
    private lazy var map: YMKMap = mapView.mapWindow.map
    private let buttonsView = UIStackView()
    private lazy var mapCameraListener = MapCameraListener(searchViewModel: searchViewModel)

    private lazy var resultsTableController = ResultsTableController()
    private lazy var searchBarController = UISearchController(searchResultsController: resultsTableController)
    private let searchViewModel = SearchViewModel()
    private var bag = Set<AnyCancellable>()

    @Published private var searchSuggests: [SuggestItem] = []

    private lazy var mapObjectTapListener = MapObjectTapListener(controller: self)

    // MARK: - Private nesting

    private enum Const {
        static let startPoint = YMKPoint(latitude: 43.0367, longitude: 44.6678)
        static let startPosition = YMKCameraPosition(target: startPoint, zoom: 13.0, azimuth: .zero, tilt: .zero)
    }

    // MARK: - Layout

    private enum Layout {
        static let buttonSize: CGFloat = 50.0
    }
}

extension MapViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.reset()
        searchViewModel.setQueryText(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.startSearch()
        searchBarController.searchBar.text = searchViewModel.mapUIState.query
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if case .idle = searchViewModel.mapUIState.searchState {
            updatePlaceholder()
        }
    }

    func setupStateUpdates() {
        searchViewModel.$mapUIState.sink { [weak self] state in
            let query = state?.query ?? String()
            self?.searchBarController.searchBar.text = query
            self?.updatePlaceholder(with: query)

            if case let .success(items, zoomToItems, itemsBoundingBox) = state?.searchState {
                self?.displaySearchResults(items: items, zoomToItems: zoomToItems, itemsBoundingBox: itemsBoundingBox)
                if zoomToItems {
                    self?.focusCamera(points: items.map { $0.point }, boundingBox: itemsBoundingBox)
                }
            }
            if let suggestState = state?.suggestState {
                self?.updateSuggests(with: suggestState)
            }
        }
        .store(in: &bag)
    }

    private func updateSuggests(with suggestState: SuggestState) {
        switch suggestState {
        case .success(let items):
            resultsTableController.items = items
            resultsTableController.tableView.reloadData()
            
        default:
            return
        }
    }

    private func updatePlaceholder(with text: String = String()) {
        searchBarController.searchBar.placeholder = text.isEmpty ? "Введите адрес доставки" : text
    }
}

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < resultsTableController.items.count else { return }

        searchBarController.isActive = false

        let item = resultsTableController.items[indexPath.row]
        print("USER adress = \(item.title.text), USER city = \(item.subtitle?.text ?? "")")
     
        let region = item.subtitle?.text.components(separatedBy: " ")
        
        if region?.last == "Алания" {
            let location = ("\(item.title.text), \(item.subtitle?.text ?? "")")
            UserSettings.userLocation?["Location"] = location
            
            // Вызываем onClick для поиска и фокусировки на выбранном месте
            item.onClick()
            
            // Закрываем контроллер после выбора адреса
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            displayAdressAlert()
        }
    }
    
    func displayAdressAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Введите корректный адрес в пределах респ. РСО-Алании", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

fileprivate class ResultsTableController: UITableViewController {
    private let cellIdentifier = "cellIdentifier"
    var items = [SuggestItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0

        let item = items[indexPath.row]

        cell.textLabel?.attributedText = item.cellText

        return cell
    }
}

fileprivate extension SuggestItem {
    var cellText: NSAttributedString {
        let result = NSMutableAttributedString(string: title.text)
        result.append(NSAttributedString(string: " "))

        let subtitle = NSMutableAttributedString(string: subtitle?.text ?? "")
        subtitle.setAttributes(
            [.foregroundColor: UIColor.secondaryLabel],
            range: NSRange(location: 0, length: subtitle.string.count)
        )
        result.append(subtitle)

        return result
    }
}
