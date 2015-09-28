class HoleScoreController < UIViewController
  stylesheet :base

  attr_accessor :players,
                :current_hole,
                :locationManager,
                :holeLocation,
                :currentLocation,
                :scorecardController

  layout :root

  def teacup_layout
    @players_table = UITableView.alloc.initWithFrame(view.frame, style: UITableViewStylePlain)
    @players_table.dataSource = self
    @players_table.delegate   = self
    @players_table.setScrollEnabled(false)
    subview(@players_table, :players_table)

    subview(UIView, :navigation_bar) do
      subview(UILabel, :hole_label, text: "#{@current_hole.nr}")
      subview(UILabel, :hole_par_label, text: "par #{@current_hole.par}")
      subview(UILabel, :hole_distance_label, text: "#{@current_hole.meters}m")
      subview(UIButton, :scorecard_button).on_tap do
        show_scorecard
      end
      #@meters_to_center_label = subview(UILabel, :meters_to_center_label, text: meters_to_center)
    end
  end

  def initWithData(hole, players, scorecardController)
    init.tap do
      @current_hole        = hole
      @players             = players
      @scorecardController = scorecardController
      # @holeLocation = CLLocation.alloc.initWithLatitude(@current_hole.lat, longitude: @current_hole.lng)

      # @locationManager = CLLocationManager.alloc.init
      # @locationManager.delegate = self
      # @locationManager.desiredAccuracy = KCLLocationAccuracyBest
      # @locationManager.activityType    = CLActivityTypeFitness
      # @locationManager.distanceFilter  = 1

      # @locationManager.startUpdatingLocation
    end
  end

  #PLAYERS
  def tableView(tableView, numberOfRowsInSection:section)
    @players.count || 0
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      p  = @players[indexPath.row]
      layout(cell.contentView) do
        subview(UILabel, :player_name_label, text: "#{p.name}")

        subview(UILabel,
          :player_points_label,
          text: "#{@scorecardController.strokes_for_player(p.id, [@current_hole.nr])}"
        )
        subview(UIView, :bottom_line)
        cell.setSelectionStyle(UITableViewCellSelectionStyleNone)
      end
    end
  end

  # SCORECARD
  def show_scorecard
    self.presentViewController(@scorecardController, animated:true, completion:nil)
  end

  # #GPS STUFF
  # def meters_to_center
  #   @currentLocation ||= @locationManager.location
  #   @currentLocation ? "#{@currentLocation.distanceFromLocation(@holeLocation).round(0)} m" : "..."
  # end

  # def locationManager(manager, didUpdateLocations: locations)
  #   @currentLocation = locations.last
  #   puts "im updating the location now..."
  #   @meters_to_center_label.text = meters_to_center
  # end

  private
    def fresh_cell
      @players_table.dequeueReusableCellWithIdentifier('Cell') ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'Cell')
    end

end