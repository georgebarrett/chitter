require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it 'gets all the posts' do
    repo = PostRepository.new

    posts = repo.all

    expect(posts.length).to eq 2
    expect(posts[0].id).to eq 1
    expect(posts[0].message).to eq 'BREAKING NEWS'
    expect(posts[0].time_made).to eq '2023-02-11 15:30:10'
    expect(posts[0].account_id).to eq 1
  end

  it 'gets a single post' do
    repo = PostRepository.new

    posts = repo.find(1)

    expect(posts.message).to eq 'BREAKING NEWS'
    expect(posts.time_made).to eq '2023-02-11 15:30:10'
    expect(posts.account_id).to eq 1
  end

  it 'gets a different single post' do
    repo = PostRepository.new

    posts = repo.find(2)
    
    expect(posts.message).to eq 'MORE BREAKING NEWS'
    expect(posts.time_made).to eq '2023-02-11 16:45:35'
    expect(posts.account_id).to eq 2
  end

  it 'creates a post' do
    new_post = Post.new
    new_post.message = 'NOW THE WEATHER'
    new_post.time_made = '2023-07-05 09:00:00'
    new_post.account_id = 2

    repo = PostRepository.new
    repo.create(new_post)

    posts = repo.all
    expect(posts[-1].message).to eq 'NOW THE WEATHER'
    expect(posts[-1].time_made).to eq '2023-07-05 09:00:00'
    expect(posts[-1].account_id).to eq 2
  end

  it 'deletes a post with id if 1' do 
    repo = PostRepository.new
    id_to_delete = 1

    repo.delete(id_to_delete)
    all_posts = repo.all

    expect(all_posts.length).to eq 1
    expect(all_posts[0].id).to eq 2
  end
end
