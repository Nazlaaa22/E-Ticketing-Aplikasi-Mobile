class TicketModel {
  final int id;
  final String title;
  final String description;
  final String status;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      title: json['title'],
      description: json['body'],
      status: "Open",
    );
  }
}