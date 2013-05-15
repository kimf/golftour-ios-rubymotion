class CoursesController < UITableViewController

  stylesheet :base

  attr_accessor :courses, :filtered_courses, :isFiltered

  layout :table do
  end

  def layoutDidLoad
   self.title = "Välj bana"
   @search_results = []
   @filtered_courses = []
   @courses = Course.order(:name).all

   # self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
   #     UIBarButtonSystemItemBack,
   #     target: self,
   #     action: :cancel)

   self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
       UIBarButtonSystemItemRefresh,
       target: self,
       action: :sync)

   search_bar = UISearchBar.alloc.initWithFrame([[0,0],[320,44]])
   search_bar.delegate = self
   view.addSubview(search_bar)
   view.tableHeaderView = search_bar

   reload_data if @courses.length == 0
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
    return false if @isFiltered

    SVProgressHUD.showWithStatus("Laddar ner banor och hål. Kommer ta ett tag!", maskType:SVProgressHUDMaskTypeGradient)

    AFMotion::Client.shared.get("courses?auth_token=#{App.delegate.auth_token}") do |result|
      if result.success?
        result.object["courses"].each do |course|
          if course["holes"] && course["holes"].length > 0
            existing_course = Course.where(:id).eq(course["id"]).first || Course.new
            existing_course.id          = course["id"]
            existing_course.name        = course["name"]
            existing_course.par         = course["par"]
            existing_course.index       = course["index"]
            existing_course.has_gps     = course["has_gps"]
            existing_course.holes_count = course["holes_count"]
            existing_course.lat         = course["lat"]
            existing_course.lng         = course["lng"]

            course["holes"].each do |hole|
              existing_hole = Hole.where(:id).eq(hole["id"]).first || Hole.new
              existing_hole.course_id  = course["id"]
              existing_hole.id         = hole["id"]
              existing_hole.nr         = hole["nr"]
              existing_hole.par        = hole["par"]
              existing_hole.length     = hole["length"]
              existing_hole.hcp        = hole["hcp"]
              existing_hole.lat        = hole["lat"]
              existing_hole.lng        = hole["lng"]
              existing_course.holes << existing_hole
            end
          end
          existing_course.save
        end
        Course.serialize_to_file('courses.dat')
        Hole.serialize_to_file('holes.dat')

        @courses = Course.order(:name).all
        self.tableView.reloadData

        SVProgressHUD.dismiss
      elsif result.failure?
        SVProgressHUD.dismiss
        App.alert(result.error.localizedDescription)
      end
    end

    return true
  end

  def cancel
    App.delegate.router.open("leaderboard")
  end

  def sync
    UIActionSheet.alert 'Vill du synca banor, det tar lite tid?', buttons: ['Ja fö fan', 'Näää!'],
      cancel: proc { reload_data },
      destructive: proc {}
  end

  # def new
  #   App.delegate.router.open("new_course")
  # end

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
    App.delegate.router.open("setup_game")
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :bottom_line)
        end
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end
    end
end