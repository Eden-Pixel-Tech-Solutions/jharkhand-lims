import React, { useState, useRef, useLayoutEffect } from 'react';
import {
  View, Text, TouchableOpacity, Image,
  StyleSheet, ActivityIndicator, Alert, ScrollView,
  useWindowDimensions,
} from 'react-native';
import * as SecureStore from 'expo-secure-store';
import * as Print from 'expo-print';
import { apiFetch } from '../api';

function esc(s) {
  return String(s || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function makeLabelHTML({ patient_name, sample_id, short_id, test_name, test_code, barcode_base64 }) {
  const patient = esc((patient_name || '—').slice(0, 30));
  const sid     = esc(short_id  || '—');
  const fullId  = esc(sample_id || '—');
  const tcode   = esc(test_code || '');
  const tname   = esc((test_name || '').slice(0, 22));

  return `<!DOCTYPE html><html><head>
<meta charset="utf-8">
<meta name="viewport" content="width=210,initial-scale=1">
<style>
  @page{size:50mm 25mm;margin:0}
  *{margin:0;padding:0;box-sizing:border-box}
  body{width:210px;background:#fff;font-family:'Courier New',Courier,monospace;color:#000;padding:3px 6px;}
  .row1{display:flex;justify-content:space-between;align-items:center;padding-bottom:2px;border-bottom:1px solid #ccc;margin-bottom:2px;}
  .pt{font-size:9px;font-weight:900;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:130px;}
  .br{font-size:6px;font-weight:900;color:#fff;background:#1e3a8a;padding:1px 5px;border-radius:3px;white-space:nowrap;letter-spacing:0.5px;}
  .bcimg{display:block;width:198px;height:44px;max-height:44px;object-fit:contain;}
  .row3{display:flex;justify-content:space-between;align-items:center;margin-top:2px;}
  .si{font-size:9px;font-weight:900;letter-spacing:1.5px;}
  .tc{font-size:7px;font-weight:900;color:#1e3a8a;border:1px solid #1e3a8a;padding:0px 4px;border-radius:3px;}
  .fl{font-size:5.5px;color:#555;margin-top:2px;letter-spacing:0.3px;}
</style></head><body>
  <div class="row1">
    <span class="pt">${patient}</span>
    <span class="br">Meril LIMS</span>
  </div>
  ${barcode_base64 ? `<img class="bcimg" src="${barcode_base64}" />` : `<div style="height:44px;text-align:center;font-size:7px;color:#aaa;line-height:44px;">No barcode</div>`}
  <div class="row3">
    <span class="si">${sid}</span>
    ${tcode ? `<span class="tc">${tcode}</span>` : ''}
  </div>
  <div class="fl">ID: ${fullId}</div>
</body></html>`;
}

export default function SampleDetailScreen({ route, navigation }) {
  const { sample } = route.params;
  const { width } = useWindowDimensions();
  const isTablet = width >= 600;

  const alreadyCollected =
    sample.status === 'Collected' || sample.status === 'In Progress' ||
    sample.status === 'Test Done'  || sample.status === 'Completed';

  const [acknowledging, setAcknowledging] = useState(false);
  const [acknowledged, setAcknowledged]   = useState(alreadyCollected);
  const [shortId, setShortId]   = useState(sample.short_id  || null);
  const [sampleId, setSampleId] = useState(sample.sample_id || null);
  const [barcodeUri, setBarcodeUri]       = useState(null);
  const [loadingBarcode, setLoadingBarcode] = useState(false);

  const handlePrintRef = useRef(null);

  useLayoutEffect(() => {
    navigation.setOptions({
      headerRight: acknowledged
        ? () => (
          <TouchableOpacity
            onPress={() => handlePrintRef.current?.()}
            style={styles.headerPrintBtn}
          >
            <Text style={[styles.headerPrintText, { fontSize: isTablet ? 15 : 13 }]}>
              Print Label
            </Text>
          </TouchableOpacity>
        )
        : undefined,
    });
  }, [navigation, acknowledged, isTablet]);

  const handleAcknowledge = async () => {
    setAcknowledging(true);
    try {
      const token    = await SecureStore.getItemAsync('hims_token');
      const userId   = await SecureStore.getItemAsync('user_id');
      const branchId = await SecureStore.getItemAsync('branch_id');

      let newSampleId = sample.sample_id;
      let newShortId  = sample.short_id;

      if (!newSampleId) {
        const genData = await apiFetch('/api/lab/generate-sample-id', {
          method: 'POST',
          body: JSON.stringify({
            branch_id:  branchId || '1',
            department: sample.category_name || sample.department || 'Laboratory',
          }),
        });
        if (genData.success) {
          newSampleId = genData.sampleId;
          newShortId  = genData.shortId;
        }
      }

      const data = await apiFetch('/api/lab/acknowledge-test', {
        method: 'POST',
        body: JSON.stringify({
          bill_item_id: sample.bill_item_id,
          sample_id:    newSampleId,
          short_id:     newShortId,
          status:       'Collected',
          collected_by: userId ? parseInt(userId, 10) : null,
        }),
      }, token);

      if (data.success) {
        setShortId(data.short_id   || newShortId);
        setSampleId(data.sample_id || newSampleId);
        setAcknowledged(true);
      } else {
        Alert.alert('Error', data.message || 'Acknowledgement failed.');
      }
    } catch {
      Alert.alert('Error', 'Could not connect to server.');
    } finally {
      setAcknowledging(false);
    }
  };

  const handleLoadBarcode = async () => {
    const resolvedShortId  = shortId  || sample.short_id;
    const resolvedSampleId = sampleId || sample.sample_id;
    if (!resolvedShortId) return;
    setLoadingBarcode(true);
    try {
      const token = await SecureStore.getItemAsync('hims_token');
      const data  = await apiFetch(
        `/api/barcodes/sample/${encodeURIComponent(resolvedShortId)}?full_id=${encodeURIComponent(resolvedSampleId || resolvedShortId)}`,
        {},
        token,
      );
      if (data.success) setBarcodeUri(data.barcodeBase64);
      else Alert.alert('Error', 'Could not load barcode.');
    } catch {
      Alert.alert('Error', 'Could not connect to server.');
    } finally {
      setLoadingBarcode(false);
    }
  };

  const handlePrint = async () => {
    const resolvedSampleId = sampleId || sample.sample_id || '—';
    const resolvedShortId  = shortId  || sample.short_id  || '—';
    try {
      let barcode_base64 = barcodeUri || null;
      if (!barcode_base64) {
        try {
          const token = await SecureStore.getItemAsync('hims_token');
          const barcodeData = await apiFetch(
            `/api/barcodes/sample/${encodeURIComponent(resolvedShortId)}?full_id=${encodeURIComponent(resolvedSampleId)}`,
            {},
            token,
          );
          if (barcodeData.success) barcode_base64 = barcodeData.barcodeBase64;
        } catch {
          // print without barcode if fetch fails
        }
      }

      const html = makeLabelHTML({
        patient_name: sample.patient_name,
        sample_id:    resolvedSampleId,
        short_id:     resolvedShortId,
        test_name:    sample.test_name || null,
        test_code:    sample.test_code || null,
        barcode_base64,
      });
      await Print.printAsync({ 
        html,
        width: 141.7, // 50mm in points (50 / 25.4 * 72)
        height: 70.9, // 25mm in points (25 / 25.4 * 72)
        orientation: Print.Orientation.landscape,
        margins: { top: 0, bottom: 0, left: 0, right: 0 }
      });
    } catch (err) {
      Alert.alert('Print Error', err.message || 'Print failed.');
    }
  };

  handlePrintRef.current = handlePrint;

  const resolvedSampleId = sampleId || sample.sample_id;
  const resolvedShortId  = shortId  || sample.short_id;
  const pad = isTablet ? 24 : 16;

  return (
    <ScrollView style={styles.container} contentContainerStyle={{ paddingBottom: 48 }}>
      <View style={[styles.inner, { padding: pad, maxWidth: isTablet ? 800 : undefined, alignSelf: isTablet ? 'center' : 'stretch', width: '100%' }]}>

        {/* Patient Info Card */}
        <View style={styles.card}>
          <View style={styles.cardHeader}>
            <Text style={[styles.cardHeaderText, { fontSize: isTablet ? 12 : 11 }]}>PATIENT INFO</Text>
            <View style={[styles.statusBadge, acknowledged ? styles.badgeGreen : styles.badgePending]}>
              <View style={[styles.statusDot, acknowledged ? styles.dotGreen : styles.dotBlue]} />
              <Text style={[styles.statusText, acknowledged ? styles.textGreen : styles.textBlue, { fontSize: isTablet ? 13 : 12 }]}>
                {acknowledged ? 'Collected' : sample.status || 'Pending'}
              </Text>
            </View>
          </View>

          <View style={[styles.cardBody, { padding: isTablet ? 22 : 18 }]}>
            <View style={styles.fullRow}>
              <Text style={[styles.fieldKey, { fontSize: isTablet ? 12 : 11 }]}>Patient Name</Text>
              <Text style={[styles.patientNameVal, { fontSize: isTablet ? 24 : 20 }]}>{sample.patient_name}</Text>
            </View>

            <View style={styles.grid}>
              <View style={styles.gridCell}>
                <Text style={[styles.fieldKey, { fontSize: isTablet ? 12 : 11 }]}>Test</Text>
                <Text style={[styles.fieldVal, { fontSize: isTablet ? 15 : 14 }]} numberOfLines={2}>{sample.test_name || '—'}</Text>
              </View>
              <View style={styles.gridCell}>
                <Text style={[styles.fieldKey, { fontSize: isTablet ? 12 : 11 }]}>Tube Type</Text>
                <Text style={[styles.fieldVal, { fontSize: isTablet ? 15 : 14 }]}>{sample.tube_color || '—'}</Text>
              </View>
              {sample.test_code ? (
                <View style={styles.gridCell}>
                  <Text style={[styles.fieldKey, { fontSize: isTablet ? 12 : 11 }]}>Test Code</Text>
                  <Text style={[styles.fieldVal, styles.mono, { fontSize: isTablet ? 15 : 14 }]}>{sample.test_code}</Text>
                </View>
              ) : null}
              {resolvedShortId ? (
                <View style={styles.gridCell}>
                  <Text style={[styles.fieldKey, { fontSize: isTablet ? 12 : 11 }]}>Short Code</Text>
                  <Text style={[styles.fieldVal, styles.mono, styles.shortCode, { fontSize: isTablet ? 22 : 18 }]}>{resolvedShortId}</Text>
                </View>
              ) : null}
            </View>

            {resolvedSampleId ? (
              <View style={styles.sampleIdRow}>
                <Text style={[styles.fieldKey, { fontSize: isTablet ? 12 : 11 }]}>Sample ID</Text>
                <Text style={[styles.fieldVal, styles.mono, styles.sampleIdText, { fontSize: isTablet ? 13 : 12 }]} numberOfLines={2} adjustsFontSizeToFit>
                  {resolvedSampleId}
                </Text>
              </View>
            ) : null}
          </View>
        </View>

        {/* Barcode Card */}
        {acknowledged && (resolvedShortId || resolvedSampleId) ? (
          <View style={styles.card}>
            <View style={styles.cardHeader}>
              <Text style={[styles.cardHeaderText, { fontSize: isTablet ? 12 : 11 }]}>BARCODE</Text>
            </View>
            <View style={[styles.cardBody, { padding: isTablet ? 22 : 18, alignItems: 'center' }]}>
              {barcodeUri ? (
                <Image
                  source={{ uri: barcodeUri }}
                  style={{ width: '100%', height: isTablet ? 80 : 64, resizeMode: 'contain' }}
                />
              ) : (
                <TouchableOpacity
                  style={[styles.loadBarcodeBtn, { paddingVertical: isTablet ? 14 : 11 }]}
                  onPress={handleLoadBarcode}
                  disabled={loadingBarcode}
                  activeOpacity={0.8}
                >
                  {loadingBarcode
                    ? <ActivityIndicator color="#fff" />
                    : <Text style={[styles.loadBarcodeTxt, { fontSize: isTablet ? 15 : 13 }]}>Load Barcode</Text>
                  }
                </TouchableOpacity>
              )}
            </View>
          </View>
        ) : null}

        {/* Acknowledge */}
        {!acknowledged && (
          <TouchableOpacity
            style={[styles.ackButton, { padding: isTablet ? 22 : 18, borderRadius: isTablet ? 16 : 14 }]}
            onPress={handleAcknowledge}
            disabled={acknowledging}
            activeOpacity={0.85}
          >
            {acknowledging
              ? <ActivityIndicator color="#fff" />
              : <Text style={[styles.ackButtonText, { fontSize: isTablet ? 18 : 16 }]}>Mark as Collected</Text>
            }
          </TouchableOpacity>
        )}

      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F0F4FF' },
  inner: {},

  card: {
    backgroundColor: '#fff',
    borderRadius: 16,
    marginBottom: 16,
    overflow: 'hidden',
    shadowColor: '#1e40af',
    shadowOpacity: 0.08,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
    elevation: 4,
  },
  cardHeader: {
    backgroundColor: '#0d2554',
    paddingHorizontal: 18,
    paddingVertical: 12,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  cardHeaderText: { color: '#93c5fd', fontWeight: '800', letterSpacing: 1.5, textTransform: 'uppercase' },
  statusBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 20,
    paddingHorizontal: 10,
    paddingVertical: 4,
    gap: 5,
  },
  badgePending: { backgroundColor: '#DBEAFE' },
  badgeGreen:   { backgroundColor: '#DCFCE7' },
  statusDot:    { width: 6, height: 6, borderRadius: 3 },
  dotBlue:      { backgroundColor: '#2563eb' },
  dotGreen:     { backgroundColor: '#16a34a' },
  statusText:   { fontWeight: '700' },
  textBlue:     { color: '#1d4ed8' },
  textGreen:    { color: '#15803d' },

  cardBody:  {},
  fullRow:   { marginBottom: 14 },
  fieldKey: {
    fontWeight: '700',
    color: '#94a3b8',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: 3,
  },
  patientNameVal: { fontWeight: '900', color: '#0f172a' },

  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12, marginBottom: 12 },
  gridCell: {
    flex: 1,
    minWidth: '44%',
    backgroundColor: '#F8FAFC',
    borderRadius: 10,
    padding: 12,
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  fieldVal:  { fontWeight: '700', color: '#1e293b' },
  mono:      { fontFamily: 'monospace' },
  shortCode: { color: '#2563eb' },

  sampleIdRow: {
    backgroundColor: '#F8FAFC',
    borderRadius: 10,
    padding: 12,
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  sampleIdText: { color: '#475569' },

  ackButton: {
    backgroundColor: '#2563eb',
    alignItems: 'center',
    marginBottom: 16,
    shadowColor: '#2563eb',
    shadowOpacity: 0.3,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 },
    elevation: 4,
  },
  ackButtonText: { color: '#fff', fontWeight: '800' },

  headerPrintBtn: {
    backgroundColor: '#16a34a',
    borderRadius: 8,
    paddingHorizontal: 14,
    paddingVertical: 6,
    marginRight: 4,
  },
  headerPrintText: { color: '#fff', fontWeight: '700' },

  loadBarcodeBtn: {
    backgroundColor: '#2563eb',
    borderRadius: 10,
    paddingHorizontal: 28,
    alignItems: 'center',
    shadowColor: '#2563eb',
    shadowOpacity: 0.25,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 3 },
    elevation: 3,
  },
  loadBarcodeTxt: { color: '#fff', fontWeight: '700' },
});
