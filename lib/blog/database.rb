require "pstore"

module Blog
  class Database
    READ_ONLY = true
    def initialize
      @db = PStore.new(File.join(__dir__, *%w[.. .. db posts.pstore]))
    end

    attr_reader :db

    def save(post)
      db.transaction do
        db[:posts] ||= [ ]
        db[:posts].unshift(post)
      end
    end

    def load(slug)
      db.transaction(READ_ONLY) do
        db[:posts].find { |post| post.slug == slug }
      end
    end

    def all
      db.transaction(READ_ONLY) do
        Array(db[:posts])
      end
    end
  end
end
