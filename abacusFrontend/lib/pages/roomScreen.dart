import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomState();
}

class _RoomState extends State<RoomScreen> {
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  final sdpController = TextEditingController();
  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:8000/3/'));
  bool _offer = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  initRenderer() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localVideoRenderer.srcObject = stream;
    return stream;
  }

  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        channel.sink.add(json.encode({
          'message': {
            'type': 'candidate',
            'message': {
              'candidate': e.candidate.toString(),
              'sdpMid': e.sdpMid.toString(),
              'sdpMlineIndex': e.sdpMLineIndex,
            }
          }
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      _remoteVideoRenderer.srcObject = stream;
    };

    return pc;
  }

  void _createOffer() async {
    print('gere');
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    print('lere');
    var session = parse(description.sdp.toString());
    print(session);
    _offer = true;
    channel.sink.add(json.encode({
      'message': {'type': 'offer', 'message': json.encode(session)}
    }));
    _peerConnection!.setLocalDescription(description);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp.toString());
    print(json.decode(json.encode(session)));
    channel.sink.add(json.encode({
      'message': {'type': 'answer', 'message': json.encode(session)}
    }));
    _peerConnection!.setLocalDescription(description);
  }

  void _setRemoteDescription() async {
    String jsonString = sdpController.text;
    //print('string' + jsonString);
    dynamic session = await jsonDecode(jsonString);
    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection!.setRemoteDescription(description);
  }

  void _addCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);
    print(session['candidate']);
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection!.addCandidate(candidate);
  }

  void initChannel() {
    channel.stream.listen((event) async {
      //print('channel');
      var data = await jsonDecode(event);
      //print(data);
      var type = data['type'];
      var message = data['message'];
      if (_offer == false && type == 'offer') {
        var decoded = await jsonDecode(message);
        String sdp = write(decoded, null);
        RTCSessionDescription description = RTCSessionDescription(sdp, type);
        print(description.toMap());
        await _peerConnection!.setRemoteDescription(description);
      } else if (_offer == true && type == 'answer') {
        var decoded = await jsonDecode(message);
        String sdp = write(decoded, null);
        RTCSessionDescription description = RTCSessionDescription(sdp, type);
        print(description.toMap());
        await _peerConnection!.setRemoteDescription(description);
      } else if (type == 'candidate' && _peerConnection != null) {
        print('candidate here');
        print(message);
        dynamic candidate = RTCIceCandidate(
            message['candidate'], message['sdpMid'], message['sdpMlineIndex']);
        await _peerConnection!.addCandidate(candidate);
      }
    });
  }

  @override
  void initState() {
    initChannel();
    initRenderer();
    _createPeerConnecion().then((pc) {
      _peerConnection = pc;
    });
    super.initState();
  }

  @override
  void dispose() async {
    await _localVideoRenderer.dispose();
    sdpController.dispose();
    channel.sink.close();
    channel.stream.drain();
    super.dispose();
  }

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Row(children: [
          Flexible(
            child: Container(
              key: const Key('local'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localVideoRenderer),
            ),
          ),
          Flexible(
            child: Container(
              key: const Key('remote'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_remoteVideoRenderer),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        videoRenderers(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: sdpController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  maxLength: TextField.noMaxLength,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _createOffer,
                  child: const Text("Offer"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _createAnswer,
                  child: const Text("Answer"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _setRemoteDescription,
                  child: const Text("Set Remote Description"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _addCandidate,
                  child: const Text("Set Candidate"),
                ),
              ],
            )
          ],
        ),
      ],
    ));
  }
}
