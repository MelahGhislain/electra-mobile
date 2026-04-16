import 'package:electra/core/utils/constants/storage_keys.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String code;

  const LanguageState(this.code);

  @override
  List<Object> get props => [code];
}

class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit() : super(const LanguageState('en'));

  void changeLanguage(String code) {
    emit(LanguageState(code));
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    return LanguageState(json[StorageKeys.languageCode]);
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    return {StorageKeys.languageCode: state.code};
  }
}
