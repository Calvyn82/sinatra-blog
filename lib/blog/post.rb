module Blog
  class Post
    def initialize(subject: nil, body: nil, created_at: Time.now)
      @subject    = subject
      @body       = body
      @created_at = created_at
    end

    attr_reader :subject, :body, :created_at

    def new?
      subject.nil? && body.nil?
    end

    def errors
      errors = [ ]
      unless subject =~ /\S/
        errors << "Subject can't be blank."
      end
      unless body =~ /\S/
        errors << "Body can't be blank."
      end
      unless created_at.is_a?(Time)
        errors << "A creation time is needed."
      end
      errors
    end

    def valid?
      subject =~ /\S/ && body =~ /\S/ && created_at.is_a?(Time)
    end

    def slug
      subject.downcase.delete("^a-z0-9 ").gsub(/\s+/, "-")
    end
  end
end
