import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/signup_view_model.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_bike,
                size: 100,
                color: Colors.teal,
              ),
              const SizedBox(height: 40),

              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.setEmail,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      onChanged: viewModel.setPassword,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Checkbox(
                          value: viewModel.locationConsent,
                          onChanged: viewModel.toggleLocationConsent, // 수정된 메서드 연결
                        ),
                        const Text('위치정보 이용에 동의합니다 (필수)'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                        final success = await viewModel.signup();
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Signup Successful!'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // 버튼 배경색 검정
                        foregroundColor: Colors.white, // 텍스트 색 흰색
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text('회원가입'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
