import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as Path;

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';

// ignore: must_be_immutable
class EditProductView extends StatefulWidget {
  Product currentProduct;

  EditProductView({super.key, required this.currentProduct});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  Color _currentSelectColor = Colors.red;

  int? _currentSelectCategory;

  final List<File?> _listFilePicked = <File?>[null, null, null, null, null];
  final List<XFile?> _listXFilePicked = <XFile?>[null, null, null, null, null];
  final List<String> _listImageName = <String>["", "", "", "", ""];

  int _indexActive = 0;

  bool _isLoading = false;

  bool _checkNameError = false;
  final bool _checkPriceError = false;
  bool _checkSalePriceError = false;

  final TextEditingController _textEditingControllerName =
      TextEditingController();
  final TextEditingController _textEditingControllerPrice =
      TextEditingController();
  final TextEditingController _textEditingControllerSalePrice =
      TextEditingController();
  final TextEditingController _textEditingControllerDescription =
      TextEditingController();
  final TextEditingController _textEditingControllerSize =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textEditingControllerName.text = widget.currentProduct.getName;
    _textEditingControllerPrice.text =
        widget.currentProduct.getPrice.toString();
    _textEditingControllerSalePrice.text =
        widget.currentProduct.getSalePrice.toString();
    _textEditingControllerDescription.text =
        widget.currentProduct.getDescription;
    _currentSelectCategory = widget.currentProduct.getIdCategory;
    convertFileImage();

    super.initState();
  }

  void convertFileImage() async {
    for (int i = 0; i < widget.currentProduct.getListImageURL.length; i++) {
      _listFilePicked[i] =
          (await _fileFromImageUrl(widget.currentProduct.getListImageURL[i]));
      _listXFilePicked[i] = XFile(_listFilePicked[i]!.path);
      _listImageName[i] = _listXFilePicked[i]!.name;
    }
  }

  Future<File> _fileFromImageUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final String imageName = imageUrl.split('/').last;
    final file = File(Path.join(documentDirectory.path, imageName));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerPrice.dispose();
    _textEditingControllerSalePrice.dispose();
    _textEditingControllerDescription.dispose();
    _textEditingControllerSize.dispose();
    super.dispose();
  }

  String? validateProduct(String? input) {
    if (input!.isEmpty) {
      setState(() {
        _checkNameError = true;
      });
      return ("Please enter product name!");
    }
    setState(() {
      _checkNameError = false;
    });
    return null;
  }

  String? validatePrice(String? input) {
    if (input!.isEmpty) {
      _textEditingControllerPrice.text = "0";
    }
    return null;
  }

  String? validateSalePrice(String? input) {
    if (input!.isEmpty) {
      _textEditingControllerSalePrice.text = "0";
    }
    double? tempSalePrice =
        double.tryParse(_textEditingControllerSalePrice.text);
    double? tempPrice = double.tryParse(_textEditingControllerPrice.text);

    if (tempSalePrice! >= tempPrice!) {
      setState(() {
        _checkSalePriceError = true;
      });
      return ("The sale price cannot be greater than or equal to price");
    }
    setState(() {
      _checkSalePriceError = false;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(builder: (context, snapshot, _) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      titleTheme(context),
                      popUpMenuCategory(),
                      selectColorForm(),
                      selectSizeForm(),
                      inputForm(),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading ? true : false,
                child: Scaffold(
                    backgroundColor: Colors.black26,
                    body: Center(
                      child: SpinKitChasingDots(
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                    )),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget titleTheme(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            items: [0, 1, 2, 3, 4].map((i) {
              return Builder(builder: (BuildContext context) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: _listFilePicked[i] == null
                              ? const DecorationImage(
                                  image: AssetImage(
                                      'assets/images_app/default_image.png'),
                                  fit: BoxFit.fitHeight)
                              : DecorationImage(
                                  image: FileImage(
                                      File(_listFilePicked[i]!.path)))),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(16),
                      child: FloatingActionButton(
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        onPressed: () async {
                          final ImagePicker picked = ImagePicker();
                          _listXFilePicked[i] = await picked.pickImage(
                              source: ImageSource.gallery);
                          if (_listXFilePicked[i] != null) {
                            setState(() {
                              _listFilePicked[i] =
                                  File(_listXFilePicked[i]!.path);
                              _listImageName[i] = _listXFilePicked[i]!.name;
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Image Not Chosen")));
                          }
                        },
                        child: const Icon(Icons.add_photo_alternate_outlined,
                            size: 24),
                      ),
                    )
                  ],
                );
              });
            }).toList(),
            options: CarouselOptions(
                viewportFraction: 1,
                height: 200,
                onPageChanged: (value, _) {
                  setState(() {
                    _indexActive = value;
                  });
                })),
        const SizedBox(
          height: 15,
        ),
        AnimatedSmoothIndicator(
          activeIndex: _indexActive,
          count: 5,
          effect: SlideEffect(
              dotColor: StrakColor.colorTheme6,
              dotWidth: 12,
              dotHeight: 12,
              activeDotColor: Colors.blue),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget selectColorForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: StrakColor.colorTheme6)),
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: widget.currentProduct.getListColor == []
              ? []
              : [
                  InkWell(
                    child: const Chip(
                        label: Text("Add Color"),
                        avatar: CircleAvatar(
                          child: Icon(Icons.add),
                        )),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                                  builder: (context, StateSetter setStates) {
                                return AlertDialog(
                                  title: const Text("Select Your Color"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        BlockPicker(
                                            availableColors: const [
                                              Colors.red,
                                              Colors.green,
                                              Colors.amber,
                                              Colors.pinkAccent,
                                              Colors.deepOrange,
                                              Colors.blue,
                                              Colors.brown,
                                              Colors.deepPurple,
                                              Colors.grey,
                                              Colors.blueGrey,
                                              Colors.black,
                                              Colors.white,
                                            ],
                                            pickerColor: _currentSelectColor,
                                            onColorChanged: (color) {
                                              setStates(() {
                                                _currentSelectColor = color;
                                              });
                                            }),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        // ignore: iterable_contains_unrelated_type
                                                        if (!widget
                                                            .currentProduct
                                                            .getListColor
                                                            .contains(
                                                                _currentSelectColor)) {
                                                          widget.currentProduct
                                                              .addColor(
                                                                  _currentSelectColor
                                                                      .toString());
                                                        }
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text("Select"))),
                                            TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            content: Column(
                                                              children: [
                                                                ColorPicker(
                                                                  pickerColor:
                                                                      _currentSelectColor,
                                                                  onColorChanged:
                                                                      (color) {
                                                                    setStates(
                                                                        () {
                                                                      _currentSelectColor =
                                                                          color;
                                                                    });
                                                                  },
                                                                ),
                                                                TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(),
                                                                    child:
                                                                        const Text(
                                                                            "OK"))
                                                              ],
                                                            ),
                                                          ));
                                                },
                                                child:
                                                    const Text("Custom Color")),
                                            CircleAvatar(
                                              backgroundColor:
                                                  _currentSelectColor,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  for (var x in widget.currentProduct.getListColor) chipColor(x)
                ],
        ),
      ),
    );
  }

  Widget chipColor(String colorString) {
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = Color(value);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text(colorToHex(otherColor)),
        onDeleted: () {
          setState(() {
            widget.currentProduct.deleteChipColor(colorString);
          });
        },
        avatar: CircleAvatar(
          backgroundColor: otherColor,
        ),
      ),
    );
  }

  Widget chipSize(String textSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text(textSize),
        onDeleted: () {
          setState(() {
            widget.currentProduct.deleteChipSize(textSize);
          });
        },
      ),
    );
  }

  Widget selectSizeForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: StrakColor.colorTheme6)),
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: widget.currentProduct.getListSize == []
              ? []
              : [
                  InkWell(
                    child: const Chip(
                        label: Text("Add Custom Size"),
                        avatar: CircleAvatar(
                          child: Icon(Icons.add),
                        )),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                                  builder: (context, StateSetter setStates) {
                                return AlertDialog(
                                    title: const Text("Custom Size Product"),
                                    content: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller:
                                                _textEditingControllerSize,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: StrakColor
                                                          .colorTheme6,
                                                      width: 3)),
                                              border: const OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 3)),
                                              prefixIcon: Icon(
                                                Icons.drive_file_rename_outline,
                                                size: 24,
                                                color: _checkNameError
                                                    ? Colors.red
                                                    : null,
                                              ),
                                              hintText: "Enter Size",
                                            ),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (widget.currentProduct
                                                      .getListSize
                                                      .contains(
                                                          _textEditingControllerSize
                                                              .text)) {
                                                    widget.currentProduct.addSize(
                                                        _textEditingControllerSize
                                                            .text);
                                                  }
                                                });
                                                _textEditingControllerSize
                                                    .clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Create"))
                                        ],
                                      ),
                                    ));
                              }));
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  for (var x in widget.currentProduct.getListSize) chipSize(x)
                ],
        ),
      ),
    );
  }

  Widget inputForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textEditingControllerName,
                validator: validateProduct,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: StrakColor.colorTheme6, width: 3)),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3)),
                  prefixIcon: Icon(
                    Icons.drive_file_rename_outline,
                    size: 24,
                    color: _checkNameError ? Colors.red : null,
                  ),
                  hintText: "Enter Product Name",
                ),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _textEditingControllerPrice,
                validator: validatePrice,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: StrakColor.colorTheme6, width: 3)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                  prefixIcon: Icon(Icons.attach_money,
                      size: 24, color: _checkPriceError ? Colors.red : null),
                  hintText: "Enter Price",
                ),
                style: const TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _textEditingControllerSalePrice,
                validator: validateSalePrice,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: StrakColor.colorTheme6, width: 3)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                  prefixIcon: Icon(Icons.attach_money,
                      size: 24,
                      color: _checkSalePriceError ? Colors.red : null),
                  hintText: "Enter Sale Price (If Any)",
                ),
                style: const TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _textEditingControllerDescription,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: StrakColor.colorTheme6, width: 3)),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3),
                    ),
                    hintText: "Enter Description",
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 24,
                    )),
                style: const TextStyle(fontSize: 12),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 20,
                maxLength: 500,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          widget.currentProduct.setName =
                              _textEditingControllerName.text;
                          widget.currentProduct.setPrice = double.tryParse(
                              _textEditingControllerPrice.text)!;
                          widget.currentProduct.setSalePrice = double.tryParse(
                              _textEditingControllerSalePrice.text)!;
                          widget.currentProduct.setDescription =
                              _textEditingControllerDescription.text;
                          DatabaseService()
                              .createNewProduct(
                                  _listXFilePicked,
                                  _listImageName,
                                  widget.currentProduct,
                                  widget.currentProduct.getId)
                              .then((value) {});

                          await Future.delayed(const Duration(seconds: 5))
                              .then((value) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Create Product Success")));
                          });
                        }
                      },
                      child: const Text("Create Product"))),
              const SizedBox(
                height: 16,
              )
            ],
          )),
    );
  }

  Widget popUpMenuCategory() {
    return Consumer<CategoryModel>(builder: (context, snapshot, _) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 3, color: StrakColor.colorTheme6)),
                child: DropdownButton(
                  items: snapshot.getListCategory.map((val) {
                    return DropdownMenuItem<int>(
                        value: val.getId, child: Text(val.getName));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentSelectCategory = val;
                      widget.currentProduct.setIdCategory = val!;
                    });
                  },
                  hint: const Text("Select Category"),
                  value: _currentSelectCategory,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  isExpanded: true,
                  underline: DropdownButtonHideUnderline(
                    child: Container(),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const DialogCreateCategory();
                      });
                },
                icon: Icon(
                  Icons.add_link,
                  color: StrakColor.colorTheme7,
                ))
          ],
        ),
      );
    });
  }
}

class DialogCreateCategory extends StatefulWidget {
  const DialogCreateCategory({super.key});

  @override
  State<DialogCreateCategory> createState() => _DialogCreateCategoryState();
}

class _DialogCreateCategoryState extends State<DialogCreateCategory> {
  File? _filePickImage;
  XFile? _image;
  final TextEditingController _textEditingControllerNameCategory =
      TextEditingController();
  Category category = Category();
  String _selectFashion = "Male";
  List<String> menuFashion = ["Male", "Female", "Both"];

  @override
  void dispose() {
    _textEditingControllerNameCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(
      builder: (context, snapshot, _) {
        if (snapshot.getListCategory != []) {
          category.id = snapshot.getListCategory.length;
        }
        return AlertDialog(
          title: const Text("Add Category"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 3, color: StrakColor.colorTheme6),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: InkWell(
                        onTap: () async {
                          final ImagePicker picked = ImagePicker();
                          _image = await picked.pickImage(
                              source: ImageSource.gallery);
                          if (_image != null) {
                            setState(() {
                              _filePickImage = File(_image!.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: _filePickImage == null
                              ? const AssetImage(
                                  "assets/images_app/default_image.png",
                                ) as ImageProvider
                              : FileImage(File(_filePickImage!.path)),
                        ))),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    controller: _textEditingControllerNameCategory,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: StrakColor.colorTheme6, width: 3)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: StrakColor.colorTheme6, width: 3)),
                      hintText: "Enter Category Name",
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: StrakColor.colorTheme6, width: 3)),
                  child: DropdownButton(
                    items:
                        menuFashion.map<DropdownMenuItem<String>>((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      setState(() {
                        _selectFashion = val!;
                        category.genderStyle = val.toLowerCase();
                      });
                    },
                    hint: const Text("Select Fashion"),
                    value: _selectFashion,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    isExpanded: true,
                    underline: DropdownButtonHideUnderline(
                      child: Container(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel")),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          StorageRepository()
                              .uploadFileImageCategory(_image!, category);
                          Navigator.of(context).pop();
                        },
                        child: const Text("Confirm"))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
