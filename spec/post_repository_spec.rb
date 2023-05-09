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
end