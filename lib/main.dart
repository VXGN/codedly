import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:codedly/features/auth/presentation/providers/auth_provider.dart';
import 'package:codedly/features/auth/presentation/providers/auth_state.dart';

import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    // Initialize dependency injection
    await configureDependencies();

    runApp(
      const ProviderScope(
        child: CodedlyApp(),
      ),
    );
  } catch (e) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: ${e.toString()}'),
          ),
        ),
      ),
    );
  }
}
