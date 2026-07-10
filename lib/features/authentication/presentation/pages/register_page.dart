import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _deptController = TextEditingController();
  UserRole _selectedRole = UserRole.employee;
  TicketCategory _selectedCategory = TicketCategory.general;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onTapUpOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                onTapUpOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.badge)),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role.name.toUpperCase()));
                }).toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
              const SizedBox(height: 16),
              if (_selectedRole == UserRole.agent)
                DropdownButtonFormField<TicketCategory>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Select Specialization',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: TicketCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                )
              else
                TextFormField(
                  controller: _deptController,
                  decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.business)),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              const SizedBox(height: 32),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  } else if (state is Authenticated) {
                    switch (state.user.role) {
                      case UserRole.employee:
                        context.go('/employee');
                        break;
                      case UserRole.agent:
                        context.go('/support');
                        break;
                      case UserRole.manager:
                        context.go('/manager');
                        break;
                    }
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) return const Center(child: CircularProgressIndicator());
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().register(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          name: _nameController.text.trim(),
                          role: _selectedRole,
                          department: _selectedRole == UserRole.agent 
                              ? _selectedCategory.name 
                              : _deptController.text.trim(),
                        );
                      }
                    },
                    child: const Text('Register'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
