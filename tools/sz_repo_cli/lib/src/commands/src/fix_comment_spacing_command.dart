import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:sz_repo_cli/src/common/common.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';

// ignore_for_file: no_spaces_after_comment_slashes

/// Adds spaces after the comment slashes if necessary.
/// Example:
///
/// Before
/// ```dart
/// // comment
/// /// doc-comment
/// ```
/// After
/// ```dart
/// // comment
/// /// doc-comment
/// ```
///
/// See: [findCommentsWithBadSpacingInCode]
class FixCommentSpacingCommand extends Command {
  FixCommentSpacingCommand(this.repo);

  final SharezoneRepo repo;

  @override
  String get description =>
      'Adds space between comment slashes and text where necessary.';

  @override
  String get name => 'fix-comment-spacing';

  @override
  Future<void> run() async {
    await _fixCommentSpacing(rootPath: repo.location.path);
    print('Warning: Some results may be false-positives');
    print(
        'If this happens you can include "// ignore_for_file: no_spaces_after_comment_slashes" in your file');
    print('(This warning will be printed regardless if anything was found)');
  }
}

bool _isExcludedFile(File file) => file.path.contains('.g.dart');

Iterable<File> _getFilesToCheck(String rootPath) => Glob('**/**.dart')
    .listSync(root: rootPath, followLinks: false)
    .whereType<File>()
    .where((file) => !_isExcludedFile(file));

// If you update the logic here update it also in [_findCommentsWithBadSpacing]
// below.
Future<void> _fixCommentSpacing({@required String rootPath}) async {
  final dartFiles = _getFilesToCheck(rootPath);
  for (final dartFile in dartFiles) {
    final content = dartFile.readAsStringSync();
    final newContent =
        fixCodeWithCommentsWithBadSpacing(content, dartFile.path);
    dartFile.writeAsStringSync(newContent);
  }
}

/// See [findCommentsWithBadSpacingInCode]
bool doesPackageIncludeFilesWithBadCommentSpacing(String packageRootPath) {
  final dartFiles = _getFilesToCheck(packageRootPath);
  for (final dartFile in dartFiles) {
    final content = dartFile.readAsStringSync();
    if (containsCommentsWithBadComments(content)) {
      print('Found comment with bad spacing in ${dartFile.path}.');
      print('This *may* be a false-positive.');
      print(
          'If this happens you can include "// ignore_for_file: no_spaces_after_comment_slashes" in your file.');
      return true;
    }
  }
  return false;
}

/// See [findCommentsWithBadSpacingInCode]
bool containsCommentsWithBadComments(String dartFileContent) {
  return findCommentsWithBadSpacingInCode(dartFileContent).isNotEmpty;
}

/// See [findCommentsWithBadSpacingInCode]
String fixCodeWithCommentsWithBadSpacing(String sourceCode, [String filePath]) {
  final badComments = findCommentsWithBadSpacingInCode(sourceCode);
  for (var i = 0; i < badComments.length; i++) {
    final badComment = badComments[i];
    if (filePath != null) {
      print('Found bad comment in $filePath');
    }
    sourceCode = _addCharAtPosition(
      sourceCode,
      ' ',
      // We add i here because when inserting a space all later occurences
      // of bad comments move back by one character
      badComment.lastCommentSlashIndex + 1 + i,
    );
  }
  return sourceCode;
}

/// Add a [char] at a [position] with the given String [s].
String _addCharAtPosition(String s, String char, int position) {
  if (s.length < position) {
    return s;
  }
  final before = s.substring(0, position);
  final after = s.substring(position, s.length);
  return before + char + after;
}

class CommentWithBadSpacingMatch {
  /// The index of the last "/" character of the comment.
  /// Can be used to insert a " " after to fix the spacing issue of the comment.
  ///
  /// Example:
  /// ```dart
  //////This is a bad doc-comment
  ///void main() {};
  /// ```
  /// The index of [lastCommentSlashIndex] would be 2:
  /// Index 0 is the first slash, 1 the second, 2 the third.
  final int lastCommentSlashIndex;

  CommentWithBadSpacingMatch(this.lastCommentSlashIndex);
}

/// Matches "//" and "///"
final _commentSlashesRegex = RegExp(r'\/{2,3}');

/// Tries to find all comments where there is no space after the slashes.
/// Example:
/// ```dart
/// //This is a bad comment
/// ///This is a bad doc-comment
/// // This is a good comment
/// /// This is a good doc-comment
/// ```
/// This method will match the first two "bad" comments.
///
/// ### False-positives
/// This method is not perfect, it may have false-positives.
/// For example something like
/// ```dart
/// print('//This will get matched but should not ');
/// ```
/// will get matched as the method relies on matching strings in the code.
///
/// A better method for parsing would be using the analyzer to see what is
/// definitely a comment and what is not. This may be achieved by using an
/// Dart analyzer-plugin.
/// (See: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1455)
///
/// Currently the implemented method is regarded as "good enough". If there are
/// any occurences of false-positives then the search for bad comments can be
/// deactivated by including
/// ```dart
/// // ignore_for_file: no_spaces_after_comment_slashes
/// ```
/// inside the file with a false-positive.
List<CommentWithBadSpacingMatch> findCommentsWithBadSpacingInCode(
    String sourceCode) {
  // As we sometimes still have false positives we want this "safety hatch".
  if (sourceCode
      .contains('// ignore_for_file: no_spaces_after_comment_slashes')) {
    return [];
  }

  final badCommentPositions = <CommentWithBadSpacingMatch>[];
  final commentMatches = _commentSlashesRegex.allMatches(sourceCode);
  for (final match in commentMatches) {
    final areCommentSlashesLastCharsInFile = sourceCode.length == match.end;
    if (areCommentSlashesLastCharsInFile) {
      // Other checks are unnecessary and will fail (index out of bounds) as
      // some will try to read characters after comment slashes.
      continue;
    }
    final hasSpaceAfterCommentSlashes = sourceCode[match.end] == ' ';

    // Windows has CRLF line endings for files ("\r\n") while Linux and macOS
    // use LF ("\n").
    //
    // This means if there is a line return after the comment then
    // `sourceCode[match.end]` (character after comment slashes) will be "\n" on
    // Linux and macOS and "\r" on Windows (because its two characters - first
    // "\r" and then "\n" on Windows).
    final isEmptyCommentWithNoSpacesAfter =
        // Linux / macOS line ending: LF (\n)
        sourceCode[match.end] == '\n' ||
            // Windows line ending: CRLF (\r\n). We just assume the \n after \r.
            sourceCode[match.end] == '\r';

    // We assume if comment has format "://" that it is propably a Url.
    // For example https://example.com
    final isPropablyUrl =
        match.start != 0 && sourceCode[match.start - 1] == ':';

    final isProbablyBadComment = !(hasSpaceAfterCommentSlashes ||
        isEmptyCommentWithNoSpacesAfter ||
        isPropablyUrl);
    if (isProbablyBadComment) {
      badCommentPositions.add(CommentWithBadSpacingMatch(match.end - 1));
    }
  }
  return badCommentPositions;
}
