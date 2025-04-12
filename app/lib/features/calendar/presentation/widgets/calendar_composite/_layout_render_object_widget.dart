part of 'calendar_composite.dart';

class _LayoutRenderObjectWidget extends MultiChildRenderObjectWidget {
  const _LayoutRenderObjectWidget({
    required super.children,
    required this.itemSpacing,
    required this.calendarOffset,
  });

  final double itemSpacing;
  final double calendarOffset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _LayoutRenderObject(
      itemSpacing: itemSpacing,
      calendarOffset: calendarOffset,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _LayoutRenderObject renderObject,
  ) {
    if (renderObject.itemSpacing != itemSpacing ||
        renderObject.calendarOffset != calendarOffset) {
      renderObject.itemSpacing = itemSpacing;
      renderObject.calendarOffset = calendarOffset;
      renderObject.markNeedsLayout();
    }
    super.updateRenderObject(context, renderObject);
  }
}

class _LayoutRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, VerticalListParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, VerticalListParentData> {
  _LayoutRenderObject({
    required this.itemSpacing,
    required this.calendarOffset,
  });

  double itemSpacing;
  double calendarOffset;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! VerticalListParentData) {
      child.parentData = VerticalListParentData();
    }
  }

  @override
  void performLayout() {
    double yOffset = 0;
    double maxWidth = 0;
    RenderBox? child = firstChild;
    int i = 0;

    while (child != null) {
      final VerticalListParentData childParentData =
          child.parentData as VerticalListParentData;

      child.layout(constraints.loosen(), parentUsesSize: true);

      if (i == 1) {
        childParentData.offset = Offset(
          0,
          -child.size.height * calendarOffset + yOffset,
        );
        yOffset += child.size.height - child.size.height * calendarOffset;
      }

      if (i == 0) {
        childParentData.offset = Offset(0, yOffset);
        yOffset += child.size.height;
        yOffset += itemSpacing;
        // yOffset += calendarOffset;
      }

      maxWidth = max(maxWidth, child.size.width);

      child = childParentData.nextSibling;
      i++;
    }

    size = constraints.constrain(Size(maxWidth, yOffset));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = lastChild;

    while (child != null) {
      final VerticalListParentData childParentData =
          child.parentData as VerticalListParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childParentData.previousSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = firstChild;
    while (child != null) {
      final VerticalListParentData childParentData =
          child.parentData as VerticalListParentData;
      if (result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      )) {
        return true;
      }
      child = childParentData.nextSibling;
    }
    return false;
  }
}

class VerticalListParentData extends ContainerBoxParentData<RenderBox> {}
