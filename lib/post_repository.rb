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

  def find(id)
    sql = 'SELECT id, message, time_made, account_id FROM posts WHERE id =$1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)
    record = result[0]

    return record_to_post_object(record)
  end

  def create(post)
    sql = 'INSERT INTO posts (message, time_made, account_id) VALUES ($1, $2, $3);'
    sql_params = [post.message, post.time_made, post.account_id]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(post)
    sql = 'UPDATE posts SET message = $1, time_made = $2, account_id = $3 WHERE id = $4;'
    sql_params = [post.message, post.time_made, post.account_id, post.id]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
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