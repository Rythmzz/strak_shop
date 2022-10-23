
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strak_shop_project/models/category.dart';
import 'package:strak_shop_project/models/category_model.dart';
import 'package:strak_shop_project/models/product.dart';
import 'package:strak_shop_project/models/product_model.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/services/storage_repository.dart';

import '../services/colors.dart';


// enum menuCategory {Shirt,Bikini,Dress,Work_Equipment,Man_Pants,Man_Shoes
// ,Man_Underwear,Man_T_Shirt,Woman_Pants,High_Heels,Woman_T_Shirt,Skirt}

// extension MenuCategoryExtension on menuCategory{
//   String? get name{
//     switch (this){
//       case menuCategory.Work_Equipment : return "Work Equipment";
//       case menuCategory.Man_Pants : return "Man Pants";
//       case menuCategory.Man_Shoes : return "Man Shoes";
//       case menuCategory.Man_Underwear : return "Man Underwear";
//       case menuCategory.Man_T_Shirt : return "Man T-Shirt";
//       case menuCategory.Woman_Pants : return "Woman Pants";
//       case menuCategory.Woman_T_Shirt : return "Woman T-Shirt";
//       case menuCategory.High_Heels : return "High Heels";
//       default:
//         return null;
//     }
//   }
// }


class CreateNewProducts extends StatefulWidget{

  @override
  State<CreateNewProducts> createState() => _CreateNewProductsState();
}


class _CreateNewProductsState extends State<CreateNewProducts> {
  late Product _product = Product(0,"", 0.0, 0.0, [], [], ["","","","",""], ["","","","",""], 0, 0, "");

  Color _currentSelectColor = Colors.red;

  int? _currentSelectCategory;

  List<File?> _listFilePicked = <File?>[null,null,null,null,null];
  List<XFile?> _listXFilePicked = <XFile?>[null,null,null,null,null];

  int _indexActive = 0;

  bool _isLoading = false;

  bool _checkNameError = false;
  bool _checkPriceError =false;
  bool _checkSalePriceError = false;

  final TextEditingController _textEditingControllerName = TextEditingController();
  final TextEditingController _textEditingControllerPrice = TextEditingController();
  final TextEditingController _textEditingControllerSalePrice = TextEditingController();
  final TextEditingController _textEditingControllerDescription = TextEditingController();
  final TextEditingController _textEditingControllerSize = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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

  String? validateProduct (String? input){
    if (input!.isEmpty){
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

  String? validatePrice(String? input){
    if(input!.isEmpty){
      _textEditingControllerPrice.text = "0";
    }
    return null;
  }

  String? validateSalePrice(String? input){
    if(input!.isEmpty){
      _textEditingControllerSalePrice.text = "0";
    }
    double? tempSalePrice = double.tryParse(_textEditingControllerSalePrice.text);
    double? tempPrice = double.tryParse(_textEditingControllerPrice.text);


    if(tempSalePrice! >= tempPrice!){
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
    return  Consumer<ProductModel>(builder:(context,snapshot,_){
      if(snapshot.getListProduct != []){
        _product.setId = snapshot.getListProduct.length;
        print(_product.getId);
      }
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
                    )
                ),
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
        CarouselSlider(items: [0,1,2,3,4].map((i) {
          return Builder(builder: (BuildContext context){
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: _listFilePicked[i] == null ? DecorationImage(image: AssetImage('assets/images_app/default_image.png'),fit: BoxFit.fitHeight) :
                      DecorationImage(image: FileImage(File(_listFilePicked[i]!.path)))
                  ),
                ),
                Container(alignment: Alignment.bottomLeft,padding: EdgeInsets.all(16),child: FloatingActionButton(backgroundColor: Colors.grey.withOpacity(0.5),onPressed: () async {
                  final ImagePicker picked = ImagePicker();
                  _listXFilePicked[i] = await picked.pickImage(source: ImageSource.gallery);
                  if(_listXFilePicked[i] != null){
                    setState(() {
                      _listFilePicked[i] = File(_listXFilePicked[i]!.path);
                      _product.setIndexImageName(i, _listXFilePicked[i]!.name);
                      _product.getImageName!.forEach((element) {
                        print(element);
                      });
                    });
                    // StorageRepository().uploadFileImageProduct(image, 'product', _product.getId!, _product.getImageName![i], i).then((value) async {
                    // String downloadURL = await  StorageRepository().getDownloadURLProduct(image.name, 'product', _product.getId!, i);
                    //   _product.setValueOfIndexImageURL(i,downloadURL);
                    // print(_product.getImageURL![i]);
                    // _product.setValueOfIndexImageName(i, image.name);
                    // print(_product.getImageName![i]);
                    // });
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Not Chosen")));
                  }
                },child: Icon(Icons.add_photo_alternate_outlined,size: 24),),)
              ],
            );
          });
        }).toList(), options: CarouselOptions(
           viewportFraction: 1,
            height: 200,
            onPageChanged: (value,_) {
              setState(() {
                _indexActive = value;
              });

            }
        )),
        SizedBox(height: 15,),
        AnimatedSmoothIndicator(activeIndex: _indexActive, count: 5,
          effect: SlideEffect(
              dotColor: StrakColor.colorTheme6,
              dotWidth: 12,
              dotHeight: 12,
            activeDotColor: Colors.blue
          ),),
        SizedBox(height: 15,)
      ],
    );
  }

  Widget selectColorForm(){
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(width: 3,color: StrakColor.colorTheme6)
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: _product.getListColor == [] ? [] : [
            InkWell(
              child: Chip(label: Text("Add Color"),avatar: CircleAvatar(child: Icon(Icons.add),)),onTap: (){
              showDialog(context: context, builder:(context) => StatefulBuilder(builder: (context,StateSetter setStates){
                return AlertDialog(
                  title: Text("Select Your Color"),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        BlockPicker(availableColors: [
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
                        ],pickerColor: _currentSelectColor, onColorChanged: (color) {
                          setStates(() {
                            _currentSelectColor = color;
                          });}),
                        Row(
                          children: [
                            Expanded(child: TextButton(onPressed: () {
                              setState(() {
                                if(!_product.getListColor!.contains(_currentSelectColor)){
                                  _product.addColor(_currentSelectColor.toString());
                                }
                              });
                              Navigator.of(context).pop(); }, child: Text("Select"))),
                            TextButton(onPressed: () {
                              showDialog(context: context, builder: (context) => AlertDialog(
                                content: Column(
                                  children: [
                                    ColorPicker(pickerColor: _currentSelectColor, onColorChanged: (color) {
                                      setStates(() {
                                        _currentSelectColor = color;
                                      });
                                    },
                                    ),
                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
                                  ],
                                ),
                              ));

                            }, child: Text("Custom Color")),
                            CircleAvatar(backgroundColor: _currentSelectColor,)
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
            },
            ),
            SizedBox(width: 5,)
            ,
            for(var x in _product.getListColor!)
              chipColor(x)
          ],
        ),
      ),
    );

  }

  Widget chipColor(String colorString){
    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = new Color(value);
    return Padding(padding: EdgeInsets.only(right: 4),child: Chip(label: Text(colorToHex(otherColor)),onDeleted: (){
      setState(() {
        _product.deleteChipColor(colorString);
      });
    }, avatar: CircleAvatar(backgroundColor: otherColor ,),),);
  }
  Widget chipSize(String textSize){
    return Padding(padding: EdgeInsets.only(right: 4),child: Chip(label: Text(textSize),onDeleted: (){
      setState(() {
        _product.deleteChipSize(textSize);
      });
    },),);
  }

  Widget selectSizeForm(){
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(width: 3,color: StrakColor.colorTheme6)
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children:  _product.getListSize == [] ? [] : [
            InkWell(
              child: Chip(label: Text("Add Custom Size"),avatar: CircleAvatar(child: Icon(Icons.add),)),onTap: (){
              showDialog(context: context, builder:(context) => StatefulBuilder(builder: (context,StateSetter setStates){
                return AlertDialog(
                  title: Text("Custom Size Product"),
                  content: Container(
                    width: 200,
                    height: 200,
                    child: Column(
                      children: [
                        TextField(
                          controller: _textEditingControllerSize,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width:3)
                            ),
                            prefixIcon: Icon(Icons.drive_file_rename_outline,size: 24,color: _checkNameError ? Colors.red : null,),
                            hintText: "Enter Size",
                          ),style: TextStyle(
                            fontSize: 12
                        ),
                        ),
                        SizedBox(height: 15,),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            if(!_product.getListSize!.contains(_textEditingControllerSize.text)){
                              _product.addSize(_textEditingControllerSize.text);
                            }
                          });
                          _textEditingControllerSize.clear();
                          Navigator.of(context).pop();
                        }, child: Text("Create"))
                      ],
                    ),
                  )
                );
              }));
            },
            ),
            SizedBox(width: 5,)
            ,
            for(var x in _product.getListSize!)
              chipSize(x)
          ],
        ),
      ),
    );
  }
  Widget inputForm(){
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(key: _formKey,child:Column(
        children: [
          TextFormField(
            controller: _textEditingControllerName,
            validator: validateProduct,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width:3)
              ),
              prefixIcon: Icon(Icons.drive_file_rename_outline,size: 24,color: _checkNameError ? Colors.red : null,),
              hintText: "Enter Product Name",
            ),style: TextStyle(
              fontSize: 12
          ),
          ),
          SizedBox(height: 8,),
          TextFormField(
            controller: _textEditingControllerPrice,
            validator: validatePrice,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width:3),
              ),
              prefixIcon: Icon(Icons.attach_money,size: 24,color:  _checkPriceError ? Colors.red : null),
              hintText: "Enter Price",
            ),
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _textEditingControllerSalePrice,
            validator: validateSalePrice,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width:3),
              ),
              prefixIcon: Icon(Icons.attach_money,size: 24,color: _checkSalePriceError ? Colors.red : null),
              hintText: "Enter Sale Price (If Any)",
            ),
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.text,
          ),
          // Visibility(visible: _errorText ? true : false,child: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text("incorrect user or password",style: TextStyle(
          //       color: Colors.red,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 14
          //   ),),
          // )),
          SizedBox(height: 8,),
          TextFormField(
            controller: _textEditingControllerDescription,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width:3),
              ),
              hintText: "Enter Description",
              suffixIcon: Icon(Icons.edit,color: Colors.white,size: 24,)
            ),
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            maxLength: 500,
          ),

          SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () async{
              if(_formKey.currentState!.validate()){
                setState(() {
                  _isLoading = true;
                });
                _product.setName = _textEditingControllerName.text;
                _product.setPrice = double.tryParse(_textEditingControllerPrice.text)!;
                _product.setSalePrice = double.tryParse(_textEditingControllerSalePrice.text)!;
                _product.setDescription = _textEditingControllerDescription.text;
                DatabaseService().createNewProduct(_listXFilePicked, _product.getListImageName!, _product.getId!, _product.getName!, _product.getPrice!,
                    _product.getSalePrice!, _product.getListColor!, _product.getListSize!, _product.getIdCategory!, _product.getView!, _product.getDescription!).then((value) {
                });

                await Future.delayed(Duration(seconds: 5)).then((value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Create Product Success")));
                });

              }
              else {
                print("Có lỗi xảy ra");
              }
          }, child: Text("Create Product"))),
          SizedBox(
            height: 16,
          )
        ],

      )),
    );
  }
  Widget popUpMenuCategory() {
    return Consumer<CategoryModel>(builder: (context,snapshot,_){
      return Padding(
        padding: EdgeInsets.only(left: 16,right: 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 8,left: 8),
                decoration: BoxDecoration(
                    border: Border.all(width: 3,color: StrakColor.colorTheme6)
                ),
                child: DropdownButton(items: snapshot.getListCategory.map((val) {
                  return DropdownMenuItem<int>(child: Text(val.getName),value:val.getId);
                }).toList() , onChanged: (val) {
                  setState(() {
                    _currentSelectCategory = val;
                    _product.setIdCategory = val!;
                  });
                },hint: Text("Select Category"),value: _currentSelectCategory,icon: Icon(Icons.arrow_drop_down),iconSize: 30,isExpanded: true,underline:  DropdownButtonHideUnderline(child: Container(),),),
              ),
            ),
            IconButton(onPressed: (){
              showDialog(context: context, builder: (context) {
                return DialogCreateCategory();
              });
            }, icon: Icon(Icons.add_card,color: Colors.red,))
          ],
        ),
      );
    });
  }
}


class DialogCreateCategory extends StatefulWidget{
  @override
  State<DialogCreateCategory> createState() => _DialogCreateCategoryState();
}

class _DialogCreateCategoryState extends State<DialogCreateCategory> {
  File? _filePickImage;
  XFile? _image;
  final TextEditingController _textEditingControllerNameCategory = TextEditingController();
  Category _category = Category(0, "", "",  "");


  @override
  void dispose() {
    _textEditingControllerNameCategory.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(
      builder: (context,snapshot,_){
        if(snapshot.getListCategory != []){
          _category.id = snapshot.getListCategory.length;
        }
        return AlertDialog(
          title: Text("Add Category"),
          content:Container(
            width: 300,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 100,height: 100,decoration: BoxDecoration(
                    border: Border.all(width: 3,color: StrakColor.colorTheme6),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                ),child: InkWell(onTap: () async{
                  final ImagePicker picked = ImagePicker();
                  _image = await picked.pickImage(source: ImageSource.gallery);
                  if( _image != null){
                    setState(() {
                      _filePickImage = File(_image!.path);
                    });
                  }
                },child: CircleAvatar(backgroundImage:_filePickImage  == null ? AssetImage("assets/images_app/default_image.png",) as ImageProvider : FileImage(File(_filePickImage!.path)),))),
                SizedBox(height: 15,)
                ,Flexible(flex: 1,
                  child: TextFormField(
                    controller: _textEditingControllerNameCategory,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: StrakColor.colorTheme6,width: 3)
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: StrakColor.colorTheme6,width: 3)
                      ),
                      hintText: "Enter Category Name",
                    ),textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(onPressed: (){
                  StorageRepository().uploadFileImageCategory(_image!,_category.getId ,_textEditingControllerNameCategory.text, _category.getImageName);
                  Navigator.of(context).pop();
                }, child: Text("Create"))
              ],
            ),
          ),
        );
      },
    );
  }
}
