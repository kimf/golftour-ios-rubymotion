class CoursesController < UITableViewController
  stylesheet :scorecards_sheet
  include Refreshable

  layout :table do
    self.title = "Select Course"
    closeButton = UIBarButtonItem.alloc.initWithTitle("Close", style: UIBarButtonItemStylePlain, target:self, action:'close')
    newCourseButton = UIBarButtonItem.alloc.initWithTitle("+", style: UIBarButtonItemStylePlain, target:self, action:'new')
    self.navigationItem.leftBarButtonItem = closeButton
    self.navigationItem.rightBarButtonItem = newCourseButton
  end

  def init
    @courses = []
    super
  end

  def viewDidLoad
    layout tableView, :table
    tableView.rowHeight = 40

    @courses = Course.all
    reload_data if @courses.length == 0

    on_refresh do
      reload_data
    end

    super
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @courses.count || 0
  end

  def reload_data
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)

    BW::HTTP.get("#{App.delegate.server}/courses?auth_token=#{App.delegate.auth_token}" ) do |response|
      json = BW::JSON.parse(response.body.to_s)
      json["courses"].each do |course|
        existing = Course.find(:id, NSFEqualTo, course["id"])
        if existing.length == 0
          puts "Creating new"
          new_course = Course.new(
            id: course["id"],
            name: course["name"],
            par: course["par"]
          )
          course["holes"].each do |hole|
            new_course.holes << Hole.create(id: hole["id"], nr: hole["nr"], par: hole["par"], hcp: hole["hcp"], length: hole["length"])
          end
          new_course.save
        end
      end
      @courses = Course.all
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
    fresh_cell.tap do |cell|
      s = @courses[indexPath.row]
      cell.textLabel.text = "#{s.name[0..22]}"
      cell.detailTextLabel.text = "#{s.holes.count} hål"

      # score_label = UILabel.alloc.initWithFrame([[280, 10], [30, 30]])
      # score_label.text = "#{s.strokes}"
      # score_label.backgroundColor = UIColor.colorWithRed(62.0/255, green: 69.0/255, blue: 95.0/255, alpha:1)
      # score_label.textColor = UIColor.whiteColor
      # score_label.textAlignment = NSTextAlignmentCenter
      # score_label.layer.cornerRadius = 4
      # cell.contentView.addSubview(score_label)
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    controller = PlayController.new
    controller.course_id = @courses[indexPath.row].id
    self.navigationController.pushViewController(controller, animated: true)
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @courses.count
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