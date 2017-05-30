Sequel.seed do # Applies only to "development" and "test" environments
  def run
    [
      ['John', 'Doe', 'john@doe.com', 'johndoe'],
      ['Maggie', 'Turner', 'maggie@turner.com', 'maggie']
    ].each do |first_name, last_name, email, username|
      User.create first_name: first_name, last_name: last_name, email: email, username: username
    end

    [
      ['First post title', 'First post body', 1],
      ['Second Post title', 'Second post body', 2]
    ].each do |title, body, user_id|
      Post.create title: title, body: body, user_id: user_id
    end

    [
      ['First post comment body', 1, 1],
      ['Second Post comment body', 2, 2]
    ].each do |body, post_id, user_id|
      Comment.create body: body, post_id: post_id, user_id: user_id
    end
  end
end
