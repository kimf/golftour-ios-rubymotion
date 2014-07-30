Teacup::Stylesheet.new :base do

  # BACKGROUND COLORS
  # ------------------------------------------------------------------------------------------
  style :root,
    backgroundColor: "#eeeeee".to_color

  style :scorecard,
    backgroundColor: "#cccccc".to_color

  style :menu,
    backgroundColor: "#152735".to_color


  # BIG ASS BUTTONS
  # ------------------------------------------------------------------------------------------
  style :big_button,
    top: lambda { superview.bounds.size.height - 60 },
    left: 20,
    width: lambda { superview.bounds.size.width - 40 },
    height: 40,
    backgroundColor: "#152735".to_color,
    titleColor: "#FFFFFF".to_color,
    font: 'OpenSans-Bold'.uifont(18),
    layer: {
      cornerRadius: 4
    }

  style :play_button, extends: :big_button,
    top: 10,
    backgroundColor: "#4c7645".to_color,
    title: "BÖRJA SPELA"


  style :button_bg,
    left: 0,
    top: 444,
    height: 60,
    width: '100%',
    backgroundColor: "#cccccc".to_color


  # SETUP GAME
  # ------------------------------------------------------------------------------------------

  style :current_course_label, extends: :label,
    left: 0,
    top: 0,
    height: 44,
    width: '100%',
    font: 'OpenSans-Bold'.uifont(14),
    textColor: "#eeeeee".to_color,
    backgroundColor: "#447ca5".to_color,
    textAlignment: UITextAlignmentCenter

  # PLAYING
  # ------------------------------------------------------------------------------------------
  style :meters_to_center_label, extends: :current_course_label,
    top: 460,
    backgroundColor: "#cccccc".to_color,
    textColor: "#393939".to_color

  style :current_hole_label, extends: :current_course_label,
    width: 60

  style :hole_label, extends: :current_hole_label,
    left: 0,
    font: 'OpenSans-Bold'.uifont(18)

  style :hole_par_label, extends: :current_hole_label,
    left: 160

  style :hole_distance_label, extends: :current_hole_label,
    left: 216

  style :scorecard_button, extends: :button,
    left: 280,
    width: 44,
    height: 44,
    backgroundColor: "#579ed4".to_color,
    titleColor: "#eeeeee".to_color,
    title: "S"

  style :end_round_button, extends: :scorecard_button,
    left: 236,
    title: "X"


  style :high_table_header,
    height: 30,
    width: '100%',
    backgroundColor: UIColor.clearColor

  style :holes_header, extends: :high_table_header,
    top: 44

  style :pars_header, extends: :high_table_header,
    top: 74

  style :small_label, extends: :label,
    width: 25,
    height: 29,
    textAlignment: UITextAlignmentCenter,
    font: 'OpenSans-Bold'.uifont(6),
    backgroundColor: "#eeeeee".to_color,
    textColor: "#7f7f7f".to_color

  style :par_label, extends: :small_label,
    top: 74

  style :hole_nr_label, extends: :small_label,
    top: 44

  style :score_label, extends: :small_label,
    height: 43


  style :scorecard_name_label, extends: :small_label,
    width: 60,
    height: 30,
    font: 'OpenSans-Bold'.uifont(8),
    backgroundColor: "#efefef".to_color

  style :hole_nr_header_label, extends: :scorecard_name_label,
    top: 44,
    height: 29

  style :par_header_label, extends: :scorecard_name_label,
    top: 74,
    height: 29

  style :score_header_label, extends: :scorecard_name_label,
    height: 43

  style :scorecard_cell_label, extends: :small_label,
    width: 25,
    height: 30,
    backgroundColor: "#ffffff".to_color

  # TABLES
  # ------------------------------------------------------------------------------------------
  style :table,
    backgroundColor: "#eeeeee".to_color,
    separatorStyle: UITableViewCellSeparatorStyleNone

  style :players_table, extends: :table,
    top: 44,
    height: 400

  style :default_cell,
    textColor: "#2b2c2e".to_color,
    font: 'OpenSans-Semibold'.uifont(14)

  style :cell, extends: :default_cell,
    detailTextLabel: {
      textColor: "#2b2c2e".to_color,
      font: 'OpenSans-Bold'.uifont(14)
    }

  style :bottom_line,
    width: '100%',
    height: 1,
    top: lambda { superview.bounds.size.height - 1 },
    backgroundColor: "#cccccc".to_color,
    autoresizingMask: UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth

  style :selected,
    backgroundColor: "#ffeebb".to_color


  style :checkmark,
    left: 300,
    width: 20,
    height: 20

  # LEADERBOARD TABLE
  # ------------------------------------------------------------------------------------------
  # HEADER
  style :table_header,
    backgroundColor: "#152735".to_color

  style :header_label, extends: :label,
    top: 0,
    height: 22,
    width: 60,
    font: 'OpenSans-Bold'.uifont(10),
    textColor: "#FFFFFF".to_color,
    backgroundColor: "#152735".to_color

  style :player_label, extends: :header_label,
    left: 40,
    text: "SPELARE"

  style :round_label, extends: :header_label,
    left: 200,
    text: "RUNDOR",
    textAlignment: UITextAlignmentCenter

  style :points_label, extends: :header_label,
    left: 260,
    text: "POÄNG",
    textAlignment: UITextAlignmentCenter



  # CELLS
  style :cell_label,
    top: 0,
    height: 43,
    width: 60,
    font: 'OpenSans-Bold'.uifont(14),
    backgroundColor: UIColor.clearColor
    # backgroundColor: "#e6e6e6".to_color

  style :player_position_label, extends: :cell_label,
    width: 20,
    left: 0,
    textAlignment: UITextAlignmentCenter,
    font: 'OpenSans-Bold'.uifont(10),
    textColor: "#152735".to_color

  style :player_name_label, extends: :cell_label,
    left: 20,
    width: 220

  style :player_rounds_label, extends: :cell_label,
    left: 200,
    textAlignment: UITextAlignmentCenter,
    textColor: "#6f808e".to_color

  style :player_points_label, extends: :cell_label,
    left: 260,
    textAlignment: UITextAlignmentCenter,
    font: 'OpenSans-Bold'.uifont(18)



  # NAVIGATION BAR
  # ------------------------------------------------------------------------------------------
  style :navigation_bar,
    left: 0,
    top: 0,
    width: '100%',
    height: 44,
    backgroundColor: "#447ca5".to_color

  style :avatar,
    left: 0,
    top: 0,
    width: 44,
    height: 44

  style :list_avatar,
    left: 20,
    top: 10,
    width: 24,
    height: 24

  style :list_header_label, extends: :label,
    left: 10,
    top: 64,
    width: 100,
    height: 22,
    font: 'OpenSans-Bold'.uifont(10),
    textColor: "#617790".to_color,
    backgroundColor: UIColor.clearColor

  style :current_player, extends: :label,
    left: 60,
    top: 0,
    height: 44,
    width: 140,
    font: 'OpenSans-Bold'.uifont(14),
    textColor: "#e0e0e0".to_color,
    backgroundColor: UIColor.clearColor

  style :menu_table,
    backgroundColor: UIColor.clearColor,
    separatorStyle: UITableViewCellSeparatorStyleNone,
    top: 88,
    left: 0,
    width: '100%',
    height: '444'


  style :menu_cell,
    textColor: "#eeeeee".to_color,
    font: 'OpenSans-Semibold'.uifont(14)

  style :menu_bottom_line,
    width: '100%',
    height: 1,
    top: lambda { superview.bounds.size.height - 1 },
    backgroundColor: "#080d12".to_color,
    autoresizingMask: UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth

  style :logout_button,
    backgroundColor: "#101010".to_color,
    title: "LOGGA UT",
    titleColor: "#eeeeee".to_color,
    font: 'OpenSans-Bold'.uifont(16),
    width: 280,
    height: 44,
    left: 0,
    top: 506
end