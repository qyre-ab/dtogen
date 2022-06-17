# Dto generator
`dtogen` is a command-line app which is used to generate DTOs
and Entities from json.

## Short info
`dtogen --help`
```
A command-line app which is used to generate DTOs and Entities from json.

Usage: dtogen [arguments]

Options:
    --no-from-json      Don't generate `fromJson` factory for DTO
    --no-to-json        Don't generate `toJson` method for DTO
    --no-entity         Don't generate Entity for DTO. Entity extends `Equatable` and uses `DateTime` instead of `String` with date
    --no-from-entity    Don't generate `fromEntity` factory for DTO
    --no-to-entity      Don't generate `toEntity` method for DTO
    --no-copy           Don't generate `CopyWith` annotation
-i, --input             Path to the json file
-o, --output            Path to the output dart file. Prints to console if not specified
    --init-class        Name of the root model
                        (defaults to "Generated")
-p, --prefix            Prefix for all generated class names
```

## Usage example
We have a json file named `shelf.json`. We want to generate
model that will be used to create shelf. This model
is a part of shelf domain. So we need to add `CreateShelf`
prefix. Also we don't want to generate `fromJson` factories
and `toEntity` for DTOs.
```json
{
  "user_id": "string",
  "created_at": "2022-06-16",
  "updated_at": "2022-06-16",
  "names": ["string"],
  "books": [
    {
      "books_needed": 0,
      "store_locations": [
        {
          "city": "string",
          "state": "string",
          "country": "string"
        }
      ],
      "book_blueprint": {
        "amount": 0,
        "hours_to_reed": 0,
        "cost": 0,
        "description": "string",
        "currency": "usd",
        "payment_method": "card"
      }
    }
  ]
}
```

To generate models for our needs we can use this command:
```sh
dtogen -i shelf.json -o shelf.dart -p CreateShelf --init-class Shelf --no-from-json --no-to-entity 
```

This command will create the following file named `shelf.dart`:
```dart
@CopyWith()
class CreateShelf extends Equatable {
  const CreateShelf({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.books,
  });

  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CreateShelfBook> books;

  @override
  List<Object?> get props => [
        userId,
        createdAt,
        updatedAt,
        books,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CreateShelfDto {
  const CreateShelfDto({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.books,
  });

  factory CreateShelfDto.fromEntity(CreateShelf entity) {
    return CreateShelfDto(
      userId: entity.userId,
      createdAt: entity.createdAt.toString(),
      updatedAt: entity.updatedAt.toString(),
      books: entity.books.map(CreateShelfBookDto.fromEntity).toList(),
    );
  }

  final String userId;
  final String createdAt;
  final String updatedAt;
  final List<CreateShelfBookDto> books;

  Map<String, dynamic> toJson() => _$CreateShelfDtoToJson(this);
}

@CopyWith()
class CreateShelfBook extends Equatable {
  const CreateShelfBook({
    required this.booksNeeded,
    required this.storeLocations,
    required this.bookBlueprint,
  });

  final int booksNeeded;
  final List<CreateShelfStoreLocation> storeLocations;
  final CreateShelfBookBlueprint bookBlueprint;

  @override
  List<Object?> get props => [
        booksNeeded,
        storeLocations,
        bookBlueprint,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CreateShelfBookDto {
  const CreateShelfBookDto({
    required this.booksNeeded,
    required this.storeLocations,
    required this.bookBlueprint,
  });

  factory CreateShelfBookDto.fromEntity(CreateShelfBook entity) {
    return CreateShelfBookDto(
      booksNeeded: entity.booksNeeded,
      storeLocations: entity.storeLocations.map(CreateShelfStoreLocationDto.fromEntity).toList(),
      bookBlueprint: CreateShelfBookBlueprintDto.fromEntity(entity.bookBlueprint),
    );
  }

  final int booksNeeded;
  final List<CreateShelfStoreLocationDto> storeLocations;
  final CreateShelfBookBlueprintDto bookBlueprint;

  Map<String, dynamic> toJson() => _$CreateShelfBookDtoToJson(this);
}

@CopyWith()
class CreateShelfBookBlueprint extends Equatable {
  const CreateShelfBookBlueprint({
    required this.amount,
    required this.hoursToReed,
    required this.cost,
    required this.description,
    required this.currency,
    required this.paymentMethod,
  });

  final int amount;
  final int hoursToReed;
  final int cost;
  final String description;
  final String currency;
  final String paymentMethod;

  @override
  List<Object?> get props => [
        amount,
        hoursToReed,
        cost,
        description,
        currency,
        paymentMethod,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CreateShelfBookBlueprintDto {
  const CreateShelfBookBlueprintDto({
    required this.amount,
    required this.hoursToReed,
    required this.cost,
    required this.description,
    required this.currency,
    required this.paymentMethod,
  });

  factory CreateShelfBookBlueprintDto.fromEntity(CreateShelfBookBlueprint entity) {
    return CreateShelfBookBlueprintDto(
      amount: entity.amount,
      hoursToReed: entity.hoursToReed,
      cost: entity.cost,
      description: entity.description,
      currency: entity.currency,
      paymentMethod: entity.paymentMethod,
    );
  }

  final int amount;
  final int hoursToReed;
  final int cost;
  final String description;
  final String currency;
  final String paymentMethod;

  Map<String, dynamic> toJson() => _$CreateShelfBookBlueprintDtoToJson(this);
}

@CopyWith()
class CreateShelfStoreLocation extends Equatable {
  const CreateShelfStoreLocation({
    required this.city,
    required this.state,
    required this.country,
  });

  final String city;
  final String state;
  final String country;

  @override
  List<Object?> get props => [
        city,
        state,
        country,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CreateShelfStoreLocationDto {
  const CreateShelfStoreLocationDto({
    required this.city,
    required this.state,
    required this.country,
  });

  factory CreateShelfStoreLocationDto.fromEntity(CreateShelfStoreLocation entity) {
    return CreateShelfStoreLocationDto(
      city: entity.city,
      state: entity.state,
      country: entity.country,
    );
  }

  final String city;
  final String state;
  final String country;

  Map<String, dynamic> toJson() => _$CreateShelfStoreLocationDtoToJson(this);
}
```
