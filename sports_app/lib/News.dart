class News{
  String title;
  String description;
  String url;
  String urlImage;
  String content;
  String author;
  String publishTime;

  News({
    this.title,
    this.description,
    this.url,
    this.urlImage,
    this.content,
    this.author,
    this.publishTime
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'].toString(),
      description: json['description'].toString(),
      url: json['url'].toString(),
      urlImage: json['urlToImage'].toString(),
      content: json['content'].toString(),
      author: json['author'].toString(),
      publishTime: json['publishedAt'].toString(),
    );
  }
}