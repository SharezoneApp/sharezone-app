// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/src/edited_image.dart';

/// Pushes the image editor page.
///
/// The image editor page allows the user to edit the given [files]. The
/// following editing options are available:
///  * Selecting the quality of the image (original or compressed).
///  * Removing the image from the list of images to be uploaded.
///
/// Later, other options might be added, e.g. cropping, rotating, painting, etc.
///
/// A user can select quality of an image only if
/// [hasUnlockedSelectingOriginalQuality] is `true`. If
/// [hasUnlockedSelectingOriginalQuality] is `false`, a note for buying
/// Sharezone Plus is shown instead because this feature is only available for
/// Sharezone Plus users.
///
/// The option to select the quality of an image is hidden and not shown if the
/// platform is web because we don't support compressed images on web.
///
/// Returns a list of [EditedImage]s. The list contains the edited images in the
/// same order as the given [files]. If the user removes an image, the image is
/// not included in the returned list.
Future<List<EditedImage>> pushImageEditorPage({
  required List<LocalFile> files,
  required bool hasUnlockedSelectingOriginalQuality,
  required VoidCallback navigateToSharezonePlusPage,
}) async {
  return [];
}
