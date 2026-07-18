final class MarkdownSelection {
  const MarkdownSelection({
    required this.baseOffset,
    required this.extentOffset,
  });

  final int baseOffset;
  final int extentOffset;

  MarkdownSelection clamp(int length) => MarkdownSelection(
        baseOffset: baseOffset.clamp(0, length),
        extentOffset: extentOffset.clamp(0, length),
      );
}

final class MarkdownEditResult {
  const MarkdownEditResult({
    required this.markdown,
    required this.selection,
  });

  final String markdown;
  final MarkdownSelection selection;
}
