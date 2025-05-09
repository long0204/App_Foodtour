import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'create_plan_state.dart';

final createPlanNotifierProvider = StateNotifierProvider<CreatePlanNotifier, CreatePlanState>((ref) {
  return CreatePlanNotifier();
});

class CreatePlanNotifier extends StateNotifier<CreatePlanState> {
  CreatePlanNotifier() : super(CreatePlanState.initial());


  void updatePlanName(String name) {
    state = state.copyWith(planName: name);
  }

  void updateBudget(String budget) {
    state = state.copyWith(budget: budget);
  }

  void updatePeopleCount(String peopleCount) {
    state = state.copyWith(peopleCount: peopleCount);
  }

  void updateSelectedDates(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(selectedDates: [startDate, endDate]);
  }

  void addLocation() {
    state = state.copyWith(
      locations: [...state.locations, LocationItem()],
    );
  }

  void removeLocation(int index) {
    state = state.copyWith(
      locations: List.from(state.locations)
        ..removeAt(index),
    );
  }

  Future<bool> savePlan() async {
    if (state.planName.isNotEmpty &&
        state.selectedDates[0] != null &&
        state.selectedDates[1] != null) {
      try {
        final locationsData = state.locations.map((loc) => {
          'place': loc.placeController.text,
          'duration': loc.durationController.text,
          'cost': loc.costController.text,
        }).toList();

        await FirebaseFirestore.instance.collection('plans').add({
          'name': state.planName,
          'startDate': state.selectedDates[0],
          'endDate': state.selectedDates[1],
          'budget': state.budget,
          'people': state.peopleCount,
          'locations': locationsData,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}



class LocationItem {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  void dispose() {
    placeController.dispose();
    durationController.dispose();
    costController.dispose();
  }
}
