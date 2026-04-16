import 'package:electra/presentation/onboading/bloc/onboarding_cubit.dart';
import 'package:electra/presentation/onboading/bloc/onboarding_state.dart';
import 'package:electra/presentation/onboading/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSetupScreen extends StatelessWidget {
  const AccountSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final cubit = context.read<OnboardingCubit>();
                final settings = state.settings;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const Center(
                      child: Icon(Icons.settings,
                          size: 80, color: Colors.white70),
                    ),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        "Account Setup",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Center(
                      child: Text(
                        "We detected your preferences",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B263B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Currency
                          SettingTile(
                            leading: const Icon(Icons.wallet,
                                color: Colors.orange),
                            title: "Currency",
                            subtitle: "Preferred currency for receipts",
                            trailing: DropdownButton<String>(
                              value: settings.currency,
                              dropdownColor: Colors.black,
                              items: ["USD", "EUR", "XAF"]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              onChanged: (val) =>
                                  cubit.changeCurrency(val!),
                            ),
                          ),

                          const Divider(),

                          // Language
                          SettingTile(
                            leading: const Icon(Icons.language,
                                color: Colors.orange),
                            title: "Language",
                            subtitle: "App display language",
                            trailing: DropdownButton<String>(
                              value: settings.language,
                              dropdownColor: Colors.black,
                              items: ["EN", "FR"]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              onChanged: (val) =>
                                  cubit.changeLanguage(val!),
                            ),
                          ),

                          const Divider(),

                          // Account Mode
                          SettingTile(
                            leading: const Icon(Icons.account_balance_wallet,
                                color: Colors.orange),
                            title: "Account Mode",
                            subtitle: "Expenses Only",
                            trailing: Switch(
                              value: settings.expensesOnly,
                              onChanged: (_) => cubit.toggleAccountMode(),
                            ),
                          ),

                          const Divider(),

                          // Budget
                          SettingTile(
                            leading: const Icon(Icons.calculate,
                                color: Colors.orange),
                            title: "Monthly Budget",
                            subtitle: "Optional spending limit",
                            trailing: SizedBox(
                              width: 80,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "0",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                onChanged: (val) => cubit.changeBudget(
                                  double.tryParse(val) ?? 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      onPressed: () {
                        // final data = state.settings;
                      },
                      child: const Text("Next: Notifications"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
