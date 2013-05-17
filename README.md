Golftour_iOS
============
iOS application for golftour, beat your friends, get bragging-rights and keep statistics!


class MenuScreen < PM::TableScreen
  def will_appear
    @view_setup ||= begin
      view.backgroundColor = :red.uicolor
      true
    end
  end
end


def table_data
  [{
    title: "Ledartavla",
    cells: [
      @friends.map do |f|
        { title: f.name, action: :tapped_friend, arguments: { friend: f } }
      end
    ]
  }]
end

self.update_table_data


#app_delagate.rb
def on_load(application, options)
  # ...
  appearance_defaults
  # ...
end

def appearance_defaults
  UIApplication.sharedApplication.setStatusBarHidden true, animated:false
  UITabBar.appearance.tintColor = "#123456".to_color
  UITabBar.appearance.selectionIndicatorImage = UIImage.imageNamed("someimage.png")
  UINavigationBar.appearance.tintColor = "#123456".to_color
  UISearchBar.appearance.tintColor = "#123456".to_color
  UIToolbar.appearance.tintColor = "123456".to_color
end