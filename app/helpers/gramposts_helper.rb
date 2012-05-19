module GrampostsHelper

  def wrap(description)
    sanitize(raw(description.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  # Returns the primary photo for the given grampost.
  def photo_for(grampost, options = { size: :thumb})
    # TODO: return different classes based on size option.
    size = options[:size]
    image_tag(grampost.photo.url(size), alt: grampost.title, class: "grampost_photo")
  end

  # Returns a comma delimited representation of the price.
  # If the price is $0, return the word "FREE."
  def price_for(grampost)
    if grampost.price == 0
      "FREE"
    else
      "$ %s" % number_with_delimiter(grampost.price, :delimiter => ',')
    end
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end
