module ApplicationHelper
  def google_tag_manager_code
    case Rails.env
    when "production" then 'GTM-M4GV4QQ'
    else
      'GTM-PXH4TF2'
    end
  end
end
