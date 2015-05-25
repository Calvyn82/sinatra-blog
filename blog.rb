require "sinatra"
require_relative "lib/blog/post"
require_relative "lib/blog/database"

db = Blog::Database.new

helpers do
  include ERB::Util
end

get "/admin/posts/new" do
  title = "Blog / Admin / New Post"
  erb :new_post, locals: {title: title, post: Blog::Post.new}
end

post "/admin/posts" do
  title = "Blog / Admin / New Post"
  post = Blog::Post.new(subject: params[:subject], body: params[:body])
  if post.valid?
    db.save(post)
    redirect "/posts/#{post.slug}"
  else
    erb :new_post, locals: {title: title, post: post}
  end
end

get "/posts/:slug" do
  post = db.load(params[:slug])
  title = "Blog / #{post.subject}"
  erb :post, locals: { title: title, post: post }
end

get "/" do
  title = "Blog"
  posts = db.all
  erb :list_posts, locals: {title: title, posts: posts}
end


# Templates:
#
# * A way to render some content (erb, haml, builder)
# * Most template engines give two ways to insert: flow and values( <% %> and <%= %> )
# * Most give a way to separate out layouts
# * There is always some way to pass information down to the template
# * Always remember to handle escaping **IMPORTANT!!!*
#
# THE WORLD'S EASIEST DATABASE
#
# * 'require "pstore"'
# * Put all interactions inside 'transaction do ...'
# * Treat as 'Hash'
# * Set _read only_ flag for speed when not writing to database
