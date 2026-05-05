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

/// Timeseries chart with the Flutter-first tooltip and trackball API.
///
/// The example imports `charts.dart` directly so common chart widgets and
/// interactions are available without a package alias.
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END

import 'package:charts_flutter/charts.dart' hide Color;
import 'package:flutter/material.dart';

class TooltipTrackball extends StatelessWidget {
  final List<Series<TimeSeriesSales, DateTime>> seriesList;
  final bool animate;

  TooltipTrackball(this.seriesList, {this.animate = false});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TooltipTrackball.withSampleData() {
    return TooltipTrackball(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory TooltipTrackball.withRandomData() {
    return TooltipTrackball(_createRandomData());
  }

  /// Create random data.
  static List<Series<TimeSeriesSales, DateTime>> _createRandomData() {
    final random = Random();

    final desktopData = [
      TimeSeriesSales(DateTime(2017, 9, 19), random.nextInt(45) + 35),
      TimeSeriesSales(DateTime(2017, 9, 26), random.nextInt(45) + 35),
      TimeSeriesSales(DateTime(2017, 10, 3), random.nextInt(45) + 35),
      TimeSeriesSales(DateTime(2017, 10, 10), random.nextInt(45) + 35),
      TimeSeriesSales(DateTime(2017, 10, 17), random.nextInt(45) + 35),
    ];

    final mobileData = [
      TimeSeriesSales(DateTime(2017, 9, 19), random.nextInt(35) + 20),
      TimeSeriesSales(DateTime(2017, 9, 26), random.nextInt(35) + 20),
      TimeSeriesSales(DateTime(2017, 10, 3), random.nextInt(35) + 20),
      TimeSeriesSales(DateTime(2017, 10, 10), random.nextInt(35) + 20),
      TimeSeriesSales(DateTime(2017, 10, 17), random.nextInt(35) + 20),
    ];

    return _series(desktopData, mobileData);
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return TimeSeriesChart(
      seriesList,
      animate: animate,
      interactions: ChartInteractions<DateTime>.trackball(
        trackball: ChartTrackball<DateTime>(
          activationMode: ChartTooltipActivationMode.longPressAndHover,
          persistence: ChartTooltipPersistence.tap,
          builder: (context, details) {
            return _SalesTooltip(details: details);
          },
        ),
      ),
    );
  }

  /// Create two series with sample hard coded data.
  static List<Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final desktopData = [
      TimeSeriesSales(DateTime(2017, 9, 19), 72),
      TimeSeriesSales(DateTime(2017, 9, 26), 68),
      TimeSeriesSales(DateTime(2017, 10, 3), 84),
      TimeSeriesSales(DateTime(2017, 10, 10), 76),
      TimeSeriesSales(DateTime(2017, 10, 17), 91),
    ];

    final mobileData = [
      TimeSeriesSales(DateTime(2017, 9, 19), 38),
      TimeSeriesSales(DateTime(2017, 9, 26), 49),
      TimeSeriesSales(DateTime(2017, 10, 3), 45),
      TimeSeriesSales(DateTime(2017, 10, 10), 58),
      TimeSeriesSales(DateTime(2017, 10, 17), 64),
    ];

    return _series(desktopData, mobileData);
  }

  static List<Series<TimeSeriesSales, DateTime>> _series(
    List<TimeSeriesSales> desktopData,
    List<TimeSeriesSales> mobileData,
  ) {
    return [
      Series<TimeSeriesSales, DateTime>(
        id: 'Desktop',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: desktopData,
      ),
      Series<TimeSeriesSales, DateTime>(
        id: 'Mobile',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: mobileData,
      ),
    ];
  }
}

class _SalesTooltip extends StatelessWidget {
  final ChartTooltipDetails<DateTime> details;

  const _SalesTooltip({required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(6),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details.formattedDomain,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            for (final point in details.points)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SeriesDot(seriesName: point.seriesName),
                    const SizedBox(width: 8),
                    Text(point.seriesName, style: theme.textTheme.bodySmall),
                    const SizedBox(width: 16),
                    Text(
                      point.formattedMeasure,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            if (details.locked)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Tap chart to unlock',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SeriesDot extends StatelessWidget {
  final String seriesName;

  const _SeriesDot({required this.seriesName});

  @override
  Widget build(BuildContext context) {
    final color = seriesName == 'Desktop'
        ? Colors.blue.shade700
        : Colors.deepOrange.shade500;

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
