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

import 'dart:math' show Point, Rectangle;

import 'package:charts_flutter/common.dart' as common;
import 'package:flutter/material.dart'
    show
        Alignment,
        AnimatedOpacity,
        AnimatedScale,
        BuildContext,
        Card,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Curves,
        EdgeInsets,
        FontWeight,
        IgnorePointer,
        Key,
        MainAxisSize,
        Offset,
        Row,
        Size,
        SizedBox,
        Text,
        TextStyle,
        Widget;
import 'package:flutter/rendering.dart' show BoxConstraints;
import 'package:flutter/widgets.dart'
    show
        CustomSingleChildLayout,
        Positioned,
        SingleChildLayoutDelegate,
        Stack,
        StatelessWidget;
import 'package:meta/meta.dart' show immutable;

import '../../base_chart_state.dart' show BaseChartState;
import '../../chart_state.dart' show ChartState;
import '../../util/color.dart' show ColorUtil;
import '../chart_behavior.dart'
    show BuildableBehavior, ChartBehavior, ChartStateBehavior, GestureType;

typedef ChartTooltipBuilder<D> =
    Widget Function(BuildContext context, ChartTooltipDetails<D> details);

@immutable
class ChartTooltip<D> extends ChartBehavior<D> {
  ChartTooltip({
    this.activationMode = ChartTooltipActivationMode.tapAndHover,
    this.persistence = ChartTooltipPersistence.none,
    this.grouping = ChartTooltipGrouping.byDomain,
    this.builder,
    this.showTrackballLine = false,
    this.trackballLineStyle = const ChartTrackballLineStyle(),
    this.maxWidth = 280,
    this.margin = const EdgeInsets.all(8),
    this.offset = const Point<double>(12, 12),
    this.animationDuration = const Duration(milliseconds: 160),
    this.selectionModelType = common.SelectionModelType.info,
  }) : desiredGestures = _getDesiredGestures(activationMode, persistence);

  factory ChartTooltip.enabled({
    ChartTooltipBuilder<D>? builder,
    ChartTooltipActivationMode activationMode =
        ChartTooltipActivationMode.tapAndHover,
    ChartTooltipPersistence persistence = ChartTooltipPersistence.none,
  }) => ChartTooltip<D>(
    activationMode: activationMode,
    persistence: persistence,
    builder: builder,
  );

  final ChartTooltipActivationMode activationMode;
  final ChartTooltipPersistence persistence;
  final ChartTooltipGrouping grouping;
  final ChartTooltipBuilder<D>? builder;
  final bool showTrackballLine;
  final ChartTrackballLineStyle trackballLineStyle;
  final double maxWidth;
  final EdgeInsets margin;
  final Point<double> offset;
  final Duration animationDuration;
  final common.SelectionModelType selectionModelType;

  @override
  final Set<GestureType> desiredGestures;

  static Set<GestureType> _getDesiredGestures(
    ChartTooltipActivationMode activationMode,
    ChartTooltipPersistence persistence,
  ) {
    final gestures = <GestureType>{};
    switch (activationMode) {
      case ChartTooltipActivationMode.tap:
        gestures.add(GestureType.onTap);
        break;
      case ChartTooltipActivationMode.longPress:
        gestures
          ..add(GestureType.onTap)
          ..add(GestureType.onLongPress);
        break;
      case ChartTooltipActivationMode.hover:
        gestures.add(GestureType.onHover);
        break;
      case ChartTooltipActivationMode.tapAndHover:
        gestures
          ..add(GestureType.onTap)
          ..add(GestureType.onHover);
        break;
      case ChartTooltipActivationMode.longPressAndHover:
      case ChartTooltipActivationMode.all:
        gestures
          ..add(GestureType.onTap)
          ..add(GestureType.onLongPress)
          ..add(GestureType.onHover);
        break;
    }

    if (persistence == ChartTooltipPersistence.tap ||
        persistence == ChartTooltipPersistence.tapOrLongPress) {
      gestures.add(GestureType.onTap);
    }
    if (persistence == ChartTooltipPersistence.longPress ||
        persistence == ChartTooltipPersistence.tapOrLongPress) {
      gestures
        ..add(GestureType.onTap)
        ..add(GestureType.onLongPress);
    }

    return gestures;
  }

  @override
  common.ChartBehavior<D> createCommonBehavior() => _TooltipBehavior<D>(this);

  @override
  void updateCommonBehavior(common.ChartBehavior commonBehavior) {
    (commonBehavior as _TooltipBehavior<D>).config = this;
  }

  @override
  String get role => 'ChartTooltip-$selectionModelType';

  @override
  bool operator ==(Object other) =>
      other is ChartTooltip<D> &&
      activationMode == other.activationMode &&
      persistence == other.persistence &&
      grouping == other.grouping &&
      builder == other.builder &&
      showTrackballLine == other.showTrackballLine &&
      trackballLineStyle == other.trackballLineStyle &&
      maxWidth == other.maxWidth &&
      margin == other.margin &&
      offset == other.offset &&
      animationDuration == other.animationDuration &&
      selectionModelType == other.selectionModelType;

  @override
  int get hashCode => Object.hash(
    activationMode,
    persistence,
    grouping,
    builder,
    showTrackballLine,
    trackballLineStyle,
    maxWidth,
    margin,
    offset,
    animationDuration,
    selectionModelType,
  );
}

@immutable
class ChartTrackball<D> extends ChartTooltip<D> {
  ChartTrackball({
    super.activationMode = ChartTooltipActivationMode.longPressAndHover,
    super.persistence = ChartTooltipPersistence.tap,
    super.grouping = ChartTooltipGrouping.byDomain,
    super.builder,
    super.trackballLineStyle,
    super.maxWidth,
    super.margin,
    super.offset,
    super.animationDuration,
    super.selectionModelType,
  }) : super(showTrackballLine: true);

  factory ChartTrackball.enabled({
    ChartTooltipBuilder<D>? builder,
    ChartTooltipPersistence persistence = ChartTooltipPersistence.tap,
  }) => ChartTrackball<D>(builder: builder, persistence: persistence);
}

enum ChartTooltipActivationMode {
  tap,
  longPress,
  hover,
  tapAndHover,
  longPressAndHover,
  all,
}

enum ChartTooltipPersistence { none, tap, longPress, tapOrLongPress }

enum ChartTooltipGrouping { nearest, byDomain }

@immutable
class ChartTrackballLineStyle {
  const ChartTrackballLineStyle({
    this.color = const common.Color(r: 117, g: 117, b: 117),
    this.width = 1,
  });

  final common.Color color;
  final double width;

  @override
  bool operator ==(Object other) =>
      other is ChartTrackballLineStyle &&
      color == other.color &&
      width == other.width;

  @override
  int get hashCode => Object.hash(color, width);
}

class ChartTooltipDetails<D> {
  const ChartTooltipDetails({
    required this.anchor,
    required this.points,
    required this.locked,
  });

  final Point<double> anchor;
  final List<ChartTooltipDatum<D>> points;
  final bool locked;

  D? get domain => points.isEmpty ? null : points.first.domain;
  String get formattedDomain =>
      points.isEmpty ? '' : points.first.formattedDomain;
}

class ChartTooltipDatum<D> {
  ChartTooltipDatum(this.detail);

  final common.DatumDetails<D> detail;

  dynamic get datum => detail.datum;
  int? get index => detail.index;
  D? get domain => detail.domain;
  num? get measure => detail.measure;
  String get formattedDomain => detail.formattedDomain;
  String get formattedMeasure => detail.formattedMeasure;
  String get seriesId => detail.series?.id ?? '';
  String get seriesName => detail.series?.displayName ?? seriesId;
  common.Color? get color => detail.color;
}

class _TooltipBehavior<D> extends common.ChartBehavior<D>
    implements BuildableBehavior, ChartStateBehavior {
  _TooltipBehavior(this.config);

  ChartTooltip<D> config;

  common.BaseChart<D>? _chart;
  ChartState? _chartState;
  common.GestureListener? _listener;
  ChartTooltipDetails<D>? _details;
  bool _locked = false;

  @override
  set chartState(BaseChartState chartState) {
    _chartState = chartState;
  }

  @override
  void attachTo(common.BaseChart<D> chart) {
    _chart = chart;
    _listener = common.GestureListener(
      onTapTest: _onTapTest,
      onTap: _onTap,
      onLongPress: _onLongPress,
      onHover: _onHover,
    );
    chart.addGestureListener(_listener!);

    if (_listensForTap) {
      chart.registerTappable(this);
    }
  }

  @override
  void removeFrom(common.BaseChart<D> chart) {
    if (_listener != null) {
      chart.removeGestureListener(_listener!);
    }
    chart.unregisterTappable(this);
    _chart = null;
    _details = null;
  }

  bool get _listensForTap =>
      config.activationMode == ChartTooltipActivationMode.tap ||
      config.activationMode == ChartTooltipActivationMode.tapAndHover ||
      config.activationMode == ChartTooltipActivationMode.all ||
      _tapLocks;

  bool get _listensForLongPress =>
      config.activationMode == ChartTooltipActivationMode.longPress ||
      config.activationMode == ChartTooltipActivationMode.longPressAndHover ||
      config.activationMode == ChartTooltipActivationMode.all ||
      _longPressLocks;

  bool get _listensForHover =>
      config.activationMode == ChartTooltipActivationMode.hover ||
      config.activationMode == ChartTooltipActivationMode.tapAndHover ||
      config.activationMode == ChartTooltipActivationMode.longPressAndHover ||
      config.activationMode == ChartTooltipActivationMode.all;

  bool get _tapLocks =>
      config.persistence == ChartTooltipPersistence.tap ||
      config.persistence == ChartTooltipPersistence.tapOrLongPress;

  bool get _longPressLocks =>
      config.persistence == ChartTooltipPersistence.longPress ||
      config.persistence == ChartTooltipPersistence.tapOrLongPress;

  bool _onTapTest(Point<double> chartPoint) =>
      _chart?.pointWithinRenderer(chartPoint) ?? false;

  bool _onTap(Point<double> chartPoint) {
    if (!_listensForTap && !_tapLocks) {
      return false;
    }
    if (_locked && _tapLocks) {
      _hide(unlock: true);
      return true;
    }
    return _showAt(chartPoint, locked: _tapLocks);
  }

  bool _onLongPress(Point<double> chartPoint) {
    if (!_listensForLongPress && !_longPressLocks) {
      return false;
    }
    return _showAt(chartPoint, locked: _longPressLocks);
  }

  bool _onHover(Point<double> chartPoint) {
    if (!_listensForHover || _locked) {
      return false;
    }
    return _showAt(chartPoint, locked: false);
  }

  bool _showAt(Point<double> chartPoint, {required bool locked}) {
    final details = _buildDetails(chartPoint, locked: locked);
    if (details == null) {
      if (!locked) {
        _hide();
      }
      return false;
    }

    _details = details;
    _locked = locked;
    _chartState?.requestRebuild();
    return true;
  }

  void _hide({bool unlock = false}) {
    if (unlock) {
      _locked = false;
    }
    if (_details == null) {
      return;
    }
    _details = null;
    _chartState?.requestRebuild();
  }

  ChartTooltipDetails<D>? _buildDetails(
    Point<double> chartPoint, {
    required bool locked,
  }) {
    final chart = _chart;
    if (chart == null) {
      return null;
    }

    final nearest = chart.getNearestDatumDetailPerSeries(chartPoint, true);
    if (nearest.isEmpty) {
      return null;
    }

    nearest.removeWhere((detail) => detail.series?.overlaySeries ?? false);
    if (nearest.isEmpty) {
      return null;
    }

    nearest.sort((a, b) {
      final domain = (a.domainDistance ?? 0).compareTo(b.domainDistance ?? 0);
      return domain == 0
          ? (a.measureDistance ?? 0).compareTo(b.measureDistance ?? 0)
          : domain;
    });

    final selected = config.grouping == ChartTooltipGrouping.nearest
        ? [nearest.first]
        : nearest
              .where((detail) => detail.domain == nearest.first.domain)
              .toList();

    final anchor = nearest.first.chartPosition;
    return ChartTooltipDetails<D>(
      anchor: Point<double>(
        anchor?.x?.toDouble() ?? chartPoint.x,
        anchor?.y?.toDouble() ?? chartPoint.y,
      ),
      points: selected.map(ChartTooltipDatum<D>.new).toList(),
      locked: locked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = _details;
    final visible = details != null && details.points.isNotEmpty;

    return IgnorePointer(
      child: Stack(
        children: [
          if (visible && config.showTrackballLine)
            Positioned(
              left: details.anchor.x - (config.trackballLineStyle.width / 2),
              top: 0,
              bottom: 0,
              child: Container(
                width: config.trackballLineStyle.width,
                color: ColorUtil.toDartColor(config.trackballLineStyle.color),
              ),
            ),
          AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: config.animationDuration,
            curve: Curves.easeOutCubic,
            child: AnimatedScale(
              scale: visible ? 1 : 0.96,
              duration: config.animationDuration,
              curve: Curves.easeOutCubic,
              alignment: const _AnchorAlignment(),
              child: visible
                  ? CustomSingleChildLayout(
                      delegate: _TooltipLayoutDelegate(
                        anchor: details.anchor,
                        margin: config.margin,
                        offset: config.offset,
                      ),
                      child: SizedBox(
                        width: config.maxWidth,
                        child:
                            config.builder?.call(context, details) ??
                            _DefaultTooltip(details: details),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  common.BehaviorPosition get position => common.BehaviorPosition.inside;

  @override
  common.OutsideJustification get outsideJustification =>
      common.OutsideJustification.start;

  @override
  common.InsideJustification get insideJustification =>
      common.InsideJustification.topStart;

  @override
  Rectangle<int>? get drawAreaBounds => _chart?.drawAreaBounds;

  @override
  String get role => config.role;
}

class _DefaultTooltip<D> extends StatelessWidget {
  const _DefaultTooltip({required this.details, Key? key}) : super(key: key);

  final ChartTooltipDetails<D> details;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.black87,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details.formattedDomain,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            for (final point in details.points)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    color: point.color == null
                        ? Colors.white
                        : ColorUtil.toDartColor(point.color!),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${point.seriesName}: ${point.formattedMeasure}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _TooltipLayoutDelegate extends SingleChildLayoutDelegate {
  _TooltipLayoutDelegate({
    required this.anchor,
    required this.margin,
    required this.offset,
  });

  final Point<double> anchor;
  final EdgeInsets margin;
  final Point<double> offset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth - margin.horizontal;
    final maxHeight = constraints.maxHeight - margin.vertical;
    return BoxConstraints(
      maxWidth: maxWidth < 0 ? 0 : maxWidth,
      maxHeight: maxHeight < 0 ? 0 : maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var x = anchor.x + offset.x;
    var y = anchor.y + offset.y;

    if (x + childSize.width + margin.right > size.width) {
      x = anchor.x - childSize.width - offset.x;
    }
    if (y + childSize.height + margin.bottom > size.height) {
      y = anchor.y - childSize.height - offset.y;
    }

    x = x.clamp(margin.left, size.width - childSize.width - margin.right);
    y = y.clamp(margin.top, size.height - childSize.height - margin.bottom);

    return Offset(x.toDouble(), y.toDouble());
  }

  @override
  bool shouldRelayout(_TooltipLayoutDelegate oldDelegate) =>
      anchor != oldDelegate.anchor ||
      margin != oldDelegate.margin ||
      offset != oldDelegate.offset;
}

class _AnchorAlignment extends Alignment {
  const _AnchorAlignment() : super(-1, -1);
}
