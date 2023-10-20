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
  final localVideoRenderer = RTCVideoRenderer();
  final remoteVideoRenderer = RTCVideoRenderer();
  final sdpController = TextEditingController();
  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://deco-websocket.onrender.com'));
  final ValueNotifier<bool> _offer = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _recievedOffer = ValueNotifier<bool>(false);
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  initRenderer() async {
    await localVideoRenderer.initialize();
    await remoteVideoRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };
    // if (WebRTC.platformIsIOS) {
    //   mediaConstraints['video'] = {'deviceId': 'broadcast'};
    // }
    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    setState(() {
      localVideoRenderer.srcObject = stream;
    });

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

      setState(() {
        remoteVideoRenderer.srcObject = stream;
      });
    };

    return pc;
  }

  void _create() async {
    if (_recievedOffer.value && !_offer.value) {
      print('creating answer');
      _offer.value = true;
      RTCSessionDescription description =
          await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});
      var session = parse(description.sdp.toString());
      channel.sink.add(json.encode({
        'message': {'type': 'answer', 'message': json.encode(session)}
      }));
      _peerConnection!.setLocalDescription(description);
    } else if (!_offer.value && !_recievedOffer.value) {
      print('creating offer');
      RTCSessionDescription description =
          await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
      var session = parse(description.sdp.toString());
      _offer.value = true;
      channel.sink.add(json.encode({
        'message': {'type': 'offer', 'message': json.encode(session)}
      }));
      _peerConnection!.setLocalDescription(description);
    }
  }

  void initChannel() {
    channel.stream.listen((event) async {
      print(_offer.toString() + _recievedOffer.value.toString());
      var data = await jsonDecode(event);
      var type = data['type'];
      var message = data['message'];

      if (!_offer.value && type == 'offer' && !_recievedOffer.value) {
        print('listen offer');
        _offer.value = true;
        _recievedOffer.value = true;
        var decoded = await jsonDecode(message);
        String sdp = write(decoded, null);
        RTCSessionDescription description = RTCSessionDescription(sdp, type);
        await _peerConnection!.setRemoteDescription(description);
      } else if (_offer == true && type == 'answer' && !_recievedOffer.value) {
        print('listen answer');
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
    await localVideoRenderer.dispose();
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
              child: RTCVideoView(localVideoRenderer),
            ),
          ),
          Flexible(
            child: Container(
              key: const Key('remote'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(remoteVideoRenderer),
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
          ValueListenableBuilder(
              valueListenable: _offer,
              builder: (context, showFirst, child) {
                return ElevatedButton(
                    onPressed: (!showFirst) ? () => _create() : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF78BC3F)),
                    child: const Text("Ready"));
              }),
          ValueListenableBuilder(
              valueListenable: _recievedOffer,
              builder: (context, showFirst, child) {
                return ElevatedButton(
                    onPressed: (showFirst && _offer.value)
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const RunScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF78BC3F)),
                    child: const Text("Start run"));
              })
        ],
      ),
    );
  }
}
