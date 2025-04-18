<a name="readme-top"></a>

<div align="center">
  <h3 align="center">LeezyData</h3>
  
  <p align="center">
    Generic, composable data layer abstractions for Swift with support for CoreData, Firestore, and custom sources.
    <br />
    <a href="https://github.com/matolah/LeezyData/issues">Report Bug</a>
    ·
    <a href="https://github.com/matolah/LeezyData/issues">Request Feature</a>
  </p>
</div>

## 📦 What is LeezyData?

**LeezyData** is a lightweight, extensible data layer framework for Swift.  
It allows you to compose multiple sources of truth — local (CoreData) or remote (Firestore) — using a unified API built around generic `Entity`, `DataService`, and `DataManager` abstractions.

- 📁 **CoreData** – for offline storage
- ☁️ **Firestore** – for real-time cloud sync
- 📦 **RemoteCollection** – for abstracting any REST or real-time backend
- 🧱 **Common** – contains the core interfaces: `Entity`, `DataService`, `DataManager`

## 📥 Installation

Add `LeezyData` to your project using **Swift Package Manager**:

```swift
dependencies: [
    .package(url: "https://github.com/matolah/LeezyData.git", .upToNextMajor(from: "1.0.0"))
]
```

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "LeezyData", package: "LeezyData"),
        .product(name: "LeezyCoreData", package: "LeezyData"),
        .product(name: "LeezyRemoteCollection", package: "LeezyData"),
        .product(name: "LeezyFirestore", package: "LeezyData")
    ]
)
```

## 🚀 Usage

### 1. Define your Entities

```swift
struct MySimpleEntity: Entity {
    let id: String
}

class MyLocalEntity: CoreDataEntity {
    @NSManaged var referenceID: String

    var reference: MyRemoteEntity? {
        if let reference = _reference, referenceID == reference.id {
            return reference
        } else {
            let anyReference: AnyRemoteFirestoreEntity? = Self.referenceBuilder?.entity(with: referenceID)
            _reference = anyReference?.value as? MyRemoteEntity
            return _reference
        }
    }
    private var _reference: MyRemoteEntity?
}

typealias AnyRemoteFirestoreEntity = AnyRemoteEntity<MyRemoteEntityIdentifier>

struct MyRemoteEntity: RemoteEntity {
    static let collectionName = MyRemoteEntityIdentifier.collectionName
    let id: String
}

enum MyRemoteEntityIdentifier: String, AnyRemoteEntityIdentifier {
    case mock

    static let collectionName = "my-remote-entity-collection"

    var metatype: any RemoteEntity.Type {
        switch self {
        case .mock:
            return MyRemoteEntity.self
        }
    }
}
```

### 2. Compose your DataManager

```swift
lazy var dataManager: DataManager = {
    let dataManager = DataManager(
        dataServices: [
            dataService,
            coreDataDataService,
            firestoreDataService
        ]
    )
    CoreDataEntity.coreDataEntityBuilder = dataManager
    CoreDataEntity.referenceBuilder = dataManager
    return dataManager
}()

let dataService = DataService<MySimpleEntity>()
let coreDataDataService = CoreDataDataService<MyLocalEntity>(
    managedObjectContext: NSPersistentContainer(name: "my_model").viewContext
)
let firestoreDataService = RemoteCollectionDataService<AnyRemoteFirestoreEntity>(
    database: Firestore.firestore()
)
```

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

## 🤝 Contributing

Contributions are welcome!
If you have suggestions for improvements, bug fixes, or new features, feel free to open an issue or submit a pull request.

## 💬 Contact

Maintained by [https://x.com/_matolah](@_matolah)
