import 'package:get/get.dart';
import 'package:tcs_flutter/controllers/base/base_controller.dart';

mixin PaginationMixin<T> on BaseController {
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxList<T> items = <T>[].obs;

  Future<void> fetchPage(int page);

  Future<void> loadNextPage() async {
    if (!hasMore.value || isLoading) return;
    currentPage.value++;
    await fetchPage(currentPage.value);
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMore.value = true;
    items.clear();
  }

  void appendPage(List<T> newItems) {
    if (newItems.isEmpty) {
      hasMore.value = false;
    } else {
      items.addAll(newItems);
    }
  }
}