import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TouchSpin extends StatefulWidget {
  final num value;
  final num min;
  final num max;
  final num step;
  final double iconSize;
  final ValueChanged<num>? onChanged;
  final NumberFormat? displayFormat;
  final Icon subtractIcon;
  final Icon addIcon;
  final EdgeInsetsGeometry iconPadding;
  final TextStyle textStyle;
  final Color? iconActiveColor;
  final Color? iconDisabledColor;
  final bool enabled;

  const TouchSpin({
    Key? key,
    this.value = 1.0,
    this.onChanged,
    this.min = 1.0,
    this.max = 9999999.0,
    this.step = 1.0,
    this.iconSize = 24.0,
    this.displayFormat,
    this.subtractIcon = const Icon(Icons.remove),
    this.addIcon = const Icon(Icons.add),
    this.iconPadding = const EdgeInsets.all(4.0),
    this.textStyle = const TextStyle(fontSize: 24),
    this.iconActiveColor,
    this.iconDisabledColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  TouchSpinState createState() => TouchSpinState();
}

class TouchSpinState extends State<TouchSpin> {
  late num value;

  bool get minusBtnDisabled =>
      value <= widget.min ||
      value - widget.step < widget.min ||
      !widget.enabled;

  bool get addBtnDisabled =>
      value >= widget.max ||
      value + widget.step > widget.max ||
      !widget.enabled;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(TouchSpin oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      setState(() => value = widget.value);
      widget.onChanged?.call(widget.value);
    }
  }

  Color? spinButtonColor(bool btnDisabled) => btnDisabled
      ? widget.iconDisabledColor ?? Theme.of(context).disabledColor
      : widget.iconActiveColor ?? Theme.of(context).textTheme.button?.color;

  void adjustValue(num adjustment) {
    num newVal = value + adjustment;
    setState(() => value = newVal);
    widget.onChanged?.call(newVal);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          padding: widget.iconPadding,
          iconSize: widget.iconSize,
          color: spinButtonColor(minusBtnDisabled),
          icon: widget.subtractIcon,
          onPressed: minusBtnDisabled ? null : () => adjustValue(-widget.step),
        ),
        Text(
          widget.displayFormat?.format(value) ?? value.toString(),
          style: widget.textStyle,
          key: ValueKey(value),
        ),
        IconButton(
          padding: widget.iconPadding,
          iconSize: widget.iconSize,
          color: spinButtonColor(addBtnDisabled),
          icon: widget.addIcon,
          onPressed: addBtnDisabled ? null : () => adjustValue(widget.step),
        ),
      ],
    );
  }
}
