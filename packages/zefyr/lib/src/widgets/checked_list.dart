// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';

import 'common.dart';
import 'paragraph.dart';
import 'theme.dart';

/// Represents number lists and bullet lists in a Zefyr editor.
class ZefyrCheckedList extends StatelessWidget {
  const ZefyrCheckedList({Key key, @required this.node}) : super(key: key);

  final BlockNode node;

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrTheme.of(context);
    final items = <Widget>[];
    var index = 1;
    for (var line in node.children) {
      items.add(_buildItem(line, index));
      index++;
    }

    final isNumberList =
        node.style.get(NotusAttribute.block) == NotusAttribute.block.numberList;
    var padding = isNumberList
        ? theme.attributeTheme.numberList.padding
        : theme.attributeTheme.bulletList.padding;
    padding = padding.copyWith(left: theme.indentWidth);

    return Padding(
      padding: padding,
      child: Column(children: items),
    );
  }

  Widget _buildItem(Node node, int index) {
    LineNode line = node;
    return ZefyrCheckedListItem(index: index, node: line);
  }
}

/// An item in a [ZefyrCheckedList].
class ZefyrCheckedListItem extends StatelessWidget {
  ZefyrCheckedListItem({Key key, this.index, this.node}) : super(key: key);

  final int index;
  final LineNode node;

  @override
  Widget build(BuildContext context) {
    final BlockNode block = node.parent;
    final style = block.style.get(NotusAttribute.block);
    final theme = ZefyrTheme.of(context);
    final blockTheme = theme.attributeTheme.bulletList;
    final isChecked = node.style.contains(NotusAttribute.checked);
    final bulletText = isChecked ? '☒' : '☐';

    TextStyle textStyle;
    Widget content;
    EdgeInsets padding;

    if (node.style.contains(NotusAttribute.heading)) {
      final headingTheme = ZefyrHeading.themeOf(node, context);
      textStyle = headingTheme.textStyle;
      padding = headingTheme.padding;
      content = ZefyrHeading(node: node);
    } else {
      textStyle = theme.defaultLineTheme.textStyle;
      content = ZefyrLine(
        node: node,
        style: textStyle,
        padding: blockTheme.linePadding,
      );
      padding = blockTheme.linePadding;
    }
    if (isChecked) {
      textStyle = textStyle.copyWith(decoration: TextDecoration.lineThrough);
    }

    Widget bullet =
        SizedBox(width: 24.0, child: Text(bulletText, style: textStyle));
    if (padding != null) {
      bullet = Padding(padding: padding, child: bullet);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[bullet, Expanded(child: content)],
    );
  }
}
