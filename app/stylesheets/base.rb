Teacup::Stylesheet.new :base do

  style :root,
    backgroundColor: "#eeeeee".to_color


  # BIG ASS BUTTONS
  # ------------------------------------------------------------------------------------------
  style :big_bottom_button,
    top: 450,
    left: 10,
    width: 300,
    height: 40,
    backgroundColor: "#9b99a1".to_color,
    textColor: "#FFFFFF".to_color,
    font: 'OpenSans-Bold'.uifont(18),
    layer: {
      cornerRadius: 4
    }

  style :play_button, extends: :big_bottom_button,
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
end