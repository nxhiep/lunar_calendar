## 1.2.1

- Fix bug not show full day of the month

## 1.2.0

- Fix onTodayPressed not call onDateSelected

## 1.1.3

- Tự động tính maxWidth

## 1.1.2

- Update docs

## 1.1.0

### Tính năng mới
- Thêm widget LunarCalendarPicker cho phép chọn ngày dễ dàng
- Hỗ trợ hiển thị theo định dạng âm lịch hoặc dương lịch
- Tùy chỉnh text và icon hiển thị cho LunarCalendarPicker
- Bottom sheet picker tích hợp với LunarCalendar

### Cải tiến
- Cập nhật callback onDateSelected để trả về cả ngày âm lịch và dương lịch
- Tối ưu hóa hiệu suất khi chuyển đổi giữa các tháng
- Cải thiện giao diện người dùng cho bottom sheet picker

### Sửa lỗi
- Sửa lỗi hiển thị ngày âm lịch không chính xác trong một số trường hợp
- Sửa lỗi định dạng ngày khi sử dụng dateFormat tùy chỉnh
- Sửa lỗi không cập nhật lại ngày khi thay đổi theme

## 1.0.0

### Tính năng
- Hiển thị lịch âm dương với chế độ xem theo tháng
- Hỗ trợ điều hướng giữa các tháng bằng nút hoặc vuốt
- Đánh dấu ngày hiện tại và ngày được chọn
- Tùy chọn hiển thị/ẩn ngày của tháng khác
- Nút quay về ngày hiện tại
- Hỗ trợ đa ngôn ngữ (Tiếng Việt và Tiếng Anh)

### Quản lý sự kiện
- Hiển thị sự kiện theo ngày được chọn
- Hỗ trợ 6 loại sự kiện với biểu tượng riêng:
  - Sinh nhật (🎂)
  - Cuộc họp (👥)
  - Ngày lễ (🎉)
  - Nhắc nhở (🔔)
  - Công việc (✓)
  - Kỷ niệm (❤️)
- Hỗ trợ cả ngày âm lịch và dương lịch
- Tùy chọn lặp lại sự kiện theo năm hoặc tháng

### Tùy biến giao diện
- Theme tùy chỉnh với nhiều thuộc tính:
  - Màu sắc chủ đạo
  - Màu nền
  - Màu chữ
  - Màu cho ngày cuối tuần
  - Font size
- Tùy chỉnh chiều rộng tối đa của calendar
- Hỗ trợ chế độ sáng/tối

