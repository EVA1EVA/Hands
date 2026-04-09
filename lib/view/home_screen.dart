import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    // نفترض وجود متغير يحدد نوع المستخدم في الـ Controller
    bool isProvider = authController.userType.value == 'provider';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. الجزء العلوي (App Bar المخصص)
          _buildHeader(context, authController),

          // 2. المحتوى المتغير بناءً على نوع المستخدم
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isProvider ? _buildProviderDashboard() : _buildSeekerHome(),
            ),
          ),
        ],
      ),
    );
  }

  // الـ Header الاحترافي مع التدرج اللوني
  Widget _buildHeader(BuildContext context, AuthController controller) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.tealGradientStart,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.tealGradientStart, AppColors.tealGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60, right: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("أهلاً بك،", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    Text(
                      "أحمد محمد", // سيتغير حسب اسم المستخدم الحقيقي
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 35),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- واجهة طالب الخدمة (Seeker) ---
  Widget _buildSeekerHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "بماذا يمكننا مساعدتك اليوم؟",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 20),
        // عرض الفئات بشكل Grid (8 أيقونات مثلاً)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 0.8,
          ),
          itemCount: 8, // عدد التصنيفات
          itemBuilder: (context, index) {
            return _buildCategoryItem("صيانة", Icons.handyman_rounded);
          },
        ),
      ],
    );
  }

  // --- واجهة مقدم الخدمة (Provider) ---
  Widget _buildProviderDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "طلبات جديدة متاحة لك",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 15),
        // قائمة الطلبات للباك إيند (SC Request)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildRequestCard();
          },
        ),
      ],
    );
  }

  // تصميم أيقونة الفئة
  Widget _buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Icon(icon, color: AppColors.tealGradientStart, size: 30),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  // تصميم بطاقة الطلب للمزود
  Widget _buildRequestCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.build_circle, color: AppColors.accent, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("إصلاح تكييف", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("الموقع: المزة، دمشق", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {}, // لفتح واجهة الـ Offer
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.tealGradientStart),
            child: const Text("تقديم عرض", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}