$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "gql"
require 'pry'

require "minitest/autorun"

require 'active_record'

ActiveRecord::Base.configurations = { 'test' => {'adapter' => 'sqlite3', 'database' => ':memory:'}}
# TODO: Not sure why it doesn't recognize test adaptoer
# ActiveRecord::Base.establish_connection('test')
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

class Blog < ActiveRecord::Base
  has_one :question
end

class Question < ActiveRecord::Base
  belongs_to :blog
  has_many :answers
end

class Answer < ActiveRecord::Base
  belongs_to :question
end

# migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Tasks::DatabaseTasks.root = Dir.pwd
ActiveRecord::Tasks::DatabaseTasks.drop_current 'test'
ActiveRecord::Tasks::DatabaseTasks.create_current 'test'

class CreateAllTables < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def self.up
    create_table(:blogs) {|t| t.string :title; t.integer :star}
    create_table(:questions) {|t| t.string :content; t.integer :star; t.integer :blog_id}
    create_table(:answers) {|t| t.string :content; t.integer :star; t.integer :question_id; t.boolean :positive}
  end
end
CreateAllTables.up

## Add data
if Blog.count == 0
  Blog.create(title: 'Ruby', star: 21)
  Blog.create(title: 'React', star: 22)
  Blog.create(title: 'Rxjs', star: 23)
end

class BlogType < Gql::ArType

end

class QuestionType < Gql::ArType
end

class QueryType < Gql::RootType
  def blog
    Blog.first
  end

  def blogs(opts)
    Blog.where(opts).all
  end
end
