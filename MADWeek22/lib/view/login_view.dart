import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/login_view_model.dart';
import '../view/signup_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 상단 아이콘
              const Icon(
                Icons.directions_bike,
                size: 100,
                color: Colors.teal,
              ),
              const SizedBox(height: 40),

              // 로그인 입력 및 버튼
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // 이메일 입력 필드
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.setEmail,
                    ),
                    const SizedBox(height: 16),

                    // 비밀번호 입력 필드
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      onChanged: viewModel.setPassword,
                    ),
                    const SizedBox(height: 16),

                    // 에러 메시지 출력
                    if (viewModel.errorMessage.isNotEmpty)
                      Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),

                    // 로그인 및 회원가입 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('회원가입'),
                        ),
                        ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                            final success = await viewModel.login();
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login Successful!'),
                                ),
                              );
                              // 로그인 성공 시 HomeView로 이동
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.errorMessage),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // 버튼 배경색 검정
                            foregroundColor: Colors.white, // 버튼 텍스트 색상 흰색
                          ),
                          child: viewModel.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text('로그인'),
                        ),
                      ],
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
