import React, { useState, useCallback } from 'react';
import {
  View, Text, FlatList, TouchableOpacity,
  StyleSheet, ActivityIndicator, Alert, RefreshControl,
} from 'react-native';
import * as SecureStore from 'expo-secure-store';
import { useFocusEffect } from '@react-navigation/native';
import { apiFetch } from '../api';

const TUBE_COLORS = {
  'EDTA': '#9333ea',
  'Purple': '#9333ea',
  'Red': '#ef4444',
  'Blue': '#3b82f6',
  'Green': '#22c55e',
  'Yellow': '#eab308',
  'Grey': '#6b7280',
  'Gray': '#6b7280',
};

function TubeChip({ color }) {
  const bg = TUBE_COLORS[color] || '#64748b';
  return (
    <View style={[styles.tubeChip, { backgroundColor: bg }]}>
      <Text style={styles.tubeChipText}>{color || '—'}</Text>
    </View>
  );
}

export default function WorklistScreen({ navigation }) {
  const [samples, setSamples] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const fetchWorklist = async (isRefresh = false) => {
    if (isRefresh) setRefreshing(true);
    else setLoading(true);
    try {
      const branchId = await SecureStore.getItemAsync('branch_id');
      const token = await SecureStore.getItemAsync('hims_token');
      const data = await apiFetch(
        `/api/lab/worklist?branch_id=${branchId}&status=Pending`,
        {},
        token
      );
      if (data && Array.isArray(data.worklist)) {
        setSamples(data.worklist);
      } else if (data && Array.isArray(data)) {
        setSamples(data);
      }
    } catch {
      Alert.alert('Error', 'Failed to load worklist.');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useFocusEffect(
    useCallback(() => {
      fetchWorklist();
    }, [])
  );

  const handleLogout = async () => {
    await SecureStore.deleteItemAsync('hims_token');
    await SecureStore.deleteItemAsync('branch_id');
    await SecureStore.deleteItemAsync('user_name');
    navigation.replace('Login');
  };

  React.useLayoutEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <TouchableOpacity onPress={handleLogout} style={{ marginRight: 4 }}>
          <Text style={{ color: '#fff', fontSize: 14 }}>Logout</Text>
        </TouchableOpacity>
      ),
    });
  }, [navigation]);

  const renderItem = ({ item }) => (
    <TouchableOpacity
      style={styles.row}
      onPress={() => navigation.navigate('SampleDetail', { sample: item })}
    >
      <View style={styles.rowTop}>
        <Text style={styles.sampleId}>{item.sample_id}</Text>
        <TubeChip color={item.tube_color} />
      </View>
      <Text style={styles.patientName}>{item.patient_name}</Text>
      <Text style={styles.testName}>{item.test_name}</Text>
    </TouchableOpacity>
  );

  if (loading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color="#0d2554" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.countBar}>
        <Text style={styles.countText}>{samples.length} pending sample{samples.length !== 1 ? 's' : ''}</Text>
      </View>
      <FlatList
        data={samples}
        keyExtractor={(item, i) => String(item.bill_item_id || item.sample_id || i)}
        renderItem={renderItem}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => fetchWorklist(true)} />}
        ListEmptyComponent={<Text style={styles.empty}>No pending samples.</Text>}
        contentContainerStyle={samples.length === 0 ? { flex: 1 } : { paddingBottom: 24 }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8fafc' },
  centered: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  countBar: {
    backgroundColor: '#0d2554',
    paddingVertical: 8,
    paddingHorizontal: 16,
  },
  countText: { color: '#93c5fd', fontSize: 13, fontWeight: '600' },
  row: {
    backgroundColor: '#fff',
    marginHorizontal: 12,
    marginTop: 10,
    borderRadius: 12,
    padding: 16,
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  rowTop: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 },
  sampleId: { fontFamily: 'monospace', fontWeight: '700', color: '#0f172a', fontSize: 14 },
  patientName: { fontSize: 16, fontWeight: '700', color: '#1e293b', marginBottom: 2 },
  testName: { fontSize: 13, color: '#64748b' },
  tubeChip: {
    borderRadius: 20,
    paddingHorizontal: 10,
    paddingVertical: 3,
  },
  tubeChipText: { color: '#fff', fontSize: 11, fontWeight: '700' },
  empty: { textAlign: 'center', color: '#94a3b8', marginTop: 80, fontSize: 16 },
});
