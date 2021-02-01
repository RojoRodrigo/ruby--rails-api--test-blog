class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  def author
    user = self.object.user

    {
      id: user.id,
      email: user.email,
      name: user.name,
    }
  end
end
