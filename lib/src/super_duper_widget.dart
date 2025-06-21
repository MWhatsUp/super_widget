import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui show TextHeightBehavior;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _SuperWidget extends StatelessWidget {
  const _SuperWidget({
    super.key,
    required this.child,
    required this.children,
    required this.direction,
    required this.horizontalAlign,
    required this.verticalAlign,
    required this.isFlexible,
    required this.isExpanded,
    required this.doNotExpand,
    required this.fillWidth,
    required this.fillHeight,
    required this.aspectRatio,
    required this.inverseAspectRatio,
    required this.clipBehaviour,
    required this.width,
    required this.height,
    required this.position,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.margin,
    required this.marginLeft,
    required this.marginRight,
    required this.marginTop,
    required this.marginBottom,
    required this.padding,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.border,
    required this.borderLeft,
    required this.borderTop,
    required this.borderRight,
    required this.borderBottom,
    required this.radius,
    required this.radiusTopLeft,
    required this.radiusTopRight,
    required this.radiusBottomRight,
    required this.radiusBottomLeft,
    required this.background,
    required this.isScrollable,
    required this.scrollController,
    required this.scale,
    required this.scaleX,
    required this.scaleY,
    required this.rotation,
    required this.flipX,
    required this.flipY,
    required this.isCentered,
    required this.opacity,
    required this.splashColor,
    required this.applyIntrinsicHeight,
    required this.heroTag,
    required this.onTap,
  });

  final Widget? child;
  final List<Widget> children;
  final $Direction direction;
  final $Align horizontalAlign;
  final $Align verticalAlign;
  final bool isFlexible;
  final bool isExpanded;
  final bool doNotExpand;
  final bool fillWidth;
  final bool fillHeight;
  final Size? aspectRatio;
  final Size? inverseAspectRatio;
  final Clip? clipBehaviour;
  final double? width;
  final double? height;
  final List<double> position;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final List<double> margin;
  final double? marginLeft;
  final double? marginRight;
  final double? marginTop;
  final double? marginBottom;
  final List<double> padding;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTop;
  final double? paddingBottom;
  final List<Object> border;
  final List<Object> borderLeft;
  final List<Object> borderTop;
  final List<Object> borderRight;
  final List<Object> borderBottom;
  final List<double> radius;
  final double? radiusTopLeft;
  final double? radiusTopRight;
  final double? radiusBottomRight;
  final double? radiusBottomLeft;
  final Color? background;
  final bool isScrollable;
  final ScrollController? scrollController;
  final List<double> scale;
  final double? scaleX;
  final double? scaleY;
  final double? rotation;
  final bool? flipX;
  final bool? flipY;
  final bool isCentered;
  final double? opacity;
  final Color? splashColor;
  final bool applyIntrinsicHeight;
  final String? heroTag;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? heroApplied = child;
    if (child != null && heroTag != null) {
      heroApplied = Hero(
        tag: heroTag!,
        child: Material(
            color: Colors.transparent,
            child: child!
        ),
      );
    }

    Widget positionedChild = heroApplied != null
        ? positionChild(heroApplied)
        : positionChildren(children);

    /* Apply container properties (width, height, margin...) */
    Widget container = positionedChild;

    // Padding
    EdgeInsetsGeometry? widgetPadding;

    if (padding.isNotEmpty || paddingLeft != null || paddingTop != null ||
        paddingRight != null || paddingBottom != null) {
      List<double?> widths = [null, null, null, null];
      int paddingLength = min(4, padding.length);

      for (int i = 0; i < paddingLength; i++) {
        widths[i] = padding[i];
      }

      // Apply auto fills
      for (int i = 0; i < 4; i++) {
        if (widths[i] == null) {
          var autofillSource = max(i - 2, 0);
          widths[i] = widths[autofillSource] ?? 0;
        }
      }

      // Overwrite widths if specifically provided
      widths[0] = paddingLeft ?? widths[0];
      widths[1] = paddingTop ?? widths[1];
      widths[2] = paddingRight ?? widths[2];
      widths[3] = paddingBottom ?? widths[3];

      // Apply values to padding
      widgetPadding =
          EdgeInsets.fromLTRB(widths[0]!, widths[1]!, widths[2]!, widths[3]!);
    }

    // Margin
    EdgeInsetsGeometry? appliedMargin;

    if (margin.isNotEmpty || marginLeft != null || marginTop != null ||
        marginRight != null || marginBottom != null) {
      List<double?> widths = [null, null, null, null];
      int marginLength = min(4, margin.length);

      for (int i = 0; i < marginLength; i++) {
        widths[i] = margin[i];
      }

      // Apply auto fills
      for (int i = 0; i < 4; i++) {
        if (widths[i] == null) {
          var autofillSource = max(i - 2, 0);
          widths[i] = widths[autofillSource] ?? 0;
        }
      }

      // Overwrite widths if specifically provided
      widths[0] = marginLeft ?? widths[0];
      widths[1] = marginTop ?? widths[1];
      widths[2] = marginRight ?? widths[2];
      widths[3] = marginBottom ?? widths[3];

      // Apply values to margin
      appliedMargin =
          EdgeInsets.fromLTRB(widths[0]!, widths[1]!, widths[2]!, widths[3]!);
    }

    // Border
    Border? widgetBorder;

    if (border.isNotEmpty || borderLeft.isNotEmpty || borderTop.isNotEmpty ||
        borderRight.isNotEmpty || borderBottom.isNotEmpty) {
      // Split width and color values into two separate arrays
      List<double?> widths = [null, null, null, null];
      List<Color?> colors = [null, null, null, null];
      int rectangleSide = 0;

      for (int i = 0; i < border.length; i++) {
        assert(border[i] is num || border[i] is Color,
        "border value is incorrect type");

        if (rectangleSide > 3) {
          break;
        }

        var item = border[i];
        var nextItem = (i + 1) < border.length ? border[i + 1] : null;

        if (item is num) {
          widths[rectangleSide] = item * 1.0;

          if (nextItem is! Color) {
            rectangleSide++;
          }
        } else if (item is Color) {
          colors[rectangleSide] = item;
          rectangleSide++;
        }
      }

      // Apply defaults and auto fills
      for (int i = 0; i < 4; i++) {
        if (widths[i] != null && colors[i] != null) {
          continue;
        } else if (widths[i] != null && widths[i]! > 0) {
          colors[i] = Colors.black;
        } else if (colors[i] != null) {
          widths[i] = 1;
        } else {
          var autofillSource = max(i - 2, 0);
          widths[i] = widths[autofillSource];
          colors[i] = colors[autofillSource];
        }
      }

      // Overwrite widths and colors if specifically provided
      if (borderLeft.isNotEmpty) {
        int length = min(2, borderLeft.length);

        for (int i = 0; i < length; i++) {
          assert(borderLeft[i] is num || borderLeft[i] is Color,
          "borderLeft provided is incorrect type");

          var item = borderLeft[i];

          if (item is Color) {
            colors[0] = item;
            widths[0] = widths[0] ?? 1;
          } else if (item is num) {
            widths[0] = item * 1.0;
            colors[0] = colors[0] ?? Colors.black;
          }
        }
      }

      if (borderTop.isNotEmpty) {
        int length = min(2, borderTop.length);

        for (int i = 0; i < length; i++) {
          assert(borderTop[i] is num || borderTop[i] is Color,
          "borderTop provided is incorrect type");

          var item = borderTop[i];

          if (item is Color) {
            colors[1] = item;
            widths[1] = widths[1] ?? 1;
          } else if (item is num) {
            widths[1] = item * 1.0;
            colors[1] = colors[1] ?? Colors.black;
          }
        }
      }

      if (borderRight.isNotEmpty) {
        int length = min(2, borderRight.length);

        for (int i = 0; i < length; i++) {
          assert(borderRight[i] is num || borderRight[i] is Color,
          "borderRight provided is incorrect type");

          var item = borderRight[i];

          if (item is Color) {
            colors[2] = item;
            widths[2] = widths[2] ?? 1;
          } else if (item is num) {
            widths[2] = item * 1.0;
            colors[2] = colors[2] ?? Colors.black;
          }
        }
      }

      if (borderBottom.isNotEmpty) {
        int length = min(2, borderBottom.length);

        for (int i = 0; i < length; i++) {
          assert(borderBottom[i] is num || borderBottom[i] is Color,
          "borderBottom provided is incorrect type");

          var item = borderBottom[i];

          if (item is Color) {
            colors[3] = item;
            widths[3] = widths[3] ?? 1;
          } else if (item is num) {
            widths[3] = item * 1.0;
            colors[3] = colors[3] ?? Colors.black;
          }
        }
      }

      // Apply values to border widget
      widgetBorder = Border(
        left: BorderSide(
          width: widths[0] ?? 0,
          color: colors[0] ?? Colors.transparent,
        ),
        top: BorderSide(
          width: widths[1] ?? 0,
          color: colors[1] ?? Colors.transparent,
        ),
        right: BorderSide(
          width: widths[2] ?? 0,
          color: colors[2] ?? Colors.transparent,
        ),
        bottom: BorderSide(
          width: widths[3] ?? 0,
          color: colors[3] ?? Colors.transparent,
        ),
      );
    }

    // Border Radius
    BorderRadiusGeometry? borderRadius;

    if (radius.isNotEmpty || radiusTopLeft != null ||
        radiusTopRight != null || radiusBottomRight != null ||
        radiusBottomLeft != null) {
      List<double?> radiusValues = [null, null, null, null];
      int radiusLength = min(4, radius.length);

      for (int i = 0; i < radiusLength; i++) {
        radiusValues[i] = radius[i];
      }

      // Apply defaults and auto fills
      for (int i = 0; i < 4; i++) {
        if (radiusValues[i] == null) {
          var autofillSource = max(i - 2, 0);
          radiusValues[i] = radiusValues[autofillSource] ?? 0;
        }
      }

      // Overwrite radius values if specifically provided
      radiusValues[0] = radiusTopLeft ?? radiusValues[0];
      radiusValues[1] = radiusTopRight ?? radiusValues[1];
      radiusValues[2] = radiusBottomRight ?? radiusValues[2];
      radiusValues[3] = radiusBottomLeft ?? radiusValues[3];

      // Apply values to radius
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(radiusValues[0]!),
        topRight: Radius.circular(radiusValues[1]!),
        bottomRight: Radius.circular(radiusValues[2]!),
        bottomLeft: Radius.circular(radiusValues[3]!),
      );
    }

    /* Apply container properties */
    Widget applyContainer(Widget widget, {double? cWidth, double? cHeight}) =>
        Container(
          width: cWidth,
          height: cHeight,
          // If clickable, margin area inherits the ripple effect. To avoid that,
          //  we apply the margin after the Inkwell widget when clickable.
          margin: onTap == null ? appliedMargin : null,
          padding: widgetPadding,
          clipBehavior: clipBehaviour ?? Clip.none,
          decoration: BoxDecoration(
            // If clickable, color needs to be applied in material
            //  otherwise the ripple effect won't work
            color: onTap == null ? background : null,
            border: widgetBorder,
            borderRadius: borderRadius,
          ),
          child: widget,
        );

    bool isSizeNotChanged = aspectRatio == null
        && inverseAspectRatio == null
        && !fillWidth
        && !fillHeight;

    for (int i = 0; i < 1; i++) {
      if (isSizeNotChanged) {
        container = applyContainer(
          positionedChild,
          cWidth: width,
          cHeight: height,
        );
        break;
      }

      if (fillWidth || fillHeight) {
        container = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              applyContainer(
                positionedChild,
                cWidth: fillWidth ? constraints.maxWidth : null,
                cHeight: fillHeight ? constraints.maxHeight : null,
              ),
        );

        break;
      }

      double calcWidth(BoxConstraints constraints) =>
          min(
            inverseAspectRatio!.width,
            constraints.maxHeight *
                (inverseAspectRatio!.width / inverseAspectRatio!.height),
          );

      double calcHeight(BoxConstraints constraints) =>
          min(
            aspectRatio!.height,
            constraints.maxWidth *
                (aspectRatio!.height / aspectRatio!.width),
          );

      container = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            applyContainer(
              positionedChild,
              cWidth: inverseAspectRatio != null
                  ? calcWidth(constraints)
                  : null,
              cHeight: aspectRatio != null ? calcHeight(constraints) : null,
            ),
      );
    }

    /* If scrollable, Place into a scroll view */
    Widget scrollableView = container;

    if (isScrollable) {
      if (hasExpandingChildren) {
        // Without this, flutter has no height to go by and throws an error
        scrollableView = IntrinsicHeight(child: container);
      }

      scrollableView = SingleChildScrollView(
        controller: scrollController,
        child: scrollableView,
      );
    }

    /* If not already applied but requested, apply intrinsic height */
    Widget intrinsicHeightApplied = scrollableView;

    if (applyIntrinsicHeight && !(isScrollable && hasExpandingChildren)) {
      intrinsicHeightApplied = IntrinsicHeight(child: scrollableView);
    }

    /* Make Clickable */
    Widget clickableWidget = intrinsicHeightApplied;

    if (onTap != null) {
      clickableWidget = Container(
        margin: appliedMargin,
        child: Material(
          borderRadius: borderRadius,
          color: background,
          child: InkWell(
            splashColor: splashColor,
            customBorder: borderRadius != null
                ? RoundedRectangleBorder(borderRadius: borderRadius)
                : null,
            onTap: onTap,
            child: scrollableView,
          ),
        ),
      );
    }

    /* Apply opacity */
    Widget opacityWidget = clickableWidget;

    if (opacity != null) {
      opacityWidget = Opacity(
        opacity: opacity!,
        child: clickableWidget,
      );
    }

    /* Apply transforms */
    Widget transformedWidget = opacityWidget;

    // Scale
    if (scale.isNotEmpty || scaleX != null || scaleY != null) {
      List<double?> scales = [null, null];
      int scaleLength = min(2, scale.length);

      for (int i = 0; i < scaleLength; i++) {
        scales[i] = scale[i];
      }

      // Apply defaults and auto fills
      scales[0] = scales[0] ?? 1;
      scales[1] = scales[1] ?? scales[0];

      // Overwrite scales if specifically provided
      scales[0] = scaleX ?? scales[0];
      scales[1] = scaleY ?? scales[1];

      // Apply values to scale transform
      transformedWidget = Transform.scale(
        scaleX: scales[0],
        scaleY: scales[1],
        child: transformedWidget,
      );
    }

    // Rotation
    if (rotation != null) {
      transformedWidget = Transform.rotate(
        angle: (rotation! * pi) / 180,
        child: transformedWidget,
      );
    }

    // Flipping
    if (flipX != null || flipY != null) {
      transformedWidget = Transform.flip(
        flipX: flipX ?? false,
        flipY: flipY ?? false,
        child: transformedWidget,
      );
    }

    /* Apply centering */
    Widget centeredWidget = transformedWidget;

    if (isCentered) {
      centeredWidget = Center(child: transformedWidget);
    }

    return centeredWidget;
  }

  Widget positionChildren(List<Widget> children) {
    var childrenInfo = children
        .map((child) => _ChildInfo(child: child))
        .toList();

    _ColumnOrRow columnOrRow = _ColumnOrRow(
      direction: direction,
      horizontalAlign: horizontalAlign,
      verticalAlign: verticalAlign,
      children: const [],
    );

    /* Move non Stack children into column/row parent */
    bool isRegularChild(_ChildInfo child) =>
        child.doesNotBelongInsideStack && !child.isExpandingSuperWidget;

    bool isFlexibleSuperWidget(_ChildInfo child) =>
        child.doesNotBelongInsideStack && child.isExpandingSuperWidget
            && child.isSetFlexible && child.isNotSetExpanded;

    bool isExpandedSuperWidget(_ChildInfo child) =>
        child.doesNotBelongInsideStack && child.isExpandingSuperWidget
            && (child.isNotSetFlexible
            || (child.isSetFlexible && child.isSetExpanded));

    bool isNonStackChild(_ChildInfo child) =>
        isRegularChild(child)
            || isFlexibleSuperWidget(child)
            || isExpandedSuperWidget(child);

    columnOrRow = columnOrRow.addChildren([

      ...childrenInfo
          .where(isNonStackChild)
          .map((childInfo) {
        if (isFlexibleSuperWidget(childInfo)) {
          return Flexible(child: childInfo.child);
        }

        if (isExpandedSuperWidget(childInfo)) {
          return Expanded(child: childInfo.child);
        }

        return childInfo.child;
      }),

    ]);

    /* Create a stack widget and place children inside if any exist */
    bool hasStackChildren = children.length > columnOrRow.children.length;
    Widget stackWidget = columnOrRow;

    if (hasStackChildren) {
      var nonSuperWidgets = childrenInfo
          .where((child) => child.isTypePositioned)
          .map((childInfo) => childInfo.child)
          .toList();

      var positionedSuperWidgets = childrenInfo
          .where((child) =>
      child.isPositionedSuperWidget && !child.isExpandingSuperWidget)
          .map((childInfo) => (childInfo.child as _SuperWidget))
          .map((child) => child.syncPositionValues())
          .map((child) =>
          Positioned(
            left: child.left,
            top: child.top,
            right: child.right,
            bottom: child.bottom,
            child: child,
          ))
          .toList();

      var expandedSuperWidgets = childrenInfo
          .where((child) =>
      child.isExpandingSuperWidget && child.isPositionedSuperWidget)
          .map((childInfo) => (childInfo.child as _SuperWidget))
          .map((child) => child.syncPositionValues())
          .map((child) =>
          Positioned.fill(
            left: child.left,
            top: child.top,
            right: child.right,
            bottom: child.bottom,
            child: child,
          ))
          .toList();

      stackWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          columnOrRow,
          ...nonSuperWidgets,
          ...positionedSuperWidgets,
          ...expandedSuperWidgets,
        ],
      );
    }

    return stackWidget;
  }

  Widget positionChild(Widget child) {
    var childInfo = _ChildInfo(child: child);

    if (childInfo.isNotSpatialWidgetType) {
      return child;
    }

    if (childInfo.isTypeExpandedOrFlexible) {
      return _ColumnOrRow(
        direction: direction,
        horizontalAlign: horizontalAlign,
        verticalAlign: verticalAlign,
        children: [child],
      );
    }

    if (childInfo.isTypePositioned) {
      return Stack(
        children: [child],
      );
    }

    var childSuperWidget = (child as _SuperWidget).syncPositionValues();

    if (childInfo.isExpandingSuperWidget && childInfo.isPositionedSuperWidget) {
      return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              left: childSuperWidget.left,
              top: childSuperWidget.top,
              right: childSuperWidget.right,
              bottom: childSuperWidget.bottom,
              child: childSuperWidget,
            ),
          ]
      );
    }

    if (childInfo.isPositionedSuperWidget) {
      return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: childSuperWidget.left,
              top: childSuperWidget.top,
              right: childSuperWidget.right,
              bottom: childSuperWidget.bottom,
              child: childSuperWidget,
            ),
          ]
      );
    }

    if (childInfo.isExpandingSuperWidget && childInfo.isSetFlexible &&
        childInfo.isNotSetExpanded) {
      return _ColumnOrRow(
        direction: direction,
        horizontalAlign: horizontalAlign,
        verticalAlign: verticalAlign,
        children: [
          Flexible(child: child),
        ],
      );
    }

    if (childInfo.isExpandingSuperWidget) {
      return _ColumnOrRow(
        direction: direction,
        horizontalAlign: horizontalAlign,
        verticalAlign: verticalAlign,
        children: [
          Expanded(child: child),
        ],
      );
    }

    return child;
  }

  _SuperWidget syncPositionValues() {
    return _SuperWidget(
      child: child,
      children: children,
      direction: direction,
      horizontalAlign: horizontalAlign,
      verticalAlign: verticalAlign,
      isFlexible: isFlexible,
      isExpanded: isExpanded,
      doNotExpand: doNotExpand,
      fillWidth: fillWidth,
      fillHeight: fillHeight,
      aspectRatio: aspectRatio,
      inverseAspectRatio: inverseAspectRatio,
      clipBehaviour: clipBehaviour,
      width: width,
      height: height,
      position: position,
      margin: margin,
      marginLeft: marginLeft,
      marginTop: marginTop,
      marginRight: marginRight,
      marginBottom: marginBottom,
      padding: padding,
      paddingLeft: paddingLeft,
      paddingTop: paddingTop,
      paddingRight: paddingRight,
      paddingBottom: paddingBottom,
      border: border,
      borderLeft: borderLeft,
      borderTop: borderTop,
      borderRight: borderRight,
      borderBottom: borderBottom,
      radius: radius,
      radiusTopLeft: radiusTopLeft,
      radiusTopRight: radiusTopRight,
      radiusBottomRight: radiusBottomRight,
      radiusBottomLeft: radiusBottomLeft,
      background: background,
      isScrollable: isScrollable,
      scrollController: scrollController,
      scale: scale,
      scaleX: scaleX,
      scaleY: scaleY,
      rotation: rotation,
      flipX: flipX,
      flipY: flipY,
      isCentered: isCentered,
      opacity: opacity,
      splashColor: splashColor,
      applyIntrinsicHeight: applyIntrinsicHeight,
      heroTag: heroTag,
      onTap: onTap,

      left: position.isNotEmpty && left == null ? position[0] : left,
      top: position.length > 1 && top == null ? position[1] : top,
      right: position.length > 2 && right == null ? position[2] : right,
      bottom: position.length > 3 && bottom == null ? position[3] : bottom,
    );
  }

  bool get hasExpandingChildren {
    if (child is Expanded) {
      return true;
    }

    if (child is Flexible) {
      return true;
    }

    if (isExpandingSuperWidget(child)) {
      return true;
    }

    var expandedChildren = children.where((child) {
      if (child is Expanded) {
        return true;
      }

      if (child is Flexible) {
        return true;
      }

      if (isExpandingSuperWidget(child)) {
        return true;
      }

      return false;
    }).toList();

    if (expandedChildren.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool isExpandingSuperWidget(Widget? widget) {
    if (widget is! _SuperWidget) {
      return false;
    }

    if (widget.doNotExpand) {
      return false;
    }

    if (widget.isExpanded) {
      return true;
    }

    if (widget.isFlexible) {
      return true;
    }

    if (widget.hasExpandingChildren) {
      return true;
    }

    return false;
  }

  static BorderRadius setRadius({
    BorderRadius? decorationRadius,
    List<double> radius = const [],
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomRight,
    double? radiusBottomLeft,
  }) {
    if (decorationRadius != null) {
      return decorationRadius;
    }

    bool noRadiusProvided = radius.isEmpty
        && radiusTopLeft == null
        && radiusTopRight == null
        && radiusBottomRight == null
        && radiusBottomLeft == null;

    if (noRadiusProvided) {
      return const BorderRadius.all(Radius.circular(4.0));
    }

    // Extract values of custom radius
    List<double?> radiusValues = [null, null, null, null];
    int radiusLength = min(4, radius.length);

    for (int i = 0; i < radiusLength; i++) {
      radiusValues[i] = radius[i];
    }

    // Apply defaults and auto fills
    for (int i = 0; i < 4; i++) {
      if (radiusValues[i] == null) {
        var autofillSource = max(i - 2, 0);
        radiusValues[i] = radiusValues[autofillSource] ?? 0;
      }
    }

    // Overwrite radius values if specifically provided
    radiusValues[0] = radiusTopLeft ?? radiusValues[0];
    radiusValues[1] = radiusTopRight ?? radiusValues[1];
    radiusValues[2] = radiusBottomRight ?? radiusValues[2];
    radiusValues[3] = radiusBottomLeft ?? radiusValues[3];

    // Apply values to radius
    BorderRadius borderRadius = BorderRadius.only(
      topLeft: Radius.circular(radiusValues[0]! - 2),
      topRight: Radius.circular(radiusValues[1]! - 2),
      bottomRight: Radius.circular(radiusValues[2]! - 2),
      bottomLeft: Radius.circular(radiusValues[3]! - 2),
    );

    return borderRadius;
  }


  static EdgeInsetsGeometry? setPadding({
    EdgeInsetsGeometry? decorationPadding,
    List<double> padding = const [],
    double? paddingLeft,
    double? paddingRight,
    double? paddingTop,
    double? paddingBottom,
  }) {
    if (decorationPadding != null) {
      return decorationPadding;
    }

    bool noPaddingProvided = padding.isEmpty
        && paddingLeft == null
        && paddingTop == null
        && paddingRight == null
        && paddingBottom == null;

    if (noPaddingProvided) {
      return null;
    }

    // Extract values of custom padding
    List<double?> widths = [null, null, null, null];
    int paddingLength = min(4, padding.length);

    for (int i = 0; i < paddingLength; i++) {
      widths[i] = padding[i];
    }

    // Apply auto fills
    for (int i = 0; i < 4; i++) {
      if (widths[i] == null) {
        var autofillSource = max(i - 2, 0);
        widths[i] = widths[autofillSource] ?? 0;
      }
    }

    // Overwrite widths if specifically provided
    widths[0] = paddingLeft ?? widths[0];
    widths[1] = paddingTop ?? widths[1];
    widths[2] = paddingRight ?? widths[2];
    widths[3] = paddingBottom ?? widths[3];

    // Apply values to padding
    EdgeInsetsGeometry widgetPadding =
    EdgeInsets.fromLTRB(widths[0]!, widths[1]!, widths[2]!, widths[3]!);

    return widgetPadding;
  }
}

class _ColumnOrRow extends StatelessWidget {
  const _ColumnOrRow({
    required this.children,
    required this.direction,
    required this.horizontalAlign,
    required this.verticalAlign,
  });

  final List<Widget> children;
  final $Direction direction;
  final $Align horizontalAlign;
  final $Align verticalAlign;

  @override
  Widget build(BuildContext context) {
    return switch(direction) {
      $Direction.down =>
          Column(
            mainAxisAlignment: verticalAlign.toMainAxisAlignment(),
            crossAxisAlignment: horizontalAlign.toCrossAxisAlignment(),
            children: children,
          ),

      $Direction.up =>
          Column(
            mainAxisAlignment: verticalAlign.toMainAxisAlignment(),
            crossAxisAlignment: horizontalAlign.toCrossAxisAlignment(),
            verticalDirection: VerticalDirection.up,
            children: children,
          ),

      $Direction.right =>
          Row(
            mainAxisAlignment: horizontalAlign.toMainAxisAlignment(),
            crossAxisAlignment: verticalAlign.toCrossAxisAlignment(),
            children: children,
          ),

      $Direction.left =>
          Row(
            mainAxisAlignment: horizontalAlign.toMainAxisAlignment(),
            crossAxisAlignment: verticalAlign.toCrossAxisAlignment(),
            textDirection: TextDirection.rtl,
            children: children,
          ),
    };
  }

  _ColumnOrRow addChildren(List<Widget> children) {
    return _ColumnOrRow(
      direction: direction,
      horizontalAlign: horizontalAlign,
      verticalAlign: verticalAlign,
      children: children,
    );
  }
}

class _ChildInfo {
  _ChildInfo({
    required this.child,
  })
      :
        isSpatialWidgetType = _isSpatialWidgetType(child),
        isTypeExpandedOrFlexible = _isTypeExpandedOrFlexible(child),
        isTypePositioned = _isTypePositioned(child),
        isSetFlexible = _isSetFlexible(child),
        isSetExpanded = _isSetExpanded(child),
        isExpandingSuperWidget = _isExpandingSuperWidget(child),
        isPositionedSuperWidget = _isPositionedSuperWidget(child);

  final Widget child;
  final bool isSpatialWidgetType;
  final bool isTypeExpandedOrFlexible;
  final bool isTypePositioned;
  final bool isSetFlexible;
  final bool isSetExpanded;
  final bool isExpandingSuperWidget;
  final bool isPositionedSuperWidget;

  bool get isNotSpatialWidgetType => !isSpatialWidgetType;

  bool get isNotTypeExpandedOrFlexible => !isTypeExpandedOrFlexible;

  bool get isNotTypePositioned => !isTypePositioned;

  bool get isNotSetFlexible => !isSetFlexible;

  bool get isNotSetExpanded => !isSetExpanded;

  bool get isNotExpandingSuperWidget => !isExpandingSuperWidget;

  bool get isNotPositionedSuperWidget => !isPositionedSuperWidget;

  bool get doesBelongInsideStack =>
      isSpatialWidgetType && (isTypePositioned || isPositionedSuperWidget);

  bool get doesNotBelongInsideStack => !doesBelongInsideStack;

  static bool _isSpatialWidgetType(Widget widget) {
    return widget is _SuperWidget
        || widget is Expanded
        || widget is Flexible
        || widget is Positioned;
  }

  static bool _isTypeExpandedOrFlexible(Widget widget) {
    return widget is Expanded || widget is Flexible;
  }

  static bool _isTypePositioned(Widget widget) {
    return widget is Positioned;
  }

  static bool _isSetFlexible(Widget widget) {
    return widget is _SuperWidget && widget.isFlexible;
  }

  static bool _isSetExpanded(Widget widget) {
    return widget is _SuperWidget && widget.isExpanded;
  }

  static bool _isExpandingSuperWidget(Widget widget) {
    if (widget is! _SuperWidget) {
      return false;
    }

    if (widget.doNotExpand) {
      return false;
    }

    if (widget.isExpanded) {
      return true;
    }

    if (widget.isFlexible) {
      return true;
    }

    if (widget.hasExpandingChildren) {
      return true;
    }

    return false;
  }

  static bool _isPositionedSuperWidget(Widget widget) {
    if (widget is! _SuperWidget) {
      return false;
    }

    if (widget.position.isNotEmpty) {
      return true;
    }

    if (widget.left != null) {
      return true;
    }

    if (widget.right != null) {
      return true;
    }

    if (widget.top != null) {
      return true;
    }

    if (widget.bottom != null) {
      return true;
    }

    return false;
  }
}

class $Single extends _SuperWidget {
  const $Single(Widget child, {
    super.key,
    super.direction = $Direction.down,
    super.horizontalAlign = $Align.start,
    super.verticalAlign = $Align.start,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(child: child, children: const []);
}

class $Rect extends _SuperWidget {
  const $Rect({
    super.key,
    super.direction = $Direction.down,
    super.horizontalAlign = $Align.start,
    super.verticalAlign = $Align.start,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(child: const _Empty(), children: const []);
}

class $ extends _SuperWidget {
  const $(List<Widget> children, {
    super.key,
    super.direction = $Direction.down,
    super.horizontalAlign = $Align.start,
    super.verticalAlign = $Align.start,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(children: children, child: null);
}

class $List extends _SuperWidget {
  const $List(List<Widget> children, {
    super.key,
    super.direction = $Direction.down,
    super.horizontalAlign = $Align.start,
    super.verticalAlign = $Align.start,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(children: children, child: null);
}

class $Row extends _SuperWidget {
  const $Row(List<Widget> children, {
    super.key,
    $Direction direction = $Direction.right,
    super.horizontalAlign = $Align.start,
    super.verticalAlign = $Align.center,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: children,
    child: null,
    direction: direction == $Direction.right || direction == $Direction.down
        ? $Direction.right
        : $Direction.left,
  );
}

class $Page extends StatelessWidget {
  const $Page(this.body, {
    super.key,
    this.appBar,
    this.title,
    this.background,
    this.appBarColor,
    this.floatingButton,
    this.direction,
    this.horizontalAlign,
    this.verticalAlign,
    this.isCentered = false,
    this.isScrollable = false,
    this.expandContent = false,
  });

  final Widget? appBar;
  final String? title;
  final List<Widget> body;
  final Color? background;
  final Color? appBarColor;
  final Widget? floatingButton;
  final $Direction? direction;
  final $Align? horizontalAlign;
  final $Align? verticalAlign;
  final bool isCentered;
  final bool isScrollable;
  final bool expandContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appBar is AppBar
          ? appBar as AppBar
          : AppBar(
        backgroundColor: appBarColor ?? Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: appBar ?? Text(title ?? ""),
      ),
      body: body.length == 1
          ? $Single(
          direction: direction ?? $Direction.down,
          horizontalAlign: horizontalAlign ?? $Align.start,
          verticalAlign: verticalAlign ?? $Align.start,
          isCentered: isCentered,
          isScrollable: isScrollable,
          expandContent? Expanded(child: body[0]) : body[0]
      )
          : $List(
        direction: direction ?? $Direction.down,
        horizontalAlign: horizontalAlign ?? $Align.start,
        verticalAlign: verticalAlign ?? $Align.start,
        isCentered: isCentered,
        isScrollable: isScrollable,
        expandContent
            ? body.map((widget) => Expanded(child: widget)).toList()
            : body,
      ),
      floatingActionButton: floatingButton,
    );
  }
}

class $Form extends _SuperWidget {
  $Form(Widget child, {
    // Form Widget properties
    Key? formKey,
    bool? canPop,
    PopInvokedWithResultCallback<Object?>? onPopInvokedWithResult,
    VoidCallback? onChanged,
    AutovalidateMode? autovalidateMode,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    child: Form(
        key: formKey,
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        child: child
    ),
  );
}

class $Text extends _SuperWidget {
  $Text(String text, {
    // Text Widget properties
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,

    // Overwritten properties
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    String? package,
    TextLeadingDistribution? leadingDistribution,
    bool? inherit,
    double? textHeight,
    Paint? foreground,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
    TextDecoration? decoration,
    String? debugLabel,
    Paint? paintBackground,
    double? wordSpacing,
    double? letterSpacing,
    FontWeight? fontWeight,
    List<FontVariation>? fontVariations,
    List<String>? fontFamilyFallback,
    FontStyle? fontStyle,
    String? fontFamily,
    List<FontFeature>? fontFeatures,

    // New properties
    bool wrapText = false,
  }) : super(children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    child: _wrapTextWidget(
      wrapText: wrapText,
      Text(
          style: TextStyle(
            color: style?.color ?? color,
            backgroundColor: style?.backgroundColor ?? backgroundColor ??
                background,
            fontFamily: style?.fontFamily ?? fontFamily,
            fontFamilyFallback: style?.fontFamilyFallback ?? fontFamilyFallback,
            fontFeatures: style?.fontFeatures ?? fontFeatures,
            fontStyle: style?.fontStyle ?? fontStyle,
            fontSize: style?.fontSize ?? fontSize,
            fontVariations: style?.fontVariations ?? fontVariations,
            fontWeight: style?.fontWeight ?? fontWeight,
            letterSpacing: style?.letterSpacing ?? letterSpacing,
            locale: style?.locale ?? locale,
            overflow: style?.overflow ?? overflow,
            wordSpacing: style?.wordSpacing ?? wordSpacing,

            background: style?.background ?? paintBackground,
            debugLabel: style?.debugLabel,
            decoration: style?.decoration ?? decoration,
            decorationColor: style?.decorationColor,
            decorationStyle: style?.decorationStyle,
            decorationThickness: style?.decorationThickness,
            foreground: style?.foreground,
            height: style?.height ?? textHeight,
            inherit: style?.inherit ?? true,
            leadingDistribution: style?.leadingDistribution,
            package: package,
            shadows: style?.shadows,
            textBaseline: style?.textBaseline,
          ),
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
          text

      ),
    ),
  );

  static Widget _wrapTextWidget(Widget widget, {required bool wrapText}) {
    if (wrapText) {
      return Flexible(child: widget);
    }

    return widget;
  }
}

class $Icon extends _SuperWidget {
  $Icon(IconData icon, {
    // Icon Widget properties
    Color? color,
    bool? applyTextScaling,
    double? fill,
    TextDirection? textDirection,
    double? grade,
    double? opticalSize,
    String? semanticLabel,
    List<Shadow>? shadows,
    double? size,
    double? weight,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    child: Icon(
      color: color,
      applyTextScaling: applyTextScaling,
      fill: fill,
      textDirection: textDirection,
      grade: grade,
      opticalSize: opticalSize,
      semanticLabel: semanticLabel,
      shadows: shadows,
      size: size,
      weight: weight,
      icon,
    ),
  );
}

class $IconButton extends _SuperWidget {
  $IconButton(Icon icon, {
    // Icon Widget properties
    double? iconSize,
    VisualDensity? visualDensity,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Color? focusColor,
    Color? hoverColor,
    Color? color,
    Color? innerSplashColor,
    Color? highlightColor,
    Color? disabledColor,
    VoidCallback? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
    String? tooltip,
    bool? enableFeedback,
    BoxConstraints? constraints,
    ButtonStyle? style,
    bool? isSelected,
    Widget? selectedIcon,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,

    // Overwritten properties
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? styleFocusColor,
    Color? styleHoverColor,
    Color? styleHighlightColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? overlayColor,
    double? elevation,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    double? styleIconSize,
    BorderSide? side,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? stylePadding,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? styleVisualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? styleEnableFeedback,
    AlignmentGeometry? styleAlignment,
    InteractiveInkFeatureFactory? splashFactory,

    // New properties
    List<double> padding = const [],
    double? paddingLeft,
    double? paddingTop,
    double? paddingRight,
    double? paddingBottom,
    Color? background,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    padding: [],
    paddingLeft: null,
    paddingTop: null,
    paddingRight: null,
    paddingBottom: null,
    background: null,
    child: IconButton(
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: _SuperWidget.setPadding(
        padding: padding,
        paddingLeft: paddingLeft,
        paddingTop: paddingTop,
        paddingRight: paddingRight,
        paddingBottom: paddingBottom,
      ),
      alignment: alignment,
      splashRadius: splashRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      color: color,
      splashColor: innerSplashColor,
      highlightColor: highlightColor,
      disabledColor: disabledColor,
      onPressed: onPressed,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      constraints: constraints,
      style: style?? IconButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: background?? backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        focusColor: styleFocusColor,
        hoverColor: styleHoverColor,
        highlightColor: styleHighlightColor,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        overlayColor: overlayColor,
        elevation: elevation,
        minimumSize: minimumSize,
        fixedSize: fixedSize,
        maximumSize: maximumSize,
        iconSize: styleIconSize,
        side: side,
        shape: shape,
        padding: stylePadding,
        enabledMouseCursor: enabledMouseCursor,
        disabledMouseCursor: disabledMouseCursor,
        visualDensity: styleVisualDensity,
        tapTargetSize: tapTargetSize,
        animationDuration: animationDuration,
        enableFeedback: styleEnableFeedback,
        alignment: styleAlignment,
        splashFactory: splashFactory,
      ),
      isSelected: isSelected,
      selectedIcon: selectedIcon,
      icon: icon,
    ),
  );
}

class $Dialog extends _SuperWidget {
  $Dialog(Widget? child, {
    // Icon Widget properties
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Duration insetAnimationDuration = const Duration(milliseconds: 100),
    Curve insetAnimationCurve = Curves.decelerate,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    padding: [],
    paddingLeft: null,
    paddingTop: null,
    paddingRight: null,
    paddingBottom: null,
    background: null,
    child: Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      insetAnimationDuration: insetAnimationDuration,
      insetAnimationCurve: insetAnimationCurve,
      insetPadding: insetPadding,
      clipBehavior: clipBehavior,
      shape: shape,
      alignment: alignment,
      child: child,
    ),
  );
}

class $ImageAsset extends _SuperWidget {
  $ImageAsset(String name, {
    // Image.asset Widget properties
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool? excludeFromSemantics,
    double? imageScale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? animationOpacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    Alignment? alignment,
    ImageRepeat? repeat,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? isAntiAlias,
    String? package,
    FilterQuality? filterQuality,
    int? cacheWidth,
    int? cacheHeight,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    width: null,
    height: null,
    child: ClipRRect(
      borderRadius: _SuperWidget.setRadius(
        radius: radius,
        radiusTopLeft: radiusTopLeft,
        radiusTopRight: radiusTopRight,
        radiusBottomRight: radiusBottomRight,
        radiusBottomLeft: radiusBottomLeft,
      ),
      child: Image.asset(
          bundle: bundle,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics ?? false,
          scale: imageScale,
          width: width,
          height: height,
          color: color,
          opacity: animationOpacity,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment ?? Alignment.center,
          repeat: repeat ?? ImageRepeat.noRepeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection ?? false,
          gaplessPlayback: gaplessPlayback ?? false,
          isAntiAlias: isAntiAlias ?? false,
          package: package,
          filterQuality: filterQuality ?? FilterQuality.low,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          name
      ),
    ),
  );
}

class $ImageMemory extends _SuperWidget {
  $ImageMemory(Uint8List bytes, {
    // Image.memory Widget properties
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool? excludeFromSemantics,
    double? imageScale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? animationOpacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    Alignment? alignment,
    ImageRepeat? repeat,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? isAntiAlias,
    FilterQuality? filterQuality,
    int? cacheWidth,
    int? cacheHeight,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    width: null,
    height: null,
    child: ClipRRect(
      borderRadius: _SuperWidget.setRadius(
        radius: radius,
        radiusTopLeft: radiusTopLeft,
        radiusTopRight: radiusTopRight,
        radiusBottomRight: radiusBottomRight,
        radiusBottomLeft: radiusBottomLeft,
      ),
      child: Image.memory(
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics ?? false,
          scale: imageScale ?? 1.0,
          width: width,
          height: height,
          color: color,
          opacity: animationOpacity,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment ?? Alignment.center,
          repeat: repeat ?? ImageRepeat.noRepeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection ?? false,
          gaplessPlayback: gaplessPlayback ?? false,
          isAntiAlias: isAntiAlias ?? false,
          filterQuality: filterQuality ?? FilterQuality.low,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          bytes
      ),
    ),
  );
}

class $ImageFile extends _SuperWidget {
  $ImageFile(File file, {
    // Image.file Widget properties
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool? excludeFromSemantics,
    double? imageScale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? animationOpacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    Alignment? alignment,
    ImageRepeat? repeat,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? isAntiAlias,
    FilterQuality? filterQuality,
    int? cacheWidth,
    int? cacheHeight,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    width: null,
    height: null,
    child: ClipRRect(
      borderRadius: _SuperWidget.setRadius(
        radius: radius,
        radiusTopLeft: radiusTopLeft,
        radiusTopRight: radiusTopRight,
        radiusBottomRight: radiusBottomRight,
        radiusBottomLeft: radiusBottomLeft,
      ),
      child: Image.file(
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics ?? false,
          scale: imageScale ?? 1.0,
          width: width,
          height: height,
          color: color,
          opacity: animationOpacity,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment ?? Alignment.center,
          repeat: repeat ?? ImageRepeat.noRepeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection ?? false,
          gaplessPlayback: gaplessPlayback ?? false,
          isAntiAlias: isAntiAlias ?? false,
          filterQuality: filterQuality ?? FilterQuality.low,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          file
      ),
    ),
  );
}

class $ImageNetwork extends _SuperWidget {
  $ImageNetwork(String src, {
    // Image.network Widget properties
    ImageLoadingBuilder? loadingBuilder,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool? excludeFromSemantics,
    double? imageScale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? animationOpacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    Alignment? alignment,
    ImageRepeat? repeat,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? isAntiAlias,
    FilterQuality? filterQuality,
    int? cacheWidth,
    int? cacheHeight,
    Map<String, String>? headers,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    width: null,
    height: null,
    child: ClipRRect(
      borderRadius: _SuperWidget.setRadius(
        radius: radius,
        radiusTopLeft: radiusTopLeft,
        radiusTopRight: radiusTopRight,
        radiusBottomRight: radiusBottomRight,
        radiusBottomLeft: radiusBottomLeft,
      ),
      child: Image.network(
          loadingBuilder: loadingBuilder,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics ?? false,
          scale: imageScale ?? 1.0,
          width: width,
          height: height,
          color: color,
          opacity: animationOpacity,
          colorBlendMode: colorBlendMode,
          fit: fit,
          alignment: alignment ?? Alignment.center,
          repeat: repeat ?? ImageRepeat.noRepeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection ?? false,
          gaplessPlayback: gaplessPlayback ?? false,
          isAntiAlias: isAntiAlias ?? false,
          filterQuality: filterQuality ?? FilterQuality.low,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          headers: headers,
          src
      ),
    ),
  );
}

class $TextField extends _SuperWidget {
  $TextField({
    // TextField Widget properties
    TextStyle? style,
    TextDirection? textDirection,
    bool? onTapAlwaysCalled,
    bool? canRequestFocus,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    void Function()? onTap,
    TextEditingController? controller,
    bool? autocorrect,
    Iterable<String>? autofillHints,
    bool? autofocus,
    Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter,
    Clip? clipBehavior,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
    Color? cursorColor,
    Color? cursorErrorColor,
    double? cursorHeight,
    bool? cursorOpacityAnimates,
    Radius? cursorRadius,
    double? cursorWidth,
    DragStartBehavior? dragStartBehavior,
    bool? enabled,
    bool? enableIMEPersonalizedLearning,
    bool? enableInteractiveSelection,
    bool? enableSuggestions,
    bool? expands,
    bool? ignorePointers,
    List<TextInputFormatter>? inputFormatters,
    Brightness? keyboardAppearance,
    TextMagnifierConfiguration? magnifierConfiguration,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines,
    int? minLines,
    MouseCursor? mouseCursor,
    bool? obscureText,
    String? obscuringCharacter,
    void Function(String, Map<String, dynamic>)? onAppPrivateCommand,
    void Function(String)? onChanged,
    void Function()? onEditingComplete,
    void Function(String)? onSubmitted,
    void Function(PointerDownEvent)? onTapOutside,
    bool? readOnly,
    String? restorationId,
    bool? scribbleEnabled,
    ScrollController? scrollController,
    EdgeInsets? scrollPadding,
    ScrollPhysics? scrollPhysics,
    TextSelectionControls? selectionControls,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    bool? showCursor,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    SpellCheckConfiguration? spellCheckConfiguration,
    WidgetStatesController? statesController,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    UndoHistoryController? undoController,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    List<Object> border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.isScrollable = false,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.applyIntrinsicHeight = false,
    super.heroTag,

    // Overwritten properties
    Color? color,
    Color? background,
    double? fontSize,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    String? package,
    TextLeadingDistribution? leadingDistribution,
    bool? inherit,
    double? textHeight,
    Paint? foreground,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
    InputDecoration? decoration,
    String? debugLabel,
    Paint? paintBackground,
    double? wordSpacing,
    double? letterSpacing,
    FontWeight? fontWeight,
    List<FontVariation>? fontVariations,
    List<String>? fontFamilyFallback,
    FontStyle? fontStyle,
    String? fontFamily,
    List<FontFeature>? fontFeatures,

    Locale? locale,
    TextOverflow? overflow,

    bool? isDense,
    bool? isCollapsed,
    Color? hoverColor,
    String? hintText,
    Widget? helper,
    Color? focusColor,
    Widget? counter,
    Color? iconColor,
    Widget? icon,
    TextStyle? labelStyle,
    Widget? label,
    TextStyle? floatingLabelStyle,
    FloatingLabelBehavior? floatingLabelBehavior,
    FloatingLabelAlignment? floatingLabelAlignment,
    Widget? error,
    BoxConstraints? constraints,
    Widget? suffixIcon,
    Widget? suffix,
    Widget? prefixIcon,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    bool? alignLabelWithHint,
    TextStyle? counterStyle,
    String? counterText,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? errorBorder,
    int? errorMaxLines,
    TextStyle? errorStyle,
    String? errorText,
    bool? filled,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    int? helperMaxLines,
    TextStyle? helperStyle,
    String? helperText,
    Duration? hintFadeDuration,
    int? hintMaxLines,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    String? labelText,
    BoxConstraints? prefixIconConstraints,
    Color? prefixIconColor,
    TextStyle? prefixStyle,
    String? prefixText,
    String? semanticCounterText,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    TextStyle? suffixStyle,
    String? suffixText,

    // New properties
    bool hasOutsideBorders = false,
    InputBorder? decorationBorder,
  }) : super(
    border: hasOutsideBorders && border.isEmpty ? const [1] : border,
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    onTap: null,
    splashColor: null,
    background: background ?? style?.backgroundColor,
    scrollController: null,
    child: TextField(
      style: TextStyle(
        color: style?.color ?? color,
        backgroundColor: style?.backgroundColor ?? background,
        fontFamily: style?.fontFamily ?? fontFamily,
        fontFamilyFallback: style?.fontFamilyFallback ?? fontFamilyFallback,
        fontFeatures: style?.fontFeatures ?? fontFeatures,
        fontStyle: style?.fontStyle ?? fontStyle,
        fontSize: style?.fontSize ?? fontSize,
        fontVariations: style?.fontVariations ?? fontVariations,
        fontWeight: style?.fontWeight ?? fontWeight,
        letterSpacing: style?.letterSpacing ?? letterSpacing,
        locale: style?.locale ?? locale,
        overflow: style?.overflow ?? overflow,
        wordSpacing: style?.wordSpacing ?? wordSpacing,
        background: style?.background ?? paintBackground,
        debugLabel: style?.debugLabel,
        decoration: style?.decoration,
        decorationColor: style?.decorationColor,
        decorationStyle: style?.decorationStyle,
        decorationThickness: style?.decorationThickness,
        foreground: style?.foreground,
        height: style?.height ?? textHeight,
        inherit: true,
        leadingDistribution: style?.leadingDistribution,
        package: null,
        shadows: style?.shadows,
        textBaseline: style?.textBaseline,
      ),
      decoration: InputDecoration(
        border: decorationBorder ??
            (decoration?.border is OutlineInputBorder || hasOutsideBorders
                ? OutlineInputBorder(
                borderRadius: _SuperWidget.setRadius(
                  decorationRadius:
                  (decoration?.border as OutlineInputBorder?)?.borderRadius,
                  radius: radius,
                  radiusTopLeft: radiusTopLeft,
                  radiusTopRight: radiusTopRight,
                  radiusBottomLeft: radiusBottomLeft,
                  radiusBottomRight: radiusBottomRight,
                ),
                borderSide: decoration?.border?.borderSide ?? BorderSide.none,
                gapPadding:
                (decoration?.border as OutlineInputBorder?)?.gapPadding ?? 4.0
            )
                : decoration?.border),

        isDense: decoration?.isDense ?? isDense,
        isCollapsed: decoration?.isCollapsed ?? isCollapsed,
        hoverColor: decoration?.hoverColor ?? hoverColor,
        hintText: decoration?.hintText ?? hintText,
        helper: decoration?.helper ?? helper,
        focusColor: decoration?.focusColor ?? focusColor,
        counter: decoration?.counter ?? counter,
        iconColor: decoration?.iconColor ?? iconColor,
        icon: decoration?.icon ?? icon,
        labelStyle: decoration?.labelStyle ?? labelStyle,
        label: decoration?.label ?? label,
        floatingLabelStyle: decoration?.floatingLabelStyle ??
            floatingLabelStyle,
        floatingLabelBehavior: decoration?.floatingLabelBehavior ??
            floatingLabelBehavior,
        floatingLabelAlignment: decoration?.floatingLabelAlignment ??
            floatingLabelAlignment,
        error: decoration?.error ?? error,
        enabled: decoration?.enabled ?? enabled ?? true,
        constraints: decoration?.constraints ?? constraints,
        suffixIcon: decoration?.suffixIcon ?? suffixIcon,
        suffix: decoration?.suffix ?? suffix,
        prefixIcon: decoration?.prefixIcon ?? prefixIcon,
        prefix: decoration?.prefix ?? prefix,
        contentPadding: _SuperWidget.setPadding(
          decorationPadding: decoration?.contentPadding ?? contentPadding,
          padding: padding,
          paddingLeft: paddingLeft,
          paddingTop: paddingTop,
          paddingRight: paddingRight,
          paddingBottom: paddingBottom,
        ),
        fillColor: decoration?.fillColor ?? fillColor ?? background,
        alignLabelWithHint: decoration?.alignLabelWithHint ??
            alignLabelWithHint,
        counterStyle: decoration?.counterStyle ?? counterStyle,
        counterText: decoration?.counterText ?? counterText,
        disabledBorder: decoration?.disabledBorder ?? disabledBorder,
        enabledBorder: decoration?.enabledBorder ?? enabledBorder,
        errorBorder: decoration?.errorBorder ?? errorBorder,
        errorMaxLines: decoration?.errorMaxLines ?? errorMaxLines,
        errorStyle: decoration?.errorStyle ?? errorStyle,
        errorText: decoration?.errorText ?? errorText,
        filled: decoration?.filled ?? filled ?? background != null,
        focusedBorder: decoration?.focusedBorder ?? focusedBorder,
        focusedErrorBorder: decoration?.focusedErrorBorder ??
            focusedErrorBorder,
        helperMaxLines: decoration?.helperMaxLines ?? helperMaxLines,
        helperStyle: decoration?.helperStyle ?? helperStyle,
        helperText: decoration?.helperText ?? helperText,
        hintFadeDuration: decoration?.hintFadeDuration ?? hintFadeDuration,
        hintMaxLines: decoration?.hintMaxLines ?? hintMaxLines,
        hintStyle: decoration?.hintStyle ?? hintStyle,
        hintTextDirection: decoration?.hintTextDirection ?? hintTextDirection,
        labelText: decoration?.labelText ?? labelText,
        prefixIconConstraints: decoration?.prefixIconConstraints ??
            prefixIconConstraints,
        prefixIconColor: decoration?.prefixIconColor ?? prefixIconColor,
        prefixStyle: decoration?.prefixStyle ?? prefixStyle,
        prefixText: decoration?.prefixText ?? prefixText,
        semanticCounterText: decoration?.semanticCounterText ??
            semanticCounterText,
        suffixIconColor: decoration?.suffixIconColor ?? suffixIconColor,
        suffixIconConstraints: decoration?.suffixIconConstraints ??
            suffixIconConstraints,
        suffixStyle: decoration?.suffixStyle ?? suffixStyle,
        suffixText: decoration?.suffixText ?? suffixText,
      ),
      textDirection: textDirection,
      onTapAlwaysCalled: onTapAlwaysCalled ?? false,
      canRequestFocus: canRequestFocus ?? true,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onTap: onTap,
      controller: controller,
      autocorrect: autocorrect ?? true,
      autofillHints: autofillHints,
      autofocus: autofocus ?? false,
      buildCounter: buildCounter,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      contentInsertionConfiguration: contentInsertionConfiguration,
      contextMenuBuilder: contextMenuBuilder,
      cursorColor: cursorColor,
      cursorErrorColor: cursorErrorColor,
      cursorHeight: cursorHeight,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth ?? 2.0,
      dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
      enabled: enabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning ?? true,
      enableInteractiveSelection: enableInteractiveSelection,
      enableSuggestions: enableSuggestions ?? true,
      expands: expands ?? false,
      ignorePointers: ignorePointers,
      inputFormatters: inputFormatters,
      keyboardAppearance: keyboardAppearance,
      magnifierConfiguration: magnifierConfiguration,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      minLines: minLines,
      mouseCursor: mouseCursor,
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? "•",
      onAppPrivateCommand: onAppPrivateCommand,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onTapOutside: onTapOutside,
      readOnly: readOnly ?? false,
      restorationId: restorationId,
      scribbleEnabled: scribbleEnabled ?? true,
      scrollController: scrollController,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
      scrollPhysics: scrollPhysics,
      selectionControls: selectionControls,
      selectionHeightStyle: selectionHeightStyle ?? BoxHeightStyle.tight,
      selectionWidthStyle: selectionWidthStyle ?? BoxWidthStyle.tight,
      showCursor: showCursor,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      spellCheckConfiguration: spellCheckConfiguration,
      statesController: statesController,
      strutStyle: strutStyle,
      textAlign: textAlign ?? TextAlign.start,
      textAlignVertical: textAlignVertical,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction,
      undoController: undoController,
    ),
  );
}

class $Button extends _SuperWidget {
  $Button(Widget? child, {
    // Button Widget properties
    ButtonStyle? style,
    FocusNode? focusNode,
    Clip? clipBehavior,
    bool? autofocus,
    IconAlignment? iconAlignment,
    void Function()? onPressed,
    void Function(bool)? onFocusChange,
    void Function(bool)? onHover,
    void Function()? onLongPress,
    WidgetStatesController? statesController,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.applyIntrinsicHeight = false,
    super.heroTag,

    // Overwritten properties
    List<Object> border = const [],
    List<double> radius = const [20],
    double? radiusTopLeft,
    double? radiusTopRight,
    double? radiusBottomRight,
    double? radiusBottomLeft,
    EdgeInsetsGeometry? buttonPadding,
    BorderSide? side,
    RoundedRectangleBorder? shape,
    Color? background,
    Color? textBackground,
    Color? foregroundColor,
    Size? minimumSize,
    Color? iconColor,
    AlignmentGeometry? alignment,
    Duration? animationDuration,
    Widget Function(BuildContext, Set<WidgetState>, Widget?)? backgroundBuilder,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? disabledIconColor,
    MouseCursor? disabledMouseCursor,
    double? elevation,
    MouseCursor? enabledMouseCursor,
    bool? enableFeedback,
    Size? fixedSize,
    Widget Function(BuildContext, Set<WidgetState>, Widget?)? foregroundBuilder,
    Size? maximumSize,
    Color? overlayColor,
    Color? shadowColor,
    InteractiveInkFeatureFactory? splashFactory,
    Color? surfaceTintColor,
    MaterialTapTargetSize? tapTargetSize,
    TextStyle? textStyle,
    VisualDensity? visualDensity,

    Color? color,
    double? fontSize,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    String? package,
    TextLeadingDistribution? leadingDistribution,
    bool? inherit,
    double? textHeight,
    Paint? foreground,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
    TextDecoration? textDecoration,
    String? debugLabel,
    Paint? paintBackground,
    double? wordSpacing,
    double? letterSpacing,
    FontWeight? fontWeight,
    List<FontVariation>? fontVariations,
    List<String>? fontFamilyFallback,
    FontStyle? fontStyle,
    String? fontFamily,
    List<FontFeature>? fontFeatures,
    Locale? locale,
    TextOverflow? overflow,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    border: const [],
    borderLeft: const [],
    borderTop: const [],
    borderRight: const [],
    borderBottom: const [],
    radius: const [],
    radiusTopLeft: 0,
    radiusTopRight: 0,
    radiusBottomRight: 0,
    radiusBottomLeft: 0,
    background: null,
    onTap: null,
    splashColor: null,
    child: ElevatedButton(
      style: style ?? ElevatedButton.styleFrom(
        padding: _SuperWidget.setPadding(
          decorationPadding: buttonPadding,
          padding: padding,
          paddingLeft: paddingLeft,
          paddingTop: paddingTop,
          paddingRight: paddingRight,
          paddingBottom: paddingBottom,
        ),
        shape: shape ?? RoundedRectangleBorder(
            borderRadius: _SuperWidget.setRadius(
              radius: radius,
              radiusTopLeft: radiusTopLeft,
              radiusTopRight: radiusTopRight,
              radiusBottomRight: radiusBottomRight,
              radiusBottomLeft: radiusBottomLeft,
            ),
            side: BorderSide(
              width: [
                if (border.isNotEmpty && border[0] is int)
                  (border[0] as int).toDouble()
                else if (border.isNotEmpty && border[0] is double)
                  border[0] as double
                else if (border.isNotEmpty )
                    1.0
                  else
                    0.0
              ][0],
              color: [
                if (border.isNotEmpty && border[0] is Color)
                  border[0] as Color
                else if (border.length > 1 && border[1] is Color)
                  border[1] as Color
                else if (border.isNotEmpty &&
                      (border[0] is double || border[0] is int))
                    Colors.black
                  else
                    Colors.transparent
              ][0],
            )
        ),
        backgroundColor: textBackground ?? background,
        foregroundColor: foregroundColor ?? color,
        minimumSize: minimumSize,
        iconColor: iconColor,
        alignment: alignment,
        animationDuration: animationDuration,
        backgroundBuilder: backgroundBuilder,
        disabledBackgroundColor: disabledBackgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        disabledIconColor: disabledIconColor,
        disabledMouseCursor: disabledMouseCursor,
        elevation: 0,
        enabledMouseCursor: enabledMouseCursor,
        enableFeedback: enableFeedback,
        fixedSize: fixedSize,
        foregroundBuilder: foregroundBuilder,
        maximumSize: maximumSize,
        overlayColor: overlayColor,
        shadowColor: shadowColor,
        splashFactory: splashFactory,
        surfaceTintColor: surfaceTintColor,
        tapTargetSize: tapTargetSize,
        textStyle: TextStyle(
          color: color,
          backgroundColor: background,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontFeatures: fontFeatures,
          fontStyle: fontStyle,
          fontSize: fontSize,
          fontVariations: fontVariations,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          locale: locale,
          overflow: overflow,
          wordSpacing: wordSpacing,
          background: paintBackground,
          debugLabel: debugLabel,
          decoration: textDecoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          foreground: foreground,
          height: textHeight,
          inherit: true,
          leadingDistribution: leadingDistribution,
          package: null,
          shadows: shadows,
          textBaseline: textBaseline,
        ),
        visualDensity: visualDensity,
      ),
      focusNode: focusNode,
      clipBehavior: clipBehavior,
      autofocus: autofocus ?? false,
      iconAlignment: iconAlignment ?? IconAlignment.start,
      onPressed: onPressed,
      onFocusChange: onFocusChange,
      onHover: onHover,
      onLongPress: onLongPress,
      statesController: statesController,
      child: child,
    ),
  );
}

class $FloatingButton extends _SuperWidget {
  $FloatingButton(Widget child, {
    // FloatingButton Widget properties
    Color? splashColor,
    MouseCursor? mouseCursor,
    Color? focusColor,
    Clip? clipBehavior,
    bool? autofocus,
    FocusNode? focusNode,
    Color? backgroundColor,
    Color? foregroundColor,
    double? disabledElevation,
    Color? hoverColor,
    double? elevation,
    bool? enableFeedback,
    double? focusElevation,
    Object? innerHeroTag,
    double? highlightElevation,
    double? hoverElevation,
    bool? isExtended,
    MaterialTapTargetSize? materialTapTargetSize,
    bool? mini,
    ShapeBorder? shape,
    String? tooltip,
    void Function()? onPressed,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [17],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.applyIntrinsicHeight = false,
    super.heroTag,

    // New properties
    Color? color,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    splashColor: null,
    onTap: null,
    padding: const [],
    paddingLeft: null,
    paddingTop: null,
    paddingRight: null,
    paddingBottom: null,
    child: FloatingActionButton(
      splashColor: splashColor,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      clipBehavior: clipBehavior ?? Clip.none,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      backgroundColor: backgroundColor ?? background,
      foregroundColor: foregroundColor ?? color,
      disabledElevation: disabledElevation,
      hoverColor: hoverColor,
      elevation: elevation,
      enableFeedback: enableFeedback,
      focusElevation: focusElevation,
      heroTag: innerHeroTag,
      highlightElevation: highlightElevation,
      hoverElevation: hoverElevation,
      isExtended: isExtended ?? false,
      materialTapTargetSize: materialTapTargetSize,
      mini: mini ?? false,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: _SuperWidget.setRadius(
          radius: radius,
          radiusTopLeft: radiusTopLeft,
          radiusTopRight: radiusTopRight,
          radiusBottomRight: radiusBottomRight,
          radiusBottomLeft: radiusBottomLeft,
        ),
      ),
      tooltip: tooltip,
      onPressed: onPressed,
      child: child,
    ),
  );
}

class $DropDown<T> extends _SuperWidget {
  $DropDown(List<DropdownMenuEntry<T>> dropdownMenuEntries, {
    // DropDown Widget properties
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    super.width,
    String? helperText,
    String? errorText,
    bool? enabled,
    Widget? label,
    String? hintText,
    TextEditingController? controller,
    bool? enableFilter,
    bool? enableSearch,
    EdgeInsets? expandedInsets,
    T? initialSelection,
    InputDecorationTheme? inputDecorationTheme,
    Widget? leadingIcon,
    double? menuHeight,
    MenuStyle? menuStyle,
    void Function(T?)? onSelected,
    bool? requestFocusOnTap,
    int? Function(List<DropdownMenuEntry<T>>, String)? searchCallback,
    Widget? selectedTrailingIcon,
    TextStyle? textStyle,
    Widget? trailingIcon,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.applyIntrinsicHeight = false,
    super.heroTag,

    // Overwritten properties
    Color? color,
    double? fontSize,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    String? package,
    TextLeadingDistribution? leadingDistribution,
    bool? inherit,
    double? textHeight,
    Paint? foreground,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
    InputDecoration? decoration,
    String? debugLabel,
    Paint? paintBackground,
    double? wordSpacing,
    double? letterSpacing,
    FontWeight? fontWeight,
    List<FontVariation>? fontVariations,
    List<String>? fontFamilyFallback,
    FontStyle? fontStyle,
    String? fontFamily,
    List<FontFeature>? fontFeatures,

    Locale? locale,
    TextOverflow? overflow,

    // New properties
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    padding: const [],
    paddingLeft: null,
    paddingTop: null,
    paddingRight: null,
    paddingBottom: null,
    radius: const [],
    radiusTopLeft: null,
    radiusTopRight: null,
    radiusBottomRight: null,
    radiusBottomLeft: null,
    onTap: null,
    splashColor: null,
    child: DropdownMenu<T>(
      dropdownMenuEntries: dropdownMenuEntries,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      width: width,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled ?? true,
      label: label,
      hintText: hintText,
      controller: controller,
      enableFilter: enableFilter ?? false,
      enableSearch: enableSearch ?? true,
      expandedInsets: expandedInsets,
      initialSelection: initialSelection,
      inputDecorationTheme: inputDecorationTheme,
      leadingIcon: leadingIcon,
      menuHeight: menuHeight,
      menuStyle: menuStyle,
      onSelected: onSelected,
      requestFocusOnTap: requestFocusOnTap,
      searchCallback: searchCallback,
      selectedTrailingIcon: selectedTrailingIcon,
      textStyle: TextStyle(
        color: textStyle?.color ?? color,
        backgroundColor: textStyle?.backgroundColor ?? background,
        fontFamily: textStyle?.fontFamily ?? fontFamily,
        fontFamilyFallback: textStyle?.fontFamilyFallback ?? fontFamilyFallback,
        fontFeatures: textStyle?.fontFeatures ?? fontFeatures,
        fontStyle: textStyle?.fontStyle ?? fontStyle,
        fontSize: textStyle?.fontSize ?? fontSize,
        fontVariations: textStyle?.fontVariations ?? fontVariations,
        fontWeight: textStyle?.fontWeight ?? fontWeight,
        letterSpacing: textStyle?.letterSpacing ?? letterSpacing,
        locale: textStyle?.locale ?? locale,
        overflow: textStyle?.overflow ?? overflow,
        wordSpacing: textStyle?.wordSpacing ?? wordSpacing,
        background: textStyle?.background ?? paintBackground,
        debugLabel: textStyle?.debugLabel,
        decoration: textStyle?.decoration,
        decorationColor: textStyle?.decorationColor,
        decorationStyle: textStyle?.decorationStyle,
        decorationThickness: textStyle?.decorationThickness,
        foreground: textStyle?.foreground,
        height: textStyle?.height ?? textHeight,
        inherit: true,
        leadingDistribution: textStyle?.leadingDistribution,
        package: null,
        shadows: textStyle?.shadows,
        textBaseline: textStyle?.textBaseline,
      ),
      trailingIcon: trailingIcon,
    ),
  );
}

class $Switch extends _SuperWidget {
  $Switch({
    // Switch Widget properties
    bool? value,
    void Function(bool)? onChanged,
    FocusNode? focusNode,
    MaterialTapTargetSize? materialTapTargetSize,
    Color? hoverColor,
    Color? focusColor,
    Color? activeColor,
    ImageProvider<Object>? activeThumbImage,
    Color? activeTrackColor,
    bool? autofocus,
    DragStartBehavior? dragStartBehavior,
    Color? inactiveThumbColor,
    ImageProvider<Object>? inactiveThumbImage,
    Color? inactiveTrackColor,
    MouseCursor? mouseCursor,
    void Function(Object, StackTrace?)? onActiveThumbImageError,
    void Function(bool)? onFocusChange,
    void Function(Object, StackTrace?)? onInactiveThumbImageError,
    WidgetStateColor? overlayColor,
    double? splashRadius,
    WidgetStateColor? thumbColor,
    WidgetStateProperty<Icon?>? thumbIcon,
    WidgetStateColor? trackColor,
    WidgetStateColor? trackOutlineColor,
    WidgetStateProperty<double?>? trackOutlineWidth,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.applyIntrinsicHeight = false,
    super.heroTag,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    splashColor: null,
    onTap: null,
    padding: const [],
    paddingLeft: null,
    paddingTop: null,
    paddingRight: null,
    paddingBottom: null,
    radius: const [],
    radiusTopLeft: null,
    radiusTopRight: null,
    radiusBottomRight: null,
    radiusBottomLeft: null,
    child: Switch(
      value: value ?? false,
      onChanged: onChanged,
      key: key,
      focusNode: focusNode,
      materialTapTargetSize: materialTapTargetSize,
      hoverColor: hoverColor,
      focusColor: focusColor,
      activeColor: activeColor,
      activeThumbImage: activeThumbImage,
      activeTrackColor: activeTrackColor,
      autofocus: autofocus ?? false,
      dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
      inactiveThumbColor: inactiveThumbColor,
      inactiveThumbImage: inactiveThumbImage,
      inactiveTrackColor: inactiveTrackColor,
      mouseCursor: mouseCursor,
      onActiveThumbImageError: onActiveThumbImageError,
      onFocusChange: onFocusChange,
      onInactiveThumbImageError: onInactiveThumbImageError,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      thumbColor: thumbColor,
      thumbIcon: thumbIcon,
      trackColor: trackColor,
      trackOutlineColor: trackOutlineColor,
      trackOutlineWidth: trackOutlineWidth,
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) =>
      Container();
}

class $BottomTabs extends StatelessWidget {
  const $BottomTabs(this.tabs, {
    super.key,
    required this.pages,
    this.indicatorSize,
    this.indicatorWeight = 2.0,
    this.indicatorColor,
    this.unselectedLabelColor,
    this.labelColor,
  });

  final List<Widget> pages;
  final List<Tab> tabs;
  final TabBarIndicatorSize? indicatorSize;
  final double indicatorWeight;
  final Color? indicatorColor;
  final Color? unselectedLabelColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(

        body: TabBarView(
          children: pages,
        ),

        bottomNavigationBar: Container(
          color: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          child: TabBar(
            indicatorSize: indicatorSize,
            indicatorWeight: indicatorWeight,
            indicatorColor: indicatorColor,
            unselectedLabelColor: unselectedLabelColor,
            labelColor: labelColor,
            tabs: tabs,
          ),
        ),

      ),
    );
  }
}

class $TextFormField extends _SuperWidget {
  $TextFormField({
    // TextFormField Widget properties
    Key? textFormFieldKey,
    String? Function(String?)? validator,
    AutovalidateMode? autovalidateMode,
    TextStyle? style,
    TextDirection? textDirection,
    bool? onTapAlwaysCalled,
    bool? canRequestFocus,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    void Function()? onTap,
    Object groupId = EditableText,
    String? forceErrorText,
    String? initialValue,
    void Function(String)? onFieldSubmitted,
    void Function(String?)? onSaved,
    TextEditingController? controller,
    bool? autocorrect,
    Iterable<String>? autofillHints,
    bool? autofocus,
    Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter,
    Clip? clipBehavior,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
    Color? cursorColor,
    Color? cursorErrorColor,
    double? cursorHeight,
    bool? cursorOpacityAnimates,
    Radius? cursorRadius,
    double? cursorWidth,
    DragStartBehavior? dragStartBehavior,
    bool? enabled,
    bool? enableIMEPersonalizedLearning,
    bool? enableInteractiveSelection,
    bool? enableSuggestions,
    bool? expands,
    bool? ignorePointers,
    List<TextInputFormatter>? inputFormatters,
    Brightness? keyboardAppearance,
    TextMagnifierConfiguration? magnifierConfiguration,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines,
    int? minLines,
    MouseCursor? mouseCursor,
    bool? obscureText,
    String? obscuringCharacter,
    void Function(String, Map<String, dynamic>)? onAppPrivateCommand,
    void Function(String)? onChanged,
    void Function()? onEditingComplete,
    void Function(String)? onSubmitted,
    void Function(PointerDownEvent)? onTapOutside,
    bool? readOnly,
    String? restorationId,
    bool? scribbleEnabled,
    ScrollController? scrollController,
    EdgeInsets? scrollPadding,
    ScrollPhysics? scrollPhysics,
    TextSelectionControls? selectionControls,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    bool? showCursor,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    SpellCheckConfiguration? spellCheckConfiguration,
    WidgetStatesController? statesController,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    UndoHistoryController? undoController,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    List<Object> border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.isScrollable = false,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,

    // Overwritten properties
    Color? color,
    Color? background,
    double? fontSize,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    String? package,
    TextLeadingDistribution? leadingDistribution,
    bool? inherit,
    double? textHeight,
    Paint? foreground,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
    InputDecoration? decoration,
    String? debugLabel,
    Paint? paintBackground,
    double? wordSpacing,
    double? letterSpacing,
    FontWeight? fontWeight,
    List<FontVariation>? fontVariations,
    List<String>? fontFamilyFallback,
    FontStyle? fontStyle,
    String? fontFamily,
    List<FontFeature>? fontFeatures,

    Locale? locale,
    TextOverflow? overflow,

    bool? isDense,
    bool? isCollapsed,
    Color? hoverColor,
    String? hintText,
    Widget? helper,
    Color? focusColor,
    Widget? counter,
    Color? iconColor,
    Widget? icon,
    TextStyle? labelStyle,
    Widget? label,
    TextStyle? floatingLabelStyle,
    FloatingLabelBehavior? floatingLabelBehavior,
    FloatingLabelAlignment? floatingLabelAlignment,
    Widget? error,
    BoxConstraints? constraints,
    Widget? suffixIcon,
    Widget? suffix,
    Widget? prefixIcon,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    bool? alignLabelWithHint,
    TextStyle? counterStyle,
    String? counterText,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? errorBorder,
    int? errorMaxLines,
    TextStyle? errorStyle,
    String? errorText,
    bool? filled,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    int? helperMaxLines,
    TextStyle? helperStyle,
    String? helperText,
    Duration? hintFadeDuration,
    int? hintMaxLines,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    String? labelText,
    BoxConstraints? prefixIconConstraints,
    Color? prefixIconColor,
    TextStyle? prefixStyle,
    String? prefixText,
    String? semanticCounterText,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    TextStyle? suffixStyle,
    String? suffixText,

    // New properties
    bool hasOutsideBorders = false,
    InputBorder? decorationBorder,
  }) : super(
    border: hasOutsideBorders && border.isEmpty ? const [1] : border,
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    onTap: null,
    background: background ?? style?.backgroundColor,
    scrollController: null,
    child: TextFormField(
      key: textFormFieldKey,
      validator: validator,
      autovalidateMode: autovalidateMode,
      groupId: groupId,
      initialValue: initialValue,
      forceErrorText: forceErrorText,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      style: TextStyle(
        color: style?.color ?? color,
        backgroundColor: style?.backgroundColor ?? background,
        fontFamily: style?.fontFamily ?? fontFamily,
        fontFamilyFallback: style?.fontFamilyFallback ?? fontFamilyFallback,
        fontFeatures: style?.fontFeatures ?? fontFeatures,
        fontStyle: style?.fontStyle ?? fontStyle,
        fontSize: style?.fontSize ?? fontSize,
        fontVariations: style?.fontVariations ?? fontVariations,
        fontWeight: style?.fontWeight ?? fontWeight,
        letterSpacing: style?.letterSpacing ?? letterSpacing,
        locale: style?.locale ?? locale,
        overflow: style?.overflow ?? overflow,
        wordSpacing: style?.wordSpacing ?? wordSpacing,
        background: style?.background ?? paintBackground,
        debugLabel: style?.debugLabel,
        decoration: style?.decoration,
        decorationColor: style?.decorationColor,
        decorationStyle: style?.decorationStyle,
        decorationThickness: style?.decorationThickness,
        foreground: style?.foreground,
        height: style?.height ?? textHeight,
        inherit: true,
        leadingDistribution: style?.leadingDistribution,
        package: null,
        shadows: style?.shadows,
        textBaseline: style?.textBaseline,
      ),
      decoration: InputDecoration(
        border: decorationBorder ??
            (decoration?.border is OutlineInputBorder || hasOutsideBorders
                ? OutlineInputBorder(
                borderRadius: _SuperWidget.setRadius(
                  decorationRadius:
                  (decoration?.border as OutlineInputBorder?)?.borderRadius,
                  radius: radius,
                  radiusTopLeft: radiusTopLeft,
                  radiusTopRight: radiusTopRight,
                  radiusBottomLeft: radiusBottomLeft,
                  radiusBottomRight: radiusBottomRight,
                ),
                borderSide: decoration?.border?.borderSide ?? BorderSide.none,
                gapPadding:
                (decoration?.border as OutlineInputBorder?)?.gapPadding ?? 4.0
            )
                : decoration?.border),

        isDense: decoration?.isDense ?? isDense,
        isCollapsed: decoration?.isCollapsed ?? isCollapsed,
        hoverColor: decoration?.hoverColor ?? hoverColor,
        hintText: decoration?.hintText ?? hintText,
        helper: decoration?.helper ?? helper,
        focusColor: decoration?.focusColor ?? focusColor,
        counter: decoration?.counter ?? counter,
        iconColor: decoration?.iconColor ?? iconColor,
        icon: decoration?.icon ?? icon,
        labelStyle: decoration?.labelStyle ?? labelStyle,
        label: decoration?.label ?? label,
        floatingLabelStyle: decoration?.floatingLabelStyle ??
            floatingLabelStyle,
        floatingLabelBehavior: decoration?.floatingLabelBehavior ??
            floatingLabelBehavior,
        floatingLabelAlignment: decoration?.floatingLabelAlignment ??
            floatingLabelAlignment,
        error: decoration?.error ?? error,
        enabled: decoration?.enabled ?? enabled ?? true,
        constraints: decoration?.constraints ?? constraints,
        suffixIcon: decoration?.suffixIcon ?? suffixIcon,
        suffix: decoration?.suffix ?? suffix,
        prefixIcon: decoration?.prefixIcon ?? prefixIcon,
        prefix: decoration?.prefix ?? prefix,
        contentPadding: _SuperWidget.setPadding(
          decorationPadding: decoration?.contentPadding ?? contentPadding,
          padding: padding,
          paddingLeft: paddingLeft,
          paddingTop: paddingTop,
          paddingRight: paddingRight,
          paddingBottom: paddingBottom,
        ),
        fillColor: decoration?.fillColor ?? fillColor ?? background,
        alignLabelWithHint: decoration?.alignLabelWithHint ??
            alignLabelWithHint,
        counterStyle: decoration?.counterStyle ?? counterStyle,
        counterText: decoration?.counterText ?? counterText,
        disabledBorder: decoration?.disabledBorder ?? disabledBorder,
        enabledBorder: decoration?.enabledBorder ?? enabledBorder,
        errorBorder: decoration?.errorBorder ?? errorBorder,
        errorMaxLines: decoration?.errorMaxLines ?? errorMaxLines,
        errorStyle: decoration?.errorStyle ?? errorStyle,
        errorText: decoration?.errorText ?? errorText,
        filled: decoration?.filled ?? filled ?? background != null,
        focusedBorder: decoration?.focusedBorder ?? focusedBorder,
        focusedErrorBorder: decoration?.focusedErrorBorder ??
            focusedErrorBorder,
        helperMaxLines: decoration?.helperMaxLines ?? helperMaxLines,
        helperStyle: decoration?.helperStyle ?? helperStyle,
        helperText: decoration?.helperText ?? helperText,
        hintFadeDuration: decoration?.hintFadeDuration ?? hintFadeDuration,
        hintMaxLines: decoration?.hintMaxLines ?? hintMaxLines,
        hintStyle: decoration?.hintStyle ?? hintStyle,
        hintTextDirection: decoration?.hintTextDirection ?? hintTextDirection,
        labelText: decoration?.labelText ?? labelText,
        prefixIconConstraints: decoration?.prefixIconConstraints ??
            prefixIconConstraints,
        prefixIconColor: decoration?.prefixIconColor ?? prefixIconColor,
        prefixStyle: decoration?.prefixStyle ?? prefixStyle,
        prefixText: decoration?.prefixText ?? prefixText,
        semanticCounterText: decoration?.semanticCounterText ??
            semanticCounterText,
        suffixIconColor: decoration?.suffixIconColor ?? suffixIconColor,
        suffixIconConstraints: decoration?.suffixIconConstraints ??
            suffixIconConstraints,
        suffixStyle: decoration?.suffixStyle ?? suffixStyle,
        suffixText: decoration?.suffixText ?? suffixText,
      ),
      textDirection: textDirection,
      onTapAlwaysCalled: onTapAlwaysCalled ?? false,
      canRequestFocus: canRequestFocus ?? true,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onTap: onTap,
      controller: controller,
      autocorrect: autocorrect ?? true,
      autofillHints: autofillHints,
      autofocus: autofocus ?? false,
      buildCounter: buildCounter,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      contentInsertionConfiguration: contentInsertionConfiguration,
      contextMenuBuilder: contextMenuBuilder,
      cursorColor: cursorColor,
      cursorErrorColor: cursorErrorColor,
      cursorHeight: cursorHeight,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth ?? 2.0,
      dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
      enabled: enabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning ?? true,
      enableInteractiveSelection: enableInteractiveSelection,
      enableSuggestions: enableSuggestions ?? true,
      expands: expands ?? false,
      ignorePointers: ignorePointers,
      inputFormatters: inputFormatters,
      keyboardAppearance: keyboardAppearance,
      magnifierConfiguration: magnifierConfiguration,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      minLines: minLines,
      mouseCursor: mouseCursor,
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? "•",
      onAppPrivateCommand: onAppPrivateCommand,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutside,
      readOnly: readOnly ?? false,
      restorationId: restorationId,
      scribbleEnabled: scribbleEnabled ?? true,
      scrollController: scrollController,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
      scrollPhysics: scrollPhysics,
      selectionControls: selectionControls,
      selectionHeightStyle: selectionHeightStyle ?? BoxHeightStyle.tight,
      selectionWidthStyle: selectionWidthStyle ?? BoxWidthStyle.tight,
      showCursor: showCursor,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      spellCheckConfiguration: spellCheckConfiguration,
      statesController: statesController,
      strutStyle: strutStyle,
      textAlign: textAlign ?? TextAlign.start,
      textAlignVertical: textAlignVertical,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction,
      undoController: undoController,
    ),
  );
}

class $ValidatedTextField extends StatefulWidget {
  const $ValidatedTextField({
    super.key,
    this.textFormFieldKey,
    this.validator,
    this.autovalidateMode,
    this.style,
    this.textDirection,
    this.onTapAlwaysCalled,
    this.canRequestFocus,
    this.focusNode,
    this.keyboardType,
    this.onTap,
    this.forceErrorText,
    this.initialValue,
    this.onFieldSubmitted,
    this.onSaved,
    this.controller,
    this.autocorrect,
    this.autofillHints,
    this.autofocus,
    this.buildCounter,
    this.clipBehavior,
    this.contentInsertionConfiguration,
    this.contextMenuBuilder,
    this.cursorColor,
    this.cursorErrorColor,
    this.cursorHeight,
    this.cursorOpacityAnimates,
    this.cursorRadius,
    this.cursorWidth,
    this.dragStartBehavior,
    this.enabled,
    this.enableIMEPersonalizedLearning,
    this.enableInteractiveSelection,
    this.enableSuggestions,
    this.expands,
    this.ignorePointers,
    this.inputFormatters,
    this.keyboardAppearance,
    this.magnifierConfiguration,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines,
    this.minLines,
    this.mouseCursor,
    this.obscureText,
    this.obscuringCharacter,
    this.onAppPrivateCommand,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTapOutside,
    this.readOnly,
    this.restorationId,
    this.scribbleEnabled,
    this.scrollPadding,
    this.scrollPhysics,
    this.selectionControls,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.spellCheckConfiguration,
    this.statesController,
    this.strutStyle,
    this.textAlign,
    this.textAlignVertical,
    this.textCapitalization,
    this.textInputAction,
    this.undoController,
    this.isFlexible = false,
    this.isExpanded = false,
    this.fillWidth = false,
    this.fillHeight = false,
    this.aspectRatio,
    this.inverseAspectRatio,
    this.clipBehaviour,
    this.width,
    this.height,
    this.position = const [],
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.margin = const [],
    this.marginLeft,
    this.marginRight,
    this.marginTop,
    this.marginBottom,
    this.padding = const [],
    this.paddingLeft,
    this.paddingRight,
    this.paddingTop,
    this.paddingBottom,
    this.border = const [],
    this.borderLeft = const [],
    this.borderTop = const [],
    this.borderRight = const [],
    this.borderBottom = const [],
    this.radius = const [],
    this.radiusTopLeft,
    this.radiusTopRight,
    this.radiusBottomRight,
    this.radiusBottomLeft,
    this.background,
    this.isScrollable = false,
    this.scrollController,
    this.scale = const [],
    this.scaleX,
    this.scaleY,
    this.rotation,
    this.flipX,
    this.flipY,
    this.isCentered = false,
    this.opacity,
    this.splashColor,
    this.applyIntrinsicHeight = false,
    this.color,
    this.fontSize,
    this.textBaseline,
    this.shadows,
    this.package,
    this.leadingDistribution,
    this.inherit,
    this.textHeight,
    this.foreground,
    this.decorationThickness,
    this.decorationStyle,
    this.decorationColor,
    this.decoration,
    this.debugLabel,
    this.paintBackground,
    this.wordSpacing,
    this.letterSpacing,
    this.fontWeight,
    this.fontVariations,
    this.fontFamilyFallback,
    this.fontStyle,
    this.fontFamily,
    this.fontFeatures,
    this.locale,
    this.overflow,
    this.isDense,
    this.isCollapsed,
    this.hoverColor,
    this.hintText,
    this.helper,
    this.focusColor,
    this.counter,
    this.iconColor,
    this.icon,
    this.labelStyle,
    this.label,
    this.floatingLabelStyle,
    this.floatingLabelBehavior,
    this.floatingLabelAlignment,
    this.error,
    this.constraints,
    this.suffixIcon,
    this.suffix,
    this.prefixIcon,
    this.prefix,
    this.contentPadding,
    this.fillColor,
    this.alignLabelWithHint,
    this.counterStyle,
    this.counterText,
    this.disabledBorder,
    this.enabledBorder,
    this.errorBorder,
    this.errorMaxLines,
    this.errorStyle,
    this.errorText,
    this.filled,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.helperMaxLines,
    this.helperStyle,
    this.helperText,
    this.hintFadeDuration,
    this.hintMaxLines,
    this.hintStyle,
    this.hintTextDirection,
    this.labelText,
    this.prefixIconConstraints,
    this.prefixIconColor,
    this.prefixStyle,
    this.prefixText,
    this.semanticCounterText,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.suffixStyle,
    this.suffixText,
    this.hasOutsideBorders = false,
    this.decorationBorder,
  });

  final bool isFlexible;
  final bool isExpanded;
  final bool fillWidth;
  final bool fillHeight;
  final Size? aspectRatio;
  final Size? inverseAspectRatio;
  final Clip? clipBehaviour;
  final double? width;
  final double? height;
  final List<double> position;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final List<double> margin;
  final double? marginLeft;
  final double? marginRight;
  final double? marginTop;
  final double? marginBottom;
  final List<double> padding;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTop;
  final double? paddingBottom;
  final List<Object> border;
  final List<Object> borderLeft;
  final List<Object> borderTop;
  final List<Object> borderRight;
  final List<Object> borderBottom;
  final List<double> radius;
  final double? radiusTopLeft;
  final double? radiusTopRight;
  final double? radiusBottomRight;
  final double? radiusBottomLeft;
  final Color? background;
  final bool isScrollable;
  final ScrollController? scrollController;
  final List<double> scale;
  final double? scaleX;
  final double? scaleY;
  final double? rotation;
  final bool? flipX;
  final bool? flipY;
  final bool isCentered;
  final double? opacity;
  final Color? splashColor;
  final bool applyIntrinsicHeight;
  final Key? textFormFieldKey;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? style;
  final TextDirection? textDirection;
  final bool? onTapAlwaysCalled;
  final bool? canRequestFocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final Object groupId = EditableText;
  final String? forceErrorText;
  final String? initialValue;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool? autocorrect;
  final Iterable<String>? autofillHints;
  final bool? autofocus;
  final Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter;
  final Clip? clipBehavior;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final double? cursorHeight;
  final bool? cursorOpacityAnimates;
  final Radius? cursorRadius;
  final double? cursorWidth;
  final DragStartBehavior? dragStartBehavior;
  final bool? enabled;
  final bool? enableIMEPersonalizedLearning;
  final bool? enableInteractiveSelection;
  final bool? enableSuggestions;
  final bool? expands;
  final bool? ignorePointers;
  final List<TextInputFormatter>? inputFormatters;
  final Brightness? keyboardAppearance;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final MouseCursor? mouseCursor;
  final bool? obscureText;
  final String? obscuringCharacter;
  final void Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool? readOnly;
  final String? restorationId;
  final bool? scribbleEnabled;
  final EdgeInsets? scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final TextSelectionControls? selectionControls;
  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;
  final bool? showCursor;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final WidgetStatesController? statesController;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final UndoHistoryController? undoController;
  final Color? color;
  final double? fontSize;
  final TextBaseline? textBaseline;
  final List<Shadow>? shadows;
  final String? package;
  final TextLeadingDistribution? leadingDistribution;
  final bool? inherit;
  final double? textHeight;
  final Paint? foreground;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final Color? decorationColor;
  final InputDecoration? decoration;
  final String? debugLabel;
  final Paint? paintBackground;
  final double? wordSpacing;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final List<FontVariation>? fontVariations;
  final List<String>? fontFamilyFallback;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final List<FontFeature>? fontFeatures;
  final Locale? locale;
  final TextOverflow? overflow;
  final bool? isDense;
  final bool? isCollapsed;
  final Color? hoverColor;
  final String? hintText;
  final Widget? helper;
  final Color? focusColor;
  final Widget? counter;
  final Color? iconColor;
  final Widget? icon;
  final TextStyle? labelStyle;
  final Widget? label;
  final TextStyle? floatingLabelStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final Widget? error;
  final BoxConstraints? constraints;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? prefix;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool? alignLabelWithHint;
  final TextStyle? counterStyle;
  final String? counterText;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final int? errorMaxLines;
  final TextStyle? errorStyle;
  final String? errorText;
  final bool? filled;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final int? helperMaxLines;
  final TextStyle? helperStyle;
  final String? helperText;
  final Duration? hintFadeDuration;
  final int? hintMaxLines;
  final TextStyle? hintStyle;
  final TextDirection? hintTextDirection;
  final String? labelText;
  final BoxConstraints? prefixIconConstraints;
  final Color? prefixIconColor;
  final TextStyle? prefixStyle;
  final String? prefixText;
  final String? semanticCounterText;
  final Color? suffixIconColor;
  final BoxConstraints? suffixIconConstraints;
  final TextStyle? suffixStyle;
  final String? suffixText;
  final bool hasOutsideBorders;
  final InputBorder? decorationBorder;

  @override
  State<$ValidatedTextField> createState() => $ValidatedTextFieldState();
}

class $ValidatedTextFieldState extends State<$ValidatedTextField> {
  late FocusNode _focus;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _focus = widget.focusNode?? FocusNode();
  }

  @override
  void dispose() {
    _focus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      $ValidatedTextFieldView(widget: widget, field: this);

  String? validate(String? value) {
    if (widget.validator == null) {
      return null;
    }

    var result = widget.validator!(value);

    if (result == null) {
      return null;
    }

    Scrollable.ensureVisible(
      _key.currentContext!,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _focus.requestFocus();
    });

    return result;
  }
}

class $ValidatedTextFieldView extends StatelessWidget {
  const $ValidatedTextFieldView({
    super.key,
    required this.widget,
    required this.field,
  });

  final $ValidatedTextField widget;
  final $ValidatedTextFieldState field;

  @override
  Widget build(BuildContext context) {
    Widget textField = $Single(
      fillWidth: widget.fillWidth,
      fillHeight: widget.fillHeight,
      aspectRatio: widget.aspectRatio,
      inverseAspectRatio: widget.inverseAspectRatio,
      clipBehaviour: widget.clipBehaviour,
      width: widget.width,
      height: widget.height,
      position: widget.position,
      left: widget.left,
      top: widget.top,
      right: widget.right,
      bottom: widget.bottom,
      margin: widget.margin,
      marginLeft: widget.marginLeft,
      marginTop: widget.marginTop,
      marginRight: widget.marginRight,
      marginBottom: widget.marginBottom,
      padding: widget.padding,
      paddingLeft: widget.paddingLeft,
      paddingTop: widget.paddingTop,
      paddingRight: widget.paddingRight,
      paddingBottom: widget.paddingBottom,
      border: widget.hasOutsideBorders && widget.border.isEmpty
          ? const [1] : widget.border,
      borderLeft: widget.borderLeft,
      borderTop: widget.borderTop,
      borderRight: widget.borderRight,
      borderBottom: widget.borderBottom,
      radius: widget.radius,
      radiusTopLeft: widget.radiusTopLeft,
      radiusTopRight: widget.radiusTopRight,
      radiusBottomRight: widget.radiusBottomRight,
      radiusBottomLeft: widget.radiusBottomLeft,
      isScrollable: widget.isScrollable,
      scale: widget.scale,
      scaleX: widget.scaleX,
      scaleY: widget.scaleY,
      rotation: widget.rotation,
      flipX: widget.flipX,
      flipY: widget.flipY,
      isCentered: widget.isCentered,
      opacity: widget.opacity,
      splashColor: widget.splashColor,
      direction: $Direction.down,
      horizontalAlign: $Align.start,
      verticalAlign: $Align.start,
      onTap: widget.onTap,
      background: widget.background,
      scrollController: widget.scrollController,
      TextFormField(
        key: widget.textFormFieldKey,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        groupId: widget.groupId,
        initialValue: widget.initialValue,
        forceErrorText: widget.forceErrorText,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        style: TextStyle(
          color: widget.style?.color ?? widget.color,
          backgroundColor: widget.style?.backgroundColor ?? widget.background,
          fontFamily: widget.style?.fontFamily ?? widget.fontFamily,
          fontFamilyFallback: widget.style?.fontFamilyFallback ??
              widget.fontFamilyFallback,
          fontFeatures: widget.style?.fontFeatures ?? widget.fontFeatures,
          fontStyle: widget.style?.fontStyle ?? widget.fontStyle,
          fontSize: widget.style?.fontSize ?? widget.fontSize,
          fontVariations: widget.style?.fontVariations ??
              widget.fontVariations,
          fontWeight: widget.style?.fontWeight ?? widget.fontWeight,
          letterSpacing: widget.style?.letterSpacing ?? widget.letterSpacing,
          locale: widget.style?.locale ?? widget.locale,
          overflow: widget.style?.overflow ?? widget.overflow,
          wordSpacing: widget.style?.wordSpacing ?? widget.wordSpacing,
          background: widget.style?.background ?? widget.paintBackground,
          debugLabel: widget.style?.debugLabel,
          decoration: widget.style?.decoration,
          decorationColor: widget.style?.decorationColor,
          decorationStyle: widget.style?.decorationStyle,
          decorationThickness: widget.style?.decorationThickness,
          foreground: widget.style?.foreground,
          height: widget.style?.height ?? widget.textHeight,
          inherit: true,
          leadingDistribution: widget.style?.leadingDistribution,
          package: null,
          shadows: widget.style?.shadows,
          textBaseline: widget.style?.textBaseline,
        ),
        decoration: InputDecoration(
          border: widget.decorationBorder ??
              (widget.decoration?.border is OutlineInputBorder ||
                  widget.hasOutsideBorders
                  ? OutlineInputBorder(
                  borderRadius: _SuperWidget.setRadius(
                    decorationRadius:
                    (widget.decoration?.border as OutlineInputBorder?)
                        ?.borderRadius,
                    radius: widget.radius,
                    radiusTopLeft: widget.radiusTopLeft,
                    radiusTopRight: widget.radiusTopRight,
                    radiusBottomLeft: widget.radiusBottomLeft,
                    radiusBottomRight: widget.radiusBottomRight,
                  ),
                  borderSide: widget.decoration?.border?.borderSide ??
                      BorderSide.none,
                  gapPadding:
                  (widget.decoration?.border as OutlineInputBorder?)
                      ?.gapPadding ?? 4.0
              )
                  : widget.decoration?.border),

          isDense: widget.decoration?.isDense ?? widget.isDense,
          isCollapsed: widget.decoration?.isCollapsed ?? widget.isCollapsed,
          hoverColor: widget.decoration?.hoverColor ?? widget.hoverColor,
          hintText: widget.decoration?.hintText ?? widget.hintText,
          helper: widget.decoration?.helper ?? widget.helper,
          focusColor: widget.decoration?.focusColor ?? widget.focusColor,
          counter: widget.decoration?.counter ?? widget.counter,
          iconColor: widget.decoration?.iconColor ?? widget.iconColor,
          icon: widget.decoration?.icon ?? widget.icon,
          labelStyle: widget.decoration?.labelStyle ?? widget.labelStyle,
          label: widget.decoration?.label ?? widget.label,
          floatingLabelStyle: widget.decoration?.floatingLabelStyle ??
              widget.floatingLabelStyle,
          floatingLabelBehavior: widget.decoration?.floatingLabelBehavior ??
              widget.floatingLabelBehavior,
          floatingLabelAlignment: widget.decoration?.floatingLabelAlignment ??
              widget.floatingLabelAlignment,
          error: widget.decoration?.error ?? widget.error,
          enabled: widget.decoration?.enabled ?? widget.enabled ?? true,
          constraints: widget.decoration?.constraints ?? widget.constraints,
          suffixIcon: widget.decoration?.suffixIcon ?? widget.suffixIcon,
          suffix: widget.decoration?.suffix ?? widget.suffix,
          prefixIcon: widget.decoration?.prefixIcon ?? widget.prefixIcon,
          prefix: widget.decoration?.prefix ?? widget.prefix,
          contentPadding: _SuperWidget.setPadding(
            decorationPadding: widget.decoration?.contentPadding ??
                widget.contentPadding,
            padding: widget.padding,
            paddingLeft: widget.paddingLeft,
            paddingTop: widget.paddingTop,
            paddingRight: widget.paddingRight,
            paddingBottom: widget.paddingBottom,
          ),
          fillColor: widget.decoration?.fillColor ?? widget.fillColor ??
              widget.background,
          alignLabelWithHint: widget.decoration?.alignLabelWithHint ??
              widget.alignLabelWithHint,
          counterStyle: widget.decoration?.counterStyle ??
              widget.counterStyle,
          counterText: widget.decoration?.counterText ?? widget.counterText,
          disabledBorder: widget.decoration?.disabledBorder ??
              widget.disabledBorder,
          enabledBorder: widget.decoration?.enabledBorder ??
              widget.enabledBorder,
          errorBorder: widget.decoration?.errorBorder ?? widget.errorBorder,
          errorMaxLines: widget.decoration?.errorMaxLines ??
              widget.errorMaxLines,
          errorStyle: widget.decoration?.errorStyle ?? widget.errorStyle,
          errorText: widget.decoration?.errorText ?? widget.errorText,
          filled: widget.decoration?.filled ?? widget.filled ??
              widget.background != null,
          focusedBorder: widget.decoration?.focusedBorder ??
              widget.focusedBorder,
          focusedErrorBorder: widget.decoration?.focusedErrorBorder ??
              widget.focusedErrorBorder,
          helperMaxLines: widget.decoration?.helperMaxLines ??
              widget.helperMaxLines,
          helperStyle: widget.decoration?.helperStyle ?? widget.helperStyle,
          helperText: widget.decoration?.helperText ?? widget.helperText,
          hintFadeDuration: widget.decoration?.hintFadeDuration ??
              widget.hintFadeDuration,
          hintMaxLines: widget.decoration?.hintMaxLines ??
              widget.hintMaxLines,
          hintStyle: widget.decoration?.hintStyle ?? widget.hintStyle,
          hintTextDirection: widget.decoration?.hintTextDirection ??
              widget.hintTextDirection,
          labelText: widget.decoration?.labelText ?? widget.labelText,
          prefixIconConstraints: widget.decoration?.prefixIconConstraints ??
              widget.prefixIconConstraints,
          prefixIconColor: widget.decoration?.prefixIconColor ??
              widget.prefixIconColor,
          prefixStyle: widget.decoration?.prefixStyle ?? widget.prefixStyle,
          prefixText: widget.decoration?.prefixText ?? widget.prefixText,
          semanticCounterText: widget.decoration?.semanticCounterText ??
              widget.semanticCounterText,
          suffixIconColor: widget.decoration?.suffixIconColor ??
              widget.suffixIconColor,
          suffixIconConstraints: widget.decoration?.suffixIconConstraints ??
              widget.suffixIconConstraints,
          suffixStyle: widget.decoration?.suffixStyle ?? widget.suffixStyle,
          suffixText: widget.decoration?.suffixText ?? widget.suffixText,
        ),
        textDirection: widget.textDirection,
        onTapAlwaysCalled: widget.onTapAlwaysCalled ?? false,
        canRequestFocus: widget.canRequestFocus ?? true,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        controller: widget.controller,
        autocorrect: widget.autocorrect ?? true,
        autofillHints: widget.autofillHints,
        autofocus: widget.autofocus ?? false,
        buildCounter: widget.buildCounter,
        clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
        contentInsertionConfiguration: widget.contentInsertionConfiguration,
        contextMenuBuilder: widget.contextMenuBuilder,
        cursorColor: widget.cursorColor,
        cursorErrorColor: widget.cursorErrorColor,
        cursorHeight: widget.cursorHeight,
        cursorOpacityAnimates: widget.cursorOpacityAnimates,
        cursorRadius: widget.cursorRadius,
        cursorWidth: widget.cursorWidth ?? 2.0,
        dragStartBehavior: widget.dragStartBehavior ??
            DragStartBehavior.start,
        enabled: widget.enabled,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning ??
            true,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        enableSuggestions: widget.enableSuggestions ?? true,
        expands: widget.expands ?? false,
        ignorePointers: widget.ignorePointers,
        inputFormatters: widget.inputFormatters,
        keyboardAppearance: widget.keyboardAppearance,
        magnifierConfiguration: widget.magnifierConfiguration,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        mouseCursor: widget.mouseCursor,
        obscureText: widget.obscureText ?? false,
        obscuringCharacter: widget.obscuringCharacter ?? "•",
        onAppPrivateCommand: widget.onAppPrivateCommand,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onTapOutside: widget.onTapOutside,
        readOnly: widget.readOnly ?? false,
        restorationId: widget.restorationId,
        scribbleEnabled: widget.scribbleEnabled ?? true,
        scrollController: widget.scrollController,
        scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
        scrollPhysics: widget.scrollPhysics,
        selectionControls: widget.selectionControls,
        selectionHeightStyle: widget.selectionHeightStyle ??
            BoxHeightStyle.tight,
        selectionWidthStyle: widget.selectionWidthStyle ??
            BoxWidthStyle.tight,
        showCursor: widget.showCursor,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        spellCheckConfiguration: widget.spellCheckConfiguration,
        statesController: widget.statesController,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign ?? TextAlign.start,
        textAlignVertical: widget.textAlignVertical,
        textCapitalization: widget.textCapitalization ??
            TextCapitalization.none,
        textInputAction: widget.textInputAction,
        undoController: widget.undoController,
      ),
    );

    if (widget.isExpanded) {
      textField = Expanded(child: textField);
    } else if (widget.isFlexible) {
      textField = Flexible(child: textField);
    }

    if (widget.applyIntrinsicHeight
        && !(widget.isScrollable || widget.isExpanded || widget.isFlexible)) {
      textField = IntrinsicHeight(child: textField);
    }

    return textField;
  }
}

class $Checkbox extends _SuperWidget {
  $Checkbox({
    // Checkbox Widget properties
    bool? value,
    ValueChanged<bool?>? onChanged,
    MouseCursor? mouseCursor,
    Color? activeColor,
    WidgetStateProperty<Color?>? fillColor,
    Color? checkColor,
    bool tristate = false,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
    Color? focusColor,
    Color? hoverColor,
    WidgetStateProperty<Color?>? overlayColor,
    double? splashRadius,
    FocusNode? focusNode,
    bool autofocus = false,
    OutlinedBorder? shape,
    BorderSide? side,
    bool isError = false,
    String? semanticLabel,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    child: Checkbox(
      value: value,
      onChanged: onChanged,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      tristate: tristate,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      focusNode: focusNode,
      autofocus: autofocus,
      shape: shape,
      side: side,
      isError: isError,
      semanticLabel: semanticLabel,
    ),
  );
}

class $Divider extends _SuperWidget {
  $Divider({
    // Icon Widget properties
    double? innerHeight,
    double? thickness,
    double? indent,
    double? endIndent,
    Color? color,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    child: Divider(
      height: innerHeight,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    ),
  );
}

class $TextButton extends _SuperWidget {
  $TextButton(Widget child, {
    // Icon Widget properties
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    Clip? clipBehavior,
    FocusNode? focusNode,
    bool autofocus = false,
    bool? isSemanticButton,
    IconAlignment iconAlignment = IconAlignment.start,

    // SuperWidget properties
    super.key,
    super.isFlexible = false,
    super.isExpanded = false,
    super.doNotExpand = false,
    super.fillWidth = false,
    super.fillHeight = false,
    super.aspectRatio,
    super.inverseAspectRatio,
    super.clipBehaviour,
    super.width,
    super.height,
    super.position = const [],
    super.left,
    super.top,
    super.right,
    super.bottom,
    super.margin = const [],
    super.marginLeft,
    super.marginTop,
    super.marginRight,
    super.marginBottom,
    super.padding = const [],
    super.paddingLeft,
    super.paddingTop,
    super.paddingRight,
    super.paddingBottom,
    super.border = const [],
    super.borderLeft = const [],
    super.borderTop = const [],
    super.borderRight = const [],
    super.borderBottom = const [],
    super.radius = const [],
    super.radiusTopLeft,
    super.radiusTopRight,
    super.radiusBottomRight,
    super.radiusBottomLeft,
    super.background,
    super.isScrollable = false,
    super.scrollController,
    super.scale = const [],
    super.scaleX,
    super.scaleY,
    super.rotation,
    super.flipX,
    super.flipY,
    super.isCentered = false,
    super.opacity,
    super.splashColor,
    super.applyIntrinsicHeight = false,
    super.heroTag,
    super.onTap,
  }) : super(
    children: const [],
    direction: $Direction.down,
    horizontalAlign: $Align.start,
    verticalAlign: $Align.start,
    child: TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      isSemanticButton: isSemanticButton,
      iconAlignment: iconAlignment,
      child: child,
    ),
  );
}

enum $Direction { right, left, up, down }

enum $Align { start, end, center, spaceBetween, spaceAround, spaceEvenly, stretch }

extension _HorizontalAlignValueConverter on $Align {
  MainAxisAlignment toMainAxisAlignment() =>
      switch(this) {
        $Align.start => MainAxisAlignment.start,
        $Align.end => MainAxisAlignment.end,
        $Align.center => MainAxisAlignment.center,
        $Align.spaceBetween => MainAxisAlignment.spaceBetween,
        $Align.spaceAround => MainAxisAlignment.spaceAround,
        $Align.spaceEvenly => MainAxisAlignment.spaceEvenly,
        $Align.stretch => MainAxisAlignment.spaceBetween,
      };

  CrossAxisAlignment toCrossAxisAlignment() =>
      switch(this) {
        $Align.start => CrossAxisAlignment.start,
        $Align.end => CrossAxisAlignment.end,
        $Align.center => CrossAxisAlignment.center,
        $Align.spaceBetween => CrossAxisAlignment.stretch,
        $Align.spaceAround => CrossAxisAlignment.stretch,
        $Align.spaceEvenly => CrossAxisAlignment.stretch,
        $Align.stretch => CrossAxisAlignment.stretch,
      };
}
