// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sz_repo_cli/src/commands/src/fix_comment_spacing_command.dart';
import 'package:test/test.dart';

// ignore_for_file: no_spaces_after_comment_slashes

void main() {
  group('bad comment spacing', () {
    test('is found for simple bad comment', () {
      const input = '''
//This is a bad comment
final x = 3;
''';

      final results = findCommentsWithBadSpacingInCode(input);
      expect(results.length, 1);
      // This is the space after the slashes (//<here>).
      expect(results.single.lastCommentSlashIndex, 1);
    });
    test('is found for simple bad doc comment', () {
      const input = '''
///This is a bad doc-comment
void main() {};
''';

      final results = findCommentsWithBadSpacingInCode(input);
      expect(results.length, 1);
      // This is the space after the slashes (///<here>).
      expect(results.single.lastCommentSlashIndex, 2);
    });

    group('does not match', () {
      void expectNoBadCommentsFound(String input) =>
          expect(findCommentsWithBadSpacingInCode(input).length, 0);

      test('simple good comments and doc comments', () {
        expectNoBadCommentsFound('''
/// This is a good doc-comment
// This is a good normal comment
void main() {};
''');
      });
      test('empty comments', () {
        /// Important: In the empty comment lines
        /// some comments have spaces and some dont.
        /// Example:
        /// ///(Space)(Space)(Space)
        /// ///
        /// (line above has no spaces after comment)
        ///
        /// Windows uses CRLF (\r\n) as line endings, Linux and macOS use
        /// LF (\n) so we test both here
        expectNoBadCommentsFound('''
/// This is a good doc-comment...
/// 
/// 
/// ...with empty lines
final x = 3;
/// This is a good comment...
///        
///\n
///\r\n
/// ...with empty lines
void main() {};
''');
      });
      test(
          'anything if input includes "// ignore_for_file: no_spaces_after_comment_slashes"',
          () {
        expectNoBadCommentsFound('''
// ignore_for_file: no_spaces_after_comment_slashes
//Some bad Comment
final x = 3;
///Here aswell
        ''');
      });
      test('links inside comments', () {
        expectNoBadCommentsFound('''
/// Defaults to https://some-url.com
final Uri url;

// https://example.com
final Uri url2;
''');
      });
      test('empty comment at end of file (edge case for overflow)', () {
        expectNoBadCommentsFound('''
final foo = "bar";
//''');
      });
      test('comment inside string', () {
        expectNoBadCommentsFound('''
print('//abc');
//''');
      },
          skip:
              "We can't really solve this without using the dart analyzer (which is complicated). This should be solved in the future by maybe using a analyzer plugin alltogether instead of regex-ing the source code. See https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1455.");
    });

    test('is found for multiple bad normal, bad doc comments', () {
      const input = '''
///This is a bad doc-comment
void main() {
  ///Where is the space?!?!
  final x = 3;
  //Important stuff we do here.
  myFunction();
};
''';

      final results = findCommentsWithBadSpacingInCode(input);
      final resultIndicies = results.map((res) => res.lastCommentSlashIndex);
      expect(resultIndicies, [2, 47, 89]);
    });
  });

  test('fixing bad comments', () {
    // Because we know that the method uses the "find bad comments" method we
    // just run one bigger "integration test" instead of testing all cases
    // again as unit tests.
    const input = '''
//I like comments....
//   
//
//...even with vast spaces

/// This is entry-point for our program.
/// 
///It will lead to ultimate success and freedom of mankind.
void main() {
  //Yes
  /// aaaaa
  ///aa
  // No
  // What
  final myString = 'Hello world'!
  print(myString);
}
//
''';

    const expectedOutput = '''
// I like comments....
//   
//
// ...even with vast spaces

/// This is entry-point for our program.
/// 
/// It will lead to ultimate success and freedom of mankind.
void main() {
  // Yes
  /// aaaaa
  /// aa
  // No
  // What
  final myString = 'Hello world'!
  print(myString);
}
//
''';

    expect(fixCodeWithCommentsWithBadSpacing(input), expectedOutput);
  });
}
