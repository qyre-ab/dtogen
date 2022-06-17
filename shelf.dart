@CopyWith()
class CreateShelf extends Equatable {
  const CreateShelf({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.names,
    required this.books,
  });

  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> names;
  final List<CreateShelfBook> books;

  @override
  List<Object?> get props => [
        userId,
        createdAt,
        updatedAt,
        names,
        books,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CreateShelfDto {
  const CreateShelfDto({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.names,
    required this.books,
  });

  factory CreateShelfDto.fromEntity(CreateShelf entity) {
    return CreateShelfDto(
      userId: entity.userId,
      createdAt: entity.createdAt.toString(),
      updatedAt: entity.updatedAt.toString(),
      names: entity.names,
      books: entity.books.map(CreateShelfBookDto.fromEntity).toList(),
    );
  }

  final String userId;
  final String createdAt;
  final String updatedAt;
  final List<String> names;
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

