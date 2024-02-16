import 'dart:convert';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:database/database.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Comment extends StatefulWidget {
  
  final int selectedEmotion;
  List resetCmt;
  List selec;
  Comment({
    Key? key,
    required this.selectedEmotion,
    required this.resetCmt,
    required this.selec,
  }) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {

TextEditingController _textEditingController = TextEditingController();
  Future<void> postData(List cmt, int selectedEmoji,String cmtdifference) async {
    final apiUrl = 'https://api.mockfly.dev/mocks/1b1eb603-acdd-4440-aec4-21f4ed51e9b0/kham5';
final pb = PocketBase('http://127.0.0.1:8090');
final body = <String, dynamic>{
"field": {
        'comments': cmt,
        'selectedEmoji': selectedEmoji,
        'commnetDifferen':cmtdifference
      }
};

final record = await pb.collection('post').create(body: body);
    // Tạo body request từ danh sách comment và emoji được chọn
    final Map<String, dynamic> requestBody = {
   
      'rate': {
        'comments': cmt,
        'selectedEmoji': selectedEmoji,
        'commnetDifferen':cmtdifference
      }
  
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Xử lý khi nhận được phản hồi từ API
        print('Dữ liệu đã được gửi thành công');
        print(response.body);
      } else {
        // Xử lý khi có lỗi từ phía server
        print('Lỗi: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Xử lý khi có lỗi kết nối
      print('Lỗi kết nối: $e');
    }
  }
bool checkrole=false;

Future<void> handlerole() async {
  
    SharedPreferences role = await SharedPreferences.getInstance();
 role.getString('role');
  if(role==1){
checkrole=true;
  }
   else if(role==2){
checkrole=false;
  }
}
  void _postApi() {
  Navigator.pushNamed(context,'/logout');
   
    postData(widget.resetCmt, widget.selectedEmotion,_textEditingController.text);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeScreen()),
    // );
  }


bool checkIndex=true;
  Map<int, Map<String, Map<int, String>>> emotions = {
    0: {
      'Rất tệ': {
        0: 'Bảo vệ,nhân viên rất thiếu nhiệt tình',
        1: 'Y bác sĩ khám điều trị yếu kém',
        2: 'Chăm sóc sau điều trị rất kém'
      }
    },
    1: {
      'Tệ': {
        0: 'Bảo vệ, nhân viên không nhiệt tình',
        1: 'Y bác sĩ khám điều trị yếu kém',
        2: 'chăm sóc sau điều trị kém',
      },
    },
    2: {
      'Bình thường': {
        0:'Khách hàng không có đánh giá gì'
      },
    },
    3: {
      'Tốt': {
        0: 'Bảo vệ,nhân viên nhiệt tình ',
        1: 'Bác sĩ khám điều trị tốt',
        2: 'Chăm sóc sau điều trị tốt',
      }
    },
    4:{
      'Hoàn hảo': {
        0: 'Bảo vệ,nhân viên rất nhiệt tình ',
        1: 'Bác sĩ khám điều trị rất tốt',
        2: 'Chăm sóc sau điều trị chu đáo',
      }
    },
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          if (widget.selectedEmotion != -1)
            Column(
              children: [
                Container(
                  height: 220,
                  child: ListView.builder(
                    itemCount:
                        emotions[widget.selectedEmotion]?.values.single.length,
                    itemBuilder: (context, index) {
                      final value =
                          emotions[widget.selectedEmotion]?.values.single.values;
                          String content=emotions[widget.selectedEmotion]!
                                .values
                                .single
                                .values
                                .elementAt(index);
                               
print(widget.selec);
                      return Container(
                        margin:
                            EdgeInsets.only(bottom: 10), // Adjust the spacing here
                        child: ListTile(
                          tileColor: widget.selec[index]
                              ? Colors.amberAccent
                              : const Color.fromARGB(255, 255, 255, 255),
                          title: Text(content
                            ,                             
                          ),
                          trailing: widget.selec[index]
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          iconColor: !widget.selec[index]
                              ? Colors.amberAccent
                              : const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          

  
                          onTap: () {
                            if(index!=2){

                            setState( () {
                            

print(widget.resetCmt);
                              widget.selec[index] = !widget.selec[index];
                              if (widget.selec[index] && !widget.resetCmt.contains(index)) {
                                widget.resetCmt.add(index);

                              }

                           else if(!widget.selec[index] && widget.resetCmt.contains(index)) {
                                widget.resetCmt.remove(index);
                              }
                              print(index);
                              print(widget.resetCmt);
                              print(widget.selectedEmotion);
                              print(
                                emotions[widget.selectedEmotion]
                                    ?.values
                                    .single
                                    .entries
                                    .length,
                              );
                            }
                            );}
                            
                            else if(index==2){
setState(() {
   widget.selec[index]=false;
   checkIndex=false;

});
      
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                  Visibility(
                    visible: checkIndex,
                    child: TextField(
                      maxLines:null,
                      controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter text',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: Colors.blue, // Đổi màu sắc của đường viền nếu cần
                              ),
                            ),
                            contentPadding: EdgeInsets.all(16.0), // Điều chỉnh khoảng cách giữa văn bản và đường viền
                          ),
                        ),
                  ),
                 SizedBox(
                  height: 20,
                ),
                 ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(20),
                          backgroundColor: Color.fromRGBO(47, 179, 178, 0.8)),
                      onPressed: _postApi,
                      child: Text("SANG BƯỚC XÁC NHẬN GIÁ",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 20)
                              )
                              ),
                
              ],
            ),
          if (widget.selectedEmotion == -1) ManHinhcho()
        ]),
        SizedBox(height:30),

        Visibility(
          visible: checkrole,
          child: ElevatedButton(style: ButtonStyle( backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Xác định màu sắc dựa trên trạng thái của nút
              if (states.contains(MaterialState.pressed)) {
                // Trạng thái khi nút được nhấn
                return Colors.red;
              } else {
                // Trạng thái mặc 
                return Color.fromRGBO(47, 179, 178, 0.8);
              }})),onPressed: _navigator, child: Text("Chuyển sang trang đánh giá trung bình")),
        )
      ],
    );
  }
  void _navigator(){
// Navigator.push(context,MaterialPageRoute(builder: (context)=>RateScreen()));
  }
  @override
  void dispose(){
    _textEditingController.dispose();
    super.dispose();
  }
}

class ManHinhcho extends StatelessWidget {
  const ManHinhcho({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          child: Image.asset('assets/images/pk.jpg'),
        ),
        
      ],
    );
  }

}
