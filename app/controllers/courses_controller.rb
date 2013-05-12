class CoursesController < UITableViewController
  stylesheet :scorecards_sheet
  include Refreshable

  attr_accessor :courses, :filtered_courses, :isFiltered

  layout :table do
    self.title = "Välj bana"
    closeButton = UIBarButtonItem.alloc.initWithTitle("Avbryt", style: UIBarButtonItemStylePlain, target:self, action:'close')
    self.navigationItem.leftBarButtonItem = closeButton
  end

  def init
    @courses = []
    super
  end

  def viewDidLoad
    super
    layout tableView, :table
    tableView.rowHeight = 40

    search_bar = UISearchBar.alloc.initWithFrame([[0,0],[320,44]])
    search_bar.delegate = self

    view.addSubview(search_bar)
    view.tableHeaderView = search_bar
    @search_results = []

    @courses = Course.all({:sort => {:name => :asc}})
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
    SVProgressHUD.showWithStatus("Uppdaterar banor", maskType:SVProgressHUDMaskTypeGradient)
    if @isFiltered
      end_refreshing
      SVProgressHUD.dismiss
      return true
    end
    BW::HTTP.get("#{App.delegate.server}/courses?auth_token=#{App.delegate.auth_token}" ) do |response|
      json = BW::JSON.parse(response.body.to_s)
      json["courses"].each do |course|
        existing_course = Course.find(:id, NSFEqualTo, course["id"]).first
        if !existing_course
          puts "Creating new"
          Course.create(
            id:           course["id"],
            name:         course["name"],
            par:          course["par"],
            index:        course["index"],
            has_gps:      course["has_gps"],
            holes_count:  course["holes_count"]
          )
        else
          existing_course.name        = course["name"]
          existing_course.par         = course["par"]
          existing_course.index       = course["index"]
          existing_course.has_gps     = course["has_gps"]
          existing_course.holes_count = course["holes_count"]
          existing_course.save
        end
      end
      @courses = Course.all({:sort => {:name => :asc}})
      self.tableView.reloadData
      SVProgressHUD.dismiss
      end_refreshing
    end
    return true
  end

  def close
    navigationController.dismissViewControllerAnimated(true, completion: lambda{})
  end

  def new
    controller = NewCourseController.new
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    navigationController.navigationBar.tintColor = "#1b8ad4".to_color
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal
    self.presentViewController(navigationController, animated: true, completion: lambda{})
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
    controller = PlayController.controller
    controller.course_id = courses[indexPath.row].id
    self.navigationController.pushViewController(controller, animated: true)
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :top_line)
          subview(UIView, :bottom_line)
        end

        cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      end
    end
end