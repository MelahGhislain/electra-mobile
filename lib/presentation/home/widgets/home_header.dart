import 'package:electra/common/blocs/receipt/receipt_cubit.dart';
import 'package:electra/common/blocs/receipt/receipt_state.dart';
import 'package:electra/core/enums/image_source_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String date;

  const HomeHeader({super.key, required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 ROW 1 — Greeting + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hello $name",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              /// Scan + Avatar pill
              Row(
                children: [
                  BlocBuilder<ReceiptCubit, ReceiptState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          context.read<ReceiptCubit>().pickImage(
                            ImageSourceType.camera,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F2937), // dark pill
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 6),

                  /// 👤 Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: const NetworkImage(
                      "https://i.pravatar.cc/100", // replace if needed
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 🔹 ROW 2 — Date
          Row(
            children: [
              const Text("📅", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 ROW 3 — Headline
          const Text(
            "Take control of\nyour day",
            style: TextStyle(
              fontSize: 34,
              height: 1.15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
