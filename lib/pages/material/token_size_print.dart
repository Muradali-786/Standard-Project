enum SizeToken {
  medium, //normal size text
  bold, //only bold text
  boldMedium, //bold with medium
  boldLarge, //bold with large
  extraLarge //extra large
}



enum AlignToken {
  left, //ESC_ALIGN_LEFT
  center, //ESC_ALIGN_CENTER
  right, //ESC_ALIGN_RIGHT
}
extension PrintSize on SizeToken {
  int get val {
    switch (this) {
      case SizeToken.medium:
        return 0;
      case SizeToken.bold:
        return 1;
      case SizeToken.boldMedium:
        return 2;
      case SizeToken.boldLarge:
        return 3;
      case SizeToken.extraLarge:
        return 4;
      default:
        return 0;
    }
  }
}



extension PrintAlign on AlignToken {
  int get val {
    switch (this) {
      case AlignToken.left:
        return 0;
      case AlignToken.center:
        return 1;
      case AlignToken.right:
        return 2;
      default:
        return 0;
    }
  }
}