// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// part 'content.dart';

enum HorizontalTitlePosition { inline, bottom }

enum HorizontalLinePosition { center, top }

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

@immutable
class EnhanceStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const EnhanceStep({
    this.icon,
    required this.title,
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive = false,
    this.isEnd = false,
    this.maxLinesContent = 3,
  });
  final bool isEnd;
  final int maxLinesContent;
  final Widget? icon;

  final Widget title;

  final Widget? subtitle;

  final Widget content;
  final StepState state;
  final bool isActive;
}

class EnhanceStepper extends StatefulWidget {
  const EnhanceStepper({
    Key? key,
    required this.steps,
    this.physics,
    this.stepIconSize = _kStepSize,
    this.type = StepperType.vertical,
    this.horizontalTitlePosition = HorizontalTitlePosition.inline,
    this.horizontalLinePosition = HorizontalLinePosition.top,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.stepIconBuilder,
  })  : assert(0 <= currentStep && currentStep < steps.length),
        super(key: key);

  final List<EnhanceStep> steps;

  final double? stepIconSize;

  final ScrollPhysics? physics;

  final StepperType type;

  final HorizontalTitlePosition horizontalTitlePosition;

  final HorizontalLinePosition horizontalLinePosition;

  final int currentStep;

  final ValueChanged<int>? onStepTapped;

  final VoidCallback? onStepContinue;

  final VoidCallback? onStepCancel;

  final ControlsWidgetBuilder? controlsBuilder;

  final StepIconBuilder? stepIconBuilder;

  @override
  State<EnhanceStepper> createState() => _EnhanceStepperState();
}

class _EnhanceStepperState extends State<EnhanceStepper>
    with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, StepState> _oldStates = <int, StepState>{};

  late final List<GlobalKey> _key1;
  late final List<double> _widget1Height;
  void _getWidgetHeight(int index) async {
    await Future.delayed(const Duration(milliseconds: 333));
    final RenderBox? renderBox =
        _key1[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _widget1Height[index] = renderBox.size.height;
    }
    if (index == widget.steps.length - 1) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );
    _key1 = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );
    _widget1Height = List<double>.generate(widget.steps.length, (int i) => 60);

    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < widget.steps.length; i++) {
        _getWidgetHeight(i);
      }
    });
  }

  @override
  void didUpdateWidget(EnhanceStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildIcon2(int index, bool oldState) {
    final StepState state =
        oldState ? _oldStates[index]! : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    final Widget? icon = widget.stepIconBuilder?.call(index, state);
    if (icon != null) {
      return icon;
    }

    switch (state) {
      case StepState.indexed:
      case StepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case StepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: (widget.stepIconSize ?? _kStepSize) - 6.0,
        );
      case StepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: (widget.stepIconSize ?? _kStepSize) - 6.0,
        );
      case StepState.error:
        return const Text('!', style: _kStepStyle);
    }
  }

  Color _circleColor(int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (!_isDark()) {
      return widget.steps[index].isActive
          ? colorScheme.primary
          : colorScheme.onSurface.withOpacity(0.38);
    } else {
      return widget.steps[index].isActive
          ? colorScheme.secondary
          : colorScheme.surface;
    }
  }

  Widget _buildCircle(int index, bool oldState) {
    EnhanceStep step = widget.steps[index];

    return SizedBox(
      // margin: EdgeInsets.only(top: index == 0 ? 0 : 0),
      width: (widget.stepIconSize ?? _kStepSize),
      height: (widget.stepIconSize ?? _kStepSize),
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: step.icon != null ? null : _circleColor(index),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildIcon2(index, oldState && step.state == StepState.error),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: (widget.stepIconSize ?? _kStepSize),
      height: (widget.stepIconSize ?? _kStepSize),
      child: Center(
        child: SizedBox(
          width: widget.stepIconSize,
          height: _kTriangleHeight,
          // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(0.0, 0.8),
              // 0.8 looks better than the geometrical 0.33.
              child: _buildIcon2(index,
                  oldState && widget.steps[index].state != StepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == StepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != StepState.error) {
        return _buildCircle(index, false);
      } else {
        return _buildTriangle(index, false);
      }
    }
  }

  Widget _buildVerticalControls(int stepIndex) {
    if (widget.controlsBuilder != null) {
      return widget.controlsBuilder!(
        context,
        ControlsDetails(
          currentStep: widget.currentStep,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel,
          stepIndex: stepIndex,
        ),
      );
    }

    final Color cancelColor;
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        break;
      case Brightness.dark:
        cancelColor = Colors.white70;
        break;
    }

    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)));
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          // The Material spec no longer includes a Stepper widget. The continue
          // and cancel button styles have been configured to match the original
          // version of this widget.
          children: <Widget>[
            TextButton(
              onPressed: widget.onStepContinue,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return states.contains(WidgetState.disabled)
                      ? null
                      : (_isDark()
                          ? colorScheme.onSurface
                          : colorScheme.onPrimary);
                }),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return _isDark() || states.contains(WidgetState.disabled)
                      ? null
                      : colorScheme.primary;
                }),
                padding:
                    WidgetStateProperty.all<EdgeInsetsGeometry>(buttonPadding),
                shape: WidgetStateProperty.all<OutlinedBorder>(buttonShape),
              ),
              child: Text(localizations.continueButtonLabel),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: TextButton(
                onPressed: widget.onStepCancel,
                style: TextButton.styleFrom(
                  foregroundColor: cancelColor,
                  padding: buttonPadding,
                  shape: buttonShape,
                ),
                child: Text(localizations.cancelButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        // case StepState.customIcon:
        return textTheme.bodyLarge!;
      case StepState.disabled:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        // case StepState.customIcon:
        return textTheme.bodySmall!;
      case StepState.disabled:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: widget.type == StepperType.horizontal &&
              widget.horizontalTitlePosition == HorizontalTitlePosition.bottom
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        if (widget.steps[index].subtitle != null)
          AnimatedDefaultTextStyle(
            style: _subtitleStyle(index),
            duration: kThemeAnimationDuration,
            curve: Curves.fastOutSlowIn,
            child: widget.steps[index].subtitle!,
          ),
      ],
    );
  }

  Widget _buildLine({double height = 0}) {
    return Container(
      width: 1,
      height: height,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildGroupLine(int index) {
    final isEnd = widget.steps[index].isEnd;
    final length = widget.steps[index].maxLinesContent;

    if (isEnd) return SizedBox(height: 18.w);
    List<Widget> child = [];
    for (var i = 0; i < length; i++) {
      child.add(_buildLine(height: i > 1 ? 10.w : 18.w));
    }
    return Column(children: child);
  }

  Widget _buildVerticalHeader(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            // Line parts are always added in order for the ink splash to
            // flood the tips of the connector lines.
            Gap(6.w),
            _buildIcon(index),
            // _buildGroupLine(index),
            if (!widget.steps[index].isEnd)
              _buildLine(height: _widget1Height[index] - 27.w),
          ],
        ),
        Expanded(
          key: _key1[index],
          child: Container(
            margin: EdgeInsetsDirectional.only(start: 14.w),
            child: _buildHeaderText(index),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: widget.stepIconSize,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: EdgeInsetsDirectional.only(
              start: 32.w,
              end: 16.w,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildVerticalControls(index),
                widget.steps[index].content,
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: CrossFadeState.showSecond,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      padding: EdgeInsets.zero,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              _buildVerticalHeader(i),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontalBottomTitle(int i) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: (widget.stepIconSize ?? _kStepSize) + 24,
          child: Center(
            child: _buildIcon(i),
          ),
        ),
        Container(
          child: _buildHeaderText(i),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: widget.steps[i].state != StepState.disabled
              ? () {
                  widget.onStepTapped?.call(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: widget.type == StepperType.horizontal &&
                  widget.horizontalTitlePosition ==
                      HorizontalTitlePosition.bottom
              ? _buildHorizontalBottomTitle(i)
              : Row(
                  children: <Widget>[
                    SizedBox(
                      height: 72.0,
                      child: Center(
                        child: _buildIcon(i),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(start: 12.0),
                      child: _buildHeaderText(i),
                    ),
                  ],
                ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 1.0,
                  color: Colors.grey.shade400,
                ),
                if (widget.type == StepperType.horizontal &&
                    widget.horizontalTitlePosition ==
                        HorizontalTitlePosition.bottom &&
                    widget.horizontalLinePosition == HorizontalLinePosition.top)
                  const SizedBox(height: 48)
                else
                  const SizedBox(height: 0)
              ],
            ),
          ),
      ],
    ];

    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          child: Row(
            children: children,
          ),
        ),
        Expanded(
          child: ListView(
            physics: widget.physics,
            padding: EdgeInsets.zero,
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                child: widget.steps[widget.currentStep].content,
              ),
              _buildVerticalControls(widget.currentStep),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null) {
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      }
      return true;
    }());

    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
        return _buildHorizontal();
    }
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    required this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}
