enum Pages { postReview, posts, favorites, newPost, userProfile }

class PagesPayload {
  final Pages page;
  final Map<String, dynamic>? payload;
  PagesPayload(
    this.page,
    this.payload,
  );
}
