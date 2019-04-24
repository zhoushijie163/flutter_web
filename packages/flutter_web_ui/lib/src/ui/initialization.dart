// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of ui;

/// Initializes the platform.
Future<void> webOnlyInitializePlatform(
    {engine.AssetManager assetManager}) async {
  if (assetManager == null) {
    assetManager = new engine.AssetManager();
  }
  await webOnlySetAssetManager(assetManager);
  await _fontCollection.ensureFontsLoaded();
}

engine.AssetManager _assetManager;
engine.FontCollection _fontCollection;

/// Specifies that the platform should use the given [AssetManager] to load
/// assets.
///
/// The given asset manager is used to initialize the font collection.
Future<void> webOnlySetAssetManager(engine.AssetManager assetManager) async {
  assert(assetManager != null, 'Cannot set assetManager to null');
  if (assetManager == _assetManager) return;

  _assetManager = assetManager;

  _fontCollection ??= engine.FontCollection();
  _fontCollection.clear();
  if (_assetManager != null) {
    await _fontCollection.registerFonts(_assetManager);
  }

  if (engine.domRenderer.debugIsInWidgetTest) {
    _fontCollection.debugRegisterTestFonts();
  }
}

/// This class handles downloading assets over the network.
engine.AssetManager get webOnlyAssetManager => _assetManager;

/// A collection of fonts that may be used by the platform.
engine.FontCollection get webOnlyFontCollection => _fontCollection;