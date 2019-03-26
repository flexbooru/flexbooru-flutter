import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class _BooruPictures extends StatelessWidget {
  const _BooruPictures({
    Key key,
    this.currentBooruPicture,
    this.otherBoorusPictures,
  }) : super(key: key);

  final Widget currentBooruPicture;
  final List<Widget> otherBoorusPictures;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          top: 0.0,
          end: 0.0,
          child: Row(
            children: (otherBoorusPictures ?? <Widget>[]).take(3).map<Widget>((Widget picture) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                child: Semantics(
                  container: true,
                  child: Container(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    width: 48.0,
                    height: 48.0,
                    child: picture,
                 ),
                ),
              );
            }).toList(),
          ),
        ),
        Positioned(
          top: 0.0,
          child: Semantics(
            explicitChildNodes: true,
            child: SizedBox(
              width: 72.0,
              height: 72.0,
              child: currentBooruPicture,
            ),
          ),
        ),
      ],
    );
  }
}

class _BooruDetails extends StatefulWidget {
  const _BooruDetails({
    Key key,
    @required this.booruName,
    @required this.booruUrl,
    this.onTap,
    this.isOpen,
  }) : super(key: key);

  final Widget booruName;
  final Widget booruUrl;
  final VoidCallback onTap;
  final bool isOpen;

  @override
  _BooruDetailsState createState() => _BooruDetailsState();
}

class _BooruDetailsState extends State<_BooruDetails> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  @override
  void initState () {
    super.initState();
    _controller = AnimationController(
      value: widget.isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn.flipped,
    )
      ..addListener(() => setState(() {
        // [animation]'s value has changed here.
      }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget (_BooruDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_animation.status == AnimationStatus.dismissed ||
        _animation.status == AnimationStatus.reverse) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final ThemeData theme = Theme.of(context);
    final List<Widget> children = <Widget>[];

    if (widget.booruName != null) {
      final Widget booruNameLine = LayoutId(
        id: _BooruDetailsLayout.booruName,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.body2,
            overflow: TextOverflow.ellipsis,
            child: widget.booruName,
          ),
        ),
      );
      children.add(booruNameLine);
    }

    if (widget.booruUrl != null) {
      final Widget booruUrlLine = LayoutId(
        id: _BooruDetailsLayout.booruUrl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.body1,
            overflow: TextOverflow.ellipsis,
            child: widget.booruUrl,
          ),
        ),
      );
      children.add(booruUrlLine);
    }
    if (widget.onTap != null) {
      final Widget dropDownIcon = LayoutId(
        id: _BooruDetailsLayout.dropdownIcon,
        child: Semantics(
          container: true,
          button: true,
          onTap: widget.onTap,
          child: SizedBox(
            height: _kBooruDetailsHeight,
            width: _kBooruDetailsHeight,
            child: Center(
              child: Transform.rotate(
                angle: _animation.value * math.pi,
                child: Icon(
                  Icons.arrow_drop_up,
                  color: theme.textTheme.body1.color,
                  semanticLabel: widget.isOpen
                    ? 'Hide boorus'
                    : 'Show boorus',
                ),
              ),
            ),
          ),
        ),
      );
      children.add(dropDownIcon);
    }

    Widget booruDetails = CustomMultiChildLayout(
      delegate: _BooruDetailsLayout(
        textDirection: Directionality.of(context),
      ),
      children: children,
    );

    if (widget.onTap != null) {
      booruDetails = InkWell(
        onTap: widget.onTap,
        child: booruDetails,
        excludeFromSemantics: true,
      );
    }

    return SizedBox(
      height: _kBooruDetailsHeight,
      child: booruDetails,
    );
  }
}

const double _kBooruDetailsHeight = 56.0;

class _BooruDetailsLayout extends MultiChildLayoutDelegate {

  _BooruDetailsLayout({ @required this.textDirection });

  static const String booruName = 'booruName';
  static const String booruUrl = 'booruUrl';
  static const String dropdownIcon = 'dropdownIcon';

  final TextDirection textDirection;

  @override
  void performLayout(Size size) {
    Size iconSize;
    if (hasChild(dropdownIcon)) {
      // place the dropdown icon in bottom right (LTR) or bottom left (RTL)
      iconSize = layoutChild(dropdownIcon, BoxConstraints.loose(size));
      positionChild(dropdownIcon, _offsetForIcon(size, iconSize));
    }

    final String bottomLine = hasChild(booruUrl) ? booruUrl : (hasChild(booruName) ? booruName : null);

    if (bottomLine != null) {
      final Size constraintSize = iconSize == null ? size : size - Offset(iconSize.width, 0.0);
      iconSize ??= const Size(_kBooruDetailsHeight, _kBooruDetailsHeight);

      // place bottom line center at same height as icon center
      final Size bottomLineSize = layoutChild(bottomLine, BoxConstraints.loose(constraintSize));
      final Offset bottomLineOffset = _offsetForBottomLine(size, iconSize, bottomLineSize);
      positionChild(bottomLine, bottomLineOffset);

      // place booru name above booru url
      if (bottomLine == booruUrl && hasChild(booruName)) {
        final Size nameSize = layoutChild(booruName, BoxConstraints.loose(constraintSize));
        positionChild(booruName, _offsetForName(size, nameSize, bottomLineOffset));
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;

  Offset _offsetForIcon(Size size, Size iconSize) {
    switch (textDirection) {
      case TextDirection.ltr:
        return Offset(size.width - iconSize.width, size.height - iconSize.height);
      case TextDirection.rtl:
        return Offset(0.0, size.height - iconSize.height);
    }
    assert(false, 'Unreachable');
    return null;
  }

  Offset _offsetForBottomLine(Size size, Size iconSize, Size bottomLineSize) {
    final double y = size.height - 0.5 * iconSize.height - 0.5 * bottomLineSize.height;
    switch (textDirection) {
      case TextDirection.ltr:
        return Offset(0.0, y);
      case TextDirection.rtl:
        return Offset(size.width - bottomLineSize.width, y);
    }
    assert(false, 'Unreachable');
    return null;
  }

  Offset _offsetForName(Size size, Size nameSize, Offset bottomLineOffset) {
    final double y = bottomLineOffset.dy - nameSize.height;
    switch (textDirection) {
      case TextDirection.ltr:
        return Offset(0.0, y);
      case TextDirection.rtl:
        return Offset(size.width - nameSize.width, y);
    }
    assert(false, 'Unreachable');
    return null;
  }
}

/// A material design [Drawer] header that identifies the app's booru.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [DrawerHeader], for a drawer header that doesn't show boorus.
///  * <https://material.io/design/components/navigation-drawer.html#anatomy>
class BoorusDrawerHeader extends StatefulWidget {
  /// Creates a material design drawer header.
  ///
  /// Requires one of its ancestors to be a [Material] widget.
  const BoorusDrawerHeader({
    Key key,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.currentBooruPicture,
    this.otherBoorusPictures,
    @required this.booruName,
    @required this.booruUrl,
    this.onDetailsPressed,
  }) : super(key: key);

  /// The header's background. If decoration is null then a [BoxDecoration]
  /// with its background color set to the current theme's primaryColor is used.
  final Decoration decoration;

  /// The margin around the drawer header.
  final EdgeInsetsGeometry margin;

  /// A widget placed in the upper-left corner that represents the current
  /// booru. Normally a [CircleAvatar].
  final Widget currentBooruPicture;

  /// A list of widgets that represent the current booru's other boorus.
  /// Up to three of these widgets will be arranged in a row in the header's
  /// upper-right corner. Normally a list of [CircleAvatar] widgets.
  final List<Widget> otherBoorusPictures;

  /// A widget that represents the booru's current booru name. It is
  /// displayed on the left, below the [currentBooruPicture].
  final Widget booruName;

  /// A widget that represents the url address of the booru's current booru.
  /// It is displayed on the left, below the [booruName].
  final Widget booruUrl;

  /// A callback that is called when the horizontal area which contains the
  /// [booruName] and [booruUrl] is tapped.
  final VoidCallback onDetailsPressed;

  @override
  _BoorusDrawerHeaderState createState() => _BoorusDrawerHeaderState();
}

class _BoorusDrawerHeaderState extends State<BoorusDrawerHeader> {
  bool _isOpen = false;

  void _handleDetailsPressed() {
    setState(() {
      _isOpen = !_isOpen;
    });
    widget.onDetailsPressed();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    return Semantics(
      container: true,
      label: MaterialLocalizations.of(context).signedInLabel,
      child: DrawerHeader(
        decoration: widget.decoration ?? BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        margin: widget.margin,
        padding: const EdgeInsetsDirectional.only(top: 16.0, start: 16.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16.0),
                  child: _BooruPictures(
                    currentBooruPicture: widget.currentBooruPicture,
                    otherBoorusPictures: widget.otherBoorusPictures,
                  ),
                ),
              ),
              _BooruDetails(
                booruName: widget.booruName,
                booruUrl: widget.booruUrl,
                isOpen: _isOpen,
                onTap: widget.onDetailsPressed == null ? null : _handleDetailsPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}