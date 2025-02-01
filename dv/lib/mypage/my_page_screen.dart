
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String nickname="nickname"; //유저 닉네임(입력받으면 바꿔야 함)
  int point=0; //포인트 초기값 설정

  XFile? _pickedFile;

  @override
  Widget build(BuildContext context) {

    final imageSize=MediaQuery.of(context).size.width /8;

    return Scaffold(
      appBar: AppBar(
        title: Text("마이페이지"),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          IconButton(onPressed: (){
            ///메뉴 버튼 실행 시 코드 작성
          }, icon: Icon(Icons.menu),),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(//위젯 크기 제약 조건 설정
                  minHeight: MediaQuery.of(context).size.width,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 100, top: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: imageSize,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nickname,
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(height: 7,),
                                Text(
                                  "보유 포인트 : $point pt",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: (){
                          _showBottomSheet();
                        }, child: const Text("프로필 편집")),

                      ],
                    ),

                  ),//왼쪽 상단 정렬

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              child: const Text('사진찍기'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = _pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

}
