import 'create_plan_notifier.dart';

class CreatePlanState {
  final String planName;
  final String budget;
  final String peopleCount;
  final List<DateTime?> selectedDates;
  final List<LocationItem> locations;
  final bool isLoading;

  CreatePlanState({
    required this.planName,
    required this.budget,
    required this.peopleCount,
    required this.selectedDates,
    required this.locations,
    required this.isLoading,
  });

  factory CreatePlanState.initial() {
    return CreatePlanState(
      planName: '',
      budget: '',
      peopleCount: '',
      selectedDates: [null, null],
      locations: [],
      isLoading: false,
    );
  }

  CreatePlanState copyWith({
    String? planName,
    String? budget,
    String? peopleCount,
    List<DateTime?>? selectedDates,
    List<LocationItem>? locations,
    bool? isLoading,
  }) {
    return CreatePlanState(
      planName: planName ?? this.planName,
      budget: budget ?? this.budget,
      peopleCount: peopleCount ?? this.peopleCount,
      selectedDates: selectedDates ?? this.selectedDates,
      locations: locations ?? this.locations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
