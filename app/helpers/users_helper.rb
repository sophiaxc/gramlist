module UsersHelper
  
  # Returns the avatar for the given user.
  def avatar_for(user, options = { size: :thumb})
    size = options[:size]
    image_tag(user.avatar.url(size), alt: user.name, class: "avatar")
  end
end
