# Ghi chú sử dụng Mason Brick: feature (GetX + Clean Architecture)

Tài liệu này hướng dẫn nhanh cách dùng brick `feature` để sinh scaffold feature theo Clean Architecture + GetX.

## 1) Mục tiêu
- Chuẩn hóa cấu trúc feature theo Clean Architecture (data, domain, presentation).
- Dùng GetX cho DI (`Bindings`), state (`GetxController`) và điều hướng (`GetPage`).

## 2) Yêu cầu
- Flutter SDK đã cài đặt.
- Mason CLI:
  ```bash
  dart pub global activate mason_cli
  # hoặc
  flutter pub global activate mason_cli
  ```

## 3) Đồng bộ brick trong dự án
Ở thư mục gốc dự án (cùng cấp `mason.yaml`):
```bash
mason get
```

## 4) Tạo feature mới
Ví dụ tạo feature `user_profile` trong scope `private_app_shell`:
```bash
mason make feature --name user_profile --scope private_app_shell
```
Các giá trị `scope` hiện có:
- `private_app_shell`
- `public_app_shell`
- `common`

## 5) Cấu trúc sinh ra
```
lib/feature/<scope>/<feature>/
  data/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  binding/
  logic/
  view/
  widget/
  index.dart
  <feature>_routes.dart
```

- `binding/`: Đăng ký DI theo thứ tự RepositoryImpl -> UseCase -> Controller.
- `logic/`: `GetxController` quản lý state, nhận `UseCase` qua constructor.
- `view/`: `GetView<Controller>` + `Obx` để listen các `Rx` state.
- `domain/`: `Entity`, `Repository` (interface), `UseCase`.
- `data/`: `Model` và `RepositoryImpl` (triển khai `Repository`).
- `index.dart`: Export nhanh các phần trong feature.
- `<feature>_routes.dart`: Khai báo `GetPage` + `Binding`.

## 6) Tích hợp Router (GetX)
Trong `GetMaterialApp`, thêm `pages` từ feature mới. Ví dụ với `user_profile`:
```dart
import 'package:get/get.dart';
import 'package:your_app/feature/private_app_shell/user_profile/user_profile_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        ...UserProfileRoutes.pages,
        // các pages khác
      ],
      initialRoute: UserProfileRoutes.route, // tuỳ chọn
    );
  }
}
```

## 7) Quy ước đặt tên
- `name` nên là snake_case (ví dụ: `user_profile`, `leave_management`).
- Class/method trong template sẽ tự chuyển sang `PascalCase`/`camelCase` theo Mustache helpers.

## 8) Gợi ý mở rộng
- Thêm `data sources` (REST, GraphQL, Local) vào `data/` và inject vào `RepositoryImpl`.
- Chuẩn hoá `Model`/`Entity` mapping theo nhu cầu thực tế.

## 9) Lưu ý
- Dự án đã cấu hình analyzer exclude `bricks/**` trong `analysis_options.yaml` để tránh lint vào file template Mustache.
- Template GetX dùng `Get.lazyPut` cho DI. Bạn có thể đổi sang `put`/`putAsync`/`fenix: true` tùy chiến lược lifecycle.

## 10) Troubleshooting
- Lỗi `mason` không nhận lệnh: đảm bảo đã activate Mason CLI và thêm `pub cache bin` vào PATH.
- Không thấy brick: chạy lại `mason get` ở thư mục gốc dự án (có `mason.yaml`).
- Tên feature sai định dạng: dùng `--name` là snake_case để đường dẫn và helper hoạt động đúng.
