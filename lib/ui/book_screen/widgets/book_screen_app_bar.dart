import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openreads/core/themes/app_theme.dart';
import 'package:openreads/generated/locale_keys.g.dart';
import 'package:openreads/logic/bloc/theme_bloc/theme_bloc.dart';
import 'package:openreads/logic/cubit/current_book_cubit.dart';
import 'package:openreads/logic/cubit/edit_book_cubit.dart';
import 'package:openreads/main.dart';
import 'package:openreads/model/book.dart';
import 'package:openreads/ui/add_book_screen/add_book_screen.dart';

class BookScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookScreenAppBar({super.key});

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;

  _showDeleteRestoreDialog(
    BuildContext context,
    bool deleted,
    bool? deletePermanently,
    Book book,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            title: Text(
              deleted
                  ? deletePermanently == true
                      ? LocaleKeys.delete_perm_question.tr()
                      : LocaleKeys.delete_book_question.tr()
                  : LocaleKeys.restore_book_question.tr(),
              style: const TextStyle(fontSize: 18),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(LocaleKeys.no.tr()),
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (deletePermanently == true) {
                    _deleteBookPermanently(book);
                  } else {
                    _changeDeleteStatus(deleted, book);
                  }

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(LocaleKeys.yes.tr()),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _changeDeleteStatus(bool deleted, Book book) async {
    await bookCubit.updateBook(book.copyWith(
      deleted: deleted,
    ));

    bookCubit.getDeletedBooks();
  }

  _deleteBookPermanently(Book book) async {
    if (book.id != null) {
      await bookCubit.deleteBook(book.id!);
    }

    bookCubit.getDeletedBooks();
  }

  @override
  Widget build(BuildContext context) {
    final moreButtonOptions = [
      LocaleKeys.edit_book.tr(),
    ];

    // Needed to add BlocBuilder because the status bar was changing
    // to different color then in BooksScreen
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final themeMode = (state as SetThemeState).themeMode;

        return AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: themeMode == ThemeMode.system
                ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark
                : themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
          ),
          actions: [
            BlocBuilder<CurrentBookCubit, Book>(
              builder: (context, state) {
                if (moreButtonOptions.length == 1) {
                  if (state.deleted == true) {
                    moreButtonOptions.add(LocaleKeys.restore_book.tr());
                    moreButtonOptions.add(
                      LocaleKeys.delete_permanently.tr(),
                    );
                  } else {
                    moreButtonOptions.add(LocaleKeys.delete_book.tr());
                  }
                }

                return PopupMenuButton<String>(
                  onSelected: (_) {},
                  itemBuilder: (_) {
                    return moreButtonOptions.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                        onTap: () async {
                          context.read<EditBookCubit>().setBook(state);

                          await Future.delayed(const Duration(
                            milliseconds: 0,
                          ));
                          if (!context.mounted) return;

                          if (choice == moreButtonOptions[0]) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddBookScreen(
                                  editingExistingBook: true,
                                ),
                              ),
                            );
                          } else if (choice == moreButtonOptions[1]) {
                            if (state.deleted == false) {
                              _showDeleteRestoreDialog(
                                  context, true, null, state);
                            } else {
                              _showDeleteRestoreDialog(
                                  context, false, null, state);
                            }
                          } else if (choice == moreButtonOptions[2]) {
                            _showDeleteRestoreDialog(
                              context,
                              true,
                              true,
                              state,
                            );
                          }
                        },
                      );
                    }).toList();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
