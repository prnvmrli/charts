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

/// Clean Flutter-first public API for charts.
///
/// Import this library when you want the polished chart widget API without
/// aliasing the package:
///
/// ```dart
/// import 'package:charts_flutter/charts.dart';
///
/// TimeSeriesChart(
///   seriesList,
///   interactions: ChartInteractions.trackball(),
/// )
/// ```
library charts;

export 'flutter.dart'
    show
        AutoDateTimeTickFormatterSpec,
        AutoDateTimeTickProviderSpec,
        AxisSpec,
        BarChart,
        BarGroupingType,
        BarLabelAnchor,
        BarLabelDecorator,
        BarLabelPosition,
        BarRendererConfig,
        BasicDateTimeTickFormatterSpec,
        BasicNumericTickFormatterSpec,
        BasicNumericTickProviderSpec,
        BasicOrdinalTickFormatterSpec,
        BasicOrdinalTickProviderSpec,
        ChartInteractions,
        ChartTooltip,
        ChartTooltipActivationMode,
        ChartTooltipBuilder,
        ChartTooltipDatum,
        ChartTooltipDetails,
        ChartTooltipGrouping,
        ChartTooltipPersistence,
        ChartTrackball,
        ChartTrackballLineStyle,
        Color,
        DateTimeAxisSpec,
        DateTimeEndPointsTickProviderSpec,
        DateTimeExtents,
        DateTimeFactory,
        DomainFormatter,
        FillPatternType,
        GridlineRendererSpec,
        LayoutConfig,
        LineChart,
        LineRendererConfig,
        LineStyleSpec,
        LocalDateTimeFactory,
        MarginSpec,
        MeasureFormatter,
        NoneRenderSpec,
        NumericAxisSpec,
        NumericComboChart,
        NumericEndPointsTickProviderSpec,
        NumericExtents,
        OrdinalAxisSpec,
        OrdinalComboChart,
        OrdinalViewport,
        PanAndZoomBehavior,
        PanBehavior,
        PieChart,
        PointRendererConfig,
        RangeAnnotation,
        RangeAnnotationAxisType,
        RangeAnnotationSegment,
        ScatterPlotChart,
        SelectionModel,
        SelectionModelConfig,
        SelectionModelListener,
        SelectionModelType,
        SelectionTrigger,
        Series,
        SeriesDatum,
        SeriesDatumConfig,
        SeriesLegend,
        SeriesRendererConfig,
        StaticDateTimeTickProviderSpec,
        StaticNumericTickProviderSpec,
        StaticOrdinalTickProviderSpec,
        TextStyleSpec,
        TickLabelAnchor,
        TickLabelJustification,
        TickSpec,
        TimeFormatterSpec,
        TimeSeriesChart,
        TypedAccessorFn,
        UTCDateTimeFactory,
        UserManagedSelectionModel,
        UserManagedState,
        measureAxisIdKey,
        rendererIdKey;
