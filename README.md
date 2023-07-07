<a name="readme-top"></a>

<div align="center">
    <img src="https://github.com/matolah/LeezyData/assets/26446518/bdcb3d9e-db05-44d3-bd55-4d936511a237" alt="Logo" width="120" height="120">
  </a>

  <h3 align="center">LeezyData</h3>

  <p align="center">
    A generic and agnostic entity-oriented data layer.
    <br />
    <br />
    <a href="https://github.com/matolah/LeezyData/issues">Report Bug</a>
    ·
    <a href="https://github.com/matolah/LeezyData/issues">Request Feature</a>
  </p>
</div>

## Should I use this package in my project?

If you are building an app with remote data collections and/or a local database layer, then the answer is yes, you should use this package. `LeezyData` is a self-serve package, meaning you can choose to be completely agnostic from third-party libraries or `Swift` frameworks and build your own services, or you can add `LeezyData`'s built-in integration with `CoreData` (for your local database) and `Firestore` (for you remote data).

### Overview of the contents

This package contains the following libraries:

* `Common`: The foundations of your data layer. It contains the `Entity` protocol, the `DataService` blueprint for each of your entities CRUD operations and the `DataManager` which is the class your app will use to communicate and perform data operations.
* `CoreData`: A local database layer that uses CoreData to store and retrieve entities. By default, this library doesn't make use of CoreData's relationships, instead it fetches the entities in all the available services using an `id`.
* `RemoteCollection`: A remote collection layer that completely abstracts the database so you can choose the one that suits you best. This layer supports type-erased entities so you no longer have headaches when modelling your collections. All you need is an `identifier` for your custom types and `AnyRemoteEntity` will do the rest.
* `Firestore`: Contains protocol conformances to support `Firestore` as a `RemoteCollection` source.


## Installation

`LeezyData` is available for installation via SPM:

```swift
dependencies: [
    .package(name: "LeezyData", url: "https://github.com/matolah/LeezyData", .upToNextMajor(from: "1.0.0")),
],
.target(
    name: "MyApp",
    dependencies: [
      .product(name: "LeezyData", package: "LeezyData"),
      .product(name: "LeezyCoreData", package: "LeezyData"),
      .product(name: "LeezyRemoteCollection", package: "LeezyData"),
      .product(name: "LeezyFirestore", package: "LeezyData")
  ]
),
```


## Usage

Create your entities:

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
    static var collectionName = "my-remote-entity-collection"

    let id: String
}

enum MyRemoteEntityIdentifier: String, AnyRemoteEntityIdentifier {
    case mock

    static var collectionName = "my-remote-entity-collection"

    var metatype: any RemoteEntity.Type {
        switch self {
        case .mock:
            return MyRemoteEntity.self
        }
    }
}
```

Create `DataService`s for your entities and inject them in your `DataManager`. Remember to initialize `coreDataEntityBuilder` for initializing empty `CoreData` objects and `referenceBuilder` if you want to use `LeezyData` relationship creation.

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

let coreDataDataService = CoreDataDataService<MyLocalEntity>(managedObjectContext: NSPersistentContainer(name: "my_model").viewContext)

let firestoreDataService = RemoteCollectionDataService<AnyRemoteFirestoreEntity>(database: Firestore.firestore())
```


## License

Distributed under the MIT License. See `LICENSE.txt` for more information.


## Contact

Twitter - [@_matolah](https://twitter.com/_matolah)
