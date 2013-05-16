Teacup::Stylesheet.new :base do

  # BACKGROUND COLORS
  # ------------------------------------------------------------------------------------------
  style :root,
    backgroundColor: "#eeeeee".to_color

  style :menu,
    backgroundColor: "#152735".to_color


  # BIG ASS BUTTONS
  # ------------------------------------------------------------------------------------------
  style :big_button,
    top: 450,
    left: 20,
    width: 280,
    height: 40,
    backgroundColor: "#9b99a1".to_color,
    titleColor: "#FFFFFF".to_color,
    font: 'OpenSans-Bold'.uifont(18),
    layer: {
      cornerRadius: 4
    }

  style :play_button, extends: :big_button,
    backgroundColor: "#68a15f".to_color,
    title: "Starta Runda!"


  # TABLES
  # ------------------------------------------------------------------------------------------

  style :table,
    backgroundColor: "#eeeeee".to_color,
    separatorStyle: UITableViewCellSeparatorStyleNone


  style :empty_cell

  style :cell,
    textColor: "#2b2c2e".to_color,
    font: 'OpenSans-Semibold'.uifont(14),
    detailTextLabel: {
      textColor: "#2b2c2e".to_color,
      font: 'OpenSans-Bold'.uifont(14),
    }

  style :bottom_line,
    width: '100%',
    height: 1,
    top: lambda { superview.bounds.size.height - 1 },
    backgroundColor: "#cccccc".to_color,
    autoresizingMask: UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth

  style :selected,
    backgroundColor: "#1b8ad4".to_color

  # LEADERBOARD TABLE
  # ------------------------------------------------------------------------------------------
  # HEADER
  style :table_header,
    backgroundColor: "#4a6288".to_color

  style :header_label, extends: :label,
    top: 0,
    height: 22,
    width: 40,
    font: 'OpenSans-Bold'.uifont(10),
    textColor: "#FFFFFF".to_color,
    backgroundColor: "#4a6288".to_color

  style :player_label, extends: :header_label,
    left: 40,
    text: "Spelare"

  style :round_label, extends: :header_label,
    left: 240,
    text: "Rundor",
    textAlignment: UITextAlignmentCenter

  style :points_label, extends: :header_label,
    left: 280,
    text: "Poäng",
    textAlignment: UITextAlignmentCenter



  # CELLS
  style :cell_label,
    top: 0,
    height: 43,
    width: 40,
    font: 'OpenSans-Bold'.uifont(14),
    backgroundColor: "#e6e6e6".to_color

  style :player_position_label, extends: :cell_label,
    left: 0,
    textAlignment: UITextAlignmentCenter,
    font: 'OpenSans-Bold'.uifont(10),
    textColor: "#55575b".to_color

  style :player_name_label, extends: :cell_label,
    left: 40,
    width: 220

  style :player_rounds_label, extends: :cell_label,
    left: 240,
    textAlignment: UITextAlignmentCenter

  style :player_points_label, extends: :cell_label,
    left: 280,
    textAlignment: UITextAlignmentCenter



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
    title: "Logga ut",
    titleColor: "#eeeeee".to_color,
    font: 'OpenSans-Bold'.uifont(16),
    width: 280,
    height: 40,
    left: 0,
    top: 508
end