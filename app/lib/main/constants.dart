// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// Can be overridden for testing purposes.
String? kDevelopmentStageOrNull =
    kDevelopmentStage == "" ? null : kDevelopmentStage;
const kDevelopmentStage = String.fromEnvironment('DEVELOPMENT_STAGE');

const isBetaStage = kDevelopmentStage == 'BETA';
const isAlphaStage = kDevelopmentStage == 'ALPHA';
const isPreviewStage = kDevelopmentStage == 'PREVIEW';
const isStableStage = kDevelopmentStage == 'STABLE';
