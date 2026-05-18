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
    _anchorDate = _shift(-1);
    load();
  }

  /// Navigate to next period
  void nextPeriod() {
    _anchorDate = _shift(1);
    load();
  }

  /// Shift the anchor date by [direction] (+1 forward, -1 backward).
  DateTime _shift(int direction) {
    switch (_period) {
      case 'weekly':
        return _anchorDate.add(Duration(days: 7 * direction));
      case 'yearly':
        return DateTime(
          _anchorDate.year + direction,
          _anchorDate.month,
          _anchorDate.day,
        );
      case 'monthly':
      default:
        return DateTime(
          _anchorDate.year,
          _anchorDate.month + direction,
          _anchorDate.day,
        );
    }
  }

  void setPeriod(String period) => load(period: period, date: DateTime.now());
}
