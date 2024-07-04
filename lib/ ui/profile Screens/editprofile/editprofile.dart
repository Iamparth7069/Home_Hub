import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/Response%20Model/user_res_model.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../constant/app_color.dart';
import 'editprofile_controller.dart';

class EditProfile extends StatefulWidget {
  UserResModel userResModel;


  EditProfile(this.userResModel);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditProfileController _editProfileController = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Obx(() => _editProfileController.isLoading.value ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
        ],
      ) : SafeArea(child: FutureBuilder(
        future: _editProfileController.loadUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text("No Data Found (404 Error)"));
                }else{
                  List<UserResModel>? servicesData = snapshot.data;
                  _editProfileController.fName.text =servicesData![0].firstName;
                  _editProfileController.lName.text = servicesData[0].lastName;
                  _editProfileController.address.text = servicesData[0].address;
                  _editProfileController.mobileNumber.text = servicesData[0].phoneNumber;
                  return Form(
                    key: _editProfileController.globel,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Obx(() => _editProfileController.imageFile.value == null ?  Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) {
                                          return LoadingAnimationWidget.hexagonDots(
                                              color: appColor, size: 5.h);
                                        },
                                        imageUrl: servicesData[0].profileImage,
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                      
                                ) : Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                      child: Image.file(_editProfileController.imageFile.value!)),
                                ) ),
                                Positioned(
                                  bottom: 0,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showImagePickerBottomSheet(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 35,
                      
                                      decoration: BoxDecoration(
                                          color: appColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Icon(Icons.edit,color: Colors.white,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          2.h.addHSpace(),
                          1.5.h.addHSpace(),
                          TextFormField(
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return "Enter First Name";
                              }else {
                                return null;
                              }
                            },
                            controller: _editProfileController.fName,
                            decoration: InputDecoration(
                                label: Text("First Name"),
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(10),
                                )
                            ),
                          ),
                          1.5.h.addHSpace(),
                          TextFormField(
                            controller: _editProfileController.lName,
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return "Enter Last Name";
                              }else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                label: Text("Last Name"),
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(10),
                                )
                            ),
                          ),
                          1.5.h.addHSpace(),
                          TextFormField(
                            controller:_editProfileController.mobileNumber,
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return "Enter Mobile Number";
                              }else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                label: Text("Mobile Number"),
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(10),
                                )
                            ),
                          ),
                          1.5.h.addHSpace(),
                          TextFormField(
                            controller: _editProfileController.address,
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return "Enter Address";
                              }else{
                                return null;
                              }
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                label: Text("Address"),
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(10),
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
      ))),
      bottomSheet: Obx(
            () => _editProfileController.isLoading.value ? Container(
          color: Colors.white,
          child: LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
        ) :  Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            child: appButton(text: "Update",onTap: () async {
              if(_editProfileController.globel.currentState!.validate()){
                UserResModel userResModel = UserResModel(firstName: _editProfileController.fName.text.toString().trim(), lastName: _editProfileController.lName.text.toString().trim(), phoneNumber: _editProfileController.mobileNumber.text.toString().trim(), address: _editProfileController.address.text.toString(), email: widget.userResModel.email, uId:  widget.userResModel.uId, profileImage: widget.userResModel.profileImage, fcmToken: widget.userResModel.fcmToken);
                bool isCheck =  await _editProfileController.updateData(userResModel);
                print(isCheck);
                Get.back();
              }
            }),
          ),
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _editProfileController.pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _editProfileController.pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
