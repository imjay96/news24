# news24

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

โครงสร้างไฟล์โปรเจกต์
lib/
├── main.dart                  // จุดเริ่มต้นแอป
├── models/
│   └── news_model.dart        // โมเดลข้อมูลข่าว
├── screen/
│   ├── home_screen.dart       // หน้าหลัก (หมวดหมู่ข่าว + ข่าว)
│   ├── news.dart              // หน้ารายละเอียดข่าว
│   ├── search.dart            // หน้าค้นหาข่าว
│   └── bookmark.dart          // หน้าจัดการ Bookmark
├── services/
│   └── news_api_service.dart  // ฟังก์ชันเรียก API ข่าว
├── bookmarkpro.dart           // Riverpod provider สำหรับ Bookmark

วิธีใช้ API แต่ละตัว (พร้อมตัวอย่าง query parameter)

วิธีจัดการ pagination

วิธีใช้ SmartRefresher เพื่อ refresh & load more

ถ้าใช้ GoRouter หรือ Riverpod ให้บอกด้วยว่าใช้อย่างไร