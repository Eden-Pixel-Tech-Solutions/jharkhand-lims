import React, { useState, useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { StatusBar } from 'expo-status-bar';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import * as SecureStore from 'expo-secure-store';

import LoginScreen from './src/screens/LoginScreen';
import WorklistScreen from './src/screens/WorklistScreen';
import SampleDetailScreen from './src/screens/SampleDetailScreen';

const Stack = createNativeStackNavigator();

export default function App() {
  const [initialRoute, setInitialRoute] = useState(null); // null = still checking

  useEffect(() => {
    // On startup, check if a login token is already saved
    SecureStore.getItemAsync('hims_token').then(token => {
      setInitialRoute(token ? 'Worklist' : 'Login');
    }).catch(() => {
      setInitialRoute('Login');
    });
  }, []);

  // Show a minimal splash while we check the token
  if (initialRoute === null) {
    return (
      <View style={styles.splash}>
        <StatusBar style="light" />
        <ActivityIndicator size="large" color="#2563eb" />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <StatusBar style="light" />
      <Stack.Navigator
        initialRouteName={initialRoute}
        screenOptions={{
          headerStyle: { backgroundColor: '#0d2554' },
          headerTintColor: '#fff',
          headerTitleStyle: { fontWeight: '700' },
        }}
      >
        <Stack.Screen name="Login" component={LoginScreen} options={{ headerShown: false }} />
        <Stack.Screen name="Worklist" component={WorklistScreen} options={{ title: 'Sample Queue' }} />
        <Stack.Screen name="SampleDetail" component={SampleDetailScreen} options={{ title: 'Sample Detail' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  splash: {
    flex: 1,
    backgroundColor: '#EFF6FF',
    justifyContent: 'center',
    alignItems: 'center',
  },
});
