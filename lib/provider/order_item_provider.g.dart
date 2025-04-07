// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderItemCollectionHash() =>
    r'29052aee54e1a60be719012b825ff4e947b12d09';

/// See also [orderItemCollection].
@ProviderFor(orderItemCollection)
final orderItemCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
  orderItemCollection,
  name: r'orderItemCollectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderItemCollectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderItemCollectionRef
    = AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
String _$addOrderItemHash() => r'55187833b6fc4391261ecd588dee39416fabe632';

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

/// See also [addOrderItem].
@ProviderFor(addOrderItem)
const addOrderItemProvider = AddOrderItemFamily();

/// See also [addOrderItem].
class AddOrderItemFamily extends Family<AsyncValue<void>> {
  /// See also [addOrderItem].
  const AddOrderItemFamily();

  /// See also [addOrderItem].
  AddOrderItemProvider call(
    OrderItem orderItem,
  ) {
    return AddOrderItemProvider(
      orderItem,
    );
  }

  @override
  AddOrderItemProvider getProviderOverride(
    covariant AddOrderItemProvider provider,
  ) {
    return call(
      provider.orderItem,
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
  String? get name => r'addOrderItemProvider';
}

/// See also [addOrderItem].
class AddOrderItemProvider extends AutoDisposeFutureProvider<void> {
  /// See also [addOrderItem].
  AddOrderItemProvider(
    OrderItem orderItem,
  ) : this._internal(
          (ref) => addOrderItem(
            ref as AddOrderItemRef,
            orderItem,
          ),
          from: addOrderItemProvider,
          name: r'addOrderItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addOrderItemHash,
          dependencies: AddOrderItemFamily._dependencies,
          allTransitiveDependencies:
              AddOrderItemFamily._allTransitiveDependencies,
          orderItem: orderItem,
        );

  AddOrderItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderItem,
  }) : super.internal();

  final OrderItem orderItem;

  @override
  Override overrideWith(
    FutureOr<void> Function(AddOrderItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddOrderItemProvider._internal(
        (ref) => create(ref as AddOrderItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderItem: orderItem,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddOrderItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddOrderItemProvider && other.orderItem == orderItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddOrderItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `orderItem` of this provider.
  OrderItem get orderItem;
}

class _AddOrderItemProviderElement
    extends AutoDisposeFutureProviderElement<void> with AddOrderItemRef {
  _AddOrderItemProviderElement(super.provider);

  @override
  OrderItem get orderItem => (origin as AddOrderItemProvider).orderItem;
}

String _$allOrderItemsHash() => r'c1f6b3628302f9ade35db34937863d354e0ffb6c';

/// See also [allOrderItems].
@ProviderFor(allOrderItems)
final allOrderItemsProvider =
    AutoDisposeStreamProvider<List<OrderItem>>.internal(
  allOrderItems,
  name: r'allOrderItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allOrderItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllOrderItemsRef = AutoDisposeStreamProviderRef<List<OrderItem>>;
String _$filteredOrderItemsHash() =>
    r'b93aba606ee1e19574a328dd7caaf97ff37a265f';

/// See also [filteredOrderItems].
@ProviderFor(filteredOrderItems)
const filteredOrderItemsProvider = FilteredOrderItemsFamily();

/// See also [filteredOrderItems].
class FilteredOrderItemsFamily extends Family<AsyncValue<List<OrderItem>>> {
  /// See also [filteredOrderItems].
  const FilteredOrderItemsFamily();

  /// See also [filteredOrderItems].
  FilteredOrderItemsProvider call(
    String status,
  ) {
    return FilteredOrderItemsProvider(
      status,
    );
  }

  @override
  FilteredOrderItemsProvider getProviderOverride(
    covariant FilteredOrderItemsProvider provider,
  ) {
    return call(
      provider.status,
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
  String? get name => r'filteredOrderItemsProvider';
}

/// See also [filteredOrderItems].
class FilteredOrderItemsProvider
    extends AutoDisposeStreamProvider<List<OrderItem>> {
  /// See also [filteredOrderItems].
  FilteredOrderItemsProvider(
    String status,
  ) : this._internal(
          (ref) => filteredOrderItems(
            ref as FilteredOrderItemsRef,
            status,
          ),
          from: filteredOrderItemsProvider,
          name: r'filteredOrderItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredOrderItemsHash,
          dependencies: FilteredOrderItemsFamily._dependencies,
          allTransitiveDependencies:
              FilteredOrderItemsFamily._allTransitiveDependencies,
          status: status,
        );

  FilteredOrderItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  Override overrideWith(
    Stream<List<OrderItem>> Function(FilteredOrderItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredOrderItemsProvider._internal(
        (ref) => create(ref as FilteredOrderItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<OrderItem>> createElement() {
    return _FilteredOrderItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredOrderItemsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredOrderItemsRef on AutoDisposeStreamProviderRef<List<OrderItem>> {
  /// The parameter `status` of this provider.
  String get status;
}

class _FilteredOrderItemsProviderElement
    extends AutoDisposeStreamProviderElement<List<OrderItem>>
    with FilteredOrderItemsRef {
  _FilteredOrderItemsProviderElement(super.provider);

  @override
  String get status => (origin as FilteredOrderItemsProvider).status;
}

String _$orderItemByIdHash() => r'ff19b8671c1f1b306133557210be04d0536d39d2';

/// See also [orderItemById].
@ProviderFor(orderItemById)
const orderItemByIdProvider = OrderItemByIdFamily();

/// See also [orderItemById].
class OrderItemByIdFamily extends Family<AsyncValue<OrderItem?>> {
  /// See also [orderItemById].
  const OrderItemByIdFamily();

  /// See also [orderItemById].
  OrderItemByIdProvider call(
    String orderItemId,
  ) {
    return OrderItemByIdProvider(
      orderItemId,
    );
  }

  @override
  OrderItemByIdProvider getProviderOverride(
    covariant OrderItemByIdProvider provider,
  ) {
    return call(
      provider.orderItemId,
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
  String? get name => r'orderItemByIdProvider';
}

/// See also [orderItemById].
class OrderItemByIdProvider extends AutoDisposeFutureProvider<OrderItem?> {
  /// See also [orderItemById].
  OrderItemByIdProvider(
    String orderItemId,
  ) : this._internal(
          (ref) => orderItemById(
            ref as OrderItemByIdRef,
            orderItemId,
          ),
          from: orderItemByIdProvider,
          name: r'orderItemByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderItemByIdHash,
          dependencies: OrderItemByIdFamily._dependencies,
          allTransitiveDependencies:
              OrderItemByIdFamily._allTransitiveDependencies,
          orderItemId: orderItemId,
        );

  OrderItemByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderItemId,
  }) : super.internal();

  final String orderItemId;

  @override
  Override overrideWith(
    FutureOr<OrderItem?> Function(OrderItemByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderItemByIdProvider._internal(
        (ref) => create(ref as OrderItemByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderItemId: orderItemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<OrderItem?> createElement() {
    return _OrderItemByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderItemByIdProvider && other.orderItemId == orderItemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderItemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderItemByIdRef on AutoDisposeFutureProviderRef<OrderItem?> {
  /// The parameter `orderItemId` of this provider.
  String get orderItemId;
}

class _OrderItemByIdProviderElement
    extends AutoDisposeFutureProviderElement<OrderItem?> with OrderItemByIdRef {
  _OrderItemByIdProviderElement(super.provider);

  @override
  String get orderItemId => (origin as OrderItemByIdProvider).orderItemId;
}

String _$updateOrderItemStatusHash() =>
    r'e84f798021e90626461397974ffadeeaaa6db2c9';

/// See also [updateOrderItemStatus].
@ProviderFor(updateOrderItemStatus)
const updateOrderItemStatusProvider = UpdateOrderItemStatusFamily();

/// See also [updateOrderItemStatus].
class UpdateOrderItemStatusFamily extends Family<AsyncValue<void>> {
  /// See also [updateOrderItemStatus].
  const UpdateOrderItemStatusFamily();

  /// See also [updateOrderItemStatus].
  UpdateOrderItemStatusProvider call(
    String orderItemId,
    String newStatus,
  ) {
    return UpdateOrderItemStatusProvider(
      orderItemId,
      newStatus,
    );
  }

  @override
  UpdateOrderItemStatusProvider getProviderOverride(
    covariant UpdateOrderItemStatusProvider provider,
  ) {
    return call(
      provider.orderItemId,
      provider.newStatus,
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
  String? get name => r'updateOrderItemStatusProvider';
}

/// See also [updateOrderItemStatus].
class UpdateOrderItemStatusProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateOrderItemStatus].
  UpdateOrderItemStatusProvider(
    String orderItemId,
    String newStatus,
  ) : this._internal(
          (ref) => updateOrderItemStatus(
            ref as UpdateOrderItemStatusRef,
            orderItemId,
            newStatus,
          ),
          from: updateOrderItemStatusProvider,
          name: r'updateOrderItemStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateOrderItemStatusHash,
          dependencies: UpdateOrderItemStatusFamily._dependencies,
          allTransitiveDependencies:
              UpdateOrderItemStatusFamily._allTransitiveDependencies,
          orderItemId: orderItemId,
          newStatus: newStatus,
        );

  UpdateOrderItemStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderItemId,
    required this.newStatus,
  }) : super.internal();

  final String orderItemId;
  final String newStatus;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateOrderItemStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateOrderItemStatusProvider._internal(
        (ref) => create(ref as UpdateOrderItemStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderItemId: orderItemId,
        newStatus: newStatus,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateOrderItemStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateOrderItemStatusProvider &&
        other.orderItemId == orderItemId &&
        other.newStatus == newStatus;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderItemId.hashCode);
    hash = _SystemHash.combine(hash, newStatus.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateOrderItemStatusRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `orderItemId` of this provider.
  String get orderItemId;

  /// The parameter `newStatus` of this provider.
  String get newStatus;
}

class _UpdateOrderItemStatusProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateOrderItemStatusRef {
  _UpdateOrderItemStatusProviderElement(super.provider);

  @override
  String get orderItemId =>
      (origin as UpdateOrderItemStatusProvider).orderItemId;
  @override
  String get newStatus => (origin as UpdateOrderItemStatusProvider).newStatus;
}

String _$updateOrderItemHash() => r'14ffb6f6f5d0c00ff03520d8d1b0002fdd3f8fe9';

/// See also [updateOrderItem].
@ProviderFor(updateOrderItem)
const updateOrderItemProvider = UpdateOrderItemFamily();

/// See also [updateOrderItem].
class UpdateOrderItemFamily extends Family<AsyncValue<void>> {
  /// See also [updateOrderItem].
  const UpdateOrderItemFamily();

  /// See also [updateOrderItem].
  UpdateOrderItemProvider call(
    String orderItemId,
    OrderItem updatedItem,
  ) {
    return UpdateOrderItemProvider(
      orderItemId,
      updatedItem,
    );
  }

  @override
  UpdateOrderItemProvider getProviderOverride(
    covariant UpdateOrderItemProvider provider,
  ) {
    return call(
      provider.orderItemId,
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
  String? get name => r'updateOrderItemProvider';
}

/// See also [updateOrderItem].
class UpdateOrderItemProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateOrderItem].
  UpdateOrderItemProvider(
    String orderItemId,
    OrderItem updatedItem,
  ) : this._internal(
          (ref) => updateOrderItem(
            ref as UpdateOrderItemRef,
            orderItemId,
            updatedItem,
          ),
          from: updateOrderItemProvider,
          name: r'updateOrderItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateOrderItemHash,
          dependencies: UpdateOrderItemFamily._dependencies,
          allTransitiveDependencies:
              UpdateOrderItemFamily._allTransitiveDependencies,
          orderItemId: orderItemId,
          updatedItem: updatedItem,
        );

  UpdateOrderItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderItemId,
    required this.updatedItem,
  }) : super.internal();

  final String orderItemId;
  final OrderItem updatedItem;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateOrderItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateOrderItemProvider._internal(
        (ref) => create(ref as UpdateOrderItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderItemId: orderItemId,
        updatedItem: updatedItem,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateOrderItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateOrderItemProvider &&
        other.orderItemId == orderItemId &&
        other.updatedItem == updatedItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderItemId.hashCode);
    hash = _SystemHash.combine(hash, updatedItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateOrderItemRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `orderItemId` of this provider.
  String get orderItemId;

  /// The parameter `updatedItem` of this provider.
  OrderItem get updatedItem;
}

class _UpdateOrderItemProviderElement
    extends AutoDisposeFutureProviderElement<void> with UpdateOrderItemRef {
  _UpdateOrderItemProviderElement(super.provider);

  @override
  String get orderItemId => (origin as UpdateOrderItemProvider).orderItemId;
  @override
  OrderItem get updatedItem => (origin as UpdateOrderItemProvider).updatedItem;
}

String _$orderItemsByOrderIdHash() =>
    r'3d15f14ffe2278314186e1f3249482494f443fe8';

/// See also [orderItemsByOrderId].
@ProviderFor(orderItemsByOrderId)
const orderItemsByOrderIdProvider = OrderItemsByOrderIdFamily();

/// See also [orderItemsByOrderId].
class OrderItemsByOrderIdFamily extends Family<AsyncValue<List<OrderItem>>> {
  /// See also [orderItemsByOrderId].
  const OrderItemsByOrderIdFamily();

  /// See also [orderItemsByOrderId].
  OrderItemsByOrderIdProvider call(
    String orderId,
  ) {
    return OrderItemsByOrderIdProvider(
      orderId,
    );
  }

  @override
  OrderItemsByOrderIdProvider getProviderOverride(
    covariant OrderItemsByOrderIdProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'orderItemsByOrderIdProvider';
}

/// See also [orderItemsByOrderId].
class OrderItemsByOrderIdProvider
    extends AutoDisposeStreamProvider<List<OrderItem>> {
  /// See also [orderItemsByOrderId].
  OrderItemsByOrderIdProvider(
    String orderId,
  ) : this._internal(
          (ref) => orderItemsByOrderId(
            ref as OrderItemsByOrderIdRef,
            orderId,
          ),
          from: orderItemsByOrderIdProvider,
          name: r'orderItemsByOrderIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderItemsByOrderIdHash,
          dependencies: OrderItemsByOrderIdFamily._dependencies,
          allTransitiveDependencies:
              OrderItemsByOrderIdFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderItemsByOrderIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    Stream<List<OrderItem>> Function(OrderItemsByOrderIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderItemsByOrderIdProvider._internal(
        (ref) => create(ref as OrderItemsByOrderIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<OrderItem>> createElement() {
    return _OrderItemsByOrderIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderItemsByOrderIdProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderItemsByOrderIdRef on AutoDisposeStreamProviderRef<List<OrderItem>> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderItemsByOrderIdProviderElement
    extends AutoDisposeStreamProviderElement<List<OrderItem>>
    with OrderItemsByOrderIdRef {
  _OrderItemsByOrderIdProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderItemsByOrderIdProvider).orderId;
}

String _$orderCountHash() => r'ea3204429937c14618e6f50ee038b8f157f5d933';

/// See also [orderCount].
@ProviderFor(orderCount)
final orderCountProvider = AutoDisposeFutureProvider<int>.internal(
  orderCount,
  name: r'orderCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$orderCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderCountRef = AutoDisposeFutureProviderRef<int>;
String _$processedOrdersCountHash() =>
    r'3e79df58364e7535f664868b200f01c113eea272';

/// See also [processedOrdersCount].
@ProviderFor(processedOrdersCount)
final processedOrdersCountProvider = AutoDisposeFutureProvider<int>.internal(
  processedOrdersCount,
  name: r'processedOrdersCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$processedOrdersCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcessedOrdersCountRef = AutoDisposeFutureProviderRef<int>;
String _$deliveredCountHash() => r'0001513074ef427f403b13960b0a02b1cd17a2aa';

/// See also [deliveredCount].
@ProviderFor(deliveredCount)
final deliveredCountProvider = AutoDisposeFutureProvider<int>.internal(
  deliveredCount,
  name: r'deliveredCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deliveredCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeliveredCountRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
