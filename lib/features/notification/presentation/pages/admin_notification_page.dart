import 'package:flutter/material.dart';
import '../../data/repositories/notification_repository.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  State<AdminNotificationPage> createState() =>
      _AdminNotificationPageState();
}

class _AdminNotificationPageState
    extends State<AdminNotificationPage> {

  final NotificationRepository _repository =
  NotificationRepository();

  Future<List<dynamic>> _loadData() {
    return _repository.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F7FB),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.black),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Notifikasi Admin",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        body: FutureBuilder<List<dynamic>>(

            future: _loadData(),

            builder: (context,snapshot){

              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(snapshot.hasError){
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              final notifications = snapshot.data ?? [];

              if(notifications.isEmpty){
                return const Center(
                  child: Text("Belum ada notifikasi"),
                );
              }

              return RefreshIndicator(

                  onRefresh: () async{
                    setState(() {});
                  },

                  child: ListView.builder(

                      padding: const EdgeInsets.all(16),

                      itemCount: notifications.length,

                      itemBuilder: (context,index){

                        final item = notifications[index];

                        Color color = Colors.blue;
                        IconData icon = Icons.notifications;

                        switch(item["type"]){

                          case "create":
                            color = Colors.blue;
                            icon = Icons.add_circle;
                            break;

                          case "assign":
                            color = Colors.orange;
                            icon = Icons.assignment_ind;
                            break;

                          case "status":
                            color = Colors.green;
                            icon = Icons.check_circle;
                            break;

                          case "delete":
                            color = Colors.red;
                            icon = Icons.delete;
                            break;

                          default:
                            color = Colors.grey;
                            icon = Icons.notifications;
                        }
                        return Dismissible(
                          key: Key(item["id"].toString()),

                          direction: DismissDirection.endToStart,

                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),

                          onDismissed: (_) async {

                            await _repository.deleteNotification(
                              item["id"],
                            );

                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Notifikasi dihapus"),
                              ),
                            );
                          },

                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(

                              contentPadding: const EdgeInsets.all(16),

                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: color.withOpacity(.15),
                                child: Icon(
                                  icon,
                                  color: color,
                                ),
                              ),

                              title: Text(
                                item["title"] ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      item["message"] ?? "",
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      item["created_at"] ?? "",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              trailing: IconButton(

                                icon: Icon(

                                  item["is_read"] == true
                                      ? Icons.mark_email_read
                                      : Icons.mark_email_unread,

                                  color: item["is_read"] == true
                                      ? Colors.green
                                      : Colors.orange,
                                ),

                                onPressed: () async {

                                  await _repository.markAsRead(
                                    item["id"],
                                  );

                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        );
                      },
                  ),
              );
            },
        ),
    );
  }
}