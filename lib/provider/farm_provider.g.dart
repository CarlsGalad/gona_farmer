// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$farmCollectionHash() => r'6aa8f090611a54e9188bd5fe4a65f65dc2797107';

/// See also [farmCollection].
@ProviderFor(farmCollection)
final farmCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
  farmCollection,
  name: r'farmCollectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmCollectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmCollectionRef
    = AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
String _$currentFarmProfileHash() =>
    r'0d62ec1e25f2d6d156807e68ebfafc2cba369d67';

/// Provides a stream of the current user's FarmProfile.  Handles null user case.
///
/// Copied from [currentFarmProfile].
@ProviderFor(currentFarmProfile)
final currentFarmProfileProvider =
    AutoDisposeStreamProvider<FarmProfile?>.internal(
  currentFarmProfile,
  name: r'currentFarmProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentFarmProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentFarmProfileRef = AutoDisposeStreamProviderRef<FarmProfile?>;
String _$farmProfileByIdHash() => r'a1a4ea0e7f9de2672f2740bed09ede5d8b0e4b92';

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

/// Fetches the farm profile by farm ID.  Returns null if not found.
///
/// Copied from [farmProfileById].
@ProviderFor(farmProfileById)
const farmProfileByIdProvider = FarmProfileByIdFamily();

/// Fetches the farm profile by farm ID.  Returns null if not found.
///
/// Copied from [farmProfileById].
class FarmProfileByIdFamily extends Family<AsyncValue<FarmProfile?>> {
  /// Fetches the farm profile by farm ID.  Returns null if not found.
  ///
  /// Copied from [farmProfileById].
  const FarmProfileByIdFamily();

  /// Fetches the farm profile by farm ID.  Returns null if not found.
  ///
  /// Copied from [farmProfileById].
  FarmProfileByIdProvider call(
    String farmId,
  ) {
    return FarmProfileByIdProvider(
      farmId,
    );
  }

  @override
  FarmProfileByIdProvider getProviderOverride(
    covariant FarmProfileByIdProvider provider,
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
  String? get name => r'farmProfileByIdProvider';
}

/// Fetches the farm profile by farm ID.  Returns null if not found.
///
/// Copied from [farmProfileById].
class FarmProfileByIdProvider extends AutoDisposeFutureProvider<FarmProfile?> {
  /// Fetches the farm profile by farm ID.  Returns null if not found.
  ///
  /// Copied from [farmProfileById].
  FarmProfileByIdProvider(
    String farmId,
  ) : this._internal(
          (ref) => farmProfileById(
            ref as FarmProfileByIdRef,
            farmId,
          ),
          from: farmProfileByIdProvider,
          name: r'farmProfileByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmProfileByIdHash,
          dependencies: FarmProfileByIdFamily._dependencies,
          allTransitiveDependencies:
              FarmProfileByIdFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  FarmProfileByIdProvider._internal(
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
    FutureOr<FarmProfile?> Function(FarmProfileByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmProfileByIdProvider._internal(
        (ref) => create(ref as FarmProfileByIdRef),
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
  AutoDisposeFutureProviderElement<FarmProfile?> createElement() {
    return _FarmProfileByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmProfileByIdProvider && other.farmId == farmId;
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
mixin FarmProfileByIdRef on AutoDisposeFutureProviderRef<FarmProfile?> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _FarmProfileByIdProviderElement
    extends AutoDisposeFutureProviderElement<FarmProfile?>
    with FarmProfileByIdRef {
  _FarmProfileByIdProviderElement(super.provider);

  @override
  String get farmId => (origin as FarmProfileByIdProvider).farmId;
}

String _$accountDetailsHash() => r'212d10d15933244a5f0719813eeb19f3a03e5b61';

/// Fetches account details for a specific farm. Returns a Map.
///
/// Copied from [accountDetails].
@ProviderFor(accountDetails)
const accountDetailsProvider = AccountDetailsFamily();

/// Fetches account details for a specific farm. Returns a Map.
///
/// Copied from [accountDetails].
class AccountDetailsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Fetches account details for a specific farm. Returns a Map.
  ///
  /// Copied from [accountDetails].
  const AccountDetailsFamily();

  /// Fetches account details for a specific farm. Returns a Map.
  ///
  /// Copied from [accountDetails].
  AccountDetailsProvider call(
    String farmId,
  ) {
    return AccountDetailsProvider(
      farmId,
    );
  }

  @override
  AccountDetailsProvider getProviderOverride(
    covariant AccountDetailsProvider provider,
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
  String? get name => r'accountDetailsProvider';
}

/// Fetches account details for a specific farm. Returns a Map.
///
/// Copied from [accountDetails].
class AccountDetailsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Fetches account details for a specific farm. Returns a Map.
  ///
  /// Copied from [accountDetails].
  AccountDetailsProvider(
    String farmId,
  ) : this._internal(
          (ref) => accountDetails(
            ref as AccountDetailsRef,
            farmId,
          ),
          from: accountDetailsProvider,
          name: r'accountDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountDetailsHash,
          dependencies: AccountDetailsFamily._dependencies,
          allTransitiveDependencies:
              AccountDetailsFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  AccountDetailsProvider._internal(
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
    FutureOr<Map<String, dynamic>> Function(AccountDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountDetailsProvider._internal(
        (ref) => create(ref as AccountDetailsRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _AccountDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountDetailsProvider && other.farmId == farmId;
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
mixin AccountDetailsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _AccountDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with AccountDetailsRef {
  _AccountDetailsProviderElement(super.provider);

  @override
  String get farmId => (origin as AccountDetailsProvider).farmId;
}

String _$updateFarmProfileHash() => r'b96a4a5e07c1b682125cec7cb9a232e688e2d935';

/// Updates the farm profile.
///
/// Copied from [updateFarmProfile].
@ProviderFor(updateFarmProfile)
const updateFarmProfileProvider = UpdateFarmProfileFamily();

/// Updates the farm profile.
///
/// Copied from [updateFarmProfile].
class UpdateFarmProfileFamily extends Family<AsyncValue<void>> {
  /// Updates the farm profile.
  ///
  /// Copied from [updateFarmProfile].
  const UpdateFarmProfileFamily();

  /// Updates the farm profile.
  ///
  /// Copied from [updateFarmProfile].
  UpdateFarmProfileProvider call(
    FarmProfile updatedProfile,
  ) {
    return UpdateFarmProfileProvider(
      updatedProfile,
    );
  }

  @override
  UpdateFarmProfileProvider getProviderOverride(
    covariant UpdateFarmProfileProvider provider,
  ) {
    return call(
      provider.updatedProfile,
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
  String? get name => r'updateFarmProfileProvider';
}

/// Updates the farm profile.
///
/// Copied from [updateFarmProfile].
class UpdateFarmProfileProvider extends AutoDisposeFutureProvider<void> {
  /// Updates the farm profile.
  ///
  /// Copied from [updateFarmProfile].
  UpdateFarmProfileProvider(
    FarmProfile updatedProfile,
  ) : this._internal(
          (ref) => updateFarmProfile(
            ref as UpdateFarmProfileRef,
            updatedProfile,
          ),
          from: updateFarmProfileProvider,
          name: r'updateFarmProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateFarmProfileHash,
          dependencies: UpdateFarmProfileFamily._dependencies,
          allTransitiveDependencies:
              UpdateFarmProfileFamily._allTransitiveDependencies,
          updatedProfile: updatedProfile,
        );

  UpdateFarmProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.updatedProfile,
  }) : super.internal();

  final FarmProfile updatedProfile;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateFarmProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateFarmProfileProvider._internal(
        (ref) => create(ref as UpdateFarmProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        updatedProfile: updatedProfile,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateFarmProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateFarmProfileProvider &&
        other.updatedProfile == updatedProfile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, updatedProfile.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateFarmProfileRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `updatedProfile` of this provider.
  FarmProfile get updatedProfile;
}

class _UpdateFarmProfileProviderElement
    extends AutoDisposeFutureProviderElement<void> with UpdateFarmProfileRef {
  _UpdateFarmProfileProviderElement(super.provider);

  @override
  FarmProfile get updatedProfile =>
      (origin as UpdateFarmProfileProvider).updatedProfile;
}

String _$updateAccountDetailsHash() =>
    r'a53d4678a4cae90c2ff82971fd8459ca23195759';

/// Updates the account details of current logged-in farm.
///
/// Copied from [updateAccountDetails].
@ProviderFor(updateAccountDetails)
const updateAccountDetailsProvider = UpdateAccountDetailsFamily();

/// Updates the account details of current logged-in farm.
///
/// Copied from [updateAccountDetails].
class UpdateAccountDetailsFamily extends Family<AsyncValue<void>> {
  /// Updates the account details of current logged-in farm.
  ///
  /// Copied from [updateAccountDetails].
  const UpdateAccountDetailsFamily();

  /// Updates the account details of current logged-in farm.
  ///
  /// Copied from [updateAccountDetails].
  UpdateAccountDetailsProvider call({
    required String accountName,
    required String bankName,
    required String accountNumber,
  }) {
    return UpdateAccountDetailsProvider(
      accountName: accountName,
      bankName: bankName,
      accountNumber: accountNumber,
    );
  }

  @override
  UpdateAccountDetailsProvider getProviderOverride(
    covariant UpdateAccountDetailsProvider provider,
  ) {
    return call(
      accountName: provider.accountName,
      bankName: provider.bankName,
      accountNumber: provider.accountNumber,
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
  String? get name => r'updateAccountDetailsProvider';
}

/// Updates the account details of current logged-in farm.
///
/// Copied from [updateAccountDetails].
class UpdateAccountDetailsProvider extends AutoDisposeFutureProvider<void> {
  /// Updates the account details of current logged-in farm.
  ///
  /// Copied from [updateAccountDetails].
  UpdateAccountDetailsProvider({
    required String accountName,
    required String bankName,
    required String accountNumber,
  }) : this._internal(
          (ref) => updateAccountDetails(
            ref as UpdateAccountDetailsRef,
            accountName: accountName,
            bankName: bankName,
            accountNumber: accountNumber,
          ),
          from: updateAccountDetailsProvider,
          name: r'updateAccountDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateAccountDetailsHash,
          dependencies: UpdateAccountDetailsFamily._dependencies,
          allTransitiveDependencies:
              UpdateAccountDetailsFamily._allTransitiveDependencies,
          accountName: accountName,
          bankName: bankName,
          accountNumber: accountNumber,
        );

  UpdateAccountDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountName,
    required this.bankName,
    required this.accountNumber,
  }) : super.internal();

  final String accountName;
  final String bankName;
  final String accountNumber;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateAccountDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateAccountDetailsProvider._internal(
        (ref) => create(ref as UpdateAccountDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountName: accountName,
        bankName: bankName,
        accountNumber: accountNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateAccountDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateAccountDetailsProvider &&
        other.accountName == accountName &&
        other.bankName == bankName &&
        other.accountNumber == accountNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountName.hashCode);
    hash = _SystemHash.combine(hash, bankName.hashCode);
    hash = _SystemHash.combine(hash, accountNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateAccountDetailsRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `accountName` of this provider.
  String get accountName;

  /// The parameter `bankName` of this provider.
  String get bankName;

  /// The parameter `accountNumber` of this provider.
  String get accountNumber;
}

class _UpdateAccountDetailsProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateAccountDetailsRef {
  _UpdateAccountDetailsProviderElement(super.provider);

  @override
  String get accountName =>
      (origin as UpdateAccountDetailsProvider).accountName;
  @override
  String get bankName => (origin as UpdateAccountDetailsProvider).bankName;
  @override
  String get accountNumber =>
      (origin as UpdateAccountDetailsProvider).accountNumber;
}

String _$createFarmProfileHash() => r'f692f3181930c279774d8121fee02ae18d07b192';

/// Creates a new farm profile during signup.  Requires email/password.
///
/// Copied from [createFarmProfile].
@ProviderFor(createFarmProfile)
const createFarmProfileProvider = CreateFarmProfileFamily();

/// Creates a new farm profile during signup.  Requires email/password.
///
/// Copied from [createFarmProfile].
class CreateFarmProfileFamily extends Family<AsyncValue<void>> {
  /// Creates a new farm profile during signup.  Requires email/password.
  ///
  /// Copied from [createFarmProfile].
  const CreateFarmProfileFamily();

  /// Creates a new farm profile during signup.  Requires email/password.
  ///
  /// Copied from [createFarmProfile].
  CreateFarmProfileProvider call({
    required String email,
    required String password,
    required String farmName,
    required String ownersName,
    required String mobile,
    required String address,
    required String farmState,
    required String lga,
  }) {
    return CreateFarmProfileProvider(
      email: email,
      password: password,
      farmName: farmName,
      ownersName: ownersName,
      mobile: mobile,
      address: address,
      farmState: farmState,
      lga: lga,
    );
  }

  @override
  CreateFarmProfileProvider getProviderOverride(
    covariant CreateFarmProfileProvider provider,
  ) {
    return call(
      email: provider.email,
      password: provider.password,
      farmName: provider.farmName,
      ownersName: provider.ownersName,
      mobile: provider.mobile,
      address: provider.address,
      farmState: provider.farmState,
      lga: provider.lga,
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
  String? get name => r'createFarmProfileProvider';
}

/// Creates a new farm profile during signup.  Requires email/password.
///
/// Copied from [createFarmProfile].
class CreateFarmProfileProvider extends AutoDisposeFutureProvider<void> {
  /// Creates a new farm profile during signup.  Requires email/password.
  ///
  /// Copied from [createFarmProfile].
  CreateFarmProfileProvider({
    required String email,
    required String password,
    required String farmName,
    required String ownersName,
    required String mobile,
    required String address,
    required String farmState,
    required String lga,
  }) : this._internal(
          (ref) => createFarmProfile(
            ref as CreateFarmProfileRef,
            email: email,
            password: password,
            farmName: farmName,
            ownersName: ownersName,
            mobile: mobile,
            address: address,
            farmState: farmState,
            lga: lga,
          ),
          from: createFarmProfileProvider,
          name: r'createFarmProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createFarmProfileHash,
          dependencies: CreateFarmProfileFamily._dependencies,
          allTransitiveDependencies:
              CreateFarmProfileFamily._allTransitiveDependencies,
          email: email,
          password: password,
          farmName: farmName,
          ownersName: ownersName,
          mobile: mobile,
          address: address,
          farmState: farmState,
          lga: lga,
        );

  CreateFarmProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
    required this.farmName,
    required this.ownersName,
    required this.mobile,
    required this.address,
    required this.farmState,
    required this.lga,
  }) : super.internal();

  final String email;
  final String password;
  final String farmName;
  final String ownersName;
  final String mobile;
  final String address;
  final String farmState;
  final String lga;

  @override
  Override overrideWith(
    FutureOr<void> Function(CreateFarmProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateFarmProfileProvider._internal(
        (ref) => create(ref as CreateFarmProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
        farmName: farmName,
        ownersName: ownersName,
        mobile: mobile,
        address: address,
        farmState: farmState,
        lga: lga,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CreateFarmProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateFarmProfileProvider &&
        other.email == email &&
        other.password == password &&
        other.farmName == farmName &&
        other.ownersName == ownersName &&
        other.mobile == mobile &&
        other.address == address &&
        other.farmState == farmState &&
        other.lga == lga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);
    hash = _SystemHash.combine(hash, farmName.hashCode);
    hash = _SystemHash.combine(hash, ownersName.hashCode);
    hash = _SystemHash.combine(hash, mobile.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);
    hash = _SystemHash.combine(hash, farmState.hashCode);
    hash = _SystemHash.combine(hash, lga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateFarmProfileRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;

  /// The parameter `farmName` of this provider.
  String get farmName;

  /// The parameter `ownersName` of this provider.
  String get ownersName;

  /// The parameter `mobile` of this provider.
  String get mobile;

  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `farmState` of this provider.
  String get farmState;

  /// The parameter `lga` of this provider.
  String get lga;
}

class _CreateFarmProfileProviderElement
    extends AutoDisposeFutureProviderElement<void> with CreateFarmProfileRef {
  _CreateFarmProfileProviderElement(super.provider);

  @override
  String get email => (origin as CreateFarmProfileProvider).email;
  @override
  String get password => (origin as CreateFarmProfileProvider).password;
  @override
  String get farmName => (origin as CreateFarmProfileProvider).farmName;
  @override
  String get ownersName => (origin as CreateFarmProfileProvider).ownersName;
  @override
  String get mobile => (origin as CreateFarmProfileProvider).mobile;
  @override
  String get address => (origin as CreateFarmProfileProvider).address;
  @override
  String get farmState => (origin as CreateFarmProfileProvider).farmState;
  @override
  String get lga => (origin as CreateFarmProfileProvider).lga;
}

String _$uploadFarmImageHash() => r'23e5c6b3b90d2780c89c949cd97b055081ab1697';

/// Uploads a farm profile image and updates the FarmProfile.
///
/// Copied from [uploadFarmImage].
@ProviderFor(uploadFarmImage)
const uploadFarmImageProvider = UploadFarmImageFamily();

/// Uploads a farm profile image and updates the FarmProfile.
///
/// Copied from [uploadFarmImage].
class UploadFarmImageFamily extends Family<AsyncValue<void>> {
  /// Uploads a farm profile image and updates the FarmProfile.
  ///
  /// Copied from [uploadFarmImage].
  const UploadFarmImageFamily();

  /// Uploads a farm profile image and updates the FarmProfile.
  ///
  /// Copied from [uploadFarmImage].
  UploadFarmImageProvider call({
    required Uint8List imageFile,
  }) {
    return UploadFarmImageProvider(
      imageFile: imageFile,
    );
  }

  @override
  UploadFarmImageProvider getProviderOverride(
    covariant UploadFarmImageProvider provider,
  ) {
    return call(
      imageFile: provider.imageFile,
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
  String? get name => r'uploadFarmImageProvider';
}

/// Uploads a farm profile image and updates the FarmProfile.
///
/// Copied from [uploadFarmImage].
class UploadFarmImageProvider extends AutoDisposeFutureProvider<void> {
  /// Uploads a farm profile image and updates the FarmProfile.
  ///
  /// Copied from [uploadFarmImage].
  UploadFarmImageProvider({
    required Uint8List imageFile,
  }) : this._internal(
          (ref) => uploadFarmImage(
            ref as UploadFarmImageRef,
            imageFile: imageFile,
          ),
          from: uploadFarmImageProvider,
          name: r'uploadFarmImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$uploadFarmImageHash,
          dependencies: UploadFarmImageFamily._dependencies,
          allTransitiveDependencies:
              UploadFarmImageFamily._allTransitiveDependencies,
          imageFile: imageFile,
        );

  UploadFarmImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imageFile,
  }) : super.internal();

  final Uint8List imageFile;

  @override
  Override overrideWith(
    FutureOr<void> Function(UploadFarmImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UploadFarmImageProvider._internal(
        (ref) => create(ref as UploadFarmImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imageFile: imageFile,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UploadFarmImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UploadFarmImageProvider && other.imageFile == imageFile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imageFile.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UploadFarmImageRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `imageFile` of this provider.
  Uint8List get imageFile;
}

class _UploadFarmImageProviderElement
    extends AutoDisposeFutureProviderElement<void> with UploadFarmImageRef {
  _UploadFarmImageProviderElement(super.provider);

  @override
  Uint8List get imageFile => (origin as UploadFarmImageProvider).imageFile;
}

String _$signInWithEmailAndPasswordHash() =>
    r'8a60e5e1c0b8ebc2a0c359cb2fc660cb25ecfcd3';

/// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
///
/// Copied from [signInWithEmailAndPassword].
@ProviderFor(signInWithEmailAndPassword)
const signInWithEmailAndPasswordProvider = SignInWithEmailAndPasswordFamily();

/// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
///
/// Copied from [signInWithEmailAndPassword].
class SignInWithEmailAndPasswordFamily extends Family<AsyncValue<void>> {
  /// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
  ///
  /// Copied from [signInWithEmailAndPassword].
  const SignInWithEmailAndPasswordFamily();

  /// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
  ///
  /// Copied from [signInWithEmailAndPassword].
  SignInWithEmailAndPasswordProvider call({
    required String email,
    required String password,
  }) {
    return SignInWithEmailAndPasswordProvider(
      email: email,
      password: password,
    );
  }

  @override
  SignInWithEmailAndPasswordProvider getProviderOverride(
    covariant SignInWithEmailAndPasswordProvider provider,
  ) {
    return call(
      email: provider.email,
      password: provider.password,
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
  String? get name => r'signInWithEmailAndPasswordProvider';
}

/// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
///
/// Copied from [signInWithEmailAndPassword].
class SignInWithEmailAndPasswordProvider
    extends AutoDisposeFutureProvider<void> {
  /// Signs in a user with email and password.  Doesn't return anything, relies on auth state changes.
  ///
  /// Copied from [signInWithEmailAndPassword].
  SignInWithEmailAndPasswordProvider({
    required String email,
    required String password,
  }) : this._internal(
          (ref) => signInWithEmailAndPassword(
            ref as SignInWithEmailAndPasswordRef,
            email: email,
            password: password,
          ),
          from: signInWithEmailAndPasswordProvider,
          name: r'signInWithEmailAndPasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$signInWithEmailAndPasswordHash,
          dependencies: SignInWithEmailAndPasswordFamily._dependencies,
          allTransitiveDependencies:
              SignInWithEmailAndPasswordFamily._allTransitiveDependencies,
          email: email,
          password: password,
        );

  SignInWithEmailAndPasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
  }) : super.internal();

  final String email;
  final String password;

  @override
  Override overrideWith(
    FutureOr<void> Function(SignInWithEmailAndPasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SignInWithEmailAndPasswordProvider._internal(
        (ref) => create(ref as SignInWithEmailAndPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SignInWithEmailAndPasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignInWithEmailAndPasswordProvider &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SignInWithEmailAndPasswordRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;
}

class _SignInWithEmailAndPasswordProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with SignInWithEmailAndPasswordRef {
  _SignInWithEmailAndPasswordProviderElement(super.provider);

  @override
  String get email => (origin as SignInWithEmailAndPasswordProvider).email;
  @override
  String get password =>
      (origin as SignInWithEmailAndPasswordProvider).password;
}

String _$farmNameByIdHash() => r'fd0ef077ccfd31c6a367dd6a576a0bce0c5cc03f';

/// Fetches a farm's name by its ID
///
/// Copied from [farmNameById].
@ProviderFor(farmNameById)
const farmNameByIdProvider = FarmNameByIdFamily();

/// Fetches a farm's name by its ID
///
/// Copied from [farmNameById].
class FarmNameByIdFamily extends Family<AsyncValue<String>> {
  /// Fetches a farm's name by its ID
  ///
  /// Copied from [farmNameById].
  const FarmNameByIdFamily();

  /// Fetches a farm's name by its ID
  ///
  /// Copied from [farmNameById].
  FarmNameByIdProvider call(
    String farmId,
  ) {
    return FarmNameByIdProvider(
      farmId,
    );
  }

  @override
  FarmNameByIdProvider getProviderOverride(
    covariant FarmNameByIdProvider provider,
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
  String? get name => r'farmNameByIdProvider';
}

/// Fetches a farm's name by its ID
///
/// Copied from [farmNameById].
class FarmNameByIdProvider extends AutoDisposeFutureProvider<String> {
  /// Fetches a farm's name by its ID
  ///
  /// Copied from [farmNameById].
  FarmNameByIdProvider(
    String farmId,
  ) : this._internal(
          (ref) => farmNameById(
            ref as FarmNameByIdRef,
            farmId,
          ),
          from: farmNameByIdProvider,
          name: r'farmNameByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmNameByIdHash,
          dependencies: FarmNameByIdFamily._dependencies,
          allTransitiveDependencies:
              FarmNameByIdFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  FarmNameByIdProvider._internal(
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
    FutureOr<String> Function(FarmNameByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmNameByIdProvider._internal(
        (ref) => create(ref as FarmNameByIdRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _FarmNameByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmNameByIdProvider && other.farmId == farmId;
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
mixin FarmNameByIdRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _FarmNameByIdProviderElement
    extends AutoDisposeFutureProviderElement<String> with FarmNameByIdRef {
  _FarmNameByIdProviderElement(super.provider);

  @override
  String get farmId => (origin as FarmNameByIdProvider).farmId;
}

String _$farmerNameHash() => r'684e96552b9c76d3bc0431790a83f79c6620bf8d';

/// See also [farmerName].
@ProviderFor(farmerName)
final farmerNameProvider = AutoDisposeFutureProvider<String>.internal(
  farmerName,
  name: r'farmerNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$farmerNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmerNameRef = AutoDisposeFutureProviderRef<String>;
String _$userDetailsHash() => r'c1346cb7724683caedef51b215f3fe551fe79241';

/// See also [UserDetails].
@ProviderFor(UserDetails)
final userDetailsProvider = AutoDisposeAsyncNotifierProvider<UserDetails,
    Map<String, dynamic>>.internal(
  UserDetails.new,
  name: r'userDetailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserDetails = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
