class Category {
  int id;
  String name;
  String imageURL;
  String imageName;
  String genderStyle;

  Category(
      {this.id = 0,
      this.name = ' ',
      this.imageName = ' ',
      this.imageURL = ' ',
      this.genderStyle = ' '});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'] ?? 0,
        name: json['name'] ?? ' ',
        imageName: json['imageName'] ?? ' ',
        imageURL: json['imageURL'],
        genderStyle: json['genderStyle'] ?? ' ');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageName': imageName,
        'imageURL': imageURL,
        'genderStyle': genderStyle
      };

  @override
  String toString() {
    return '''
    id $id \n
    name $name \n
    imageName $imageName \n
    imageURL $imageURL \n,
    genderStyle $genderStyle \n
    ''';
  }

  String get getImageName => imageName;

  set setImageName(String value) {
    imageName = value;
  }

  String get getImageURL => imageURL;

  set setImageURL(String value) {
    imageURL = value;
  }

  String get getName => name;

  set setName(String value) {
    name = value;
  }

  int get getId => id;

  set setId(int value) {
    id = value;
  }

  String get getGenderStyle => genderStyle;

  set setGenderStyle(String value) {
    genderStyle = value;
  }
}
