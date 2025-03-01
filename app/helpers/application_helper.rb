module ApplicationHelper

  def full_title(page_title = '')
    #ここで関数を定義しており、引数がpage_titleの中に格納される。
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

end
