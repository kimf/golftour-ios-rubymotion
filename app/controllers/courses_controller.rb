class CoursesController < UITableViewController
  include Refreshable

  stylesheet :table

  attr_accessor :courses, :filtered_courses, :isFiltered

  layout :table do
    self.title = "Välj bana"
    @search_results = []
    @filtered_courses = []
    @courses = Course.all({:sort => {:name => :asc}})

    closeButton = UIBarButtonItem.alloc.initWithTitle("Avbryt", style: UIBarButtonItemStylePlain, target:self, action:'cancel')
    self.navigationItem.leftBarButtonItem = closeButton

    search_bar = UISearchBar.alloc.initWithFrame([[0,0],[320,44]])
    search_bar.delegate = self
    view.addSubview(search_bar)
    view.tableHeaderView = search_bar

    reload_data if @courses.length == 0
    on_refresh do
      reload_data
    end
  end

  def searchBarSearchButtonClicked(search_bar)
    @search_results.clear
    search_bar.resignFirstResponder
    search_for(search_bar.text)
  end

  def searchBar(searchBar, textDidChange: searchText)
    search_for(searchText)
  end


  def search_for(text)
    if text.length == 0
      @isFiltered = false
    else
      @isFiltered = true
      @filtered_courses = @courses.select{|c| c.name.downcase.match(text.downcase) }
    end
    self.tableView.reloadData
  end


  def tableView(tableView, numberOfRowsInSection:section)
    courses = @isFiltered ? @filtered_courses : @courses
    courses.count || 0
  end

  def reload_data
    if @isFiltered
      end_refreshing
      return true
    end
    SVProgressHUD.showWithStatus("Laddar ner banor och hål. Kommer ta ett tag!", maskType:SVProgressHUDMaskTypeGradient)
    App.delegate.store.save_interval = 10000

    AFMotion::Client.shared.get("courses?auth_token=#{App.delegate.auth_token}") do |result|
      if result.success?
        result.object["courses"].each do |course|
          existing_course = Course.find(:id, NSFEqualTo, course["id"]).first || Course.new
          existing_course.id          = course["id"]
          existing_course.name        = course["name"]
          existing_course.par         = course["par"]
          existing_course.index       = course["index"]
          existing_course.has_gps     = course["has_gps"]
          existing_course.holes_count = course["holes_count"]
          App.delegate.store          << existing_course

          if course["holes"] && course["holes"].length > 0
            course["holes"].each do |hole|
              existing_hole = Hole.find(:id, NSFEqualTo, hole["id"]).first || Hole.new
              existing_hole.course_id  = course["id"]
              existing_hole.id         = hole["id"]
              existing_hole.nr         = hole["nr"]
              existing_hole.par        = hole["par"]
              existing_hole.length     = hole["length"]
              existing_hole.hcp        = hole["hcp"]
              existing_hole.lat        = hole["lat"]
              existing_hole.lng        = hole["lng"]
              App.delegate.store       << existing_hole
            end
          end

        end

        App.delegate.store.save
        App.delegate.store.save_interval = 1

        @courses = Course.all({:sort => {:name => :asc}})
        self.tableView.reloadData

        SVProgressHUD.dismiss
      elsif result.failure?
        SVProgressHUD.dismiss
        App.alert(result.error.localizedDescription)
      end
      end_refreshing
    end

    return true
  end

  def cancel
    App.delegate.router.open("leaderboard")
  end

  def new
    App.delegate.router.open("new_course")
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    courses = @isFiltered ? @filtered_courses : @courses
    fresh_cell.tap do |cell|
      s = courses[indexPath.row]
      cell.textLabel.text = "#{s.name[0..22]}"
      cell.detailTextLabel.text = "#{s.holes_count} hål"
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    courses = @isFiltered ? @filtered_courses : @courses
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    App::Persistence['current_course_id'] = courses[indexPath.row].id
    App.delegate.router.open("players")
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :bottom_line)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end
end