class Offer {
  final int id;
  final String product;
  final int points;
  final String? createdAt;
  final String? updatedAt;
  final String? image;
  final String imageLink;

  Offer({
    required this.id,
    required this.product,
    required this.points,
    this.createdAt,
    this.updatedAt,
    this.image,
    required this.imageLink,
  });

  // Factory method to create an Offer instance from JSON
  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      product: json['product'],
      points: json['points'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      imageLink: json['image_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'points': points,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
      'image_link': imageLink,
    };
  }
}

List<Offer> parseOffers(Map<String, dynamic> json) {
  var offersList = json['offers'] as List;
  return offersList.map((offer) => Offer.fromJson(offer)).toList();
}
