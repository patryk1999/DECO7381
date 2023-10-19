import 'dart:convert';
import 'package:abacusfrontend/components/app_bar.dart';
import 'package:abacusfrontend/pages/homeScreen.dart';
import 'package:abacusfrontend/pages/runScreen.dart';
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
      WebSocketChannel.connect(Uri.parse('wss://deco-websocket.onrender.com'));
  bool _offer = false;
  ValueNotifier<bool> _recievedOffer = ValueNotifier<bool>(false);

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
      },
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localVideoRenderer.srcObject = stream;
    return stream;
  }

  _createPeerConnection() async {
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

    // Replace addStream with addTrack
    _localStream!.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

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
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    _offer = true;
    channel.sink.add(json.encode({
      'message': {'type': 'offer', 'message': json.encode(session)}
    }));
    _peerConnection!.setLocalDescription(description);
    print("offer hello");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RunScreen(),
        ));
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    channel.sink.add(json.encode({
      'message': {'type': 'answer', 'message': json.encode(session)}
    }));
    _peerConnection!.setLocalDescription(description);
    print("answer");
  }

  void initChannel() {
    channel.stream.listen((event) async {
      print(_offer.toString() + _recievedOffer.toString());
      var data = await jsonDecode(event);
      var type = data['type'];
      var message = data['message'];

      if (!_offer && type == 'offer' && !_recievedOffer.value) {
        _recievedOffer.value = true;
        var decoded = await jsonDecode(message);
        String sdp = write(decoded, null);
        RTCSessionDescription description = RTCSessionDescription(sdp, type);
        await _peerConnection!.setRemoteDescription(description);
      } else if (_offer == true && type == 'answer') {
        _recievedOffer.value = true;
        var decoded = await jsonDecode(message);
        String sdp = write(decoded, null);
        RTCSessionDescription description = RTCSessionDescription(sdp, type);
        await _peerConnection!.setRemoteDescription(description);
      } else if (type == 'candidate' && _recievedOffer == true) {
        dynamic candidate = RTCIceCandidate(
            message['candidate'], message['sdpMid'], message['sdpMlineIndex']);
        print('adding candidate');
        await _peerConnection!.addCandidate(candidate);
      }
    });
  }

  @override
  void initState() {
    initChannel();
    initRenderer();
    _createPeerConnection().then((pc) {
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
    TextButton firstButton = TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF78BC3F),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: const Icon(Icons.arrow_back),
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Start run',
        firstButton: firstButton,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: videoRenderers()),
          ValueListenableBuilder<bool>(
            valueListenable: _recievedOffer,
            builder: (context, showFirst, child) {
              return Text(!showFirst
                  ? 'Wait, the runner is getting ready'
                  : 'The runner is ready!');
            },
          ),
          Expanded(
            child: Container(),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _recievedOffer.value ? _createAnswer : _createOffer,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF78BC3F)),
              child: _recievedOffer.value
                  ? const Text("Start run")
                  : const Text("Create run"),
            ),
          ),
        ],
      ),
    );
  }
}
