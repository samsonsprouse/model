class User
  include Hanami::Entity
end

class Author
  include Hanami::Entity
end

class Book
  include Hanami::Entity
end

class Operator
  include Hanami::Entity
end

class UserRepository < Hanami::Repository
  relation(:users) do
    schema(infer: true) do
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       User
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]

  def [](id)
    users.by_id(id).as(:entity).one
  end
  alias_method :find, :[]

  def all
    users.as(:entity)
  end

  def first
    users.as(:entity).first
  end

  def last
    users.order(Sequel.desc(users.primary_key)).as(:entity).first
  end

  def clear
    users.delete
  end

  def by_name(name)
    users.where(name: name).as(:entity)
  end
end

class AuthorRepository < Hanami::Repository
  relation(:authors) do
    schema(infer: true) do
      associate do
        many :books
      end
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Author
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]
  relations :books

  def [](id)
    authors.by_id(id).as(:entity).one
  end
  alias_method :find, :[]

  def find_with_books(id)
    aggregate(:books).where(authors__id: id).as(Author).one
  end
end

class BookRepository < Hanami::Repository
  relation(:books) do
    schema(infer: true) do
      # associate do
      #   many :books
      # end
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Book
    register_as :entity
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]
  # relations :books

  def [](id)
    books.by_id(id).as(:entity).one
  end
  alias_method :find, :[]

#   def find_with_books(id)
#     aggregate(:books).where(authors__id: id).as(Author).one
#   end
end

class OperatorRepository < Hanami::Repository
  relation(:t_operator) do
    schema(infer: true) do
    end

    def by_id(id)
      where(primary_key => id)
    end
  end

  mapping do
    model       Operator
    register_as :entity

    attribute :id,   from: :operator_id
    attribute :name, from: :s_name
  end

  commands :create, update: :by_id, delete: :by_id, mapper: :entity, use: [:mapping, :timestamps]

  def [](id)
    t_operator.by_id(id).as(:entity).one
  end
  alias_method :find, :[]

  def all
    t_operator.as(:entity)
  end

  def first
    t_operator.as(:entity).first
  end

  def last
    t_operator.order(Sequel.desc(t_operator.primary_key)).as(:entity).first
  end

  def clear
    t_operator.delete
  end
end

Hanami::Model.load!