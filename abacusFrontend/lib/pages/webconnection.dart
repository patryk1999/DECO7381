import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyWebRTCApp extends StatefulWidget {
  const MyWebRTCApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyWebRTCAppState createState() => _MyWebRTCAppState();
}

class _MyWebRTCAppState extends State<MyWebRTCApp> {
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;

  @override
  void initState() {
    super.initState();
    initWebRTC();
  }

  Future<void> initWebRTC() async {
    await WebRTC.initialize();

    final configuration = <String, dynamic>{
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    final offer = await _peerConnection.createOffer({});

    await _peerConnection.setLocalDescription(offer);

    sendOfferToRemotePeer(offer);
  }

  Future<void> sendOfferToRemotePeer(RTCSessionDescription offer) async {
    final url = Uri.parse(
        'http://127.0.0.1:8000/voicechat/send-offer'); // Replace with your server's endpoint
    final headers = {'Content-Type': 'application/json'};
    final body =
        json.encode({'offer': offer.toMap()}); // Convert offer to a JSON map

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Offer sent successfully');
      } else {
        print('Failed to send offer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending offer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebRTC Example'),
      ),
      body: const Center(
        child: Text('WebRTC functionality goes here'),
      ),
    );
  }

  @override
  void dispose() {
    _localStream.dispose();
    _peerConnection.close();
    super.dispose();
  }
}
