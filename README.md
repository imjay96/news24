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

### โครงสร้างไฟล์โปรเจกต์

1.main.dart
เป็นจุดเริ่มต้นของแอป ใช้กำหนดธีม และเส้นทางของหน้าแอปผ่าน GoRouter เช่น หน้าแรก

2.bookmarkpro.dart
เป็นไฟล์ที่ใช้ Riverpod สำหรับจัดการสถานะการบุ๊คมาร์กข่าว สามารถเพิ่ม ลบ หรือสลับสถานะบุ๊คมาร์กได้ โดยข่าวที่บุ๊คมาร์กไว้จะถูกเก็บใน List ภายใน state

3.models/news_model.dart
เป็นโมเดลข้อมูลของข่าว ใช้เก็บข้อมูลต่าง ๆ ที่ได้จาก API เช่น หัวข้อข่าว ผู้เขียน คำอธิบาย รูปภาพ วันที่เผยแพร่ และหมวดหมู่

4.services/news_api_service.dart
เป็นไฟล์ที่ใช้เรียก API จาก NewsAPI โดยใช้แพ็กเกจ Dio โดยมีสองฟังก์ชันหลักคือ
fetchnews: สำหรับโหลดข่าวรายหมวดหมู่
searchNews: สำหรับค้นหาข่าวจากคำค้นที่ผู้ใช้ป้อน

5.homescreen.dart: หน้าแรกของแอป

6.search.dart: หน้าค้นหาข่าว

7.news.dart: หน้าแสดงรายละเอียดของข่าวที่ผู้ใช้เลือก

8.bookmark.dart: หน้าบุ๊คมาร์ก

9.title.dart
เป็นวิดเจ็ตที่ใช้แสดงรายการข่าวในรูปแบบtileพร้อมรูปภาพ หัวข้อข่าว ผู้เขียน หมวดหมู่ และวันที่

### วิธีใช้ API แต่ละตัว

ใช้ NewsAPI ในการดึงข่าว ใช้ฟังก์ชันหลักสองตัวคือ fetchnews สำหรับดึงข่าวตามหมวดหมู่ และ searchNews สำหรับค้นหาข่าวโดยใช้คำค้น โดยจะส่งค่าต่าง ๆ เช่น category, query, page และ pageSize ไปกับพารามิเตอร์ ตัวอย่างเช่น ถ้าจะดึงข่าวเทคโนโลยีหน้าแรก จะส่ง category เป็น technology, page เป็น 1 และ pageSize เป็น 50

### วิธีจัดการ pagination

จัดการแบบแบ่งหน้า ใช้ page และ pageSize เมื่อเลื่อนหน้าจอลงจนสุด ระบบจะโหลดหน้าถัดไป และถ้าโหลดครบหมดแล้วก็จะแจ้งว่าno more data

### วิธีใช้ SmartRefresher เพื่อ refresh และ load more

ใช้แพ็กเกจ pull_to_refresh เพื่อให้สามารถดึงหน้าจอลงเพื่อโหลดข่าวใหม่ หรือเลื่อนลงเพื่อโหลดข่าวเพิ่มเติมได้ โดยมีการกำหนดฟังก์ชัน onRefresh สำหรับรีเฟรช และ onLoading สำหรับโหลดเพิ่ม

### ถ้าใช้ GoRouter หรือ Riverpod ให้อธิบายด้วยว่าใช้อย่างไร

ใช้ GoRouter ในการจัดการเส้นทางระหว่างหน้าต่างๆ เช่น หน้าแรก,หน้ารายละเอียดข่าว และหน้าบุ๊คมาร์ก โดยกำหนดเส้นทางไว้ใน main.dart และใช้การส่งค่าnews ไปแสดงรายละเอียดในอีกหน้า

Riverpod ใช้สำหรับจัดการบุ๊คมาร์กข่าว โดยสร้างตัวแปร bookmarkProvider เพื่อเก็บรายการข่าวที่ผู้ใช้บันทึกไว้ ทำให้สามารถกดเพิ่มหรือลบบุ๊คมาร์กได้จากทุกหน้า และสถานะจะอัปเดตอัตโนมัติ
