module FlashHelper
  def flash_color(key)
    case key
    when 'notice' then 'green'
    when 'alert' then 'red'
    when 'warning' then 'yellow'
    else 'yellow'
    end
  end
end
