# Leave Request Detail - Refactored Structure

## Tổng quan
File `leave_request_detail_screen.dart` ban đầu có hơn 1600 dòng code, chứa cả logic và UI trong một file duy nhất. Đã được refactor thành cấu trúc modular để dễ bảo trì và tái sử dụng.

## Cấu trúc mới

### 1. Controller Layer
- **`controller/leave_request_detail_controller.dart`**
  - Xử lý tất cả logic business
  - Load API data, xử lý myId, approve/reject
  - Quản lý state (loading, data, permissions)
  - Tách biệt hoàn toàn khỏi UI

### 2. UI Components
- **`widget/leave_request_header_section.dart`**
  - Hiển thị thông tin chính: status, employee info, quick stats
  - Có thể tái sử dụng cho các màn hình khác

- **`widget/leave_request_attachment_card.dart`**
  - Hiển thị danh sách file đính kèm
  - Xử lý preview ảnh và download
  - Tách biệt logic download thành service

- **`widget/leave_request_workflow_card.dart`**
  - Hiển thị quy trình duyệt
  - Sử dụng lại WorkflowList component có sẵn

### 3. Service Layer
- **`service/attachment_download_service.dart`**
  - Xử lý download và lưu file attachments
  - Hỗ trợ cả ảnh (lưu vào gallery) và file khác
  - Singleton pattern để tái sử dụng

- **`service/image_gallery_service.dart`**
  - Xử lý hiển thị image gallery
  - Sử dụng PhotoView để zoom/pan ảnh
  - Singleton pattern

### 4. Dialog Components
- **`widget/leave_request_dialogs.dart`**
  - Tập trung tất cả dialog components
  - Permission dialog, download success dialog, loading dialog
  - Static methods để dễ sử dụng

### 5. Main Screen
- **`view/leave_request_detail_screen.dart`**
  - Chỉ chứa UI layout và kết nối với controller
  - Sử dụng các widget components
  - Gọn gàng, dễ đọc (từ 1600+ dòng xuống ~230 dòng)

## Lợi ích của cấu trúc mới

### ✅ Dễ đọc và bảo trì
- Mỗi file có trách nhiệm rõ ràng
- Code ngắn gọn, dễ hiểu
- Dễ tìm và sửa lỗi

### ✅ Dễ test
- Logic riêng có thể viết unit test
- UI components có thể viết widget test
- Services có thể test độc lập

### ✅ Tái sử dụng
- HeaderSection có thể dùng cho màn hình khác
- AttachmentCard có thể dùng cho các loại attachment khác
- WorkflowCard có thể dùng cho các workflow khác
- Services có thể dùng cho các tính năng khác

### ✅ Tách biệt concerns
- UI chỉ lo hiển thị
- Controller chỉ lo logic
- Service chỉ lo xử lý dữ liệu
- Dialog chỉ lo tương tác

## Cách sử dụng

### Import và sử dụng controller
```dart
final controller = Get.put(LeaveRequestDetailController());
```

### Sử dụng UI components
```dart
LeaveRequestHeaderSection(
  leave: controller.leave,
  getStatusColor: controller.getStatusColor,
)
```

### Sử dụng services
```dart
final downloadService = AttachmentDownloadService();
final result = await downloadService.downloadAttachment(attachment, context);
```

### Sử dụng dialogs
```dart
LeaveRequestDialogs.showDownloadSuccessDialog(context, fileName, filePath);
```

## Migration Guide

### Từ code cũ sang mới:
1. **Logic**: Chuyển từ StatefulWidget sang GetX Controller
2. **UI**: Tách thành các widget components riêng
3. **Download**: Sử dụng AttachmentDownloadService thay vì inline code
4. **Gallery**: Sử dụng ImageGalleryService thay vì inline code
5. **Dialogs**: Sử dụng LeaveRequestDialogs thay vì inline showDialog

### Breaking Changes:
- Class name vẫn giữ nguyên `ListoffDetail` để không ảnh hưởng routing
- API interface không thay đổi
- UI/UX giữ nguyên

## Testing

### Unit Tests
- Test controller logic
- Test service methods
- Test utility functions

### Widget Tests
- Test individual UI components
- Test dialog interactions
- Test responsive behavior

### Integration Tests
- Test full screen flow
- Test API integration
- Test file download functionality
