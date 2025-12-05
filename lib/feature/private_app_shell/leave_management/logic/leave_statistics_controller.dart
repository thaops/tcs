import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_request_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_list_off_usecase.dart';

class LeaveStatisticsController extends GetxController {
  final LeaveManagementRepository repository = LeaveManagementRepository();
  late final GetListOffUseCase _getListOff;

  final RxList<LeaveRequest> todayLeaves = <LeaveRequest>[].obs;
  final RxList<LeaveRequest> upcomingLeaves = <LeaveRequest>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  LeaveStatisticsController() {
    _getListOff = GetListOffUseCase(repository);
  }

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      isLoading.value = true;

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day, 0, 0, 0);

      // Lấy data từ hôm nay đến 7 ngày sau để có đủ data cho "Sắp tới"
      final futureEnd = now.add(const Duration(days: 7));

      final response = await _getListOff.call(todayStart, futureEnd, 1);

      if (response != null) {
        // Filter "Hôm nay": đơn có status == '2', có ngày nghỉ = ngày hiện tại
        todayLeaves.value =
            response.where((leave) {
              if (leave.status != '2') return false;

              final fromDate = leave.fromDate;
              final toDate = leave.toDate;

              if (fromDate == null || toDate == null) return false;

              final fromDateOnly = DateTime(
                fromDate.year,
                fromDate.month,
                fromDate.day,
              );
              final toDateOnly = DateTime(
                toDate.year,
                toDate.month,
                toDate.day,
              );
              final todayOnly = DateTime(now.year, now.month, now.day);

              // Kiểm tra xem ngày hiện tại có nằm trong khoảng từ fromDate đến toDate không
              return (fromDateOnly.isAtSameMomentAs(todayOnly) ||
                  toDateOnly.isAtSameMomentAs(todayOnly) ||
                  (fromDateOnly.isBefore(todayOnly) &&
                      toDateOnly.isAfter(todayOnly)));
            }).toList();

        // Filter "Sắp tới": đơn có status == '2', thời gian nghỉ trong 7 ngày tiếp theo
        final sevenDaysLater = now.add(const Duration(days: 7));
        upcomingLeaves.value =
            response.where((leave) {
                if (leave.status != '2') return false;

                final fromDate = leave.fromDate;
                if (fromDate == null) return false;

                final fromDateOnly = DateTime(
                  fromDate.year,
                  fromDate.month,
                  fromDate.day,
                );
                final todayOnly = DateTime(now.year, now.month, now.day);
                final sevenDaysLaterOnly = DateTime(
                  sevenDaysLater.year,
                  sevenDaysLater.month,
                  sevenDaysLater.day,
                );

                // Ngày nghỉ phải sau hôm nay và trong vòng 7 ngày tới
                return fromDateOnly.isAfter(todayOnly) &&
                    (fromDateOnly.isBefore(sevenDaysLaterOnly) ||
                        fromDateOnly.isAtSameMomentAs(sevenDaysLaterOnly));
              }).toList()
              ..sort((a, b) {
                // Sắp xếp tăng dần theo ngày nghỉ (gần nhất → xa nhất)
                final dateA = a.fromDate ?? DateTime.now();
                final dateB = b.fromDate ?? DateTime.now();
                return dateA.compareTo(dateB);
              });
      }
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
