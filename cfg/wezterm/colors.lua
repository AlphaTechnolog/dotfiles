return {
    -- The default text color
    foreground = '#a5b6cf',
    -- The default background color
    background = '#0d0f18',

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = '#a5b6cf',
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = '#0d0f18',
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = '#a5b6cf',

    -- the foreground color of selected text
    selection_fg = '#a5b6cf',
    -- the background color of selected text
    selection_bg = '#151720',

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = '#11131c',

    -- The color of the split lines between panes
    split = '#0f111a',

    ansi = {
      '#151720',
      '#dd6777',
      '#90ceaa',
      '#ecd3a0',
      '#86aaec',
      '#c296eb',
      '#93cee9',
      '#cbced3',
    },
    brights = {
      '#262831',
      '#e26c7c',
      '#95d3af',
      '#f1d8a5',
      '#8baff1',
      '#c79bf0',
      '#98d3ee',
      '#d0d3d8',
    },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = '#c296eb',
}
