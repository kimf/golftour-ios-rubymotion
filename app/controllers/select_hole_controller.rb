class SelectHoleController < UITableViewController
  stylesheet :base

  attr_accessor :course, :holes

  layout :table do
  end


  def tableView(tableView, numberOfRowsInSection:section)
    @holes.count || 0
  end

  def initWithCourse(course)
    init.tap do
      @holes = course.holes.all
    end
  end


  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      s = @holes[indexPath.row]
      cell.textLabel.text = "Hål #{s.nr}, par #{s.par}"
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    self.viewDeckController.closeLeftViewBouncing(
      Proc.new { |controller|
        if controller.centerController.is_a?(UINavigationController)
          cc = controller.centerController.topViewController
          cc.change_hole(@holes[indexPath.row])
          if cc.respond_to?(:tableView)
            cc.tableView.deselectRowAtIndexPath(cc.tableView.indexPathForSelectedRow, animated: false)
          end
        end
      }
    )
  end

  private
    def fresh_cell
      tableView.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell').tap do |cell|
        layout cell, :cell do
          subview(UIView, :bottom_line)
        end
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end
    end
end