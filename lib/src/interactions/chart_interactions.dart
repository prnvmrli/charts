// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:meta/meta.dart' show immutable;

import '../behaviors/chart_behavior.dart' show ChartBehavior;
import '../behaviors/select_nearest.dart' show SelectNearest;
import '../behaviors/tooltip/trackball_tooltip.dart'
    show ChartTooltip, ChartTrackball;
import '../behaviors/zoom/pan_and_zoom_behavior.dart' show PanAndZoomBehavior;
import '../behaviors/zoom/pan_behavior.dart' show PanBehavior;

/// High-level interaction configuration for chart widgets.
///
/// This is the discoverable API intended for application code. The lower-level
/// [ChartBehavior] list remains available for advanced or custom behavior
/// implementations.
@immutable
class ChartInteractions<D> {
  const ChartInteractions({
    this.tooltip,
    this.trackball,
    this.selection,
    this.pan,
    this.zoomPan,
    this.includeDefaultInteractions,
    this.behaviors = const [],
  }) : assert(pan == null || zoomPan == null),
       assert(tooltip == null || trackball == null);

  const ChartInteractions.none()
    : tooltip = null,
      trackball = null,
      selection = null,
      pan = null,
      zoomPan = null,
      includeDefaultInteractions = false,
      behaviors = const [];

  factory ChartInteractions.tooltip({
    ChartTooltip<D>? tooltip,
    bool? includeDefaultInteractions,
    List<ChartBehavior<D>> behaviors = const [],
  }) => ChartInteractions<D>(
    tooltip: tooltip ?? ChartTooltip<D>.enabled(),
    includeDefaultInteractions: includeDefaultInteractions,
    behaviors: behaviors,
  );

  factory ChartInteractions.trackball({
    ChartTrackball<D>? trackball,
    bool? includeDefaultInteractions,
    List<ChartBehavior<D>> behaviors = const [],
  }) => ChartInteractions<D>(
    trackball: trackball ?? ChartTrackball<D>.enabled(),
    includeDefaultInteractions: includeDefaultInteractions,
    behaviors: behaviors,
  );

  factory ChartInteractions.zoomPan({
    PanAndZoomBehavior<D>? zoomPan,
    bool? includeDefaultInteractions,
    List<ChartBehavior<D>> behaviors = const [],
  }) => ChartInteractions<D>(
    zoomPan: zoomPan ?? PanAndZoomBehavior<D>(),
    includeDefaultInteractions: includeDefaultInteractions,
    behaviors: behaviors,
  );

  factory ChartInteractions.defaults({
    ChartTooltip<D>? tooltip,
    ChartTrackball<D>? trackball,
    SelectNearest<D>? selection,
    PanBehavior<D>? pan,
    PanAndZoomBehavior<D>? zoomPan,
    bool? includeDefaultInteractions,
    List<ChartBehavior<D>> behaviors = const [],
  }) => ChartInteractions<D>(
    tooltip: tooltip,
    trackball: trackball,
    selection: selection,
    pan: pan,
    zoomPan: zoomPan,
    includeDefaultInteractions: includeDefaultInteractions,
    behaviors: behaviors,
  );

  /// Tooltip rendered as a Flutter widget overlay.
  final ChartTooltip<D>? tooltip;

  /// Data-snapped tooltip with a trackball guide line.
  final ChartTrackball<D>? trackball;

  /// Selection behavior used for highlights, legends, and callbacks.
  final SelectNearest<D>? selection;

  /// Domain-axis panning behavior.
  final PanBehavior<D>? pan;

  /// Domain-axis pan and zoom behavior.
  final PanAndZoomBehavior<D>? zoomPan;

  /// Whether chart defaults such as tap selection and built-in highlighters
  /// should also be installed.
  ///
  /// When null, the chart widget's existing `defaultInteractions` value is
  /// used for backwards compatibility.
  final bool? includeDefaultInteractions;

  /// Additional advanced behaviors to install with these interactions.
  final List<ChartBehavior<D>> behaviors;

  List<ChartBehavior<D>> createBehaviors() {
    return [
      if (selection != null) selection!,
      if (tooltip != null) tooltip!,
      if (trackball != null) trackball!,
      if (pan != null) pan!,
      if (zoomPan != null) zoomPan!,
      ...behaviors,
    ];
  }
}
