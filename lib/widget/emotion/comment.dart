import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/comment.dart';

class Comment extends StatefulWidget {
  final int index;
  String status;
  Comment({Key? key, required this.index, required this.status})
      : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  List<String> selectedOptions = []; // Đổi sang kiểu List<String>
  List<ListComment> listComment = [];

  Future<void> getApi() async {
    listComment.clear();
    ApiResponse res = await ApiRequest.getComment();

    if (res.result == true) {
      setState(() {
        for (var e in res.data) {
          listComment.add(ListComment.fromJson(e));
        }
      });
      print(listComment);
    } else {
      print(res.message ?? "Lỗi");
    }
  }

  @override
  void initState() {
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.index == -1
            ? Container()
            : Column(
                children: [
                  RadioListTile(
                    title: Text(listComment[widget.index].detail!.s0 ?? ''),
                    value: listComment[widget.index].detail!.s0,
                    groupValue: selectedOptions
                            .contains(listComment[widget.index].detail!.s0)
                        ? listComment[widget.index].detail!.s0
                        : null,
                    onChanged: (value) {
                      setState(() {
                        if (selectedOptions.contains(value)) {
                          selectedOptions.remove(value);
                        } else {
                          selectedOptions.add(value!);
                        }
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(listComment[widget.index].detail!.s1 ?? ''),
                    value: listComment[widget.index].detail!.s1,
                    groupValue: selectedOptions
                            .contains(listComment[widget.index].detail!.s1)
                        ? listComment[widget.index].detail!.s1
                        : null,
                    onChanged: (value) {
                      setState(() {
                        if (selectedOptions.contains(value)) {
                          selectedOptions.remove(value);
                        } else {
                          selectedOptions.add(value!);
                        }
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(listComment[widget.index].detail!.s2 ?? ''),
                    value: listComment[widget.index].detail!.s2,
                    groupValue: selectedOptions
                            .contains(listComment[widget.index].detail!.s2)
                        ? listComment[widget.index].detail!.s2
                        : null,
                    onChanged: (value) {
                      setState(() {
                        if (selectedOptions.contains(value)) {
                          selectedOptions.remove(value);
                        } else {
                          selectedOptions.add(value!);
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(selectedOptions);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text('test'),
                  )
                ],
              ),
      ],
    );
  }
}
