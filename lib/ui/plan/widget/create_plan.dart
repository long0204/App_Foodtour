import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../providers/create_plan_notifier.dart';
import 'location_item_card.dart';

class CreatePlanScreen extends ConsumerWidget {
  const CreatePlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPlanState = ref.watch(createPlanNotifierProvider);
    final createPlanNotifier = ref.read(createPlanNotifierProvider.notifier);
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Tạo Kế Hoạch', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade300,
        actions: [
          IconButton(
            onPressed: () async {
              final success = await createPlanNotifier.savePlan();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Lưu kế hoạch thành công!' : 'Lưu kế hoạch thất bại!',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );

              if (success) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save, color: Colors.white),
          )
        ],
      ),
      body: createPlanState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: createPlanState.planName,
                      onChanged: createPlanNotifier.updatePlanName,
                      decoration: const InputDecoration(
                        labelText: 'Tên kế hoạch',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    const Gap(16),
                    GestureDetector(
                      onTap: () =>
                          _selectDateRange(context, createPlanNotifier),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Chọn khoảng thời gian dự kiến',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          controller: TextEditingController(
                            text: createPlanState.selectedDates[0] == null ||
                                    createPlanState.selectedDates[1] == null
                                ? ''
                                : 'Từ ${dateFormatter.format(createPlanState.selectedDates[0]!)} đến ${dateFormatter.format(createPlanState.selectedDates[1]!)}',
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                    const Gap(16),
                    TextFormField(
                      initialValue: createPlanState.budget,
                      onChanged: createPlanNotifier.updateBudget,
                      decoration: const InputDecoration(
                        labelText: 'Kinh phí dự kiến',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(16),
                    TextFormField(
                      initialValue: createPlanState.peopleCount,
                      onChanged: createPlanNotifier.updatePeopleCount,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng người',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(16),
                    const Text('Các điểm đến',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const Gap(8),
                    for (int i = 0; i < createPlanState.locations.length; i++)
                      LocationItemCard(
                        locationItem: createPlanState.locations[i],
                        index: i,
                        removeLocation: () =>
                            createPlanNotifier.removeLocation(i),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: createPlanNotifier.addLocation,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(''),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.green.shade200,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDateRange(
      BuildContext context, CreatePlanNotifier notifier) async {
    final List<DateTime?>? selectedDates = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) {
        return Dialog(
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              selectedDayHighlightColor: Colors.redAccent,
              dayTextStyle: const TextStyle(fontSize: 14),
            ),
            value: notifier.state.selectedDates,
            onValueChanged: (dates) {
              notifier.updateSelectedDates(
                  dates[0], dates.length > 1 ? dates[1] : null);
            },
          ),
        );
      },
    );

    if (selectedDates != null && selectedDates.isNotEmpty) {
      notifier.updateSelectedDates(
          selectedDates[0], selectedDates.length > 1 ? selectedDates[1] : null);
    }
  }
}
