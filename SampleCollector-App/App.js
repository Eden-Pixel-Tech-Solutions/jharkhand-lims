import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { StatusBar } from 'expo-status-bar';

import LoginScreen from './src/screens/LoginScreen';
import WorklistScreen from './src/screens/WorklistScreen';
import SampleDetailScreen from './src/screens/SampleDetailScreen';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <StatusBar style="light" />
      <Stack.Navigator
        initialRouteName="Login"
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
