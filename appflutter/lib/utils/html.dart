// ignore: depend_on_referenced_packages

String replaceEmbedTags(String html) {
  final embedRegex = RegExp(r'\[embed\](.*?)\[/embed\]', multiLine: true);

  return html.replaceAllMapped(embedRegex, (match) {
    String url = match.group(1) ?? "";
    if (url.contains("youtu.be") || url.contains("youtube.com")) {
      url = url
          .replaceAll("watch?v=", "embed/")
          .replaceAll("youtu.be/", "www.youtube.com/embed/");
    }
    return '''
        <iframe 
          width="100%" height="250" 
          src="$url" 
          frameborder="0" 
          allowfullscreen>
        </iframe>
      ''';
  });
}

String fitSizeHtml(String html) {
  final widthFitted = html.replaceAllMapped(
    RegExp(r'(<img[^>]+)(width=)', caseSensitive: false),
    (match) {
      final part1 = match.group(1);
      return part1 != null ? '${part1}_${match.group(2) ?? ''}' : '';
    },
  );
  final heightFitted = widthFitted.replaceAllMapped(
    RegExp(r'(<img[^>]+)(height=)', caseSensitive: false),
    (match) {
      final part1 = match.group(1);
      return part1 != null ? '${part1}_${match.group(2) ?? ''}' : '';
    },
  );
  return heightFitted;
}
