class MenuController < UIViewController
  stylesheet :base

  layout :menu do
    subview(UILabel, :navigation_bar) do
      avatar = UIImage.imageNamed("1.png")
      subview(UIImageView, :avatar, image: avatar)
      subview(UILabel, :current_player, text: "KIM FRANSMAN")
    end

    subview(UILabel, :list_header_label, text: "TOURER")


    @table = UITableView.alloc.initWithFrame(view.frame, style: UITableViewStylePlain)
    @table.dataSource = self
    @table.delegate   = self

    subview(@table, :menu_table)

    subview(UIButton, :logout_button).on_tap do
      App.delegate.logout
    end


  end

  def layoutDidLoad
    super
    @tours = [
      {name: 'Simple Golftour'},
      {name: 'Team Eightyfour'},
      {name: 'Baraspara Trophy'}
    ]
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @tours.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(cell_identifier)

    if not cell
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_identifier).tap do |cell|
        layout cell, :menu_cell do
          subview(UIView, :menu_bottom_line)
        end
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end
    end

    cell.textLabel.text = "#{@tours[indexPath.row][:name]}"

    return cell
  end

  def cell_identifier
    @@cell_identifier ||= 'Cell'
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    self.viewDeckController.closeLeftViewBouncing(
      Proc.new { |controller|
        if controller.centerController.is_a?(UINavigationController)
          cc = controller.centerController.topViewController
          cc.navigationItem.title = tableView.cellForRowAtIndexPath(indexPath).textLabel.text
          if cc.respond_to?(:tableView)
            cc.tableView.deselectRowAtIndexPath(cc.tableView.indexPathForSelectedRow, animated: false)
          end
        end
      }
    )
  end

end