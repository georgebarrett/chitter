require_relative 'post'

class PostRepository

  def all
    sql = 'SELECT id, message, time_made, account_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []

    result_set.each do |record|   
      posts << record_to_post_object(record)
    end
    return posts
  end

  private

  def record_to_post_object(record)
    post = Post.new
    
    post.id = record['id'].to_i
    post.message = record['message']
    post.time_made = record['time_made']
    post.account_id = record['account_id'].to_i

    return post
  end

end