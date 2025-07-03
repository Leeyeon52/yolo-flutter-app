class NotificationIcon extends StatelessWidget {
  final int unreadNotifications;

  NotificationIcon({required this.unreadNotifications});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),
        if (unreadNotifications > 0)
          Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: Text(
                unreadNotifications.toString(),
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
