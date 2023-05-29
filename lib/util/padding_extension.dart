import 'package:flutter/material.dart';

///扩展int以方便使用
extension IntFix on int {
  ///eg 200.px
  SizedBox get paddingHeight {
    return SizedBox(height: toDouble());
  }

  SizedBox get paddingWidth {
    return SizedBox(width: toDouble());
  }
}

///扩展double以方便使用
extension DoubleFix on double {
  ///eg 200.px
  SizedBox get paddingHeight {
    return SizedBox(height: this);
  }

  SizedBox get paddingWidth {
    return SizedBox(width: this);
  }

  ///eg 200.rpx
  SizedBox get rpxHeight {
    return SizedBox(height: this * 750 / 375);
  }

  SizedBox get rpxWidth {
    return SizedBox(width: this * 750 / 375);
  }
}
