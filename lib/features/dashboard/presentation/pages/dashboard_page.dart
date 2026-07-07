import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../ticket/data/repositories/ticket_repository.dart';
import '../../../ticket/presentation/pages/create_ticket_page.dart';
import '../../../ticket/presentation/pages/ticket_page.dart';
import 'package:e_ticketing_helpdesk/features/notification/presentation/pages/admin_notification_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Selamat Pagi ☀";
    if (hour < 15) return "Selamat Siang 🌤";
    if (hour < 18) return "Selamat Sore 🌇";
    return "Selamat Malam 🌙";
  }

  @override
  Widget build(BuildContext context) {
    final repo = TicketRepository();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff2563EB),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateTicketPage(),
              ),
            );
          },
          icon: const Icon(Icons.add,color: Colors.white),
          label: const Text(
            "Buat Tiket",
            style: TextStyle(color: Colors.white),
          ),
        ),

        body: FutureBuilder<List<dynamic>>(

            future: Future.wait([
              repo.getStatistics(),
              repo.getWeeklyChart(),
              repo.getTickets(),
            ]),

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

              final statistics =
              snapshot.data![0] as Map<String,dynamic>;

              final weekly =
              snapshot.data![1] as List<dynamic>;

              final tickets =
              snapshot.data![2] as List<dynamic>;

              final total = statistics["total"] ?? 0;
              final open = statistics["open"] ?? 0;
              final progress = statistics["progress"] ?? 0;
              final done = statistics["done"] ?? 0;

              return RefreshIndicator(

                  onRefresh: () async{
                    (context as Element).markNeedsBuild();
                  },

                  child: SingleChildScrollView(

                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      child: Column(

                        children: [

                        Container(

                        width: double.infinity,

                        padding: const EdgeInsets.fromLTRB(
                            20,55,20,28),

                        decoration: const BoxDecoration(

                          gradient: LinearGradient(

                            colors: [

                              Color(0xff2563EB),
                              Color(0xff3B82F6),

                            ],

                          ),

                          borderRadius: BorderRadius.vertical(

                            bottom: Radius.circular(30),

                          ),

                        ),

                        child: Row(

                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: [

                            Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  _greeting(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height:6),

                                const Text(
                                  "Administrator",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height:4),

                                Text(
                                  DateFormat(
                                    "EEEE, dd MMM yyyy",
                                    "id",
                                  ).format(DateTime.now()),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                              ],

                            ),

                            Row(

                              children: [

                                IconButton(

                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const AdminNotificationPage(),
                                      ),
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),

                                ),

                                const CircleAvatar(
                                  radius:24,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xff2563EB),
                                  ),
                                ),

                              ],

                            ),

                          ],

                        ),

                      ),

                      Padding(

                        padding: const EdgeInsets.all(18),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                          Text(
                          "Ringkasan Tiket",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height:16),GridView.count(

                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        crossAxisCount: 2,

                        crossAxisSpacing: 14,

                        mainAxisSpacing: 14,

                        childAspectRatio: 1.45,

                              children: [

                                _dashboardCard(
                                  context,
                                  Colors.blue,
                                  Icons.confirmation_number,
                                  "$total",
                                  "Total Ticket",
                                ),

                                _dashboardCard(
                                  context,
                                  Colors.orange,
                                  Icons.mark_email_unread,
                                  "$open",
                                  "Open",
                                ),

                                _dashboardCard(
                                  context,
                                  Colors.deepPurple,
                                  Icons.timelapse,
                                  "$progress",
                                  "Progress",
                                ),

                                _dashboardCard(
                                  context,
                                  Colors.green,
                                  Icons.check_circle,
                                  "$done",
                                  "Done",
                                ),

                              ],

                      ),

                        const SizedBox(height: 30),

                          Text(
                            "Statistik Mingguan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),

                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 12,
                                offset: const Offset(0,6),
                              )
                            ],
                          ),

                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                      "Ticket 7 Hari Terakhir",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),

                                    const Icon(
                                      Icons.bar_chart,
                                      color: Colors.blue,
                                    ),
                                  ],

                              ),

                              const SizedBox(height: 24),

                              SizedBox(
                                height: 170,
                                child: Row(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,

                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,

                                  children: weekly.map((item){

                                    final value =
                                    ((item["count"] ?? 0) * 18)
                                        .toDouble()
                                        .clamp(10,110);

                                    return Column(

                                      mainAxisAlignment:
                                      MainAxisAlignment.end,

                                      children: [

                                        AnimatedContainer(

                                          duration:
                                          const Duration(milliseconds:600),

                                          width: 22,

                                          height: value,

                                          decoration: BoxDecoration(

                                            gradient:
                                            const LinearGradient(

                                              colors: [
                                                Color(0xff2563EB),
                                                Color(0xff60A5FA),
                                              ],

                                              begin: Alignment.bottomCenter,

                                              end: Alignment.topCenter,

                                            ),

                                            borderRadius:
                                            BorderRadius.circular(8),

                                          ),

                                        ),

                                        const SizedBox(height:8),

                                        Text(
                                          item["day"].toString(),
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                      ],

                                    );

                                  }).toList(),

                                ),

                              ),

                            ],

                          ),

                        ),

                        const SizedBox(height:30),
                            Text(
                              "Quick Actions",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                _actionButton(
                                  context,
                                  Icons.add_circle,
                                  "Buat",
                                  Colors.blue,
                                ),

                                _actionButton(
                                  context,
                                  Icons.assignment_ind,
                                  "Assign",
                                  Colors.orange,
                                ),

                                _actionButton(
                                  context,
                                  Icons.analytics,
                                  "Report",
                                  Colors.green,
                                ),

                                _actionButton(
                                  context,
                                  Icons.people_alt,
                                  "User",
                                  Colors.deepPurple,
                                ),

                              ],
                            ),

                            const SizedBox(height: 30),

                            Text(
                              "Recent Tickets",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 14),

                            ...tickets.take(5).map((ticket) {

                              return Card(
                                color: theme.cardColor,
                                elevation: 0,

                                margin: const EdgeInsets.only(bottom: 12),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),

                                child: ListTile(

                                  leading: CircleAvatar(
                                    backgroundColor:
                                    _statusColor(ticket["status"]).withOpacity(.12),
                                    child: Icon(
                                      Icons.confirmation_number,
                                      color: _statusColor(ticket["status"]),
                                    ),
                                  ),

                                  title: Text(
                                    ticket["title"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),

                                  subtitle: Text(
                                    ticket["description"].toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(.7),
                                    ),
                                  ),

                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                      _statusColor(ticket["status"]).withOpacity(.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      ticket["status"].toString(),
                                      style: TextStyle(
                                        color: _statusColor(ticket["status"]),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const TicketPage(),
                                      ),
                                    );
                                  },

                                ),

                              );

                            }).toList(),

                            const SizedBox(height: 40),

                          ],
                        ),
                      ),
                        ],
                      ),
                  ),
              );
            },
        ),
    );
  }
  //================ CARD =================

  Widget _dashboardCard(
      BuildContext context,
      Color color,
      IconData icon,
      String value,
      String title,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(.7),
            ),
          ),

        ],
      ),
    );
  }

  //================ QUICK ACTION =================

  Widget _actionButton(
      BuildContext context,
      IconData icon,
      String title,
      Color color,
      ) {
    return InkWell(

      borderRadius: BorderRadius.circular(18),

      onTap: () {

        if (title == "Buat") {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTicketPage(),
            ),
          );

        } else {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TicketPage(),
            ),
          );

        }

      },

      child: Column(

        children: [

          Container(

            width: 68,

            height: 68,

            decoration: BoxDecoration(

              color: color.withOpacity(.12),

              borderRadius: BorderRadius.circular(20),

            ),

            child: Icon(
              icon,
              color: color,
              size: 30,
            ),

          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

        ],

      ),

    );
  }

  //================ STATUS =================

  Color _statusColor(String status) {

    switch (status.toLowerCase()) {

      case "open":
        return Colors.orange;

      case "progress":
        return Colors.blue;

      case "done":
        return Colors.green;

      default:
        return Colors.grey;

    }

  }

}