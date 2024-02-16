class ListComment {
  int? level;
  List<Comments>? comments;

  ListComment({this.level, this.comments});

  ListComment.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? id;
  int? commentType;
  int? level;
  String? content;

  Comments({this.id, this.commentType, this.level, this.content});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentType = json['commentType'];
    level = json['level'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commentType'] = this.commentType;
    data['level'] = this.level;
    data['content'] = this.content;
    return data;
  }
}
