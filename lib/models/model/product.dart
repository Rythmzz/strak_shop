class Product {
  int id;
  String name;
  double price;
  double salePrice;
  List<String> color;
  List<String> size;
  List<String> imageURL;
  List<String> imageName;
  int idCategory;
  int view;
  String description;

  Product(
      {this.id = 0,
      this.name = ' ',
      this.price = 0.0,
      this.salePrice = 0.0,
      this.color = const [],
      this.size = const [],
      this.imageURL = const [],
      this.imageName = const [],
      this.idCategory = 0,
      this.view = 0,
      this.description = ' '});

  int promotionPercent() {
    return (100 - (salePrice / price) * 100).round();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'salePrice': salePrice,
        'color': color,
        'size': size,
        'idCategory': idCategory,
        'view': view,
        'description': description
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] ?? 0,
        name: json['name'] ?? ' ',
        price: json['price'] ?? 0.0,
        salePrice: json['salePrice'] ?? 0.0,
        color: json['color'].cast<String>() ?? const [],
        size: json['size'].cast<String>() ?? const [],
        imageURL: (json['imageURL'] == null
            ? []
            : json['imageURL'].cast<String>() ?? const []),
        imageName: (json['imageURL'] == null
            ? []
            : json['imageName'].cast<String>() ?? const []),
        idCategory: json['idCategory'] ?? 0,
        view: json['view'] ?? 0,
        description: json['description'] ?? ' ');
  }

  @override
  String toString() {
    return '''
    id $id \n
    name $name \n
    price $price \n
    salePrice $salePrice \n,
    color $color \n
    size $size \n 
    imageURL $imageURL \n
    imageName $imageName \n
    idCategory $idCategory \n
    view $view \n
    description $description \n
    ''';
  }

  String get getDescription => description;

  set setDescription(String value) {
    description = value;
  }

  double get getSalePrice => salePrice;

  set setSalePrice(double value) {
    salePrice = value;
  }

  double get getPrice => price;

  set setPrice(double value) {
    price = value;
  }

  String get getName => name;

  set setName(String value) {
    name = value;
  }

  List<String> get getListImageURL => imageURL;

  int get getId => id;

  set setId(int value) {
    id = value;
  }

  List<String> get getImageName => imageName;

  List<String> get getImageURL => imageURL;

  set setImageName(List<String> value) {
    imageName = value;
  }

  void setValueOfIndexImageName(int index, String value) {
    imageName[index] = value;
  }

  void setValueOfIndexImageURL(int index, String value) {
    imageURL[index] = value;
  }

  List<String> get getListColor => color;

  set setColor(List<String> value) {
    color = value;
  }

  void addColor(String color) {
    this.color.add(color);
  }

  void deleteChipColor(String color) {
    this.color.remove(color);
  }

  void deleteChipSize(String textSize) {
    if (size.contains(textSize)) {
      size.remove(textSize);
    }
  }

  int? get getIdCategory => idCategory;

  set setIdCategory(int value) {
    idCategory = value;
  }

  String getSize(int index) {
    return size[index];
  }

  List<String> get getListSize => size;

  void setIndexSize(int index, String textSize) {
    size[index] = textSize;
  }

  void addSize(String textSize) {
    size.add(textSize);
  }

  void setIndexImageName(int index, String imageName) {
    this.imageName[index] = imageName;
  }

  String getIndexImageName(int index) {
    return imageName[index];
  }

  List<String> get getListImageName => imageName;

  int get getView => view;

  set setView(int view) {
    view = view;
  }
}
