import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blurhash/blurhash.dart' as blurhash;
import 'package:openreads/core/constants/constants.dart';

import 'package:openreads/logic/cubit/edit_book_cubit.dart';
import 'package:sealed_languages/sealed_languages.dart';

class Helpers {
  static Future generateBlurHash(Uint8List bytes, BuildContext context) async {
    final blurHashStringTmp = await blurhash.BlurHash.encode(
      bytes,
      blurHashX,
      blurHashY,
    );

    if (!context.mounted) return;

    context.read<EditBookCubit>().setBlurHash(blurHashStringTmp);
  }

  static List<String> getLanguageCodes() {
    return NaturalLanguage.list
        .map((e) => e.bibliographicCode ?? e.code)
        .toList();
  }

  static List<String> getLanguages() {
    return NaturalLanguage.list.map((e) => e.name).toList();
  }
}
