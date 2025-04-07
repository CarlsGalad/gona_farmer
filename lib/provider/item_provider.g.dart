// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$itemCollectionHash() => r'307ac671099e56773a426775ff9488a5d47dbbcf';

/// Provider for the Items collection in Firestore
///
/// Copied from [itemCollection].
@ProviderFor(itemCollection)
final itemCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
  itemCollection,
  name: r'itemCollectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itemCollectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ItemCollectionRef
    = AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
String _$createItemHash() => r'918c71e888d0872d1b654c72523a407159e69506';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Creates a new item in the database
///
/// Copied from [createItem].
@ProviderFor(createItem)
const createItemProvider = CreateItemFamily();

/// Creates a new item in the database
///
/// Copied from [createItem].
class CreateItemFamily extends Family<AsyncValue<void>> {
  /// Creates a new item in the database
  ///
  /// Copied from [createItem].
  const CreateItemFamily();

  /// Creates a new item in the database
  ///
  /// Copied from [createItem].
  CreateItemProvider call(
    Item newItem,
  ) {
    return CreateItemProvider(
      newItem,
    );
  }

  @override
  CreateItemProvider getProviderOverride(
    covariant CreateItemProvider provider,
  ) {
    return call(
      provider.newItem,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createItemProvider';
}

/// Creates a new item in the database
///
/// Copied from [createItem].
class CreateItemProvider extends AutoDisposeFutureProvider<void> {
  /// Creates a new item in the database
  ///
  /// Copied from [createItem].
  CreateItemProvider(
    Item newItem,
  ) : this._internal(
          (ref) => createItem(
            ref as CreateItemRef,
            newItem,
          ),
          from: createItemProvider,
          name: r'createItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createItemHash,
          dependencies: CreateItemFamily._dependencies,
          allTransitiveDependencies:
              CreateItemFamily._allTransitiveDependencies,
          newItem: newItem,
        );

  CreateItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.newItem,
  }) : super.internal();

  final Item newItem;

  @override
  Override overrideWith(
    FutureOr<void> Function(CreateItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateItemProvider._internal(
        (ref) => create(ref as CreateItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        newItem: newItem,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CreateItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateItemProvider && other.newItem == newItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, newItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `newItem` of this provider.
  Item get newItem;
}

class _CreateItemProviderElement extends AutoDisposeFutureProviderElement<void>
    with CreateItemRef {
  _CreateItemProviderElement(super.provider);

  @override
  Item get newItem => (origin as CreateItemProvider).newItem;
}

String _$allItemsHash() => r'68365e1f526c420d66e80b2cc6accae78b6eb02f';

/// Streams all items from the database
///
/// Copied from [allItems].
@ProviderFor(allItems)
final allItemsProvider = AutoDisposeStreamProvider<List<Item>>.internal(
  allItems,
  name: r'allItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllItemsRef = AutoDisposeStreamProviderRef<List<Item>>;
String _$itemByIdHash() => r'652457f9de75ab11054159fafc91f3afbac72a27';

/// Fetches a single item by ID
///
/// Copied from [itemById].
@ProviderFor(itemById)
const itemByIdProvider = ItemByIdFamily();

/// Fetches a single item by ID
///
/// Copied from [itemById].
class ItemByIdFamily extends Family<AsyncValue<Item?>> {
  /// Fetches a single item by ID
  ///
  /// Copied from [itemById].
  const ItemByIdFamily();

  /// Fetches a single item by ID
  ///
  /// Copied from [itemById].
  ItemByIdProvider call(
    String itemId,
  ) {
    return ItemByIdProvider(
      itemId,
    );
  }

  @override
  ItemByIdProvider getProviderOverride(
    covariant ItemByIdProvider provider,
  ) {
    return call(
      provider.itemId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemByIdProvider';
}

/// Fetches a single item by ID
///
/// Copied from [itemById].
class ItemByIdProvider extends AutoDisposeFutureProvider<Item?> {
  /// Fetches a single item by ID
  ///
  /// Copied from [itemById].
  ItemByIdProvider(
    String itemId,
  ) : this._internal(
          (ref) => itemById(
            ref as ItemByIdRef,
            itemId,
          ),
          from: itemByIdProvider,
          name: r'itemByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemByIdHash,
          dependencies: ItemByIdFamily._dependencies,
          allTransitiveDependencies: ItemByIdFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  ItemByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    FutureOr<Item?> Function(ItemByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemByIdProvider._internal(
        (ref) => create(ref as ItemByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Item?> createElement() {
    return _ItemByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemByIdProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemByIdRef on AutoDisposeFutureProviderRef<Item?> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _ItemByIdProviderElement extends AutoDisposeFutureProviderElement<Item?>
    with ItemByIdRef {
  _ItemByIdProviderElement(super.provider);

  @override
  String get itemId => (origin as ItemByIdProvider).itemId;
}

String _$updateItemHash() => r'cb3b4a1f44bb11bb0e7f10a37d1a535f7106bfdd';

/// Updates an existing item in the database
///
/// Copied from [updateItem].
@ProviderFor(updateItem)
const updateItemProvider = UpdateItemFamily();

/// Updates an existing item in the database
///
/// Copied from [updateItem].
class UpdateItemFamily extends Family<AsyncValue<void>> {
  /// Updates an existing item in the database
  ///
  /// Copied from [updateItem].
  const UpdateItemFamily();

  /// Updates an existing item in the database
  ///
  /// Copied from [updateItem].
  UpdateItemProvider call(
    String itemId,
    Item updatedItem,
  ) {
    return UpdateItemProvider(
      itemId,
      updatedItem,
    );
  }

  @override
  UpdateItemProvider getProviderOverride(
    covariant UpdateItemProvider provider,
  ) {
    return call(
      provider.itemId,
      provider.updatedItem,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateItemProvider';
}

/// Updates an existing item in the database
///
/// Copied from [updateItem].
class UpdateItemProvider extends AutoDisposeFutureProvider<void> {
  /// Updates an existing item in the database
  ///
  /// Copied from [updateItem].
  UpdateItemProvider(
    String itemId,
    Item updatedItem,
  ) : this._internal(
          (ref) => updateItem(
            ref as UpdateItemRef,
            itemId,
            updatedItem,
          ),
          from: updateItemProvider,
          name: r'updateItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateItemHash,
          dependencies: UpdateItemFamily._dependencies,
          allTransitiveDependencies:
              UpdateItemFamily._allTransitiveDependencies,
          itemId: itemId,
          updatedItem: updatedItem,
        );

  UpdateItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
    required this.updatedItem,
  }) : super.internal();

  final String itemId;
  final Item updatedItem;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateItemProvider._internal(
        (ref) => create(ref as UpdateItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
        updatedItem: updatedItem,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateItemProvider &&
        other.itemId == itemId &&
        other.updatedItem == updatedItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);
    hash = _SystemHash.combine(hash, updatedItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `itemId` of this provider.
  String get itemId;

  /// The parameter `updatedItem` of this provider.
  Item get updatedItem;
}

class _UpdateItemProviderElement extends AutoDisposeFutureProviderElement<void>
    with UpdateItemRef {
  _UpdateItemProviderElement(super.provider);

  @override
  String get itemId => (origin as UpdateItemProvider).itemId;
  @override
  Item get updatedItem => (origin as UpdateItemProvider).updatedItem;
}

String _$deleteItemHash() => r'f475e369035a9202e5cf967f3c23914d98ffe909';

/// Deletes an item from the database
///
/// Copied from [deleteItem].
@ProviderFor(deleteItem)
const deleteItemProvider = DeleteItemFamily();

/// Deletes an item from the database
///
/// Copied from [deleteItem].
class DeleteItemFamily extends Family<AsyncValue<void>> {
  /// Deletes an item from the database
  ///
  /// Copied from [deleteItem].
  const DeleteItemFamily();

  /// Deletes an item from the database
  ///
  /// Copied from [deleteItem].
  DeleteItemProvider call(
    String itemId,
  ) {
    return DeleteItemProvider(
      itemId,
    );
  }

  @override
  DeleteItemProvider getProviderOverride(
    covariant DeleteItemProvider provider,
  ) {
    return call(
      provider.itemId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteItemProvider';
}

/// Deletes an item from the database
///
/// Copied from [deleteItem].
class DeleteItemProvider extends AutoDisposeFutureProvider<void> {
  /// Deletes an item from the database
  ///
  /// Copied from [deleteItem].
  DeleteItemProvider(
    String itemId,
  ) : this._internal(
          (ref) => deleteItem(
            ref as DeleteItemRef,
            itemId,
          ),
          from: deleteItemProvider,
          name: r'deleteItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteItemHash,
          dependencies: DeleteItemFamily._dependencies,
          allTransitiveDependencies:
              DeleteItemFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  DeleteItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteItemProvider._internal(
        (ref) => create(ref as DeleteItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteItemProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _DeleteItemProviderElement extends AutoDisposeFutureProviderElement<void>
    with DeleteItemRef {
  _DeleteItemProviderElement(super.provider);

  @override
  String get itemId => (origin as DeleteItemProvider).itemId;
}

String _$toggleItemPausedHash() => r'975b355fc02a2add6b573b9002037eae32ea7513';

/// Toggles the paused status of an item
///
/// Copied from [toggleItemPaused].
@ProviderFor(toggleItemPaused)
const toggleItemPausedProvider = ToggleItemPausedFamily();

/// Toggles the paused status of an item
///
/// Copied from [toggleItemPaused].
class ToggleItemPausedFamily extends Family<AsyncValue<void>> {
  /// Toggles the paused status of an item
  ///
  /// Copied from [toggleItemPaused].
  const ToggleItemPausedFamily();

  /// Toggles the paused status of an item
  ///
  /// Copied from [toggleItemPaused].
  ToggleItemPausedProvider call(
    String itemId,
  ) {
    return ToggleItemPausedProvider(
      itemId,
    );
  }

  @override
  ToggleItemPausedProvider getProviderOverride(
    covariant ToggleItemPausedProvider provider,
  ) {
    return call(
      provider.itemId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'toggleItemPausedProvider';
}

/// Toggles the paused status of an item
///
/// Copied from [toggleItemPaused].
class ToggleItemPausedProvider extends AutoDisposeFutureProvider<void> {
  /// Toggles the paused status of an item
  ///
  /// Copied from [toggleItemPaused].
  ToggleItemPausedProvider(
    String itemId,
  ) : this._internal(
          (ref) => toggleItemPaused(
            ref as ToggleItemPausedRef,
            itemId,
          ),
          from: toggleItemPausedProvider,
          name: r'toggleItemPausedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$toggleItemPausedHash,
          dependencies: ToggleItemPausedFamily._dependencies,
          allTransitiveDependencies:
              ToggleItemPausedFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  ToggleItemPausedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    FutureOr<void> Function(ToggleItemPausedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ToggleItemPausedProvider._internal(
        (ref) => create(ref as ToggleItemPausedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ToggleItemPausedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ToggleItemPausedProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ToggleItemPausedRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _ToggleItemPausedProviderElement
    extends AutoDisposeFutureProviderElement<void> with ToggleItemPausedRef {
  _ToggleItemPausedProviderElement(super.provider);

  @override
  String get itemId => (origin as ToggleItemPausedProvider).itemId;
}

String _$decreaseInventoryHash() => r'2b0626eb8d878d558805ca6884c532930776e4f2';

/// See also [decreaseInventory].
@ProviderFor(decreaseInventory)
const decreaseInventoryProvider = DecreaseInventoryFamily();

/// See also [decreaseInventory].
class DecreaseInventoryFamily extends Family<AsyncValue<void>> {
  /// See also [decreaseInventory].
  const DecreaseInventoryFamily();

  /// See also [decreaseInventory].
  DecreaseInventoryProvider call(
    String itemId,
    int quantity,
  ) {
    return DecreaseInventoryProvider(
      itemId,
      quantity,
    );
  }

  @override
  DecreaseInventoryProvider getProviderOverride(
    covariant DecreaseInventoryProvider provider,
  ) {
    return call(
      provider.itemId,
      provider.quantity,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'decreaseInventoryProvider';
}

/// See also [decreaseInventory].
class DecreaseInventoryProvider extends AutoDisposeFutureProvider<void> {
  /// See also [decreaseInventory].
  DecreaseInventoryProvider(
    String itemId,
    int quantity,
  ) : this._internal(
          (ref) => decreaseInventory(
            ref as DecreaseInventoryRef,
            itemId,
            quantity,
          ),
          from: decreaseInventoryProvider,
          name: r'decreaseInventoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$decreaseInventoryHash,
          dependencies: DecreaseInventoryFamily._dependencies,
          allTransitiveDependencies:
              DecreaseInventoryFamily._allTransitiveDependencies,
          itemId: itemId,
          quantity: quantity,
        );

  DecreaseInventoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
    required this.quantity,
  }) : super.internal();

  final String itemId;
  final int quantity;

  @override
  Override overrideWith(
    FutureOr<void> Function(DecreaseInventoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DecreaseInventoryProvider._internal(
        (ref) => create(ref as DecreaseInventoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
        quantity: quantity,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DecreaseInventoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DecreaseInventoryProvider &&
        other.itemId == itemId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);
    hash = _SystemHash.combine(hash, quantity.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DecreaseInventoryRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `itemId` of this provider.
  String get itemId;

  /// The parameter `quantity` of this provider.
  int get quantity;
}

class _DecreaseInventoryProviderElement
    extends AutoDisposeFutureProviderElement<void> with DecreaseInventoryRef {
  _DecreaseInventoryProviderElement(super.provider);

  @override
  String get itemId => (origin as DecreaseInventoryProvider).itemId;
  @override
  int get quantity => (origin as DecreaseInventoryProvider).quantity;
}

String _$itemsByFarmHash() => r'2343a1ac633ace841b54b1ec72d74102b65a6e88';

/// Streams items filtered by farm ID
///
/// Copied from [itemsByFarm].
@ProviderFor(itemsByFarm)
const itemsByFarmProvider = ItemsByFarmFamily();

/// Streams items filtered by farm ID
///
/// Copied from [itemsByFarm].
class ItemsByFarmFamily extends Family<AsyncValue<List<Item>>> {
  /// Streams items filtered by farm ID
  ///
  /// Copied from [itemsByFarm].
  const ItemsByFarmFamily();

  /// Streams items filtered by farm ID
  ///
  /// Copied from [itemsByFarm].
  ItemsByFarmProvider call(
    String farmId,
  ) {
    return ItemsByFarmProvider(
      farmId,
    );
  }

  @override
  ItemsByFarmProvider getProviderOverride(
    covariant ItemsByFarmProvider provider,
  ) {
    return call(
      provider.farmId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemsByFarmProvider';
}

/// Streams items filtered by farm ID
///
/// Copied from [itemsByFarm].
class ItemsByFarmProvider extends AutoDisposeStreamProvider<List<Item>> {
  /// Streams items filtered by farm ID
  ///
  /// Copied from [itemsByFarm].
  ItemsByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => itemsByFarm(
            ref as ItemsByFarmRef,
            farmId,
          ),
          from: itemsByFarmProvider,
          name: r'itemsByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemsByFarmHash,
          dependencies: ItemsByFarmFamily._dependencies,
          allTransitiveDependencies:
              ItemsByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  ItemsByFarmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
  }) : super.internal();

  final String farmId;

  @override
  Override overrideWith(
    Stream<List<Item>> Function(ItemsByFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemsByFarmProvider._internal(
        (ref) => create(ref as ItemsByFarmRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Item>> createElement() {
    return _ItemsByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsByFarmProvider && other.farmId == farmId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemsByFarmRef on AutoDisposeStreamProviderRef<List<Item>> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _ItemsByFarmProviderElement
    extends AutoDisposeStreamProviderElement<List<Item>> with ItemsByFarmRef {
  _ItemsByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as ItemsByFarmProvider).farmId;
}

String _$itemsByCategoryHash() => r'9bf6ab3b696e5095e3927c9fc26f5fe32b7fa2e8';

/// Streams items filtered by category ID
///
/// Copied from [itemsByCategory].
@ProviderFor(itemsByCategory)
const itemsByCategoryProvider = ItemsByCategoryFamily();

/// Streams items filtered by category ID
///
/// Copied from [itemsByCategory].
class ItemsByCategoryFamily extends Family<AsyncValue<List<Item>>> {
  /// Streams items filtered by category ID
  ///
  /// Copied from [itemsByCategory].
  const ItemsByCategoryFamily();

  /// Streams items filtered by category ID
  ///
  /// Copied from [itemsByCategory].
  ItemsByCategoryProvider call(
    int categoryId,
  ) {
    return ItemsByCategoryProvider(
      categoryId,
    );
  }

  @override
  ItemsByCategoryProvider getProviderOverride(
    covariant ItemsByCategoryProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemsByCategoryProvider';
}

/// Streams items filtered by category ID
///
/// Copied from [itemsByCategory].
class ItemsByCategoryProvider extends AutoDisposeStreamProvider<List<Item>> {
  /// Streams items filtered by category ID
  ///
  /// Copied from [itemsByCategory].
  ItemsByCategoryProvider(
    int categoryId,
  ) : this._internal(
          (ref) => itemsByCategory(
            ref as ItemsByCategoryRef,
            categoryId,
          ),
          from: itemsByCategoryProvider,
          name: r'itemsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemsByCategoryHash,
          dependencies: ItemsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ItemsByCategoryFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  ItemsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    Stream<List<Item>> Function(ItemsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemsByCategoryProvider._internal(
        (ref) => create(ref as ItemsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Item>> createElement() {
    return _ItemsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsByCategoryProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemsByCategoryRef on AutoDisposeStreamProviderRef<List<Item>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _ItemsByCategoryProviderElement
    extends AutoDisposeStreamProviderElement<List<Item>>
    with ItemsByCategoryRef {
  _ItemsByCategoryProviderElement(super.provider);

  @override
  int get categoryId => (origin as ItemsByCategoryProvider).categoryId;
}

String _$promoItemsHash() => r'dfbe03a62449bf190e9446d6448ecb552f9d6f8d';

/// Streams promotional items
///
/// Copied from [promoItems].
@ProviderFor(promoItems)
final promoItemsProvider = AutoDisposeStreamProvider<List<Item>>.internal(
  promoItems,
  name: r'promoItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$promoItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromoItemsRef = AutoDisposeStreamProviderRef<List<Item>>;
String _$lowInventoryItemsHash() => r'8155e15722c68d2b7a343b5278509347af1dcee9';

/// Streams items with low inventory (less than threshold)
///
/// Copied from [lowInventoryItems].
@ProviderFor(lowInventoryItems)
const lowInventoryItemsProvider = LowInventoryItemsFamily();

/// Streams items with low inventory (less than threshold)
///
/// Copied from [lowInventoryItems].
class LowInventoryItemsFamily extends Family<AsyncValue<List<Item>>> {
  /// Streams items with low inventory (less than threshold)
  ///
  /// Copied from [lowInventoryItems].
  const LowInventoryItemsFamily();

  /// Streams items with low inventory (less than threshold)
  ///
  /// Copied from [lowInventoryItems].
  LowInventoryItemsProvider call({
    int threshold = 5,
  }) {
    return LowInventoryItemsProvider(
      threshold: threshold,
    );
  }

  @override
  LowInventoryItemsProvider getProviderOverride(
    covariant LowInventoryItemsProvider provider,
  ) {
    return call(
      threshold: provider.threshold,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lowInventoryItemsProvider';
}

/// Streams items with low inventory (less than threshold)
///
/// Copied from [lowInventoryItems].
class LowInventoryItemsProvider extends AutoDisposeStreamProvider<List<Item>> {
  /// Streams items with low inventory (less than threshold)
  ///
  /// Copied from [lowInventoryItems].
  LowInventoryItemsProvider({
    int threshold = 5,
  }) : this._internal(
          (ref) => lowInventoryItems(
            ref as LowInventoryItemsRef,
            threshold: threshold,
          ),
          from: lowInventoryItemsProvider,
          name: r'lowInventoryItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lowInventoryItemsHash,
          dependencies: LowInventoryItemsFamily._dependencies,
          allTransitiveDependencies:
              LowInventoryItemsFamily._allTransitiveDependencies,
          threshold: threshold,
        );

  LowInventoryItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threshold,
  }) : super.internal();

  final int threshold;

  @override
  Override overrideWith(
    Stream<List<Item>> Function(LowInventoryItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LowInventoryItemsProvider._internal(
        (ref) => create(ref as LowInventoryItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threshold: threshold,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Item>> createElement() {
    return _LowInventoryItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LowInventoryItemsProvider && other.threshold == threshold;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threshold.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LowInventoryItemsRef on AutoDisposeStreamProviderRef<List<Item>> {
  /// The parameter `threshold` of this provider.
  int get threshold;
}

class _LowInventoryItemsProviderElement
    extends AutoDisposeStreamProviderElement<List<Item>>
    with LowInventoryItemsRef {
  _LowInventoryItemsProviderElement(super.provider);

  @override
  int get threshold => (origin as LowInventoryItemsProvider).threshold;
}

String _$increaseInventoryHash() => r'dd9472474e952d888ecc6a4d1cdb8ef84efc9cdc';

/// Increases the inventory quantity of an item
///
/// Copied from [increaseInventory].
@ProviderFor(increaseInventory)
const increaseInventoryProvider = IncreaseInventoryFamily();

/// Increases the inventory quantity of an item
///
/// Copied from [increaseInventory].
class IncreaseInventoryFamily extends Family<AsyncValue<void>> {
  /// Increases the inventory quantity of an item
  ///
  /// Copied from [increaseInventory].
  const IncreaseInventoryFamily();

  /// Increases the inventory quantity of an item
  ///
  /// Copied from [increaseInventory].
  IncreaseInventoryProvider call(
    String itemId,
    int quantity,
  ) {
    return IncreaseInventoryProvider(
      itemId,
      quantity,
    );
  }

  @override
  IncreaseInventoryProvider getProviderOverride(
    covariant IncreaseInventoryProvider provider,
  ) {
    return call(
      provider.itemId,
      provider.quantity,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'increaseInventoryProvider';
}

/// Increases the inventory quantity of an item
///
/// Copied from [increaseInventory].
class IncreaseInventoryProvider extends AutoDisposeFutureProvider<void> {
  /// Increases the inventory quantity of an item
  ///
  /// Copied from [increaseInventory].
  IncreaseInventoryProvider(
    String itemId,
    int quantity,
  ) : this._internal(
          (ref) => increaseInventory(
            ref as IncreaseInventoryRef,
            itemId,
            quantity,
          ),
          from: increaseInventoryProvider,
          name: r'increaseInventoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$increaseInventoryHash,
          dependencies: IncreaseInventoryFamily._dependencies,
          allTransitiveDependencies:
              IncreaseInventoryFamily._allTransitiveDependencies,
          itemId: itemId,
          quantity: quantity,
        );

  IncreaseInventoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
    required this.quantity,
  }) : super.internal();

  final String itemId;
  final int quantity;

  @override
  Override overrideWith(
    FutureOr<void> Function(IncreaseInventoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IncreaseInventoryProvider._internal(
        (ref) => create(ref as IncreaseInventoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
        quantity: quantity,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _IncreaseInventoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncreaseInventoryProvider &&
        other.itemId == itemId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);
    hash = _SystemHash.combine(hash, quantity.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IncreaseInventoryRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `itemId` of this provider.
  String get itemId;

  /// The parameter `quantity` of this provider.
  int get quantity;
}

class _IncreaseInventoryProviderElement
    extends AutoDisposeFutureProviderElement<void> with IncreaseInventoryRef {
  _IncreaseInventoryProviderElement(super.provider);

  @override
  String get itemId => (origin as IncreaseInventoryProvider).itemId;
  @override
  int get quantity => (origin as IncreaseInventoryProvider).quantity;
}

String _$searchItemsHash() => r'b4fd92fe4aced4fdf630a6c2a92ecc0eb1e8b12b';

/// Searches for items by name
///
/// Copied from [searchItems].
@ProviderFor(searchItems)
const searchItemsProvider = SearchItemsFamily();

/// Searches for items by name
///
/// Copied from [searchItems].
class SearchItemsFamily extends Family<AsyncValue<List<Item>>> {
  /// Searches for items by name
  ///
  /// Copied from [searchItems].
  const SearchItemsFamily();

  /// Searches for items by name
  ///
  /// Copied from [searchItems].
  SearchItemsProvider call(
    String query,
  ) {
    return SearchItemsProvider(
      query,
    );
  }

  @override
  SearchItemsProvider getProviderOverride(
    covariant SearchItemsProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchItemsProvider';
}

/// Searches for items by name
///
/// Copied from [searchItems].
class SearchItemsProvider extends AutoDisposeStreamProvider<List<Item>> {
  /// Searches for items by name
  ///
  /// Copied from [searchItems].
  SearchItemsProvider(
    String query,
  ) : this._internal(
          (ref) => searchItems(
            ref as SearchItemsRef,
            query,
          ),
          from: searchItemsProvider,
          name: r'searchItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchItemsHash,
          dependencies: SearchItemsFamily._dependencies,
          allTransitiveDependencies:
              SearchItemsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    Stream<List<Item>> Function(SearchItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchItemsProvider._internal(
        (ref) => create(ref as SearchItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Item>> createElement() {
    return _SearchItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchItemsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchItemsRef on AutoDisposeStreamProviderRef<List<Item>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchItemsProviderElement
    extends AutoDisposeStreamProviderElement<List<Item>> with SearchItemsRef {
  _SearchItemsProviderElement(super.provider);

  @override
  String get query => (origin as SearchItemsProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
