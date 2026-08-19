import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalapp/providers/auth_provider.dart';
import 'package:journalapp/screens/journal_home_screen.dart';
import 'package:journalapp/screens/register_screen.dart';
import 'package:journalapp/screens/widgets/responsive_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
 const LoginScreen({super.key});

 @override
 ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
 final _formKey = GlobalKey<FormState>();
 final TextEditingController _emailEditingController = TextEditingController();
 final TextEditingController _passwordEditingController = TextEditingController();
 bool _isLoading = false;

 Future<void> _submit() async {
   if (!_formKey.currentState!.validate()) return;

   setState(() {
     _isLoading = true;
   });

   try {
     final authService = ref.read(authServiceProvider);
     await authService.signIn(
       _emailEditingController.text.trim(),
       _passwordEditingController.text.trim(),
     );
     Navigator.of(context).pushAndRemoveUntil(
       MaterialPageRoute(builder:(context) => const JournalHomeScreen()),
       (route) => false,
     );
   } catch (e) {
     if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(e.toString())),
       );
     }
   } finally {
     if (mounted) {
       setState(() {
         _isLoading = false;
       });
     }
   }
 }

 @override
 void dispose() {
   _emailEditingController.dispose();
   _passwordEditingController.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: ResponsiveBuilder(
       builder: (context, constraints) {
         final screenWidth = constraints.maxWidth;
         final isDesktop = screenWidth > 900;
         final isTablet = screenWidth > 600 && screenWidth <= 900;
         final isMobile = screenWidth <= 600;

         double getHorizontalPadding() {
           if (isDesktop) return screenWidth * 0.3;
           if (isTablet) return screenWidth * 0.2;
           if (isMobile) return screenWidth * 0.04;
           return 24.0;
         }

         double getFormWidth() {
           if (isDesktop) return 400;
           if (isTablet) return screenWidth * 0.6;
           return screenWidth - 48;
         }

         return Center(
           child: SingleChildScrollView(
             padding: EdgeInsets.symmetric(
               horizontal: getHorizontalPadding(),
             ),
             child: Container(
               width: getFormWidth(),
               padding: EdgeInsets.all(isDesktop ? 32 : 24),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withAlpha(26),
                     spreadRadius: 1,
                     blurRadius: isDesktop ? 10 : 2,
                     offset: const Offset(0, 2),
                   ),
                 ],
               ),
               child: Form(
                 key: _formKey,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Icon(
                       Icons.lock_outlined,
                       size: isDesktop ? 64 : 48,
                       color: Colors.blue,
                     ),
                     const SizedBox(height: 20),
                     TextFormField(
                       controller: _emailEditingController,
                       keyboardType: TextInputType.emailAddress,
                       decoration: const InputDecoration(
                         labelText: 'Email',
                         prefixIcon: Icon(Icons.email_outlined),
                         border: OutlineInputBorder(),
                       ),
                       validator: (value) {
                         if (value == null || value.trim().isEmpty) {
                           return 'Please enter your email.';
                         }
                         final email = value.trim();
                         final emailRegex = RegExp(
                           r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                         );
                         if (!emailRegex.hasMatch(email)) {
                           return 'Please enter a valid email.';
                         }
                         return null;
                       },
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _passwordEditingController,
                       obscureText: true,
                       keyboardType: TextInputType.visiblePassword,
                       decoration: const InputDecoration(
                         labelText: 'Password',
                         prefixIcon: Icon(Icons.lock_outlined),
                         border: OutlineInputBorder(),
                       ),
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Please enter your password.';
                         }
                         if (value.length < 6) {
                           return 'Password must be at least 6 characters.';
                         }
                         return null;
                       },
                     ),
                     SizedBox(height: isDesktop ? 30 : 24),
                     SizedBox(
                       height: isDesktop ? 56 : 48,
                       child: ElevatedButton(
                         onPressed: _isLoading ? null : _submit,
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blue,
                           foregroundColor: Colors.white,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                         child: _isLoading
                             ? const CircularProgressIndicator(color: Colors.white)
                             : Text(
                                 'Login',
                                 style: TextStyle(
                                   fontSize: isDesktop ? 18 : 16,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                       ),
                     ),
                     const SizedBox(height: 12),
                     TextButton(
                       onPressed: _isLoading
                           ? null
                           : () {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => const RegisterScreen(),
                                 ),
                               );
                             },
                       child: const Text('Don\'t have an account? Register'),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         );
       },
     ),
   );
 }
}