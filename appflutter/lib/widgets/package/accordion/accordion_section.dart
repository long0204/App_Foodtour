import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'accordion.dart';

class AccordionSection extends StatelessWidget with CommonParams {
  final SectionController sectionCtrl = SectionController();
  late final UniqueKey uniqueKey;
  late final int index;
  final bool isOpen;

  final Function? onOpenSection;

  /// Callback function or when a section closes
  final Function? onCloseSection;

  /// The text to be displayed in the header
  final Widget header;

  /// The widget to be displayed as the content of the section when open
  final Widget content;

  AccordionSection({
    Key? key,
    this.index = 0,
    this.isOpen = false,
    required this.header,
    required this.content,
    Color? headerBackgroundColor,
    Color? headerBackgroundColorOpened,
    List<Color> gradient = const [Colors.black, Colors.black],
    Color? headerBorderColor,
    Color? headerBorderColorOpened,
    double? headerBorderWidth,
    double? headerBorderRadius,
    EdgeInsets? headerPadding,
    Widget? leftIcon,
    Widget? rightIcon,
    Widget? rightWidget,
    Color? contentBackgroundColor,
    Color? contentBorderColor,
    double? contentBorderWidth,
    double? contentBorderRadius,
    double? contentHorizontalPadding,
    double? contentVerticalPadding,
    double? paddingBetweenOpenSections,
    double? paddingBetweenClosedSections,
    ScrollIntoViewOfItems? scrollIntoViewOfItems,
    SectionHapticFeedback? sectionOpeningHapticFeedback,
    SectionHapticFeedback? sectionClosingHapticFeedback,
    String? accordionId,
    this.onOpenSection,
    this.onCloseSection,
  }) : super(key: key) {
    final listCtrl = Get.put(ListController(), tag: accordionId);
    uniqueKey = listCtrl.keys.elementAt(index);
    sectionCtrl.isSectionOpen.value = listCtrl.openSections.contains(uniqueKey);

    this.headerBackgroundColor = headerBackgroundColor;
    this.headerBackgroundColorOpened =
        headerBackgroundColorOpened ?? headerBackgroundColor;
    this.headerBorderColor = headerBorderColor ?? headerBackgroundColor;
    this.headerBorderColorOpened =
        headerBorderColorOpened ?? headerBackgroundColorOpened;
    this.headerBorderWidth = headerBorderWidth;
    this.headerBorderRadius = headerBorderRadius;
    this.headerPadding = headerPadding;
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon;
    this.rightWidget = rightWidget;
    this.contentBackgroundColor = contentBackgroundColor;
    this.contentBorderColor = contentBorderColor;
    this.contentBorderWidth = contentBorderWidth;
    this.contentBorderRadius = contentBorderRadius;
    this.contentHorizontalPadding = contentHorizontalPadding;
    this.contentVerticalPadding = contentVerticalPadding;
    this.paddingBetweenOpenSections = paddingBetweenOpenSections;
    this.paddingBetweenClosedSections = paddingBetweenClosedSections;
    this.scrollIntoViewOfItems =
        scrollIntoViewOfItems ?? ScrollIntoViewOfItems.fast;
    this.sectionOpeningHapticFeedback = sectionOpeningHapticFeedback;
    this.sectionClosingHapticFeedback = sectionClosingHapticFeedback;
    this.accordionId = accordionId;
    this.gradient = gradient;

    listCtrl.controllerIsOpen.stream.asBroadcastStream().listen((data) {
      sectionCtrl.isSectionOpen.value = listCtrl.openSections.contains(key);
    });
  }

  /// getter to flip the widget vertically (Icon by default)
  /// on the left of this section header to visually indicate
  /// if this section is open or closed
  get _flipQuarterTurnsLeft =>
      SectionController.flipLeftIconIfOpen && _isOpen ? 2 : 0;

  /// getter to flip the widget vertically (Icon by default)
  /// on the right of this section header to visually indicate
  /// if this section is open or closed
  get _flipQuarterTurnsRight =>
      SectionController.flipRightIconIfOpen && _isOpen ? 2 : 0;

  /// getter indication the open or closed status of this section
  get _isOpen {
    final listCtrl = Get.put(ListController(), tag: accordionId);
    final open = sectionCtrl.isSectionOpen.value;

    Timer(
      sectionCtrl.firstRun
          ? (listCtrl.initialOpeningSequenceDelay + min(index * 200, 1000))
              .milliseconds
          : 0.seconds,
      () {
        if (MyAccordion.sectionAnimation) {
          sectionCtrl.controller
              .fling(velocity: open ? 1 : -1, springDescription: springFast);
        } else {
          sectionCtrl.controller.value = open ? 1 : 0;
        }
        sectionCtrl.firstRun = false;
      },
    );

    return open;
  }

  /// play haptic feedback when opening/closing sections
  _playHapticFeedback(bool opening) {
    final feedback =
        opening ? sectionOpeningHapticFeedback : sectionClosingHapticFeedback;

    switch (feedback) {
      case SectionHapticFeedback.light:
        HapticFeedback.lightImpact();
        break;
      case SectionHapticFeedback.medium:
        HapticFeedback.mediumImpact();
        break;
      case SectionHapticFeedback.heavy:
        HapticFeedback.heavyImpact();
        break;
      case SectionHapticFeedback.selection:
        HapticFeedback.selectionClick();
        break;
      case SectionHapticFeedback.vibrate:
        HapticFeedback.vibrate();
        break;
      default:
    }
  }

  @override
  build(context) {
    final borderRadius = headerBorderRadius ?? 10;
    final contentBorderRadius = this.contentBorderRadius ?? 10;

    return Obx(
      () => Container(
        margin: EdgeInsets.only(top: 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          key: uniqueKey,
          children: [
            InkWell(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
                bottom: Radius.circular(_isOpen ? 0 : borderRadius),
              ),
              onTap: () {
                final listCtrl = Get.put(ListController(), tag: accordionId);

                listCtrl.updateSections(uniqueKey);
                _playHapticFeedback(_isOpen);

                if (_isOpen &&
                    scrollIntoViewOfItems != ScrollIntoViewOfItems.none &&
                    listCtrl.controller.hasClients) {
                  Timer(
                    250.milliseconds,
                    () {
                      listCtrl.controller.cancelAllHighlights();
                      listCtrl.controller.scrollToIndex(index,
                          preferPosition: AutoScrollPosition.middle,
                          duration: (scrollIntoViewOfItems ==
                                      ScrollIntoViewOfItems.fast
                                  ? .5
                                  : 1)
                              .seconds);
                    },
                  );
                }

                if (_isOpen) {
                  if (onCloseSection != null) onCloseSection!.call();
                } else {
                  if (onOpenSection != null) onOpenSection!.call();
                }
              },
              child: LayoutBuilder(builder: (context, c) {
                return AnimatedContainer(
                  duration: MyAccordion.sectionAnimation
                      ? 750.milliseconds
                      : 0.milliseconds,
                  curve: Curves.easeOut,
                  alignment: Alignment.center,
                  padding: headerPadding,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(colors: [
                    //   Colors.red,
                    //   Colors.green,
                    // ]),
                    // color: (_isOpen
                    //         ? headerBackgroundColorOpened
                    //         : headerBackgroundColor) ??
                    //     Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius),
                      bottom: Radius.circular(_isOpen ? 0 : borderRadius),
                    ),
                    border: Border.all(
                      color: (_isOpen
                              ? headerBorderColorOpened
                              : headerBorderColor) ??
                          Theme.of(context).primaryColor,
                      width: (headerBorderWidth ?? 0),
                      style: (headerBorderWidth ?? 0) <= 0
                          ? BorderStyle.none
                          : BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (leftIcon != null)
                        RotatedBox(
                          quarterTurns: _flipQuarterTurnsLeft,
                          child: leftIcon!,
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: leftIcon == null ? 0 : 15),
                        child: header,
                      ),
                      const Gap(5),
                      if (rightIcon != null)
                        RotatedBox(
                          quarterTurns: _flipQuarterTurnsRight,
                          child: rightIcon!,
                        ),
                      const Spacer(),
                      if (rightWidget != null) rightWidget!
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: _isOpen
                      ? paddingBetweenOpenSections ?? 10
                      : paddingBetweenClosedSections ?? 10),
              child: SizeTransition(
                sizeFactor: sectionCtrl.controller,
                child: ScaleTransition(
                  scale: MyAccordion.sectionScaleAnimation
                      ? sectionCtrl.controller
                      : const AlwaysStoppedAnimation(1.0),
                  child: Center(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: contentBorderColor ??
                            Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(contentBorderRadius)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          contentBorderWidth ?? 1,
                          0,
                          contentBorderWidth ?? 1,
                          contentBorderWidth ?? 1,
                        ),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(
                                      contentBorderRadius / 1.02))),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: contentBackgroundColor,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(
                                        contentBorderRadius / 1.02))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentHorizontalPadding ?? 10,
                                vertical: contentVerticalPadding ?? 10,
                              ),
                              child: Center(
                                child: content,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
