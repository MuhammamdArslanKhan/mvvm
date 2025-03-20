# Flutter Bloc with CI/CD Deployment

This README provides a basic guide for implementing the Bloc design pattern in a Flutter application and setting up CI/CD with reusable workflows for iOS and Android deployments.

## Bloc Design Pattern Implementation

Bloc (Business Logic Component) is a state management pattern that helps separate business logic from UI in Flutter applications.

### 1. Installation

Add the `flutter_bloc` and `equatable` packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3 # Replace with latest version
  equatable: ^2.0.5 # Replace with latest version
```

Run flutter pub get to install the packages.

### 2. Create Events
Create an events.dart file to define the events that your Bloc will handle:

```import 'package:equatable/equatable.dart';

abstract class MyEvent extends Equatable {
  const MyEvent();

  @override
  List<Object> get props => [];
}

class LoadDataEvent extends MyEvent {}

class UpdateDataEvent extends MyEvent {
  final String newData;

  const UpdateDataEvent(this.newData);

  @override
  List<Object> get props => [newData];
}
```
### 3. Create States
Create a states.dart file to define the states that your Bloc can be in:

```import 'package:equatable/equatable.dart';

abstract class MyState extends Equatable {
  const MyState();

  @override
  List<Object> get props => [];
}

class MyInitialState extends MyState {}

class MyLoadingState extends MyState {}

class MyLoadedState extends MyState {
  final String data;

  const MyLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class MyErrorState extends MyState {
  final String error;

  const MyErrorState(this.error);

  @override
  List<Object> get props => [error];
}
```
### 4. Create the Bloc
Create a bloc.dart file to implement the Bloc logic:
```
import 'package:flutter_bloc/flutter_bloc.dart';
import 'events.dart';
import 'states.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyInitialState()) {
    on<LoadDataEvent>(_onLoadData);
    on<UpdateDataEvent>(_onUpdateData);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<MyState> emit) async {
    emit(MyLoadingState());
    try {
      // Simulate data loading
      await Future.delayed(Duration(seconds: 2));
      emit(MyLoadedState("Sample Data"));
    } catch (e) {
      emit(MyErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateData(UpdateDataEvent event, Emitter<MyState> emit) async {
    emit(MyLoadedState(event.newData));
  }
}
```
### 5. Use the Bloc in UI
Wrap your UI with BlocProvider and use BlocBuilder to react to state changes.
```
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';
import 'states.dart';
import 'events.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('Bloc Example')),
        body: Center(
          child: BlocBuilder<MyBloc, MyState>(
            builder: (context, state) {
              if (state is MyLoadingState) {
                return CircularProgressIndicator();
              } else if (state is MyLoadedState) {
                return Text('Data: ${state.data}');
              } else if (state is MyErrorState) {
                return Text('Error: ${state.error}');
              } else {
                return ElevatedButton(
                  onPressed: () => context.read<MyBloc>().add(LoadDataEvent()),
                  child: Text('Load Data'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
```
## CI/CD with Reusable Workflows
This section outlines how to set up CI/CD using reusable workflows for iOS and Android deployments.
### 1. Setup Secrets
In your GitHub repository, go to "Settings" > "Secrets and variables" > "Actions" and add the following secrets:

### Android:

PLAY_STORE_JSON_KEY: Google Play Store service account JSON key.

KEYSTORE_FILE: Base64 encoded keystore file.

KEYSTORE_PASSWORD: Keystore password.

KEY_ALIAS: Key alias.

KEY_PASSWORD: Key password.

### iOS:

APP_STORE_CONNECT_API_KEY: App Store Connect API key JSON.

CERTIFICATE_P12: Base64 encoded .p12 certificate.

CERTIFICATE_PASSWORD: Certificate password.

PROVISIONING_PROFILE: Base64 encoded provisioning profile.

### 2. Create Reusable Workflows
Create .github/workflows/android-deploy.yml and .github/workflows/ios-deploy.yml with the content provided in the previous responses.

### 3. Create Calling Workflow
Create .github/workflows/deploy-all.yml with the content provided in the previous responses.

### 4. Configure Workflows
Replace placeholders like YourScheme in ios-deploy.yml with your actual Xcode scheme.

Adjust Gradle tasks and paths in android-deploy.yml as needed.

Ensure your ExportOptions.plist exists in the root of your project for iOS deployments.

Make sure to replace the Xcode version inside the ios workflow.
### 5. Commit and Push
Commit and push the workflow files to your repository.

### 6. Trigger Deployment
Push changes to the main branch to trigger the deployment workflow.

### Additional Notes
Remember to replace placeholder values with your project-specific information.

Thoroughly test your workflows in a non-production environment before deploying to production.

Implement proper error handling and logging in your workflows.

Consider adding unit and integration tests to your CI/CD pipeline.

Ensure that your android and ios applications are configured properly inside the respective platforms.
