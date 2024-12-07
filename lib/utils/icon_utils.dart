import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

typedef IconBuilder = Widget Function(
  BuildContext context, {
  Color? color,
  double? size,
});

class IconUtils {
  IconUtils._();

  static Widget _getIcon({
    required BuildContext context,
    required IconData icon,
    Color? color,
    double? size,
  }) =>
      FaIcon(
        icon,
        color: color ?? primaryColorFrom(context),
        size: size,
      );

  static Widget add(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.plus,
        color: color,
        size: size,
      );

  static Widget close(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.xmark,
        color: color,
        size: size,
      );

  static Widget copy(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.copy,
        color: color,
        size: size,
      );

  static Widget copyAll(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: Icons.copy,
        color: color,
        size: size,
      );

  static Widget circleInfo(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.circleInfo,
        color: color,
        size: size,
      );

  static Widget circleQuestion(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.circleQuestion,
        color: color,
        size: size,
      );

  static Widget table(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.table,
        color: color,
        size: size,
      );

  static Widget arrowLeft(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.arrowLeft,
        color: color,
        size: size,
      );

  static Widget edit(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.penToSquare,
        color: color,
        size: size,
      );

  static Widget check(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.check,
        color: color,
        size: size,
      );

  static Widget replay(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.rotateLeft,
        color: color,
        size: size,
      );

  static Widget gears(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.gears,
        color: color,
        size: size,
      );

  static Widget file(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.file,
        color: color,
        size: size,
      );

  static Widget trashCan(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.trashCan,
        color: color,
        size: size,
      );

  static Widget squareClose(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.rectangleXmark,
        color: color,
        size: size,
      );

  static Widget come(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.rightToBracket,
        color: color,
        size: size,
      );

  static Widget leave(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.rightFromBracket,
        color: color,
        size: size,
      );

  static Widget gear(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.gear,
        color: color,
        size: size,
      );

  static Widget clipboard(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.clipboard,
        color: color,
        size: size,
      );

  static Widget clock(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.clock,
        color: color,
        size: size,
      );

  static Widget clear(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.circleXmark,
        color: color,
        size: size,
      );

  static Widget doubleLeftArrow(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.anglesLeft,
        color: color,
        size: size,
      );

  static Widget doubleRightArrow(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.anglesRight,
        color: color,
        size: size,
      );

  static Widget caretRight(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.caretRight,
        color: color,
        size: size,
      );

  static Widget caretLeft(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.caretLeft,
        color: color,
        size: size,
      );

  static Widget link(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.link,
        color: color,
        size: size,
      );

  static Widget ellipsisVertical(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.ellipsisVertical,
        color: color,
        size: size,
      );

  static Widget square(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.square,
        color: color,
        size: size,
      );
  static Widget squareCheck(
    BuildContext context, {
    Color? color,
    double? size,
  }) =>
      _getIcon(
        context: context,
        icon: FontAwesomeIcons.squareCheck,
        color: color,
        size: size,
      );
}
