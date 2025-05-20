import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/presentation/pages/user/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveEvent {
  final bool isSystem;
  final String fullName;
  final String? avatar;
  final String text;

  LiveEvent({
    required this.text,
    required this.fullName,
    this.isSystem = false,
    this.avatar,
  });
}

class ListLiveEvent extends StatefulWidget {
  final Function(LiveEvent) onSendMessage;

  const ListLiveEvent({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<ListLiveEvent> createState() => ListLiveEventState();
}

class ListLiveEventState extends State<ListLiveEvent> {
  final TextEditingController _messageController = TextEditingController();
  final List<LiveEvent> _listEvents = [];
  final ScrollController _scrollController = ScrollController();

  addEventItem() {}

  void addEvent(LiveEvent liveEvent, {bool isSystem = false}) {
    setState(() {
      _listEvents.add(liveEvent);
    });

    // Scroll to bottom after message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmitted(LiveEvent event) {
    if (event.text.isEmpty) return;

    widget.onSendMessage(event);
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  stops: const [0, 0.75],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: _listEvents.length,
                itemBuilder: (context, index) {
                  final event = _listEvents[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: event.isSystem
                        ? Text(
                            event.text,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileAvatar(
                                avatar: event.avatar,
                                size: 18.r,
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                children: [
                                  Text(
                                    event.fullName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    event.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập bình luận...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    onSubmitted: (value) async {
                      _handleSubmitted(
                        LiveEvent(
                          fullName:
                              await SharedPreferencesHelper.getStringValue(
                            SharedPreferencesHelper.FULL_NAME,
                          ),
                          avatar: await SharedPreferencesHelper.getStringValue(
                            SharedPreferencesHelper.AVATAR,
                          ),
                          text: value.trim(),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    _handleSubmitted(
                      LiveEvent(
                        fullName: await SharedPreferencesHelper.getStringValue(
                          SharedPreferencesHelper.FULL_NAME,
                        ),
                        avatar: await SharedPreferencesHelper.getStringValue(
                          SharedPreferencesHelper.AVATAR,
                        ),
                        text: _messageController.text.trim(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
