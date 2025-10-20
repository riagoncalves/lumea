module SeoHelper
  def title(title)
    content_for :app_title do
      "#{title} | Lumea"
    end
  end

  def seo_title
    content_for?(:app_title) ? content_for(:app_title) : 'Lumea'
  end

  def seo_description
    ''
  end

  def seo_keywords
    ''
  end

  def seo_author
    'riagoncalves.dev'
  end

  def seo_url
    'https://localhost:3000'
  end

  def seo_image
    #asset_url('thumbnail.png')
  end
end
