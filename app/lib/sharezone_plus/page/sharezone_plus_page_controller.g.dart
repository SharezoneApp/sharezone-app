// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharezone_plus_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharezonePlusPageNotifierHash() =>
    r'b733f034fe26d85ee1c4902c7f9541e9a234d5de';

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

abstract class _$SharezonePlusPageNotifier
    extends BuildlessAutoDisposeNotifier<PlusPageViewModel> {
  late final BuildContext context;

  PlusPageViewModel build(
    BuildContext context,
  );
}

/// See also [SharezonePlusPageNotifier].
@ProviderFor(SharezonePlusPageNotifier)
const sharezonePlusPageNotifierProvider = SharezonePlusPageNotifierFamily();

/// See also [SharezonePlusPageNotifier].
class SharezonePlusPageNotifierFamily extends Family<PlusPageViewModel> {
  /// See also [SharezonePlusPageNotifier].
  const SharezonePlusPageNotifierFamily();

  /// See also [SharezonePlusPageNotifier].
  SharezonePlusPageNotifierProvider call(
    BuildContext context,
  ) {
    return SharezonePlusPageNotifierProvider(
      context,
    );
  }

  @override
  SharezonePlusPageNotifierProvider getProviderOverride(
    covariant SharezonePlusPageNotifierProvider provider,
  ) {
    return call(
      provider.context,
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
  String? get name => r'sharezonePlusPageNotifierProvider';
}

/// See also [SharezonePlusPageNotifier].
class SharezonePlusPageNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SharezonePlusPageNotifier, PlusPageViewModel> {
  /// See also [SharezonePlusPageNotifier].
  SharezonePlusPageNotifierProvider(
    BuildContext context,
  ) : this._internal(
          () => SharezonePlusPageNotifier()..context = context,
          from: sharezonePlusPageNotifierProvider,
          name: r'sharezonePlusPageNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharezonePlusPageNotifierHash,
          dependencies: SharezonePlusPageNotifierFamily._dependencies,
          allTransitiveDependencies:
              SharezonePlusPageNotifierFamily._allTransitiveDependencies,
          context: context,
        );

  SharezonePlusPageNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
  }) : super.internal();

  final BuildContext context;

  @override
  PlusPageViewModel runNotifierBuild(
    covariant SharezonePlusPageNotifier notifier,
  ) {
    return notifier.build(
      context,
    );
  }

  @override
  Override overrideWith(SharezonePlusPageNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SharezonePlusPageNotifierProvider._internal(
        () => create()..context = context,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SharezonePlusPageNotifier,
      PlusPageViewModel> createElement() {
    return _SharezonePlusPageNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharezonePlusPageNotifierProvider &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SharezonePlusPageNotifierRef
    on AutoDisposeNotifierProviderRef<PlusPageViewModel> {
  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _SharezonePlusPageNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SharezonePlusPageNotifier,
        PlusPageViewModel> with SharezonePlusPageNotifierRef {
  _SharezonePlusPageNotifierProviderElement(super.provider);

  @override
  BuildContext get context =>
      (origin as SharezonePlusPageNotifierProvider).context;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
