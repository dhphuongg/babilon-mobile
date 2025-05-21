import 'dart:async';

import 'package:babilon/presentation/pages/record_video/widgets/list_live_event.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/websocket_event.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/utils/permission.dart';
import 'package:babilon/di.dart';
import 'package:babilon/infrastructure/services/livekit_service.dart';
import 'package:babilon/infrastructure/services/socket_client.service.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => LiveScreenState();
}

class LiveScreenState extends State<LiveScreen> with WidgetsBindingObserver {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<ListLiveEventState> _chatKey =
      GlobalKey<ListLiveEventState>();
  String _avatarUrl = '';
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isBackCamera = false; // Track which camera is active

  bool _isLiving = false;
  bool _isConnecting = false;
  late VideoTrack? _localVideoTrack;
  late Room _room;
  String? _liveId;
  Function? _roomSubscription;

  late UserInfo? _userInfo;

  // load user info from shared preferences
  Future<void> _loadUserInfo() async {
    final user = await SharedPreferencesHelper.getUserInfo();

    setState(() {
      _userInfo = user;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserInfo();
    PermissionUtil.checkCameraPermission(
      () => PermissionUtil.checkMicrophonePermission(
        () => _initCamera(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _titleController.dispose();
    _roomSubscription?.call();
    _disconnectFromRoom();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    await _cameraController?.dispose();
    List<CameraDescription> cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      final CameraDescription cameraDescription = _isBackCamera
          ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            )
          : cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => cameras.last,
            );

      _cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      try {
        await _cameraController!.initialize();

        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null) return;

    setState(() {
      _isCameraInitialized = false;
      _isBackCamera = !_isBackCamera;
    });

    await _cameraController?.dispose();
    await _initCamera();
  }

  Future<void> _setupVideoStream({
    required String liveId,
    required String token,
    required String url,
  }) async {
    await _cameraController?.dispose();

    setState(() {
      _isConnecting = true;
    });

    _room = await LivekitService.broadcasterCreateRoom(
      liveId: liveId,
      token: token,
      url: url,
    );

    final participant = _room.localParticipant;
    if (participant == null) return;

    // Enable camera to ensure we have a video track
    await participant.setCameraEnabled(true);

    // Function to check for the local video track
    void checkForLocalVideoTrack() {
      // Find the local camera video track
      for (final trackPublication in participant.trackPublications.values) {
        if (trackPublication.kind == TrackType.VIDEO &&
            trackPublication.track != null) {
          setState(() {
            _localVideoTrack = trackPublication.track as VideoTrack;
          });
          break;
        }
      }
    }

    // Check immediately in case the track is already published
    checkForLocalVideoTrack();

    // If no track found, listen to room events for track published
    if (_localVideoTrack == null) {
      _room.events.listen((event) {
        if (event is LocalTrackPublishedEvent) {
          if (event.publication.kind == TrackType.VIDEO &&
              event.publication.track != null) {
            setState(() {
              _localVideoTrack = event.publication.track as VideoTrack;
            });
          }
        }
      });

      // Check again after a short delay to ensure we pick up the track
      Future.delayed(Duration(milliseconds: 500), checkForLocalVideoTrack);
    }

    setState(() {
      _isConnecting = false;
      _isLiving = true;
    });

    getIt<SocketClientService>().socket.on(
      WebsocketEvent.USER_JOIN_LIVE,
      (user) {
        _chatKey.currentState?.addEvent(
          LiveEvent(
            text: '${user['username']} đã tham gia live',
            isSystem: true,
            avatar: user['avatar'],
            fullName: user['fullName'],
          ),
        );
      },
    );

    getIt<SocketClientService>().socket.on(
      WebsocketEvent.USER_LEAVE_LIVE,
      (user) {
        _chatKey.currentState?.addEvent(
          LiveEvent(
            text: '${user['username']} đã rời khỏi live',
            isSystem: true,
            avatar: user['avatar'],
            fullName: user['fullName'],
          ),
        );
      },
    );

    getIt<SocketClientService>().socket.on(
      WebsocketEvent.USER_SEND_MESSAGE_TO_LIVE,
      (message) {
        _chatKey.currentState?.addEvent(
          LiveEvent(
            text: message['text'],
            avatar: message['user']['avatar'],
            fullName: message['user']['fullName'],
          ),
        );
      },
    );
  }

  startLive() async {
    final data = {
      'title': _titleController.text,
      'broadcasterId': _userInfo!.userId,
    };
    getIt<SocketClientService>().socket.emitWithAck(
      WebsocketEvent.BROADCASTER_CREATE_LIVE,
      data,
      ack: (response) {
        print('Response from socket server: $response');
        _liveId = response['liveId'];
        String token = response['token'];
        String url = response['url'];

        _setupVideoStream(
          liveId: _liveId!,
          token: token,
          url: url,
        );
      },
    );
  }

  Future<void> _disconnectFromRoom() async {
    try {
      // Ensure we disable camera and microphone first
      final participant = _room.localParticipant;
      if (participant != null) {
        await participant.setCameraEnabled(false);
        await participant.setMicrophoneEnabled(false);
      }

      // Disconnect from the room
      await _room.disconnect();

      getIt<SocketClientService>().socket.emit(
        WebsocketEvent.BROADCASTER_FINISH_LIVE,
        {
          'liveId': _liveId,
          'broadcasterId': _userInfo!.userId,
        },
      );
    } catch (e) {
      print('Error disconnecting from room: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (_isConnecting)
                    const Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Đang kết nối...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_isLiving)
                    Positioned.fill(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _localVideoTrack != null
                            ? VideoTrackRenderer(_localVideoTrack!)
                            // ? CameraPreview(_cameraController!)
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )
                  else if (_isCameraInitialized)
                    Positioned.fill(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CameraPreview(_cameraController!),
                      ),
                    )
                  else
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (_isLiving)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ListLiveEvent(
                        key: _chatKey,
                        onSendEvent: (event) {
                          // TODO: Implement send message functionality
                          getIt<SocketClientService>().socket.emit(
                            WebsocketEvent.USER_SEND_MESSAGE_TO_LIVE,
                            {
                              'liveId': _liveId,
                              'text': event.text,
                              'user': {
                                'userId': _userInfo!.userId,
                                'username': _userInfo!.username,
                                'avatar': _userInfo!.avatar,
                                'fullName': _userInfo!.fullName,
                              },
                            },
                          );
                        },
                      ),
                    ),
                  if (_isLiving)
                    Positioned(
                      top: 20.h,
                      right: 20.w,
                      child: GestureDetector(
                        onTap: () async {
                          if (_isLiving) {
                            // show confirm dialog
                            final confirm = await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text(
                                      'Bạn có chắc chắn muốn kết thúc live?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Xác nhận'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == null || !confirm) {
                              return;
                            }
                          }
                          await _disconnectFromRoom();
                          await _cameraController?.dispose();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.power_settings_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 20.h,
                      left: 20.w,
                      child: GestureDetector(
                        onTap: () async {
                          final currentContext = context;
                          await _cameraController?.dispose();
                          if (mounted) {
                            Navigator.pop(currentContext);
                          }
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  if (!_isLiving)
                    Positioned(
                      top: 20.h,
                      right: 20.w,
                      child: GestureDetector(
                        onTap: _switchCamera,
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  if (!_isLiving)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 75.h,
                      bottom: 40.h,
                      child: _buildLiveControl(),
                    ),
                ],
              ),
            ),
            // SizedBox(height: 65.h)
          ],
        ),
      ),
    );
  }

  Widget _buildLiveControl() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                avatar: _avatarUrl,
                size: 25.r,
              ),
              SizedBox(width: AppPadding.input),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập tiêu đề của buổi live...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppPadding.input),
          AppButton(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            text: _isConnecting ? 'Đang kết nối...' : 'Bắt đầu live',
            disable: _isConnecting,
            onPressed: startLive,
          ),
        ],
      ),
    );
  }
}
