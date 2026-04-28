import 'package:electra/domain/usecases/insights/get_insights_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  final GetInsightsUseCase _getInsights;

  InsightsCubit(this._getInsights) : super(const InsightsInitial());

  String _period = 'monthly';
  DateTime _anchorDate = DateTime.now();

  Future<void> load({String? period, DateTime? date}) async {
    _period = period ?? _period;
    _anchorDate = date ?? _anchorDate;

    emit(const InsightsLoading());

    final dateStr =
        '${_anchorDate.year}-${_anchorDate.month.toString().padLeft(2, '0')}-${_anchorDate.day.toString().padLeft(2, '0')}';

    final result = await _getInsights(period: _period, date: dateStr);

    result.fold(
      (failure) => emit(InsightsFailure(failure.message)),
      (insights) => emit(
        InsightsLoaded(
          insights: insights,
          period: _period,
          anchorDate: _anchorDate,
        ),
      ),
    );
  }

  /// Navigate to previous period
  void previousPeriod() {
    final offset = _periodOffset();
    _anchorDate = DateTime(
      _anchorDate.year,
      _anchorDate.month - (offset == 12 ? 12 : 0),
      _anchorDate.day - (offset != 12 ? offset : 0),
    );
    load();
  }

  /// Navigate to next period
  void nextPeriod() {
    final offset = _periodOffset();
    _anchorDate = DateTime(
      _anchorDate.year,
      _anchorDate.month + (offset == 12 ? 12 : 0),
      _anchorDate.day + (offset != 12 ? offset : 0),
    );
    load();
  }

  int _periodOffset() {
    switch (_period) {
      case 'weekly':
        return 7;
      case 'yearly':
        return 12; // used as month offset
      default:
        return 0; // monthly uses month arithmetic directly
    }
  }

  void setPeriod(String period) => load(period: period, date: _anchorDate);
}
